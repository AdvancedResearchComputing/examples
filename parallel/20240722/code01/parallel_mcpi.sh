#!/bin/bash

#  Slurm submission script for running a batch of R scripts in parallel
#using GNU parallel

# Job specs.
#SBATCH --job-name=gnu-parallel
#SBATCH --account=arcadm    
#SBATCH --time=01:00:00    
#SBATCH --partition=normal_q           
#SBATCH --output=gnu-parallel.%j.out    
#SBATCH --error=gnu-parallel.%j.err      

#SBATCH --nodes=1               
#SBATCH --ntasks-per-node=16    
#SBATCH --cpus-per-task=1       


# Load modules.
module reset
module load parallel/20240722-GCCcore-13.3.0
module load R/4.4.2-gfbf-2024a

# #set r libraries (if you need custom libraries)
# export R_LIBS="$HOME/R/4.0.2-foss-2020a/tinkercliffs/lib:$R_LIBS"

# Number of r processes to run in all.
ncopies=32

# Processes to run at a time.
nparallel=$SLURM_NTASKS

echo "$( date ): Starting mcpi"

#parallel will be doing something like the following bash loop,
#but with load balancing and other nice features
# for i in $( seq 1 $ncopies ); do 
#   Rscript mcpi_run.R seed=$i > mcpi_run_${i}.Rout &
# done
# wait

#parallel version
seq 1 $ncopies | parallel -j$nparallel "Rscript mcpi_run.R seed={} > mcpi_run_{}.Rout"

#Collect results and print some statistics
Rscript mcpi_collect.R

echo "$( date ): Finished mcpi"
