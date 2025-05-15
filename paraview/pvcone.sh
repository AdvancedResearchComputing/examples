#!/bin/bash

#SBATCH -p dev_q #l40s_dev_q      # partition to run in
#SBATCH -N 1               # Total number of nodes requested
#SBATCH -n 1               # Total number of processes to run
##SBATCH --gres=gpu:1       # Total number of gpus requested 
#SBATCH -t 00:10:00        # Run time (hh:mm:ss) - 10 mins
#SBATCH -J pvbatch
#SBATCH -o pvbatch.out
#SBATCH -e pvbatch.err

#module load ParaView/5.13.2-foss-2023a-CUDA-12.1.1
module load ParaView/5.11.2-foss-2023a

# You might need to change your working directory, to the path of your data and Python script. Uncomment the following command and change the path accordingly.

#cd $SCRATCH/data

# run pvbatch one or more times (sequentially)

mpirun pvbatch pvcone.py
