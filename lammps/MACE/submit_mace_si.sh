#!/bin/bash
#SBATCH -t 1:00:00
#SBATCH --account=personal
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --gres=gpu:1
#SBATCH --mem=1G
#SBATCH --partition=a30_normal_q
#SBATCH --job-name="lmp_mace_gpu"
#SBATCH -o mace_si.o
#SBATCH -e mace_si.e


module reset
module load LAMMPS/28Oct2024-foss-2023a-kokkos-mace-CUDA-12.1.1

cd "$SLURM_SUBMIT_DIR"

lmp -in in.mace_si > output.txt
