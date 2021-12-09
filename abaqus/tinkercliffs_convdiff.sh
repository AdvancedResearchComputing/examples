#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --cpus-per-task=1
#SBATCH --partition=dev_q
#SBATCH --time=1:00:00
## Replace "YOURACCOUNT" with the name of your slurm account
#SBATCH --account=YOURACCOUNT

module reset
module load ABAQUS/2018
module load intel/2019b

cd $SLURM_SUBMIT_DIR
echo "working in `pwd`"

#echo "Current license availability is:"
#abaqus licensing lmdiag -n

echo "Unsetting SLURM_GTIDS=$SLURM_GTIDS to prevent <IBM Platform MPI> error"
unset SLURM_GTIDS

echo "Fetching job files from Abaqus installation"
abaqus fetch job=convectdifftemppulse*

echo "compiling fortran programs"
abaqus make job=2dtemp0 user=convectdifftemppulse_2dtemp0.f
abaqus make job=exact user=convectdifftemppulse_exact.f

echo "running compiled fortran codes to generate data files"
./2dtemp0
./exact

echo "Running with cpus=$SLURM_NTASKS"
abaqus analysis job=convectdifftemppulse_dcc2d4 cpus=$SLURM_NTASKS interactive