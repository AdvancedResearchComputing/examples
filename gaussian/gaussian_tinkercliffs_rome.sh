#! /bin/bash
#
#SBATCH -t 00:05:00
#SBATCH -N1 --ntasks-per-node=8
#SBATCH -p dev_q
#

#
module reset
module load gaussian
#
echo "GAUSSIAN_TINKERCLIFFS ROME: Normal beginning of execution."
#
#  Run.
#
g09 < g09_input.txt > gaussian_tinkercliffs_rome.txt
if [ $? -ne 0 ]; then
  echo "GAUSSIAN_TINKERCLIFFS ROME: Run error!"
  exit 1
fi
#
echo "GAUSSIAN_TINKERCLIFFS ROME: Normal end of execution."
exit 0
