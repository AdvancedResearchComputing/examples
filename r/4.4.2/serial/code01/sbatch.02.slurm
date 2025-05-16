#!/bin/bash


#SBATCH -J rserial.02

## Account.
#SBATCH --account arcadm

## Time.
#SBATCH --time 00:10:00

## Reservation.
#SBATCH --reservation=HPCMaintTesting

## Partition.
## #SBATCH --partition normal_q
#SBATCH --partition dev_q

## Num nodes, tasks, cores.
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1

## Slurm output and error files.
## Always put "%j" into the output (-o) and error (-e) files.
## %j is the unique job ID assigned by slurm and provides
## traceability.
#SBATCH -o r.serial.owl.02.%j.out
#SBATCH -e r.serial.owl.02.%j.err

## Get familiar with global variables whose values
## are provided by Slurm, e.g., ${SLURM_JOB_ID}.
echo "date: `date`"
echo "hostname: $HOSTNAME"; echo
echo -e "\nChecking job details for CPU_IDs..."
## The switch "--details" gives the IDs of the cores of a 
## compute node that are assigned to this job. 
scontrol show job --details $SLURM_JOB_ID

echo " " 

## Load all required modules.
module purge
module reset
module load R/4.4.2-gfbf-2024a

param4="owl.dev_q"
param5=${SLURM_JOB_ID}
## param5="output.owl.dev_q.JOB_ID.txt"


## Invocation of the R code.
Rscript test_args.02.R param1 param2 param3 ${param4}  ${param5}
