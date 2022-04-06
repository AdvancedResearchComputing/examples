#!/bin/bash

## Translation from PBS to SLURM can be found at
## https://slurm.schedmd.com/rosetta.pdf

#SBATCH --partition=normal_q  # queue type
#SBATCH --nodes=2  # this requests 1 node
#SBATCH --ntasks-per-node=64  # this requests 128 cores across 2 nodes
#SBATCH --time=0-0:05:00 # wall clock time time [days-hh:mm:ss]
#SBATCH --account=personal
##SBATCH --export=NONE # this makes sure the compute environment is clean


echo "Starting hello world mpi job"

##printenv
# Navigate to the directory where the submit script was executed in
export RUNDIR=$SLURM_SUBMIT_DIR
cd $RUNDIR

module reset
module load foss

echo "loaded modules are:"
module list

echo "compiling mpihello.c"
mpicc mpihello.c -o tc-mpihello.x

# Store the nodes which are being used for referece
echo $SLURM_JOB_NODELIST | uniq > node_list.log

# Store the date and time the job is being run for reference
echo "Job begin: " `date`

# Run the job
#OMPI_MCA_btl_openib_allow_ib=true mpirun -np 64 $EXEC
mpirun -np $SLURM_NTASKS ./tc-mpihello.x

echo "Job end: " `date`

exit
