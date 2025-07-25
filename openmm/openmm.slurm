#! /bin/bash
#
#SBATCH --job-name=openmm_example
#SBATCH --partition=a100_normal_q
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --gres=gpu:1
#SBATCH --time=0-0:05:00
#SBATCH --mem=1GB  #this is memory per node, total memory requested=40GB
#SBATCH --account=personal
#

#
module reset
module load OpenMM
#


#Run OpenMM's HelloArgonInC example
#  This example and the Makefile were copied from OpenMM's
#  examples directory $EBROOTOPENMM/examples
#  Note that we adjusted the value of OpenMM_INSTALL_DIR in the
#  Makefile to point to the module's directory $(EBROOTOPENMM)
make HelloArgonInC
./HelloArgonInC

echo "Done with Hello Argon Example"
exit
