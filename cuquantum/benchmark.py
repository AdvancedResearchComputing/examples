import cupy as cp
from cuquantum import tensornet as tn
import time

# Create random tensors on GPU
A = cp.random.rand(64, 128).astype(cp.complex64)
B = cp.random.rand(128, 32).astype(cp.complex64)

# Warm-up
_ = tn.contract("ij,jk->ik", A, B)

# Time multiple contractions
n_trials = 100
start = time.time()
for _ in range(n_trials):
    _ = tn.contract("ij,jk->ik", A, B)
end = time.time()

print(f"[cuTensorNet] Contract time per op: {(end - start) / n_trials * 1000:.3f} ms")

