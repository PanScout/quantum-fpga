#!/usr/bin/env python3
import os
import subprocess
import time
import math
import sys
import torch
import numpy as np
from scipy.ndimage import gaussian_filter
import matplotlib
matplotlib.use("Agg")  # Use non-interactive backend
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D  # Ensure 3D plotting is available
import matplotlib.cm as cm
import matplotlib.colors as colors
import io
import concurrent.futures  # FIX 1: Add missing import
from concurrent.futures import ProcessPoolExecutor, as_completed
from tqdm import tqdm

# Use the Solarized Light Two style for a pleasing look.
plt.style.use('Solarize_Light2')

# === Configuration ===
t_min, t_max = 0, 7
render_fps = 60       # Rendering frames per second (for smooth slow motion)
output_fps = 60       # Final video playback FPS
n_qubits = 10         # Number of qubits
system_dim = 2 ** n_qubits  # Hilbert space dimension
s = int(np.sqrt(system_dim))  # Grid size (assumed square)
height_scale = 1
sigma = 1.5

# Figure settings
fig_size = (18, 10)   # Figure size in inches for rendering
dpi = 400             # Resolution for saving figures (dots per inch)
color_map = 'hsv'     # Color mapping for phase (overrides the theme)
num_frames = int(math.ceil(render_fps * (t_max - t_min)))
max_retries = 3       # Max retries for failed frames
# ======================

# Set up device (using MPS if available, else CPU)
device = torch.device("mps" if torch.backends.mps.is_available() else "cpu")

# --- Quantum Gates Setup ---
I = torch.eye(2, dtype=torch.complex64, device=device)
X = torch.tensor([[0, 1], [1, 0]], dtype=torch.complex64, device=device)
Y = torch.tensor([[0, -1j], [1j, 0]], dtype=torch.complex64, device=device)
Z = torch.tensor([[1, 0], [0, -1]], dtype=torch.complex64, device=device)

def tensor_product(operators):
    result = operators[0]
    for op in operators[1:]:
        result = torch.kron(result, op)
    return result

# --- Hamiltonian Construction ---
def build_hamiltonian():
    pauli_gates = [I, X, Y, Z]
    num_terms = 10
    H = torch.zeros((system_dim, system_dim), dtype=torch.complex64, device=device)
    for _ in range(num_terms):
        gate_indices = torch.randint(0, 4, (n_qubits,))
        paulis = [pauli_gates[i] for i in gate_indices]
        H += torch.randn(1, device=device) * tensor_product(paulis)
    return (H + H.mH) / 2  # Ensure Hermiticity

# --- Worker Initialization ---
def init_worker(z_all, c_all, t_values, X, Y, fig_size, dpi, color_map):
    global _Z_all, _C_all, _t_values, _X, _Y, _fig_size, _dpi, _color_map
    _Z_all = z_all
    _C_all = c_all
    _t_values = t_values
    _X = X
    _Y = Y
    _fig_size = fig_size
    _dpi = dpi
    _color_map = color_map

# --- Worker Function with Error Handling ---
def render_frame(frame):
    try:
        fig = plt.figure(figsize=_fig_size)
        ax = fig.add_subplot(111, projection='3d')
        
        ax.view_init(elev=55, azim=45)
        ax.set_xlabel('X axis', fontsize=14, labelpad=10)
        ax.set_ylabel('Y axis', fontsize=14, labelpad=10)
        ax.set_zlabel('Amplitude', fontsize=14, labelpad=10)
        ax.tick_params(axis='both', which='major', labelsize=12)
        ax.grid(True, linestyle='--', alpha=0.7)
        
        z_data = _Z_all[:, :, frame]
        phase_data = _C_all[:, :, frame]
        
        cmap = plt.get_cmap(_color_map)
        facecolors = cmap(phase_data)
        
        ax.plot_surface(_X, _Y, z_data, facecolors=facecolors,
                        rstride=1, cstride=1, linewidth=0, antialiased=True)
        
        t_val = _t_values[frame]
        ax.set_title(f"Time Evolution: t = {t_val:.2f}", pad=20, fontsize=16)
        
        norm = colors.Normalize(vmin=0, vmax=1)
        sm = cm.ScalarMappable(cmap=cmap, norm=norm)
        sm.set_array([])
        cbar = fig.colorbar(sm, ax=ax, shrink=0.6, aspect=15, pad=0.1)
        cbar.set_label('Phase', fontsize=14)
        cbar.ax.tick_params(labelsize=12)
        
        buf = io.BytesIO()
        plt.savefig(buf, format='png', bbox_inches='tight', pad_inches=0.1, dpi=_dpi)
        plt.close(fig)
        img_data = buf.getvalue()
        buf.close()
        return (frame, img_data, True)
    except Exception as e:
        return (frame, None, str(e))

# --- FFmpeg Setup ---
def create_ffmpeg_pipe(output_filename):
    return subprocess.Popen([
        'ffmpeg', '-y', '-loglevel', 'error',
        '-f', 'image2pipe',
        '-framerate', str(render_fps),
        '-c:v', 'png',
        '-i', '-',
        '-vf', f'pad=ceil(iw/2)*2:ceil(ih/2)*2,setpts=({render_fps}/{output_fps})*PTS',
        '-c:v', 'libx264',
        '-crf', '18',
        '-preset', 'slow',
        '-tune', 'animation',
        '-r', str(output_fps),
        '-pix_fmt', 'yuv420p',
        '-movflags', '+faststart',
        output_filename
    ], stdin=subprocess.PIPE)

# --- Main Program ---
def main():
    print(f"Initializing {system_dim}-dim quantum system on {device}...")
    H = build_hamiltonian()

    V_rand = (torch.randn(system_dim, dtype=torch.complex64, device=device) +
              1j * torch.randn(system_dim, dtype=torch.complex64, device=device))
    norm = torch.sqrt(torch.sum(torch.abs(V_rand) ** 2))
    V_rand /= norm

    print("Precomputing time evolution...")
    pre_start = time.time()

    H_cpu = H.cpu().to(torch.complex128)
    eigvals, Q = torch.linalg.eigh(H_cpu)
    eigvals = eigvals.to(device, dtype=torch.float32)
    Q = Q.to(device, dtype=H.dtype)

    t_values = torch.linspace(t_min, t_max, num_frames, device=device).cpu().numpy()

    Z_all = torch.empty((s, s, num_frames), device=device)
    C_all = torch.empty((s, s, num_frames), device=device)

    for i, t in enumerate(t_values):
        sys.stdout.write(f"\rProcessing t = {t:.2f} ({i+1}/{num_frames})")
        sys.stdout.flush()
        phase_factors = torch.exp(-1j * eigvals * t)
        evolved = Q @ (phase_factors * (Q.mH @ V_rand))
    
        prob_data = torch.abs(evolved) ** 2
        prob_matrix = prob_data.view(s, s)
        filtered_np = gaussian_filter(prob_matrix.cpu().numpy() * height_scale, sigma=sigma)
        filtered = torch.tensor(filtered_np, device=device)
        fmin, fmax = filtered.min(), filtered.max()
        if fmax > fmin:
            Z_all[:, :, i] = (filtered - fmin) / (fmax - fmin)
        else:
            Z_all[:, :, i] = 0
    
        evolved_view = evolved.view(s, s)
        real = evolved_view.real
        imag = evolved_view.imag
        phase = (torch.atan2(imag, real) + math.pi) / (2 * math.pi)
        phase_np = gaussian_filter(phase.cpu().numpy(), sigma=sigma) % 1
        C_all[:, :, i] = torch.tensor(phase_np, device=device)

    Z_all = Z_all.cpu().numpy()
    C_all = C_all.cpu().numpy()
    print(f"\nPrecomputed {num_frames} frames in {time.time()-pre_start:.2f}s")

    output_filename = f"quantum_q{n_qubits}_render{render_fps}_output{output_fps}.mp4"
    ffmpeg = create_ffmpeg_pipe(output_filename)

    X, Y = np.meshgrid(np.arange(s), np.arange(s))
    initializer_args = (Z_all, C_all, t_values, X, Y, fig_size, dpi, color_map)

    print("Rendering frames with ProcessPoolExecutor...")
    with ProcessPoolExecutor(max_workers=8, initializer=init_worker, initargs=initializer_args) as executor:
        # Track frames and retries
        total_frames = num_frames
        futures = {}
        for frame in range(num_frames):
            future = executor.submit(render_frame, frame)
            futures[future] = (frame, 0)  # (frame, attempt)
        
        # Prepare buffer and counters
        frame_buffer = {}
        next_frame = 0
        progress = tqdm(total=num_frames, desc="Rendering frames")
        failed_frames = set()

        while futures:
            # Wait for the next future to complete
            done, _ = concurrent.futures.wait(  # Now correctly referenced
                futures.keys(), 
                return_when=concurrent.futures.FIRST_COMPLETED
            )
            
            for future in done:
                frame, attempt = futures.pop(future)
                result = future.result()
                
                if result[2] is True:  # Success
                    frame_idx, img_data, _ = result
                    frame_buffer[frame_idx] = img_data
                else:  # Error
                    error_msg = result[2]
                    print(f"Frame {frame} failed (attempt {attempt+1}): {error_msg}")
                    if attempt + 1 < max_retries:
                        new_future = executor.submit(render_frame, frame)
                        futures[new_future] = (frame, attempt + 1)
                    else:
                        print(f"Frame {frame} failed after {max_retries} attempts.")
                        failed_frames.add(frame)

            # Write completed frames in order
            while next_frame in frame_buffer:
                ffmpeg.stdin.write(frame_buffer.pop(next_frame))
                next_frame += 1
                progress.update(1)

        progress.close()
        
        # FIX 2: Check if we actually wrote frames before closing ffmpeg
        if next_frame == 0:
            print("ERROR: No frames rendered successfully!")
            sys.exit(1)
        else:
            ffmpeg.stdin.close()
            ffmpeg.wait()

    print(f"\nOutput file: {output_filename}")


if __name__ == '__main__':
    main()