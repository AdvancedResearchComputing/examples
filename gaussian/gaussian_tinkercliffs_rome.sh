#! /bin/bash
#
#SBATCH -t 00:05:00
#SBATCH -N1 --ntasks-per-node=8
#SBATCH -p dev_q
#

#
module reset
module load gaussian
module list

# Set Gaussian's scratch directory to local disk
# Could also try tmpfs ($TMPFS) to provide fastest performance
# But will consume memory
export GAUSS_SCRDIR=$TMPFS
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
