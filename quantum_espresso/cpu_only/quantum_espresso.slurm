#! /bin/bash
#
#SBATCH --job-name silicon
#SBATCH --partition=normal_q
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --cpus-per-task=1
#SBATCH --mem=8GB
#SBATCH --time=00:10:00
#SBATCH --account=<account_name_no_beaks>
#

#
module reset
module load QuantumESPRESSO/7.4-foss-2024a

#
echo "Quantum ESPRESSO: Normal beginning of execution."
#

mpirun -np $SLURM_NTASKS pw.x -i silicon.in > silicon.out

echo "Quantum ESPRESSO: Normal end of execution."

exit 0

