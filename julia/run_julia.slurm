#!/bin/bash

#SBATCH -J juliaserial

## Wall time.
#SBATCH --time=0-00:10:00 

## Account to "charge" to/run against.
#SBATCH --account=arcadm

## Partition/queue.
#SBATCH --partition=normal_q

### This requests 1 node, 1 core. 1 gpu.
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1 

## Load modules, if any.
module reset
module load Julia/1.11.3-linux-x86_64

julia test_script.jl > output.txt


