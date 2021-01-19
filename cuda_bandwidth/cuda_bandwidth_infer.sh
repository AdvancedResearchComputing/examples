#! /bin/bash
#
#SBATCH -t 00:05:00
#SBATCH -N1 --ntasks-per-node=32 --gres=gpu:1
#SBATCH -p t4_dev_q
#

#Load CUDA module
module reset
module load CUDA/11.1.1-GCC-10.2.0
#

#Run CUDA's bandwidth test
$EBROOTCUDA/extras/demo_suite/bandwidthTest --memory=pinned --mode=quick --dtoh

