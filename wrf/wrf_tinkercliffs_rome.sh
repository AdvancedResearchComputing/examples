#! /bin/bash
#
#SBATCH -t 00:10:00
#SBATCH -N1 --ntasks-per-node=4
#SBATCH -p dev_q
#

#load modules
module reset
module load WRF

#link
echo "Setting up b_wave case by linking data files into this directory"
echo "linking to RRTM_DATA in WRF's run directory"
ln -sf "$EBROOTWRF/WRF-4.1.3/run/RRTM_DATA" .

#run ideal.exe to generate input files
ideal.exe

#run WRF
mpirun -np $SLURM_NTASKS wrf.exe
