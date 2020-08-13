#! /bin/bash
#
#SBATCH -t 00:10:00
#SBATCH -N1 --ntasks-per-node=4
#SBATCH -p dev_q
#

#
module reset
module load QuantumESPRESSO
#
echo "ESPRESSO_TINKERCLIFFS ROME: Normal beginning of execution."
#
./run_example
if [ $? -ne 0 ]; then
  echo "ESPRESSO_TINKERCLIFFS ROME: Run error!"
  exit 1
fi
#
echo "ESPRESSO_TINKERCLIFFS ROME: Normal end of execution."
exit 0

