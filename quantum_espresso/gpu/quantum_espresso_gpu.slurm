#!/bin/bash
#SBATCH --account=personal                # your account allocation
#SBATCH --job-name=QuantumEspresso_gpu  # name of slurm job
#SBATCH --partition=a30_normal_q        # partition
#SBATCH --nodes=1                       # node count
#SBATCH --ntasks-per-node=8             # number of tasks per node
#SBATCH --cpus-per-task=1               # cpu-cores per task (>1 if multi-threaded tasks)
#SBATCH --mem=32G                       # total memory per node
#SBATCH --gres=gpu:2                    # number of gpus per node
#SBATCH --time=00:15:00                 # total run time limit (HH:MM:SS)

module reset
module load apptainer
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

apptainer run --nv -B "$TMPDIR" -B /projects /apps/common/software/QuantumESPRESSO/7.3.1/quantum_espresso-7.3.1.sif mpiexec -n $SLURM_NTASKS -x OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK pw.x -input ausurf.in -npool 2
