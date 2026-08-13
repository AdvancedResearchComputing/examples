#!/bin/bash
#SBATCH --job-name=lammps_gpu
#SBATCH --account=<account_name_no_beaks>
#SBATCH --partition=a30_normal_q
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --gres=gpu:1
#SBATCH -t 1:00:00
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
