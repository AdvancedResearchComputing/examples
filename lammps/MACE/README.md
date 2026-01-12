# LAMMPS + MACE GPU Job 

This directory contains a Slurm submission script for running **LAMMPS with a MACE (Machine-learning Atomic Cluster Expansion) potential** on a GPU-enabled node.

---

## What is MACE?

**MACE (Machine-learning Atomic Cluster Expansion)** is a machine-learning interatomic potential implemented using **PyTorch**.  
In LAMMPS, `pair_style mace` acts as an interface that passes atomic environments from LAMMPS into a PyTorch model, which then computes energies and forces.

Key points:
- MACE is **not a native LAMMPS force kernel**
- All heavy computation happens **inside PyTorch**
- GPU acceleration is provided directly by **PyTorch CUDA**

---

## Why Kokkos is NOT needed for MACE

LAMMPS provides **Kokkos** to accelerate *LAMMPS-native* force calculations (e.g., LJ, EAM, Tersoff) by running those kernels on GPUs.

However, **MACE does not benefit from Kokkos**, because:

- MACE forces are computed inside **PyTorch**, not inside LAMMPS C++
- PyTorch already manages:
  - GPU memory
  - CUDA kernels
  - Parallel execution on the GPU
- Enabling Kokkos (`-k on`, `-sf kk`, or `pair_style mace/kk`) attempts to mix:
  - Kokkos GPU memory management
  - PyTorch CUDA memory management

On some builds, this leads to GPU pointer and memory-space conflicts.

### Design choice in this workflow

This job script:
- Uses `pair_style mace`
- **Does not enable Kokkos**
- Relies on **PyTorch CUDA** for GPU acceleration

This is:
- Simpler
- More stable
- Fully GPU-accelerated for MACE
- Consistent with common MACE-in-LAMMPS usage

---

## Files in this directory

- `submit_mace_si.sh`  
  Slurm submission script for running LAMMPS + MACE on GPU

- `in.mace_si`  
  LAMMPS input file using `pair_style mace`

- `structure.data`
  LAMMPS data file using `read_data`

- `finetuned_MACE.model-lammps.pt`
  TorchScript model, trained MACE interatomic potential

- `output.txt`  
  Captured LAMMPS standard output

- `mace_si.o`, `mace_si.e`  
  Slurm stdout / stderr

