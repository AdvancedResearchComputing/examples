#!/bin/bash
#SBATCH --job-name=amber_md_gpu
#SBATCH --account=arcadm
#SBATCH --partition=a100_normal_q
#SBATCH --nodes=2
#SBATCH --ntasks=2
#SBATCH --gres=gpu:1
#SBATCH --cpus-per-task=4
#SBATCH --time=00:05:00

module reset
module load Amber/24.0-foss-2023b-AmberTools-24.0-CUDA-12.4.0

echo "=== Testing node and GPU visibility ==="
srun --mpi=pmix_v3 --label hostname
srun --mpi=pmix_v3 --label nvidia-smi
srun --mpi=pmix_v3 --label ls -l ala.*

echo "=== Running Amber ==="
srun --mpi=pmix_v3 --label pmemd.cuda.MPI \
  -O -i ala.in \
  -o ala_%t.out \
  -p ala.top -c ala.rst7 \
  -r ala_prod_%t.rst7 -x ala_%t.nc

