#! /bin/bash
#
#SBATCH -t 00:05:00
#SBATCH -N1 --ntasks-per-node=1
#SBATCH -p dev_q
#

#
module reset
module load HDF5
#
echo "HDF5_TINKERCLIFFS ROME: Normal beginning of execution."
#
h5pcc -c hdf5_test.c
if [ $? -ne 0 ]; then
  echo "HDF5_TINKERCLIFFS ROME: Compile error."
  exit 1
fi
#
h5pcc -o hdf5_test hdf5_test.o
if [ $? -ne 0 ]; then
  echo "HDF5_TINKERCLIFFS ROME: Load error."
  exit 1
fi
rm hdf5_test.o
#
./hdf5_test > hdf5_tinkercliffs_rome.txt
if [ $? -ne 0 ]; then
  echo "HDF5_TINKERCLIFFS ROME: Run error."
  exit 1
fi
rm hdf5_test
#
echo "HDF5_TINKERCLIFFS ROME: Normal end of execution."
exit 0
