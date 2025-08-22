#! /bin/bash
#
#SBATCH --job-name=gaussian_example
#SBATCH --partition=normal_q
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4  # match nproc=4 in gaussian input file
#SBATCH --cpus-per-task=1
#SBATCH --time=0-0:05:00
#SBATCH --account=personal
#

#
module reset
module load Gaussian
module list

# Set Gaussian's scratch directory to local disk
# Could also try tmpfs ($TMPFS) to provide fastest performance
# But will consume memory
export GAUSS_SCRDIR=$TMPFS
#
echo "GAUSSIAN_TINKERCLIFFS: Normal beginning of execution."
#
#  Run.
#
g16 < g16_input.txt > gaussian_$SLURM_JOB_ID.out
if [ $? -ne 0 ]; then
  echo "GAUSSIAN_TINKERCLIFFS: Run error!"
  exit 1
fi
#
echo "GAUSSIAN_TINKERCLIFFS: Normal end of execution."
exit 0
