#!/bin/bash
#SBATCH --account=personal
#SBATCH --job-name=cp2k_external
#SBATCH --output=cp2k-external-%j.log
#SBATCH --error=cp2k-external-%j.err
#SBATCH --partition=a100_normal_q
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=4
#SBATCH --cpus-per-task=2
#SBATCH --gres=gpu:1
#SBATCH --time=00:05:00

module reset
module load OpenMPI
module load CP2K

#Set which container sif to use
CTNR=/apps/arch/software/CP2K/2025.1/cp2k_2025.1.sif

export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

mpiexec -n $SLURM_NTASKS apptainer run --nv -B "$PWD" -B "$TMPDIR" -B /cm --env PATH=$PATH --env LD_LIBRARY_PATH=$LD_LIBRARY_PATH $CTNR cp2k -i H2O-32.inp

echo "End of cp2k run"
