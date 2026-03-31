#!/bin/bash
#SBATCH --account=personal
#SBATCH --partition=a30_normal_q
#SBATCH --nodes=1
#SBATCH --ntasks=2
#SBATCH --gres=gpu:2
#SBATCH --time=00:15:00
#
module reset
module load VASP/6.5.1-OpenMPI-5.0.3-NVHPC-24.9-CUDA-12.6.0-VTST-6.5.1

scontrol show job -d $SLURM_JOB_ID
echo "VASP : Normal beginning of execution."

mpirun -np $SLURM_NTASKS vasp_std

if [ $? -ne 0 ]; then
  echo "VASP : Run error!"
  exit 1
fi
#
echo "VASP : Normal end of execution."
exit 0
