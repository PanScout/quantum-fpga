import sys
import numpy as np
from PyQt5.QtWidgets import *
from PyQt5.QtCore import *
from PyQt5.QtGui import *
from scipy.linalg import logm, expm
from enum import Enum
import matplotlib
matplotlib.use('Qt5Agg')
import matplotlib.pyplot as plt
from FPGA_INTERFACE_PY import *

# ------------------------------------------------------------------------------
# Predefined quantum gates using raw matrices
# ------------------------------------------------------------------------------
class StandardGate(Enum):
    """
    Enum for predefined quantum gate matrices.
    Each gate is represented as a raw list which will later be converted into a numpy array.
    """
    IDENTITY = [[1, 0],
                [0, 1]]
    PAULI_X = [[0, 1],
               [1, 0]]
    HADAMARD = [[1/np.sqrt(2), 1/np.sqrt(2)],
                [1/np.sqrt(2), -1/np.sqrt(2)]]
    CNOT = [[1, 0, 0, 0],
            [0, 1, 0, 0],
            [0, 0, 0, 1],
            [0, 0, 1, 0]]
    CONTROLLED_Z = [[1, 0, 0, 0],
                    [0, 1, 0, 0],
                    [0, 0, 1, 0],
                    [0, 0, 0, -1]]


# ------------------------------------------------------------------------------
# Class representing a quantum gate and its embedding logic into a multi-qubit space.
# ------------------------------------------------------------------------------
class QuantumGate:
    """
    Represents a quantum gate and includes methods to embed it into an N-qubit Hilbert space.
    
    Attributes:
        unitary_matrix (np.ndarray): The unitary matrix representing the gate.
        target_qubits (tuple): The qubit indices this gate acts on.
    """
    def __init__(self, raw_matrix, qubit_indices):
        """
        Initializes a QuantumGate instance.

        Args:
            raw_matrix (list): The raw list representing the gate matrix.
            qubit_indices (iterable): The qubit indices that the gate will act on.
        """
        self.unitary_matrix = np.array(raw_matrix, dtype=complex)
        self.target_qubits = tuple(qubit_indices)

    def __eq__(self, other):
        """
        Equality check between two QuantumGate instances.
        """
        return (np.array_equal(self.unitary_matrix, other.unitary_matrix) and 
                self.target_qubits == other.target_qubits)

    def __hash__(self):
        """
        Generates a hash for the QuantumGate instance.
        """
        return hash((tuple(self.unitary_matrix.flatten()), self.target_qubits))

    def embed(self, total_qubits):
        """
        Embeds the gate into the Hilbert space of 'total_qubits' qubits.
        
        Args:
            total_qubits (int): Total number of qubits in the system.

        Returns:
            np.ndarray: The embedded unitary matrix.
        
        Raises:
            ValueError: If the gate is neither a 1-qubit nor a 2-qubit gate.
        """
        if len(self.target_qubits) == 1:
            return self._embed_single_qubit(total_qubits)
        elif len(self.target_qubits) == 2:
            return self._embed_two_qubit(total_qubits)
        else:
            raise ValueError("Only 1-qubit and 2-qubit gates are supported.")

    def _embed_single_qubit(self, total_qubits):
        """
        Embeds a single-qubit gate into an N-qubit system.
        
        Args:
            total_qubits (int): Total number of qubits.

        Returns:
            np.ndarray: The embedded unitary matrix for the single-qubit gate.
        """
        # Create identity matrices for all qubits
        qubit = self.target_qubits[0]
        gate_matrices = [np.eye(2, dtype=complex) for _ in range(total_qubits)]
        # Replace the target qubit with the gate's unitary matrix
        gate_matrices[qubit] = self.unitary_matrix
        # Return the tensor product of all matrices
        return self._kron_product(gate_matrices)

    def _embed_two_qubit(self, total_qubits):
        """
        Embeds a two-qubit gate into an N-qubit system.
        
        Args:
            total_qubits (int): Total number of qubits.

        Returns:
            np.ndarray: The embedded unitary matrix for the two-qubit gate.
        """
        # Sort the qubit indices to simplify embedding logic
        qubit1, qubit2 = sorted(self.target_qubits)
        # If the qubits are adjacent, use a simplified embedding
        if abs(qubit1 - qubit2) == 1:
            return self._embed_adjacent(total_qubits, qubit1)
        # Otherwise, handle non-adjacent (controlled) gates
        return self._embed_non_adjacent(total_qubits)

    def _embed_adjacent(self, total_qubits, start_qubit_index):
        """
        Embeds a two-qubit gate acting on adjacent qubits.
        
        Args:
            total_qubits (int): Total number of qubits.
            start_qubit_index (int): The index of the first (control) qubit.

        Returns:
            np.ndarray: The embedded two-qubit gate matrix.
        """
        # Identity for qubits to the left of the gate application
        left_identity = np.eye(2**start_qubit_index, dtype=complex)
        # Identity for qubits to the right of the gate application
        right_identity = np.eye(2**(total_qubits - start_qubit_index - 2), dtype=complex)
        # Tensor product: left_identity ⊗ (gate) ⊗ right_identity
        return np.kron(np.kron(left_identity, self.unitary_matrix), right_identity)

    def _embed_non_adjacent(self, total_qubits):
        """
        Embeds a two-qubit controlled gate where the target qubits are not adjacent.
        Assumes that the controlled operation is stored in the lower-right block of unitary_matrix.

        Args:
            total_qubits (int): Total number of qubits.

        Returns:
            np.ndarray: The embedded two-qubit gate matrix.
        """
        control_qubit, target_qubit = self.target_qubits
        # Extract the operation for the controlled part from the lower-right block of the matrix
        controlled_operation = self.unitary_matrix[2:, 2:]
        
        # Build the first term: when control qubit is in the |0> state
        matrices_when_control_zero = [
            np.array([[1, 0], [0, 0]], dtype=complex) if q == control_qubit 
            else np.eye(2, dtype=complex)
            for q in range(total_qubits)
        ]
        term_when_control_zero = self._kron_product(matrices_when_control_zero)
        
        # Build the second term: when control qubit is in the |1> state, apply the operation on the target qubit
        matrices_when_control_one = [
            np.array([[0, 0], [0, 1]], dtype=complex) if q == control_qubit 
            else (controlled_operation if q == target_qubit else np.eye(2, dtype=complex))
            for q in range(total_qubits)
        ]
        term_when_control_one = self._kron_product(matrices_when_control_one)
        
        # Sum the two terms to get the complete embedded controlled gate
        return term_when_control_zero + term_when_control_one

    @staticmethod
    def _kron_product(matrix_list):
        """
        Computes the Kronecker (tensor) product of a list of matrices.

        Args:
            matrix_list (list of np.ndarray): List of matrices to multiply.

        Returns:
            np.ndarray: The resulting tensor product matrix.
        """
        result = np.array([[1]], dtype=complex)
        for matrix in matrix_list:
            result = np.kron(result, matrix)
        return result


# ------------------------------------------------------------------------------
# Class representing a layer of quantum gates.
# ------------------------------------------------------------------------------
class Layer:
    """
    Represents a single layer of quantum gates in a quantum circuit.
    
    A layer can either consist entirely of single-qubit gates acting on different qubits,
    or a single two-qubit gate (e.g., a controlled gate).
    """
    def __init__(self, gate_list):
        """
        Initializes a Layer with a list of QuantumGate instances.

        Args:
            gate_list (list): List of QuantumGate objects.
        
        Raises:
            ValueError: If the layer is empty, contains invalid gate combinations,
                        or has conflicting qubit usage for single-qubit gates.
        """
        self.gates = gate_list
        self.effective_hamiltonian = None

        if not gate_list:
            raise ValueError("Layer must contain at least one gate.")

        # Check if there is any two-qubit gate in the layer
        two_qubit_gates = [gate for gate in gate_list if len(gate.target_qubits) == 2]
        if two_qubit_gates:
            # Layer with a two-qubit gate should not contain any other gate
            if len(gate_list) != 1:
                raise ValueError("Layer with a two-qubit gate must contain exactly one gate.")
            # Validate controlled gate structure (first 2x2 block must be identity)
            two_qubit_gate = two_qubit_gates[0]
            if not np.allclose(two_qubit_gate.unitary_matrix[:2, :2], np.eye(2, dtype=complex)):
                raise ValueError("Invalid controlled gate structure")
        else:
            # For single-qubit gates, ensure no two gates act on the same qubit
            qubit_indices = []
            for gate in gate_list:
                if len(gate.target_qubits) != 1:
                    raise ValueError("Invalid gate type in layer")
                qubit_indices.append(gate.target_qubits[0])
            if len(qubit_indices) != len(set(qubit_indices)):
                raise ValueError("Qubit conflict in layer")

    def generate_effective_hamiltonian(self, total_qubits):
        """
        Generates the effective Hamiltonian for the layer by composing the embedded gates.
        Validates and corrects the unitary matrix for numerical issues.

        Args:
            total_qubits (int): Total number of qubits in the circuit.

        Returns:
            np.ndarray: The effective Hamiltonian for this layer.
        
        Raises:
            ValueError: If the corrected unitary matrix is not unitary.
        """
        # Embed each gate into the total Hilbert space
        embedded_matrices = [gate.embed(total_qubits) for gate in self.gates]
        
        # Multiply the matrices in reverse order to get the overall unitary for the layer
        overall_unitary = np.eye(2**total_qubits, dtype=complex)
        for embedded_matrix in reversed(embedded_matrices):
            overall_unitary = embedded_matrix @ overall_unitary

        # Use SVD to correct numerical errors and enforce unitarity
        U, _, Vh = np.linalg.svd(overall_unitary)
        overall_unitary = U @ Vh

        # Validate unitarity of the corrected matrix
        if not np.allclose(overall_unitary @ overall_unitary.conj().T, 
                           np.eye(overall_unitary.shape[0]), atol=1e-6):
            raise ValueError("Non-unitary matrix after correction")

        # Calculate the effective Hamiltonian using the matrix logarithm
        effective_H = (1j / np.pi) * logm(overall_unitary)
        self.effective_hamiltonian = effective_H
        return effective_H


# ------------------------------------------------------------------------------
# Class representing a quantum circuit composed of multiple layers.
# ------------------------------------------------------------------------------
class Circuit:
    """
    Represents a quantum circuit made up of multiple layers of quantum gates.

    Attributes:
        layers (list): List of Layer objects forming the circuit.
        total_qubits (int): The number of qubits in the circuit.
        state_vector (np.ndarray): The current quantum state vector.
        state_evolution (list): History of state evolutions for each layer.
        current_layer_index (int): Index of the next layer to be applied.
    """
    def __init__(self, layers, total_qubits):
        """
        Initializes the quantum circuit.

        Args:
            layers (list): List where each element is a list of QuantumGate objects (a layer).
            total_qubits (int): Total number of qubits in the circuit.
        """
        # Create a list of Layer objects from the provided gate lists
        self.layers = [Layer(gate_list) for gate_list in layers]
        self.total_qubits = total_qubits
        
        # Initialize the state vector to |0...0>
        self.state_vector = np.zeros(2**total_qubits, dtype=complex)
        self.state_vector[0] = 1
        
        # To store the evolution of the state after each layer
        self.state_evolution = []
        self.current_layer_index = 0

    def step(self, RUN_ON_HARDWARE=False, num_time_steps=30):
        """
        Applies the next layer in the circuit and simulates the state evolution.
        
        Args:
            num_time_steps (int): Number of time steps to simulate the evolution within the layer.
        
        Returns:
            None. The circuit's state is updated and the evolution is stored.
        """
        # Check if all layers have been applied
        if self.current_layer_index >= len(self.layers):
            print("All layers have been applied.")
            return

        # Get the current layer and generate its effective Hamiltonian
        current_layer = self.layers[self.current_layer_index]
        effective_H = current_layer.generate_effective_hamiltonian(self.total_qubits)
        if not RUN_ON_HARDWARE:
            # Create time values from 0 to π for evolution simulation
            time_values = np.linspace(0, np.pi, num_time_steps)

            # Prepare a matrix to store the state evolution for each time step
            evolution_history = np.zeros((2**self.total_qubits, num_time_steps), dtype=complex)
            initial_state = self.state_vector.copy()

            # Evolve the state for each time step using the unitary evolution operator
            for idx, t in enumerate(time_values):
                evolution_operator = expm(-1j * effective_H * t)
                evolved_state = evolution_operator @ initial_state
                evolution_history[:, idx] = evolved_state
        else:
            print("\n RUNNING HARDWARE \n")
            initial_state = self.state_vector.copy()
            evolution_history = send_data(effective_H, initial_state,1e-2)


        # Record the evolution history for this layer
        self.state_evolution.append(evolution_history)
        # Update the state vector to the final state of this layer
        self.state_vector = evolution_history[:, -1]
        # Move on to the next layer
        self.current_layer_index += 1

    def shots(self, n):
        """
        Completes the circuit by applying all layers, computes the final state's measurement probabilities,
        performs n measurement shots (state collapses), and plots the distribution of outcomes.

        Args:
            n (int): Number of measurement shots to perform.

        Returns:
            None. Displays a bar plot of the measurement counts for each basis state.
        """
        # Complete the circuit if there are remaining layers
        while self.current_layer_index < len(self.layers):
            self.step()
        
        # Compute measurement probabilities from the final state vector
        probabilities = np.abs(self.state_vector)**2
        num_states = 2 ** self.total_qubits
        outcomes = np.arange(num_states)
        
        # Perform n measurement shots using the probability distribution
        measurement_results = np.random.choice(outcomes, size=n, p=probabilities)
        
        # Count occurrences for each basis state
        counts = np.bincount(measurement_results, minlength=num_states)
        
        # Prepare x-axis labels as binary strings (e.g., '00', '01', ...)
        state_labels = [format(x, '0' + str(self.total_qubits) + 'b') for x in outcomes]
        
        # Plot the histogram of measurement outcomes
        plt.bar(outcomes, counts, tick_label=state_labels)
        plt.xlabel('Basis State')
        plt.ylabel('Counts')
        plt.title(f'Measurement Outcomes ({n} shots)')
        plt.show()
