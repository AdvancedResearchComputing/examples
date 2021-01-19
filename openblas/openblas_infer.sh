#! /bin/bash
#
#SBATCH -t 05:00
#SBATCH -N 1 --ntasks-per-node=4
#SBATCH -p t4_dev_q
#
#
module reset
module load foss

export OMP_NUM_THREADS=$SLURM_NTASKS
#
echo "OPENBLAS_INFER: Normal beginning of execution."
#
gcc -c -I$EBROOTOPENBLAS/include openblas_test_c.c
if [ $? -ne 0 ]; then
  echo "OPENBLAS_INFER: Compile error!"
  exit 1
fi
#
gcc -o openblas_test_c openblas_test_c.o -L$EBROOTOPENBLAS/lib -lopenblas
if [ $? -ne 0 ]; then
  echo "OPENBLAS_INFER: Load error!"
  exit 1
fi
#
./openblas_test_c > openblas_infer.txt
if [ $? -ne 0 ]; then
  echo "OPENBLAS_INFER: Run error!"
  exit 1
fi
#
rm openblas_test_c.o
rm openblas_test_c
#
echo "OPENBLAS_INFER: Normal end of execution."
exit 0
