#! /bin/bash
#
#SBATCH -t 00:05:00
#SBATCH -N1 --ntasks-per-node=1
#SBATCH -p dev_q
#

#
module reset
module load netCDF
module list
#
echo "NETCDF_TINKERCLIFFS ROME: Normal beginning of execution."
#
gcc -c -I$EBROOTNETCDF/include netcdf_test.c
if [ $? -ne 0 ]; then
  echo "NETCDF_TINKERCLIFFS ROME: Compile error!"
  exit 1
fi
#
gcc -o netcdf_test netcdf_test.o -L$EBROOTNETCDF/lib64 -lnetcdf
if [ $? -ne 0 ]; then
  echo "NETCDF_TINKERCLIFFS ROME: Load error!"
  exit 1
fi
rm netcdf_test.o
#
./netcdf_test > netcdf_tinkercliffs_rome.txt
if [ $? -ne 0 ]; then
  echo "NETCDF_TINKERCLIFFS ROME: Run error!"
  exit 1
fi
rm netcdf_test
#
echo "NETCDF_TINKERCLIFFS ROME: Normal end of execution."
exit 0
