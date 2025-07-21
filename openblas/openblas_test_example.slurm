#!/bin/bash
######################## Start of SLURM Directives for Batch Job #########################################

# To understand each of the SLURM directives below (lines beginning with #SBATCH),
# please refer to the ARC documentation:
# https://www.docs.arc.vt.edu/usage/more-slurm.html#most-commonly-used-job-configuration-options

########################################
# Batch Job Identification & Runtime Specifications
# [PLEASE CUSTOMIZE THIS SECTION WITH ATLEAST YOUR OWN ACCOUNT NAME AND SELECTION OF AN APPROPRIATE ARC CLUSTER AND PARTITION FOR THAT CLUSTER BASED ON YOUR NEEDS]
########################################
#SBATCH --job-name=openblas_test_example          # Descriptive job name
#SBATCH --account=HPCBIGDATA                      # SLURM account name (see your project allocation in Coldfront: https://coldfront.arc.vt.edu, and search for 'slurm_account_name' under the allocation)
#SBATCH --time=01:00:00                           # Walltime limit for the batch job (format: HH:MM:SS)
#SBATCH --partition=normal_q                      # Partition/queue to submit batch job to (adjust as needed for the ARC cluster you are running the batch job on)

#######################################
# Compute Node and CPU Configuration for the Batch Job
#######################################
#SBATCH --nodes=1                                 # Number of compute nodes to request for the batch job
#SBATCH --ntasks-per-node=1                       # Number of tasks per node
#SBATCH --cpus-per-task=4                         # CPUs per task
########################## End of SLURM Directives for Batch Job #########################################

# Load compiler and BLAS libraries
module reset				                     # Reset all modules
module load foss                                 # Loads GCC + OpenMPI + OpenBLAS, etc.

# Set number of OpenMP threads based on --cpus-per-task=4
export OMP_NUM_THREADS=$SLURM_CPUS_PER_TASK

#
echo "OPENBLAS: Beginning of execution."
#

# Compile the OpenBLAS test code #
gcc -c -I$EBROOTOPENBLAS/include openblas_test_c.c
if [ $? -ne 0 ]; then
  echo "OPENBLAS: Compile error!"
  exit 1
fi

# Link the compiled object with OpenBLAS
gcc -o openblas_test_c openblas_test_c.o -L$EBROOTOPENBLAS/lib -lopenblas
if [ $? -ne 0 ]; then
  echo "OPENBLAS: Linking error!"
  exit 1
fi

# Run the executable and save output
./openblas_test_c > openblas.txt
if [ $? -ne 0 ]; then
  echo "OPENBLAS: Runtime error!"
  exit 1
fi

# Clean up build artifacts
rm openblas_test_c.o
rm openblas_test_c

echo "OPENBLAS: End of execution."
exit 0
