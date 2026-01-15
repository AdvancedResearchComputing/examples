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

- *(Optional)* Diagnostic Slurm script (used previously)  
  This script prints:
  - PyTorch version
  - CUDA availability
  - GPU device name
  - LAMMPS and Python paths  

  Use the following script if you need to **debug or revalidate** the MACE/GPU setup.

```bash
#!/bin/bash
#SBATCH -t 1:00:00
#SBATCH --account=personal
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --gres=gpu:1
#SBATCH --mem=10G
#SBATCH --partition=a30_normal_q
#SBATCH --job-name="lmp_mace_gpu"
#SBATCH -o mace_si.o
#SBATCH -e mace_si.e


module reset
module load LAMMPS/28Oct2024-foss-2023a-kokkos-mace-CUDA-12.1.1

cd "$SLURM_SUBMIT_DIR"

echo "=== Job info ==="
echo "PWD: $(pwd)"
echo "HOST: $(hostname)"
echo "JOBID: ${SLURM_JOB_ID}"
echo "CUDA_VISIBLE_DEVICES: ${CUDA_VISIBLE_DEVICES:-unset}"
echo

echo "=== Binaries ==="
which lmp
which python
python -V
echo

echo "=== GPU check (PyTorch) ==="
python - <<'EOF'
import torch
print("torch:", torch.__version__)
print("cuda available:", torch.cuda.is_available())
if torch.cuda.is_available():
    print("gpu:", torch.cuda.get_device_name(0))
EOF
echo

echo "=== Input files ==="
ls -lh in.mace_si || true
echo

echo "=== Running LAMMPS (MACE via PyTorch GPU; no Kokkos) ==="
# IMPORTANT: no -k / no -sf kk
lmp -in in.mace_si > output.txt

echo "=== Done ==="
tail -n 50 output.txt || true
```
