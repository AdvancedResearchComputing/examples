#! /bin/bash
#
#SBATCH -t 00:05:00
#SBATCH -N1 --ntasks-per-node=1 --gres=gpu:1
#SBATCH -p t4_dev_q
#

#
module reset
module load OpenMM/7.5.0-fosscuda-2019b-Python-3.7.4
#


#Run OpenMM's HelloArgonInC example
#  This example and the Makefile were copied from OpenMM's
#  examples directory $EBROOTOPENMM/examples
#  Note that we adjusted the value of OpenMM_INSTALL_DIR in the
#  Makefile to point to the module's directory $(EBROOTOPENMM)
make HelloArgonInC
./HelloArgonInC
