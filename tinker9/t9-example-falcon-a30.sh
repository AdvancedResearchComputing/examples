#!/bin/bash
#SBATCH --account=<your account>
#SBATCH --partition=a30_normal_q
#SBATCH --nodes=1
#SBATCH --gres=gpu:1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=4
#SBATCH --time=0-1:00:00

# Each node type has different modules avilable. Resetting makes the appropriate stack available
module reset
module load falcon-sapphirerapids/tinker9/1.4.0-nvhpc-23.7

# We will use it, so make sure the USERNAME variable is set correctly
if [ "$USER" != `id -un` ]; then
  USER=`id -un`
fi

# Make a directory on /scratch for the test if it doesn't already exist
# /scratch is preferred over /home or /projects for staging and running jobs
WORKDIR="/scratch/${USER}/t9-example"
if [ ! -d "$WORKDIR" ]; then
  mkdir -p $WORKDIR
fi

# Tinker9 installation has example files. Copying them to working directory
cp -vr $EBROOTTINKER9/tinker9/{example,params} .
cd example

# Diagnostic output
echo "working in `pwd`"
ls -l

# Start background process to log GPU utilization to a file
# This example should run at about 97% GPU utilization and <1GB of device memory while running
/apps/useful_scripts/bin/gpumon > $SLURM_SUBMIT_DIR/job-${SLURM_JOB_ID}-gpu.log &

tinker9 info
# Run the example. Expected runtime for this example is 1 minute on a A30 GPU
echo "-------- Starting tinker9: `date` -------"
tinker9 dynamic dhfr2.xyz 5000 2 1 2 298
echo "------- tinker9 has exited: `date` --------"