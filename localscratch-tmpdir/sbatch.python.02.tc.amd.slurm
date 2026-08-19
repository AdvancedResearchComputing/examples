#!/bin/bash

## For TC.

# file: run.03.slurm

#SBATCH -J tmpfs-job

## Wall time.
#SBATCH --time=00:10:00 

#SBATCH --account=arcadm

## The collection of nodes (normal_q) and the 
## specific AMD nodes within that collection.
#SBATCH --partition=normal_q
#SBATCH --constraint=amd

### This requests 1 node, 1 core.
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1

## Do not specify memory explicitly; use the default allocation given to this job.
## #SBATCH --mem=200G

## Slurm output and error files.
#SBATCH -o slurm.local-scratch-01.tc.amd.%j.out
#SBATCH -e slurm.local-scratch-01.tc.amd.%j.err


# Load modules.
module reset
module load Python/3.13.5-GCCcore-14.3.0


# Activate a python env.
# None.

## Always write out the resources that you use, for confirmation.
echo " " 
echo "Job details: "
echo " " 

scontrol show job --details $SLURM_JOB_ID

echo " " 
echo " " 

# Copy input file, script, and code to $TMPDIR (fast memory access on local_scratch).
cp    input.02.inp      $TMPDIR/.
cp    run.03            $TMPDIR/.
cp    char_count_02.py  $TMPDIR/.


echo " " 
echo "original directory : ";pwd
echo " " 

cd $TMPDIR

echo " " 
echo "Changed the active directory to TMPDIR (see below)"

echo " " 
echo "TMPDIR = working directory = current directory: ";pwd
echo " " 

echo " " 
echo "run code"
echo " " 

# Code to execute.
sh run.03


# Move back to original directory.
echo "change back to the original directory:"
cd -

echo " " 
echo "current directory (should be original directory) : ";pwd
echo " " 

# Move results back to a permanent directory (and out of local_scratch).
cp -p $TMPDIR/results.python.02.out .

echo " " 
echo "Copy of output file complete.  All done."
echo " " 

