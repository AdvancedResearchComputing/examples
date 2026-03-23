#!/bin/bash
#SBATCH --job-name=mliap
#SBATCH --account=personal
#SBATCH --partition=a100_normal_q
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --gres=gpu:1
#SBATCH -t 1:00:00
#

module reset
module load LAMMPS/22Jul2025-foss-2024a-kokkos-CUDA-12.6.0
module load PyTorch/2.7.1-foss-2024a-CUDA-12.6.0
module load CuPy/13.6.0-foss-2024a-CUDA-12.6.0
module load MACE/0.3.5-foss-2024a-CUDA-12.6.0-ASE-3.25.0
#
echo "LAMMPS: Normal beginning of execution."
#

export TORCH_FORCE_NO_WEIGHTS_ONLY_LOAD=1
export OMP_PROC_BIND=true

#Include the next line if you have a trained MACE model that needs to be converted into an ML-IAP checkpoint (.pt) file
python /apps/arch/software/MACE/0.3.5-foss-2024a-CUDA-12.6.0-ASE-3.25.0/lib/python3.12/site-packages/mace/cli/create_lammps_model.py mace-omat-0-small.model --format=mliap

#Include newton on and neigh half (or neigh full) to run ML-IAP with LAMMPS and KOKKOS
mpirun -np $SLURM_NTASKS lmp -k on g $SLURM_JOB_GPUS -sf kk -pk kokkos newton on neigh half -in in.mliap

if [ $? -ne 0 ]; then
  echo "LAMMPS: Run error!"
  exit 1
fi
#
echo "LAMMPS: Normal end of execution."
exit 0
