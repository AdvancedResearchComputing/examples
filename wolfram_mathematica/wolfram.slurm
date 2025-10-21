#! /bin/bash
#
#SBATCH --job-name wolfram_ex
#SBATCH --time=00:10:00
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --partition=normal_q
#SBATCH --account=personal
#

#Load modules
module reset
module load Wolfram/14.1

#Run beginner tutorial
echo "Wolfram Mathematica: Normal beginning of execution."
wolframscript -file example.wls
echo "Wolfram Mathematica: Normal end of execution."
