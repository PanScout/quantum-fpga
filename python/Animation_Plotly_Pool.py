#!/usr/bin/env python3
import os
import shutil
import subprocess
import time
import math
import sys
import torch
import numpy as np
from scipy.ndimage import gaussian_filter
import plotly.graph_objects as go
from concurrent.futures import ProcessPoolExecutor, as_completed
import io
from tqdm import tqdm

# === Configuration ===
t_min, t_max = 0, 1
render_fps = 60       # High rendering FPS for smooth slow motion
output_fps = 24        # Final video playback FPS
n_qubits = 10          # Number of qubits
system_dim = 2 ** n_qubits         # Hilbert space dimension
s = int(np.sqrt(system_dim))         # Grid size (assumed square)
height_scale = 1
sigma = 1.5
max_workers = os.cpu_count()  # Use physical cores
chunk_size = 20               # Larger chunks reduce overhead
num_frames = int(math.ceil(render_fps * (t_max - t_min)))

# Set up GPU device (using MPS if available, else CPU)
device = torch.device("mps" if torch.backends.mps.is_available() else "cpu")

# --- Quantum Gates Setup ---
I = torch.eye(2, dtype=torch.complex64, device=device)
X = torch.tensor([[0, 1], [1, 0]], dtype=torch.complex64, device=device)
Y = torch.tensor([[0, -1j], [1j, 0]], dtype=torch.complex64, device=device)
Z = torch.tensor([[1, 0], [0, -1]], dtype=torch.complex64, device=device)

def tensor_product(operators):
    """Compute tensor product of multiple operators on GPU"""
    result = operators[0]
    for op in operators[1:]:
        result = torch.kron(result, op)
    return result

def build_hamiltonian():
    pauli_gates = [I, X, Y, Z]
    num_terms = 10
    H = torch.zeros((system_dim, system_dim), dtype=torch.complex64, device=device)
    for _ in range(num_terms):
        gate_indices = torch.randint(0, 4, (n_qubits,))
        paulis = [pauli_gates[i] for i in gate_indices]
        H += torch.randn(1, device=device) * tensor_product(paulis)
    return (H + H.mH) / 2  # Ensure Hermiticity

def precompute_evolution():
    print(f"Initializing {system_dim}-dim quantum system on {device}...")
    H = build_hamiltonian()
    # Create and normalize initial state vector
    V_rand = (torch.randn(system_dim, dtype=torch.complex64, device=device) +
              1j * torch.randn(system_dim, dtype=torch.complex64, device=device))
    norm = torch.sqrt(torch.sum(torch.abs(V_rand) ** 2))
    V_rand /= norm

    print("Precomputing time evolution...")
    pre_start = time.time()
    H_cpu = H.cpu()
    eigvals, Q = torch.linalg.eigh(H_cpu)
    Q = Q.to(device)
    eigvals = eigvals.to(device)
    t_values = torch.linspace(t_min, t_max, num_frames, device=device).cpu().numpy()

    # Preallocate arrays for the computed data.
    Z_all = torch.empty((s, s, num_frames), device=device)
    C_all = torch.empty((s, s, num_frames), device=device)

    for i, t in enumerate(tqdm(t_values, desc="Precomputing frames", total=num_frames)):
        # Time evolution using diagonalization.
        phase_factors = torch.exp(-1j * eigvals * t)
        evolved = Q @ (phase_factors * (Q.mH @ V_rand))
        
        # Compute and process probabilities.
        prob_data = torch.abs(evolved) ** 2
        prob_matrix = prob_data.view(s, s)
        filtered_np = gaussian_filter(prob_matrix.cpu().numpy() * height_scale, sigma=sigma)
        filtered = torch.tensor(filtered_np, device=device)
        fmin, fmax = filtered.min(), filtered.max()
        Z_all[:, :, i] = (filtered - fmin) / (fmax - fmin) if fmax > fmin else 0

        # Calculate phase.
        evolved_view = evolved.view(s, s)
        real = evolved_view.real
        imag = evolved_view.imag
        phase = (torch.atan2(imag, real) + math.pi) / (2 * math.pi)
        phase_np = gaussian_filter(phase.cpu().numpy(), sigma=sigma) % 1
        C_all[:, :, i] = torch.tensor(phase_np, device=device)

    # Move arrays to CPU for easier pickling.
    Z_all = Z_all.cpu().numpy()
    C_all = C_all.cpu().numpy()
    print(f"Precomputed {num_frames} frames in {time.time()-pre_start:.2f}s")
    return Z_all, C_all, t_values

def create_ffmpeg_pipe(output_filename):
    return subprocess.Popen([
        'ffmpeg', '-y', '-loglevel', 'error',
        '-f', 'image2pipe',
        '-framerate', str(render_fps),
        '-c:v', 'png',
        '-i', '-',
        '-vf', f'setpts=({render_fps}/{output_fps})*PTS',
        '-c:v', 'libx264',
        '-crf', '18',
        '-preset', 'slow',
        '-tune', 'animation',
        '-r', str(output_fps),
        '-pix_fmt', 'yuv420p',
        '-movflags', '+faststart',
        output_filename
    ], stdin=subprocess.PIPE)

def init_worker(z_all, c_all, t_vals):
    """Initializer for worker processes: set globals and initialize Plotly/Kaleido"""
    global Z_all, C_all, t_values
    Z_all = z_all
    C_all = c_all
    t_values = t_vals
    # Initialize Kaleido in worker process to prevent concurrent initialization issues
    fig = go.Figure()
    buf = io.BytesIO()
    fig.write_image(buf, format='png')  # Dummy export to trigger initialization

def render_chunk(chunk_range, fig_template):
    """Render a chunk of frames using Plotly."""
    buffers = []
    fig = go.Figure(fig_template)
    initial_frame = chunk_range[0]
    surface_trace = go.Surface(
        z=Z_all[:, :, initial_frame],
        surfacecolor=C_all[:, :, initial_frame],
        colorscale='HSV',
        cmin=0,
        cmax=1,
        showscale=False
    )
    fig.add_trace(surface_trace)
    fig.update_layout(
        scene=dict(
            zaxis=dict(range=[0, 1]),
            aspectratio=dict(x=1, y=1, z=0.7),
            camera_projection=dict(type='orthographic')
        ),
        margin=dict(l=0, r=0, b=0, t=30)
    )
    for frame in chunk_range:
        try:
            fig.data[0].update(
                z=Z_all[:, :, frame],
                surfacecolor=C_all[:, :, frame]
            )
            fig.update_layout(
                title_text=f"Time Evolution: t = {t_values[frame]:.2f}",
                title_x=0.5
            )
            buf = io.BytesIO()
            fig.write_image(buf, format='png', scale=2)  # Reduced scale for performance
            buffers.append(buf.getvalue())
        except Exception as e:
            print(f"Error rendering frame {frame}: {str(e)}", file=sys.stderr)
            raise
    return buffers

def main():
    Z_all, C_all, t_vals = precompute_evolution()

    # Create visualization template
    fig_template = go.Figure().update_layout(
        scene=dict(
            xaxis_showspikes=False,
            yaxis_showspikes=False,
            zaxis_showspikes=False,
            camera_projection=dict(type='orthographic')
        ),
        paper_bgcolor='white',
        plot_bgcolor='white',
        showlegend=False
    ).to_dict()

    output_filename = f"quantum_q{n_qubits}_render{render_fps}_output{output_fps}.mp4"
    ffmpeg = create_ffmpeg_pipe(output_filename)

    print(f"\nRendering {num_frames} frames ({s}x{s} grid)")
    render_start = time.time()
    
    # Generate ordered chunk indices with padding
    chunks = [
        (i, list(range(i, min(i+chunk_size, num_frames))))
        for i in range(0, num_frames, chunk_size)
    ]

    with tqdm(total=len(chunks), desc="Processing chunks") as chunk_progress:
        with ProcessPoolExecutor(
            max_workers=max_workers,
            initializer=init_worker,
            initargs=(Z_all, C_all, t_vals)
        ) as executor:
            future_to_chunk = {
                executor.submit(render_chunk, chunk_range, fig_template): idx
                for idx, (start, chunk_range) in enumerate(chunks)
            }

            # Store results with chunk index
            completed = []
            for future in as_completed(future_to_chunk):
                chunk_idx = future_to_chunk[future]
                try:
                    buffers = future.result()
                    completed.append((chunk_idx, buffers))
                except Exception as e:
                    print(f"\nERROR in chunk {chunk_idx}: {str(e)}")
                    executor.shutdown(wait=False, cancel_futures=True)
                    raise
                chunk_progress.update(1)

            # Write frames in ORDER
            completed.sort(key=lambda x: x[0])
            for _, buffers in completed:
                ffmpeg.stdin.write(b''.join(buffers))

    # Cleanup AFTER all processing
    ffmpeg.stdin.close()
    ffmpeg.wait()
    total_time = time.time() - render_start
    print(f"\nTotal render time: {total_time:.1f}s")
            
if __name__ == "__main__":
    main()