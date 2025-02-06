#!/bin/bash
# This example was runs SU2's published Incompressible Flow tutorial on Composition-Dependent model for Species Transport equations 
# https://su2code.github.io/tutorials/Inc_Species_Transport_Composition_Dependent_Model/
# It demonstrates running an SU2 solver which has been compiled with MPI for distributed parallelism
# On Tinkercliffs normal_q, it takes about 16.5 minutes using 4 nodes and 32 tasks-per-node
#
# Usage: to run this example, 
# 1. copy the contents of this script into a file on an ARC system named su2-tc-kmt.sh
# 2. edit the script to reference your Slurm account and adjust nodes/tasks as desired
# 3. submit the job with the command "sbatch su2-tc-kmt.sh"
# ----------------------------------------------------------------------------------------
#
#SBATCH --account=<your Slurm account>
#SBATCH --partition=normal_q
#SBATCH --time=0-0:30:00
#SBATCH --nodes=4
#SBATCH --ntasks-per-node=32
#SBATCH --cpus-per-task=1

module reset
module load tinkercliffs-rome/su2

# We will use it, so make sure the USERNAME variable is set correctly
if [ "$USER" != `id -un` ]; then
  USER=`id -un`
fi

# Make a directory on /scratch for the test if it doesn't already exist
WORKDIR="/scratch/${USER}/su2-tut"
if [ ! -d "$WORKDIR" ]; then
  mkdir -p $WORKDIR
fi

# Copy the tutorial directory
cp -r $SU2_DIR/Tutorials/incompressible_flow/Inc_Species_Transport_Composition_Dependent_Model/ $WORKDIR
cd $WORKDIR/Inc_Species_Transport_Composition_Dependent_Model/

mpirun -n $SLURM_NTASKS SU2_CFD kenics_mixer_tutorial.cfg