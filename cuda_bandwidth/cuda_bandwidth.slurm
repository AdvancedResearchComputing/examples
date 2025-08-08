#! /bin/bash

#SBATCH --job-name=cuda_bandwidth_example
#SBATCH --partition=a100_normal_q
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --gres=gpu:1
#SBATCH --cpus-per-task=1
#SBATCH --time=0-0:05:00
#SBATCH --mem=1GB  #this is memory per node, total memory requested=40GB
##SBATCH --account=personal
#SBATCH --account=arcadm
#

#Load CUDA module
module reset
module load cuda12.6/toolkit
module load CUDA
#

#Run CUDA's bandwidth test
$EBROOTCUDA/extras/demo_suite/bandwidthTest --memory=pinned --mode=quick --dtoh

