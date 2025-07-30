#! /bin/bash
#
#SBATCH -t 00:10:00
#SBATCH -N1 --ntasks-per-node=1 # request 1 node with 1 core
#SBATCH -p normal_q
#SBATCH -A personal
#SBATCH --reservation=HPCMaintTesting

#Load modules
module reset
module load  scikit-learn/1.1.2-foss-2022a
# then load other modules you need

# make sure that all modeules were loaded
module list

#Run example tutorial
python example.py
