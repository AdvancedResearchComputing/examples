#!/bin/bash
#SBATCH --account=personal            # Account allocation
#SBATCH --partition=a30_normal_q     # Partition of the cluster
#SBATCH --nodes=1                   # Number of compute nodes
#SBATCH --ntasks-per-node=2         # Number of processes
#SBATCH --cpus-per-task=4           # Number of CPU cores per process
#SBATCH --gres=gpu:2           # Number of GPUs per node
#SBATCH --time=00-00:10:00          # Runtime limit of 10 minutes (format DD-HH:MM:SS)

module load OpenMPI/5.0.3-NVHPC-24.9-CUDA-12.6.0
module load cuDSS/0.7.1.4-cuda12
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
echo "Running on $SLURM_NTASKS tasks with $OMP_NUM_THREADS threads each"
make
mpirun -np $SLURM_NTASKS ./mpi_cudss
