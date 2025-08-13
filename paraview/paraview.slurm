#!/bin/bash

#SBATCH --job-name=paraview_example
#SBATCH --partition=l40s_normal_q
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --gres=gpu:1       # Total number of gpus requested 
#SBATCH --time=0-0:10:00
#SBATCH --mem=1GB  #this is memory per node, total memory requested=40GB
#SBATCH --qos=fal_l40s_normal_base #setting quality of serivce to base
#SBATCH --account=personal

module load ParaView

# You might need to change your working directory, to the path of your data and Python script. Uncomment the following command and change the path accordingly.

#cd $SCRATCH/data

# run pvbatch one or more times (sequentially)

mpirun pvbatch pvcone.py
