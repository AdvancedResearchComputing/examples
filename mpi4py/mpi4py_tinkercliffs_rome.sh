#! /bin/bash
#
#SBATCH -t 00:05:00
#SBATCH -N1 --ntasks-per-node=4
#SBATCH -p dev_q
#

#load modules
module reset
module load mpi4py

#run mpi4py hello world
mpirun -np $SLURM_NTASKS python hello_mpi.py
