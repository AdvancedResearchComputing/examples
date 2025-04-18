#!/bin/bash
#SBATCH --account=personal     # edit this to specify another Slurm account if desired
#SBATCH --partition=normal_q
#SBATCH --timelimit=0-0:10:00  # 10 minutes - more than enough for this helloworld job
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=1G               # this minimal example needs very little memory
## end of slurm options #################################################################
# usage:
# sbatch helloworld.sh
#########################################################################################
date  #print the date and time in the output file
echo "Running a Julia \"Hello World\" example"

cd $SLURM_SUBMIT_DIR # change to the current working directory when the job was submitted

module reset
module load Julia/1.10.4-linux-x86_64

echo "Julia installation info:"
which julia # print the location of the julia executable
julia -v    # ask the julia executable to print its version

echo "... running..."

julia helloworld.jl

date
echo "complete!"