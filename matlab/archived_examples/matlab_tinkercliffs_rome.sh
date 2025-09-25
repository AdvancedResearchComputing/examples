#! /bin/bash
#
#SBATCH -t 00:10:00
#SBATCH -N1 --ntasks-per-node=16
#SBATCH -p dev_q
#

#
module reset
module load MATLAB

## Start MATLAB and call the script
matlab -batch prime_batch_local

exit 0
