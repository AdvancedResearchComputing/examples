#!/bin/bash

# Sample submission script for parallel Metropolis-Hastings
# This example uses the parallel package only without Rmpi,
# so it only worked within a node. Rmpi can be enabled by
# uncommenting a few lines in the R script and below

#SBATCH -t 00:10:00
#SBATCH -N 1 --ntasks-per-node=8
#SBATCH -p dev_q

# Add modules
module purge
module load intel/18.2 openmpi/4.0.1 R/3.6.1 R-parallel/3.6.1

# Run R
Rscript mh_parallel.r

#Uncomment to start with MPI
# --oversubscribe so we can start as many child processes as cores
#mpirun -np 1 --oversubscribe Rscript mh_parallel.r

