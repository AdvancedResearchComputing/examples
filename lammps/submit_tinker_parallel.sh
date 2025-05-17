#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16       
#SBATCH --account=personal
#SBATCH --partition=normal_q
#SBATCH --time=00:15:00
#
module reset
module load LAMMPS/29Aug2024-foss-2023b-kokkos
#
echo "LAMMPS_TINKERCLIFFS ROME: Normal beginning of execution."
#
mpirun -np $SLURM_NTASKS lmp < input.in > output.txt

if [ $? -ne 0 ]; then
  echo "LAMMPS_TINKERCLIFFS ROME: Run error!"
  exit 1
fi
#
echo "LAMMPS_TINKERCLIFFS ROME: Normal end of execution."
exit 0
