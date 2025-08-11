#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16        # Adjusted to fit the hybrid setup
#SBATCH --cpus-per-task=4           # Using 4 OpenMP threads per MPI task
#SBATCH --account=personal
#SBATCH --partition=normal_q
#SBATCH --time=00:15:00
#SBATCH --mem=1GB

module reset
module load LAMMPS

export OMP_NUM_THREADS=4            # Set OpenMP threads

# Run LAMMPS with optimized mpirun settings and OMP suffix

echo "LAMMPS: Normal beginning of execution."


mpirun --map-by ppr:1:L3cache --bind-to l3cache -x OMP_NUM_THREADS  lmp -sf omp -pk omp $OMP_NUM_THREADS < input.in > output_hybrid.txt

if [ $? -ne 0 ]; then
  echo "LAMMPS: Run error!"
  exit 1
fi
#
echo "LAMMPS: Normal end of execution."
exit 0

