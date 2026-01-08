#! /bin/bash
#
#SBATCH --job-name orca_water
#SBATCH --time=00:10:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --partition=normal_q
#SBATCH --account=personal
#

#Load modules
module reset
module load ORCA/6.1.1-gompi-2023b-avx2

#Run beginner tutorial
echo "ORCA 6.1.1: Normal beginning of execution."
#for parallel runs you have to use the full path name for orca
/apps/common/software/ORCA/6.1.1-gompi-2023b-avx2/bin/orca hellowater.inp > hellowater.out
echo "ORCA 6.1.1: Normal end of execution."
