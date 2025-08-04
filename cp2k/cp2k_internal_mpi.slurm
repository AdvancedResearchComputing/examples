#!/bin/bash
#SBATCH --account=personal
#SBATCH --job-name=cp2k_internal
#SBATCH --output=cp2k-internal-%j.log
#SBATCH --error=cp2k-internal-%j.err
#SBATCH --partition=a100_normal_q
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --cpus-per-task=2
#SBATCH --gres=gpu:1
#SBATCH --time=00:05:00

module reset
module load CP2K #also loads apptainer

#Set which container sif to use
CTNR=/apps/arch/software/CP2K/2025.1/cp2k_2025.1.sif

#Must be apptainer run not apptainer exec for mpiexec to be found within container
apptainer run --nv -B "$PWD" -B "$TMPDIR" -B /cm --env PATH=$PATH --env LD_LIBRARY_PATH=$LD_LIBRARY_PATH $CTNR mpiexec -n $SLURM_NTASKS -x OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK cp2k -i H2O-32.inp

echo "End of cp2k run"
