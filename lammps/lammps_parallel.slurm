#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16       
#SBATCH --cpus-per-task=1
#SBATCH --account=personal
#SBATCH --partition=normal_q
#SBATCH --time=00:15:00
#SBATCH --mem=1GB
#
module reset
module load LAMMPS
#
echo "LAMMPS: Normal beginning of execution."
#
mpirun -np $SLURM_NTASKS lmp < input.in > output.txt

if [ $? -ne 0 ]; then
  echo "LAMMPS: Run error!"
  exit 1
fi
#
echo "LAMMPS: Normal end of execution."
exit 0
