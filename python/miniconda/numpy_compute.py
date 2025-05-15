# numpy_compute.py

import numpy as np

# Create two random matrices
A = np.random.rand(1000, 1000)
B = np.random.rand(1000, 1000)

# Perform matrix multiplication
C = np.matmul(A, B)

# Print summary statistics
print("Matrix multiplication complete.")
print(f"Result matrix shape: {C.shape}")
print(f"Mean of result: {C.mean():.4f}, Std Dev: {C.std():.4f}")
