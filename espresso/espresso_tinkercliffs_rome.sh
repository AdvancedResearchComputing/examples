#! /bin/bash
#
#SBATCH -t 00:05:00
#SBATCH -N1 --ntasks-per-node=1
#SBATCH -p dev_q
#

#
module reset
module load QuantumESPRESSO
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

