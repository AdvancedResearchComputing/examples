#! /bin/bash
#
#SBATCH -t 05:00
#SBATCH -N 1 --ntasks-per-node=4
#SBATCH -p dev_q
#
#
module reset
module load foss

export OMP_NUM_THREADS=$SLURM_NTASKS
#
echo "OPENBLAS_TINKERCLIFFS: Normal beginning of execution."
#
gcc -c -I$OPENBLAS_DIR/include openblas_test_c.c
if [ $? -ne 0 ]; then
  echo "OPENBLAS_TINKERCLIFFS: Compile error!"
  exit 1
fi
#
gcc -o openblas_test_c openblas_test_c.o -L$OPENBLAS_LIB -lopenblas
if [ $? -ne 0 ]; then
  echo "OPENBLAS_TINKERCLIFFS: Load error!"
  exit 1
fi
#
./openblas_test_c > openblas_tinkercliffs_rome.txt
if [ $? -ne 0 ]; then
  echo "OPENBLAS_TINKERCLIFFS: Run error!"
  exit 1
fi
#
rm openblas_test_c.o
rm openblas_test_c
#
echo "OPENBLAS_TINKERCLIFFS: Normal end of execution."
exit 0
