#!/bin/bash

# Sample submission script for Pi Monte Carlo using the parallel and Rmpi packages

#SBATCH -t 00:10:00
#SBATCH -N 1 --ntasks-per-node=8
#SBATCH -p dev_q

# Add modules
module purge
module load intel/18.2 openmpi/4.0.1 R/3.6.1 R-parallel/3.6.1

# OpenMPI environment variables to fix hangs
#export OMPI_MCA_btl_openib_allow_ib=1 #allow infiniband
#export OMPI_MCA_rmaps_base_inherit=1  #child processes inherit environment

# Run R
#Run as a script; this works but the .r file must be changed so the number
#of child processes is 1 less than the number of cores allocated
#Rscript mcpi_parallel.r

#Start with MPI
# --oversubscribe so we can start as many child processes as cores
#mpirun -np 1 --bind-to none --oversubscribe Rscript mcpi_parallel.r 
mpirun -np 1 --oversubscribe Rscript mcpi_parallel.r 

exit;
