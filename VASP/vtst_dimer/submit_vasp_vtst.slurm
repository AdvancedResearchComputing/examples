#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4       
#SBATCH --account=personal
#SBATCH --partition=normal_q
#SBATCH --time=00:15:00
#
module reset
module load VASP/5.4.4-vtst-5-intel2023a
module list
#
echo "VASP_TINKERCLIFFS ROME: Normal beginning of execution."

mpirun -np $SLURM_NTASKS vasp_std

if [ $? -ne 0 ]; then
  echo "VASP_TINKERCLIFFS ROME: Run error!"
  exit 1
fi
#
echo "VASP_TINKERCLIFFS ROME: Normal end of execution."
exit 0
