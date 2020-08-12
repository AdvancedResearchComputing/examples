#! /bin/bash
#
#SBATCH -t 05:00
#SBATCH -N 1 --ntasks-per-node=1
#SBATCH -p dev_q
#
module reset
module load OpenFOAM
#
echo "OPENFOAM_TINKERCLIFFS: Normal beginning of execution."
#
#  Define OpenFOAM environment.
#
. $FOAM_BASH
#
blockMesh > cavity_tinkercliffs_rome.txt
if [ $? -ne 0 ]; then
  echo "OPENFOAM_TINKERCLIFFS: Run error!"
  exit 1
fi
#
icoFoam >> cavity_tinkercliffs_rome.txt
if [ $? -ne 0 ]; then
  echo "OPENFOAM_TINKERCLIFFS: Run error!"
  exit 1
fi
#
echo "OPENFOAM_TINKERCLIFFS: Normal end of execution."
exit 0
