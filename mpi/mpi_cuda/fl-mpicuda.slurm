#!/bin/bash
#SBATCH --account=personal          # Account allocation
#SBATCH --partition=l40s_normal_q   # Partition of the cluster
#SBATCH --ntasks=6                  # Number of processes
#SBATCH --gpus-per-task=1           # Number of GPUs per task
#SBATCH --time=00-00:10:00          # Runtime limit of 10 minutes (format DD-HH:MM:SS)

module load OpenMPI/5.0.3-NVHPC-24.9-CUDA-12.6.0

echo "Compiling code ..."
echo "============================="
make

echo "Running on $SLURM_NTASKS tasks on $SLURM_NNODES nodes"
echo "============================="
srun --mpi=pmix ./mpi_cuda