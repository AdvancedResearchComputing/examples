#!/bin/bash
# This example was runs SU2's published Incompressible Flow tutorial on Composition-Dependent model for Species Transport equations 
# https://su2code.github.io/tutorials/Inc_Species_Transport_Composition_Dependent_Model/
# It demonstrates running an SU2 solver which has been compiled with MPI for distributed parallelism
# On Tinkercliffs normal_q, it takes about 20 minutes using 4 nodes and 32 tasks-per-node
#
# ----------------------------------------------------------------------------------------
#
#SBATCH --job-name=su2_example
#SBATCH --partition=normal_q
#SBATCH --nodes=4
#SBATCH --ntasks-per-node=32
#SBATCH --cpus-per-task=1
#SBATCH --time=0-0:30:00
#SBATCH --mem=10GB  #this is memory per node, total memory requested=40GB
#SBATCH --account=personal

module reset
module load SU2

# We will use it, so make sure the USERNAME variable is set correctly
if [ "$USER" != `id -un` ]; then
  USER=`id -un`
fi

# Make a directory on /scratch for the test if it doesn't already exist
WORKDIR="/scratch/${USER}/su2-tut"
if [ ! -d "$WORKDIR" ]; then
  mkdir -p $WORKDIR
fi

#Copy tutorial file in this example (which was taken from SU2 Tutorial Github)
cp -r tutorial_example $WORKDIR

#Change into the working directory in /scratch
cd $WORKDIR/tutorial_example/

#run the tutorial example
mpirun -n $SLURM_NTASKS SU2_CFD kenics_mixer_tutorial.cfg
