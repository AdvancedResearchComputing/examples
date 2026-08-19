#!/bin/bash


## openmpi.

## -----------------------
# SLURM JOB SCRIPT OPTIONS:

## -----------------------
## EXECUTION DURATION.
# Set the time, which is the maximum time your job can run in HH:MM:SS
#SBATCH --time=0:10:00

## -----------------------
## NUM NODES AND CORES.
## The number of compute nodes is not specified directly.
## The total number of MPI processes is given, and then number of
## MPI processes per compute node.
## From this, the number of compute nodes is automatically calculated.

## Total number of MPI processes in the entire job.
#SBATCH --ntasks=2

## Number of MPI processes per compute node.
#SBATCH --ntasks-per-node=1

## Number of cores (total) per compute node (e.g., for hybrid threading).
#SBATCH --cpus-per-task=1


## -----------------------
## JOB QUEUE/PARTITION AND CONSTRAINTS.
##  Set the partition to submit to (a partition is equivalent to a queue)
#SBATCH --partition=normal_q
#SBATCH --constraint=amd


## -----------------------
## Exclusivity for nodes.
## If needed, request whole nodes by uncommenting the "#SBATCH --exclusive" line
## below.
## #SBATCH --exclusive

## -----------------------
## SLURM OUTPUT AND ERROR FILES.
#SBATCH --output slurm.tc.amd.intel.mpi.02.%j.out
#SBATCH --error slurm.tc.amd.intel.mpi.02.%j.err


## -----------------------
## ACCOUNT.
## The account to charge to.
## You will have your own accounts.
#SBATCH --account arcadm


## -----------------------
## MEMORY.
## Example if you want/need to specify memory per node.
##SBATCH --mem=122368

## -----------------------
## RESERVATION.
##  #SBATCH --reservation=HPCMaintenance

## -----------------------
## MODULES.
module reset
module load intel/2024a


## -----------------------
## WORKING DIRECTORY.
cd $SLURM_SUBMIT_DIR



## -----------------------
## Record slurm conditions.
echo " "
echo "slurm scontrol:" 
echo " "
scontrol show job --details $SLURM_JOB_ID
echo " "
echo " << end slurm scontrol >>" 
echo " "


## -----------------------
## EXPORTS 
## Exports and variable assignments.
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK
export MV2_ENABLE_AFFINITY=0

echo "   SLURM_CPUS_PER_TASK: " $SLURM_CPUS_PER_TASK
echo "   OMP_NUM_THREADS: " $OMP_NUM_THREADS
echo "   MV2_ENABLE_AFFINITY: "  $MV2_ENABLE_AFFINITY
echo "   SLURM_NTASKS: "  $SLURM_NTASKS
echo "   SLURM_JOB_NUM_NODES: "  $SLURM_JOB_NUM_NODES


## -----------------------
## JOB.
## Number of MPI processes is the number of tasks.
the_exec="./mpi.simple02.intel"
num_message_iterations=200
base_output_file="mpi_results"
## srun --mpi=pmix  ${the_exec}  ${num_tasks}  ${base_output_file}
mpiexec -n  $SLURM_NTASKS     ${the_exec}  ${num_message_iterations}  ${base_output_file} 
