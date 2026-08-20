#!/bin/bash


## openmpi.


## -----------------------
# SLURM JOB SCRIPT OPTIONS:

## -----------------------
## ACCOUNT.
## The account (A) to charge to.
#SBATCH --account arcadm

## -----------------------
## EXECUTION DURATION.
# Set the time, which is the maximum time your job can run in HH:MM:SS
#SBATCH --time=0:30:00

## -----------------------
## NUM NODES AND CORES.
## The number of compute nodes is not specified directly.
## The total number of MPI processes is given, and then number of
## MPI processes per compute node.

## Total number compute nodes
## is derived from next two parameters.
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
## MEMORY.
## #SBATCH --mem=122MB
## #SBATCH --mem-per-cpu=100000000
## Exclusivity for nodes.
## If needed, request whole nodes by uncommenting the "#SBATCH --exclusive" line
## below.
## #SBATCH --exclusive


## -----------------------
## SLURM OUTPUT AND ERROR FILES.
#SBATCH --output slurm.tc.amd.mpich.mpi.02.%j.out
#SBATCH --error  slurm.tc.amd.mpich.mpi.02.%j.err

## -----------------------
## RESERVATION.
## #SBATCH --reservation=HPCMaintenance



## -----------------------
## MODULES.
module reset
module load MPICH/4.3.0-GCC-14.2.0



## -----------------------
## WORKING DIRECTORY.
cd $SLURM_SUBMIT_DIR


## -----------------------
## Record slurm conditions.
echo " "
echo "slurm scontrol" 
echo " "
scontrol show job --details $SLURM_JOB_ID
echo " "
echo "<< end slurm scontrol >>" 
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
the_exec="./mpi.simple02.mpich"
num_message_iterations=200
base_output_file="mpi_results"
mpiexec -n $SLURM_NTASKS     ${the_exec}  ${num_message_iterations}  ${base_output_file}

