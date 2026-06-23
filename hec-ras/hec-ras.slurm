#!/bin/bash
#SBATCH --job-name=HECRAS_CAL17
#SBATCH --partition=normal_q
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --time=00:30:00
#SBATCH --account=personal

module load HEC-RAS/6.6

#Uncomment the following line if you have encountered a segfault error
#ulimit -s unlimited

#Uncomment the following line if you have already run a previous HEC-RAS calculation
#rm Muncie.*

#This is coping over clear input files for the simulation
cp -r wrk_source/* $SLURM_SUBMIT_DIR

RasUnsteady Muncie.p04.tmp.hdf x04

# make a copy of the file and rename the hdf file
cp Muncie.p04.tmp.hdf Muncie.p04.hdf

