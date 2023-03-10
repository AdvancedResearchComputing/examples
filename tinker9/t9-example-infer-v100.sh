#!/bin/bash
#SBATCH --account=<your account>
#SBATCH --partition=v100_normal_q
#SBATCH --nodes=1
#SBATCH --gres=gpu:1
#SBATCH --ntasks-per-node=12
#SBATCH --cpus-per-task=1
#SBATCH --time=0-1:00:00

# Each node type has different modules avilable. Resetting makes the appropriate stack available
module reset
module load infer-skylake_v100/tinker9/1.4.0-nvhpc-21.11

# V100 nodes have local SSD drives which are much faster than HOME or PROJECTS
# Using this scratch storage as the working directory for the job
cd $TMPSSD

# Tinker9 installation has example files. Copying them to working directory
cp -vr $EBROOTTINKER9/tinker9/{example,params} .
cd example

# Diagnostic output
echo "working in `pwd`"
ls -l

# Start background process to log GPU utilization to a file
/apps/useful_scripts/bin/gpumon > $SLURM_SUBMIT_DIR/job-${SLURM_JOB_ID}-gpu.log &

# Run the example
echo "-------- Starting tinker9: `date` -------"
tinker9 dynamic dhfr2.xyz 5000 2 1 2 298
echo "------- tinker9 has exited: `date` --------"

# Copy result files from local scratch (TMPSSD) back to job directory
# Local scratch is erased when the job ends
cp $TMPSSD/example/dhfr2.arc $SLURM_SUBMIT_DIR
