#! /bin/bash
#SBATCH -t 48:00:00
#SBATCH --account=personal
#SBATCH --partition=a100_normal_q
#SBATCH --nodes=1
#SBATCH --gres=gpu:2
#SBATCH --ntasks-per-node=2
#SBATCH --cpus-per-task=8

module reset
module load VASP/6.5.1-OpenMPI-5.0.3-NVHPC-24.9-CUDA-12.6.0
module list

# Instruct OpenMPI not to use some deprecated interfaces, particularly openib
export OMPI_MCA_btl=^vader,tcp,openib,uct

echo "VASP_TINKERCLIFFS ROME: Normal beginning of execution."
which vasp_std

# log gpu usage
nvidia-smi --query-gpu=timestamp,name,pci.bus_id,driver_version,temperature.gpu,utilization.gpu,utilization.memory,memory.total,memory.free,memory.used --format=csv -l 3 > $SLURM_JOBID.gpu.log &

echo "Launching VASP with ${SLURM_GPUS_PER_NODE} GPUs and hybrid MPI+OpenMP"
echo " with ${SLURM_NTASKS_PER_NODE} tasks x ${SLURM_CPUS_PER_TASK} threads per task"

OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

mpirun vasp_std