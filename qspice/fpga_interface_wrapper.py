#!/usr/bin/env python3
"""
Python wrapper for fpga_interface.c using ctypes.
Provides the send_data function that calls the C implementation.
"""

import ctypes
import numpy as np
import os
import platform

# --- Load the C library ---
# Determine library path and extension
lib_name = 'FPGA_INTERFACE.so'
if platform.system() == 'Windows':
    lib_name = 'FPGA_INTERFACE.dll' # Adjust if compiling on Windows
elif platform.system() == 'Darwin':
    lib_name = 'FPGA_INTERFACE.dylib' # Adjust if compiling on macOS

# Assume the .so file is in the same directory as the script
lib_path = os.path.join(os.path.dirname(os.path.abspath(__file__)), lib_name)

try:
    # Load the shared library
    c_lib = ctypes.CDLL(lib_path)
    print(f"Successfully loaded C library: {lib_path}")
except OSError as e:
    print(f"Error loading C library '{lib_path}': {e}")
    print("Please ensure the C code is compiled correctly (e.g., using GCC):")
    print("gcc -shared -o FPGA_INTERFACE.so -fPIC fpga_interface.c -lpigpio -lm -pthread")
    exit(1)


# --- Define argument types and return type for the C functions ---

# Define complex type for ctypes if not already available easily
# Based on numpy's complex128 structure (two doubles)
class Complex128(ctypes.Structure):
    _fields_ = [("real", ctypes.c_double),
                ("imag", ctypes.c_double)]

# Pointer types
P_VOID = ctypes.c_void_p
P_INT = ctypes.POINTER(ctypes.c_int)
P_DOUBLE_COMPLEX = ctypes.POINTER(Complex128) # Pointer to our complex struct

# Configure send_data_c function signature
# int send_data_c(const void* H_data, int H_rows, int H_cols, int H_type,
#                 const void* V_data, int V_rows, int V_cols, int V_type,
#                 double S,
#                 void** result_data_out, int* result_rows_out, int* result_cols_out)
try:
    c_send_data = c_lib.send_data_c
    c_send_data.argtypes = [
        P_VOID, ctypes.c_int, ctypes.c_int, ctypes.c_int,  # H data, rows, cols, type
        P_VOID, ctypes.c_int, ctypes.c_int, ctypes.c_int,  # V data, rows, cols, type
        ctypes.c_double,                                   # S
        ctypes.POINTER(P_VOID),                            # result_data_out (pointer to void*)
        P_INT,                                             # result_rows_out
        P_INT                                              # result_cols_out
    ]
    c_send_data.restype = ctypes.c_int # Return status code

    # Configure free_memory function signature
    # void free_memory(void* ptr)
    c_free_memory = c_lib.free_memory
    c_free_memory.argtypes = [P_VOID]
    c_free_memory.restype = None

    print("Successfully configured C function signatures.")

except AttributeError as e:
     print(f"Error finding functions in C library: {e}")
     print("Ensure 'send_data_c' and 'free_memory' are defined and exported correctly in the C code.")
     exit(1)

# --- Python send_data function calling the C implementation ---
def send_data(H, V, S):
    """
    Sends H matrix and V vector to the FPGA interface via C implementation.

    Args:
        H: NumPy array (float64 or complex128), must be 2D.
        V: NumPy array (float64 or complex128), must be 1D or 2D.
        S: Float speed factor (can be 0).

    Returns:
        NumPy array (complex128) containing the processed psi_matrix.
    """
    print(f"Python: Preparing data for C call (H shape: {H.shape}, V shape: {V.shape}, S: {S})")
    # --- Input Validation and Preparation ---
    if not isinstance(H, np.ndarray) or H.ndim != 2:
        raise TypeError("H must be a 2D NumPy array")
    if not isinstance(V, np.ndarray) or V.ndim > 2: # Allow 1D or 2D
        raise TypeError("V must be a 1D or 2D NumPy array")
    if not isinstance(S, (int, float)):
         raise TypeError("S must be a number")

    # Ensure arrays are C-contiguous for safe pointer access
    # Fortran order might be needed if C expects it, but C code uses linear indexing based on C order assumption mostly.
    # Let's stick to C contiguous for simplicity unless issues arise. The C filter logic *does* assume F-order though.
    # Important: The C code's filtering *assumes Fortran order* based on the Python code.
    # We should pass data such that accessing `k + j * initial_rows` works as intended.
    # If H and V are naturally C-order, their flattened versions will be row-major.
    # The *received* data is processed assuming F-order.
    # Let's pass H and V flattened in C order, the C code converts them to bits fine.
    # The C code *receives* data and *interprets* it as F-order for filtering.

    H_flat = H.flatten() # Flatten in C order (row-major)
    V_flat = V.flatten() # Flatten in C order (row-major)

    H_cont = np.ascontiguousarray(H_flat)
    V_cont = np.ascontiguousarray(V_flat)


    # Determine data types (0 for float64, 1 for complex128)
    h_type_code = 1 if np.iscomplexobj(H_cont) else 0
    v_type_code = 1 if np.iscomplexobj(V_cont) else 0

    # Get pointers to data
    h_ptr = H_cont.ctypes.data_as(P_VOID)
    v_ptr = V_cont.ctypes.data_as(P_VOID)

    # Get dimensions (use original shapes for logical rows/cols passed to C)
    # C code uses flattened length anyway, but pass original shape info too.
    h_rows, h_cols = H.shape
    # Handle 1D or 2D V input for rows/cols info
    v_rows = V.shape[0]
    v_cols = V.shape[1] if V.ndim == 2 else 1


    # Prepare output parameters
    result_data_ptr = P_VOID() # Pointer to store the data pointer returned by C
    result_rows = ctypes.c_int()
    result_cols = ctypes.c_int()

    print("Python: Calling C function send_data_c...")
    # --- Call the C function ---
    status = c_send_data(
        h_ptr, h_rows, h_cols, h_type_code,
        v_ptr, v_rows, v_cols, v_type_code,
        ctypes.c_double(S),
        ctypes.byref(result_data_ptr), # Pass address of the pointer
        ctypes.byref(result_rows),
        ctypes.byref(result_cols)
    )
    print(f"Python: C function returned status {status}")

    # --- Process the result ---
    if status != 0:
        # Cleanup potentially allocated memory even on error?
        # The C code *should* clean up on error, but if result_data_ptr got set...
        # It's safer *not* to free here unless we know C guarantees cleanup failure modes.
        # if result_data_ptr.value:
        #     print("Python: Attempting to free potentially allocated C memory after error...")
        #     c_free_memory(result_data_ptr) # Risky if C already freed or didn't allocate
        raise RuntimeError(f"C function send_data_c failed with status code {status}")

    rows = result_rows.value
    cols = result_cols.value
    print(f"Python: C function returned dimensions: rows={rows}, cols={cols}")

    if not result_data_ptr.value:
        print("Python: C function returned NULL data pointer (likely empty result).")
        # Return an empty array with the correct number of rows (matching num_vector)
        # Output is always complex128
        return np.empty((rows, 0), dtype=np.complex128) # Correct shape for empty result

    if rows == 0 or cols == 0:
         print("Python: C function returned zero dimensions.")
         # Free the (potentially non-NULL but zero-sized?) pointer C returned
         c_free_memory(result_data_ptr)
         return np.empty((rows, cols), dtype=np.complex128)

    # Create a NumPy array that *wraps* the C memory
    try:
        # Calculate expected buffer size
        dtype = np.complex128
        itemsize = np.dtype(dtype).itemsize
        buffer_size = rows * cols * itemsize

        # Create a ctypes buffer object from the raw pointer and size
        # This doesn't copy the data yet
        c_buffer = (ctypes.c_char * buffer_size).from_address(result_data_ptr.value)

        # Create a NumPy array VIEW onto the buffer
        # Important: This array shares memory with the C buffer.
        # If the C memory is freed, this array becomes invalid.
        np_array_view = np.frombuffer(c_buffer, dtype=dtype).reshape((rows, cols))

        # **Crucial Step:** Copy the data into a new Python-managed NumPy array.
        # This ensures the data persists after we free the C memory.
        # Note: The C code *already applied* the Fortran-order logic during filtering
        # and copying to the final buffer. So the final buffer we receive *should*
        # contain the data arranged correctly for a standard (C-order preferred)
        # NumPy array of shape (rows, cols). Let's copy directly.
        # If the C code returns data in Fortran layout, specify order='F' in copy.
        # Given C's malloc and manual copying loop, it's likely C-order compatible layout
        # *unless* the manual copy loop `dest_index = k + current_final_col * initial_rows`
        # forces Fortran layout. Let's assume it does and copy with order='F'.
        # If plots look transposed later, change copy() to copy(order='C') or just copy().
        result_array = np_array_view.copy(order='F') # Create a Python-owned Fortran-order copy

    except Exception as e:
        print(f"Python: Error creating NumPy array from C data: {e}")
        # Try to free C memory before re-raising
        c_free_memory(result_data_ptr)
        raise
    finally:
        # --- Free the C memory ---
        # Whether creating the NumPy array succeeded or failed,
        # we MUST free the memory allocated by C.
        print(f"Python: Calling C to free memory at {result_data_ptr.value}...")
        c_free_memory(result_data_ptr)

    print(f"Python: Successfully created NumPy array of shape {result_array.shape}")
    return result_array