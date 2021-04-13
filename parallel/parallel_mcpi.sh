#!/bin/bash
#Slurm submission script for running a batch of R scripts in parallel
#using GNU parallel

#SBATCH -N 1
#SBATCH --ntasks-per-node=16
#SBATCH -t 0:05:00
#SBATCH -p normal_q              


#load modules
module reset
module load parallel/20200522-GCCcore-9.3.0
module load R/4.0.2-foss-2020a

# #set r libraries (if you need custom libraries)
# export R_LIBS="$HOME/R/4.0.2-foss-2020a/tinkercliffs/lib:$R_LIBS"

#number of r processes to run in all
ncopies=32

#processes to run at a time
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
