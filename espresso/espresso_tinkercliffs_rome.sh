#! /bin/bash
#
#SBATCH -t 00:05:00
#SBATCH -N1 --ntasks-per-node=1
#SBATCH -p dev_q
#

#
module reset
module load intel/15.3
module load openmpi/2.0.0
module load mkl/11.2.3
module load fftw/3.3.4
module load scalapack/2.0.2
module load espresso/5.1.2
#
echo "ESPRESSO_TINKERCLIFFS ROME: Normal beginning of execution."
#
mkdir -p tempdir
#
./run_example
if [ $? -ne 0 ]; then
  echo "ESPRESSO_TINKERCLIFFS ROME: Run error!"
  exit 1
fi
#
echo "ESPRESSO_TINKERCLIFFS ROME: Normal end of execution."
exit 0

