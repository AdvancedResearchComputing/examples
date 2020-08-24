#! /bin/bash
#
#SBATCH -t 00:05:00
#SBATCH -N1 --ntasks-per-node=8
#SBATCH -p dev_q
#

#
module reset
module load OpenMolcas
module list

#
echo "OPENMOLCAS_TINKERCLIFFS ROME: Normal beginning of execution."
#
#  Run.
#
molcas water.input -f
if [ $? -ne 0 ]; then
  echo "OPENMOLCAS_TINKERCLIFFS ROME: Run error!"
  exit 1
fi
#
echo "OPENMOLCAS_TINKERCLIFFS ROME: Normal end of execution."
exit 0
