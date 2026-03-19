#!/bin/bash
#SBATCH --job-name=mace_gpu
#SBATCH --account=personal
#SBATCH --partition=a30_normal_q
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --gres=gpu:1
#SBATCH -t 1:00:00
#SBATCH -e mace_si.e

module reset
module load LAMMPS/28Oct2024-foss-2023a-kokkos-mace-CUDA-12.1.1

#
echo "LAMMPS: Normal beginning of execution."
#

mpirun -np $SLURM_NTASKS lmp -in in.mace_si > output.txt

if [ $? -ne 0 ]; then
  echo "LAMMPS: Run error!"
  exit 1
fi
#
echo "LAMMPS: Normal end of execution."
exit 0
