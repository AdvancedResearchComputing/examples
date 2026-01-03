#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --account=personal
#SBATCH --partition=a30_normal_q
#SBATCH --gres=gpu:1
#SBATCH --time=01:00:00
#
module reset
module load LAMMPS/22Jul2025-foss-2024a-kokkos-CUDA-12.6.0
#
echo "LAMMPS: Normal beginning of execution."
#
export OMP_PROC_BIND=true
mpirun -np $SLURM_NTASKS lmp -sf kk -k on g 1 -in input.in

if [ $? -ne 0 ]; then
  echo "LAMMPS: Run error!"
  exit 1
fi
#
echo "LAMMPS: Normal end of execution."
exit 0
