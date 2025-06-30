#! /bin/bash
#
#SBATCH --job-name water_scf
#SBATCH --partition=normal_q
#SBATCH --nodes=1
#SBATCH --mem=1GB
#SBATCH --time=00:05:00
#SBATCH --account=personal
#

#
module reset
module load OpenMolcas
module list

#
echo "OPENMOLCAS: Normal beginning of execution."
#
#  Run.
#
pymolcas water.input -f


if [ $? -ne 0 ]; then
  echo "OPENMOLCAS: Run error!"
  exit 1
fi
#
echo "OPENMOLCAS: Normal end of execution."
exit 0
