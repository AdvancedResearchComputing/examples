#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16        # Adjusted to fit the hybrid setup
#SBATCH --cpus-per-task=4           # Using 4 OpenMP threads per MPI task
#SBATCH --account=personal
#SBATCH --partition=normal_q
#SBATCH --time=00:15:00

module reset
module load LAMMPS/29Aug2024-foss-2023b-kokkos

export OMP_NUM_THREADS=4            # Set OpenMP threads

# Run LAMMPS with optimized mpirun settings and OMP suffix

echo "LAMMPS_TINKERCLIFFS ROME: Normal beginning of execution."


mpirun --map-by ppr:1:L3cache --bind-to l3cache -x OMP_NUM_THREADS  lmp -sf omp -pk omp $OMP_NUM_THREADS < input.in > output.txt

if [ $? -ne 0 ]; then
  echo "LAMMPS_TINKERCLIFFS ROME: Run error!"
  exit 1
fi
#
echo "LAMMPS_TINKERCLIFFS ROME: Normal end of execution."
exit 0

