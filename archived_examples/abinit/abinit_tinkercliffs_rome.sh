#! /bin/bash
#
#SBATCH -t 00:05:00
#SBATCH -N1 --ntasks-per-node=1
#SBATCH -p dev_q
#

#
module reset
module load ABINIT
module list
#
echo "ABINIT_TINKERCLIFFS ROME: Normal beginning of execution."
#
abinit < tbase1_x.files > abinit_tinkercliffs_rome.txt
if [ $? -ne 0 ]; then
  echo "ABINIT_TINKERCLIFFS ROME: Run error!"
  exit 1
fi
#
echo "ABINIT_TINKERCLIFFS ROME: Normal end of execution."
exit 0
