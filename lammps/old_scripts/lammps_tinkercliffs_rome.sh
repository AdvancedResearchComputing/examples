#! /bin/bash
#
#SBATCH -t 00:05:00
#SBATCH -N1 --ntasks-per-node=48
#SBATCH -p normal_q
#SBATCH --account=arcadm
#

#
module reset
module load LAMMPS
#
echo "LAMMPS_TINKERCLIFFS ROME: Normal beginning of execution."
#
mpirun -np $SLURM_NTASKS lmp < in.lj > lammps_tinkercliffs_rome.txt
if [ $? -ne 0 ]; then
  echo "LAMMPS_TINKERCLIFFS ROME: Run error!"
  exit 1
fi
#
echo "LAMMPS_TINKERCLIFFS ROME: Normal end of execution."
exit 0
