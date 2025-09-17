#!/bin/bash
#SBATCH --account=personal                      # your account allocation
#SBATCH --partition=normal_q                    # parition
#SBATCH --job-name=FDMNES_test_suite            # name of job seen in the queue
#SBATCH --nodes=1                               # node count
#SBATCH --ntasks-per-node 32                    # number of tasks per node
#SBATCH --cpus-per-task 2                       # cpu-cores per task (>1 if multi-threaded tasks)
#SBATCH --time=1-00:00:00                      # total run time limit (HH:MM:SS)

module load FDMNES/2025-07-15-foss-2024a
mpirun -np $SLURM_NTASKS -x HOST_NUM_FOR_MUMPS=$SLURM_CPUS_PER_TASK fdmnes

