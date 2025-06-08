#!/bin/bash
#SBATCH --job-name=amber_md_gpu
#SBATCH --account=arcadm
#SBATCH --partition=a100_normal_q
#SBATCH --gres=gpu:3
#SBATCH --nodes=1
#SBATCH --ntasks=3
#SBATCH --cpus-per-task=4
#SBATCH --time=00:05:00

module reset
module load Amber/24.0-foss-2023b-AmberTools-24.0-CUDA-12.4.0

mpirun -np 3 pmemd.cuda.MPI -O -i ala.in -o ala.out -p ala.top -c ala.rst7 -r ala_prod.rst7 -x ala.nc
