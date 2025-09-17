#! /bin/bash
#
#SBATCH --job-name pw_energy_bandstruct
#SBATCH --partition=normal_q
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --mem=1GB
#SBATCH --time=00:05:00
#SBATCH --account=personal
#

#
module reset
module load QuantumESPRESSO/7.4-foss-2024a
#
echo "Quantum ESPRESSO: Normal beginning of execution."
#
./run_example
if [ $? -ne 0 ]; then
  echo "Quantum ESPRESSO: Run error!"
  exit 1
fi
#
echo "Quantum ESPRESSO: Normal end of execution."
exit 0

