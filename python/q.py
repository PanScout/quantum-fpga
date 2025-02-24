from manim import *
import torch, numpy as np, math

class QuantumVectorField(Scene):
    def construct(self):
        # === Configuration ===
        n_qubits = 6                   # e.g. 6 qubits → 8×8 grid
        system_dim = 2 ** n_qubits
        s = int(np.sqrt(system_dim))   # grid size (assumed square)
        t_min, t_max = 0, 7
        duration = 7                   # total animation duration (seconds)
        gamma = 0.5                    # gamma for contrast enhancement
        spacing = 1.0                  # spacing between grid points

        # Use a dark background
        self.camera.background_color = BLACK

        # Add a background grid for reference.
        plane = NumberPlane(
            x_range=[-s/2 - 1, s/2 + 1, 1],
            y_range=[-s/2 - 1, s/2 + 1, 1],
            background_line_style={
                "stroke_color": GREY,
                "stroke_width": 1,
                "stroke_opacity": 0.5,
            },
        )
        self.add(plane)

        # --- Quantum Setup (using PyTorch) ---
        device = torch.device("cpu")   # for simplicity, use CPU
        # Define Pauli matrices:
        I = torch.eye(2, dtype=torch.complex64, device=device)
        X = torch.tensor([[0, 1], [1, 0]], dtype=torch.complex64, device=device)
        Y = torch.tensor([[0, -1j], [1j, 0]], dtype=torch.complex64, device=device)
        Z = torch.tensor([[1, 0], [0, -1]], dtype=torch.complex64, device=device)

        def tensor_product(ops):
            result = ops[0]
            for op in ops[1:]:
                result = torch.kron(result, op)
            return result

        def build_hamiltonian():
            paulis = [I, X, Y, Z]
            num_terms = 10
            H = torch.zeros((system_dim, system_dim), dtype=torch.complex64, device=device)
            for _ in range(num_terms):
                indices = torch.randint(0, 4, (n_qubits,))
                ops = [paulis[i] for i in indices]
                H += torch.randn(1, device=device) * tensor_product(ops)
            return (H + H.mH) / 2  # Make Hermitian

        H = build_hamiltonian()

        # Prepare an initial random state and normalize it.
        V_rand = (torch.randn(system_dim, dtype=torch.complex64, device=device) +
                  1j * torch.randn(system_dim, dtype=torch.complex64, device=device))
        norm = torch.sqrt(torch.sum(torch.abs(V_rand) ** 2))
        V_rand /= norm

        # --- Compute Eigen Decomposition ---
        H_cpu = H.cpu().to(torch.complex128)
        eigvals, Q = torch.linalg.eigh(H_cpu)
        eigvals = eigvals.to(device, dtype=torch.float32)
        Q = Q.to(device, dtype=H.dtype)

        # Function to compute the quantum state at time t.
        def compute_state(t: float):
            phase_factors = torch.exp(-1j * eigvals * t)
            evolved = Q @ (phase_factors * (Q.mH @ V_rand))
            state = evolved.view(s, s)
            return state.cpu().numpy()

        # --- Create Grid of Arrows ---
        arrows = VGroup()
        arrow_dict = {}  # to hold arrow objects keyed by grid index
        for i in range(s):
            for j in range(s):
                state = compute_state(t_min)
                val = state[i, j]
                angle = np.angle(val)
                arrow = Arrow(
                    ORIGIN,
                    0.8 * np.array([np.cos(angle), np.sin(angle), 0]),
                    buff=0,
                    stroke_width=4,
                    tip_length=0.15,
                )
                # Center the grid around the origin.
                pos = np.array([(j - (s - 1) / 2) * spacing, ((s - 1) / 2 - i) * spacing, 0])
                arrow.move_to(pos)
                arrows.add(arrow)
                arrow_dict[(i, j)] = arrow

        # --- Updater for Arrows ---
        def update_arrows(group, dt):
            t = time_tracker.get_value()
            state = compute_state(t)
            for i in range(s):
                for j in range(s):
                    arr = arrow_dict[(i, j)]
                    val = state[i, j]
                    angle = np.angle(val)
                    new_vec = np.array([np.cos(angle), np.sin(angle), 0])
                    start = arr.get_start()
                    arr.put_start_and_end_on(start, start + 0.8 * new_vec)
                    # Compute probability (scaled so uniform state → 1)
                    p_raw = (np.abs(val) ** 2) * (s * s)
                    p_gamma = p_raw ** gamma
                    # Interpolate color between BLUE and YELLOW.
                    color = interpolate_color(BLUE, YELLOW, np.clip(p_gamma, 0, 1))
                    arr.set_color(color)
            return group

        # Create a ValueTracker to animate time.
        time_tracker = ValueTracker(t_min)
        arrows.add_updater(lambda m, dt: update_arrows(m, dt))
        self.add(arrows)

        # Add a time label in the upper right.
        time_label = DecimalNumber(t_min, num_decimal_places=2).scale(0.8).to_corner(UR, buff=0.5)
        time_label.add_updater(lambda mob: mob.set_value(time_tracker.get_value()))
        self.add(time_label)

        # Add a title at the top.
        title = Text("Quantum Vector Field", font_size=36, color=WHITE).to_edge(UP)
        self.add(title)

        # Animate time from t_min to t_max.
        self.play(time_tracker.animate.set_value(t_max), run_time=duration, rate_func=linear)
        self.wait(1)
