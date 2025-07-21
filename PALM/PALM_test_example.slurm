#!/bin/bash
######################## Start of SLURM Directives for Batch Job #########################################

# To understand each of the SLURM directives below (lines beginning with #SBATCH),
# please refer to the ARC documentation:
# https://www.docs.arc.vt.edu/usage/more-slurm.html#most-commonly-used-job-configuration-options

########################################
# Batch Job Identification & Runtime Specifications
# [PLEASE CUSTOMIZE THIS SECTION WITH ATLEAST YOUR OWN ACCOUNT NAME AND SELECTION OF AN APPROPRIATE ARC CLUSTER AND PARTITION FOR THAT CLUSTER BASED ON YOUR NEEDS]
########################################
#SBATCH --job-name=palm_test_example              # Descriptive job name
#SBATCH --account=HPCBIGDATA                      # SLURM account name (see your project allocation in Coldfront: https://coldfront.arc.vt.edu, and search for 'slurm_account_name' under the allocation)
#SBATCH --time=01:00:00                           # Walltime limit for the batch job (format: HH:MM:SS)
#SBATCH --partition=normal_q                      # Partition/queue to submit batch job to (adjust as needed for the ARC cluster you are running the batch job on)

#######################################
# Compute Node and CPU Configuration for the Batch Job
#######################################
#SBATCH --nodes=1                                 # Number of compute nodes to request for the batch job
#SBATCH --ntasks-per-node=4                       # Number of tasks per node
########################## End of SLURM Directives for Batch Job #########################################

echo "PALM example run started at: $(date)"

# Reset and load the PALM module
module reset
module load PALM/23.10-foss-2023a

# Set the working directory to your local PALM installation
export PALM_HOME=$HOME/PALM/23.10-foss-2023a
cd "$PALM_HOME"

# Set up the example case directory and copy input file
mkdir -p JOBS/example_cbl/INPUT
cp /apps/arch/software/PALM/23.10-foss-2023a/palm_model_system-v23.10/packages/palm/model/tests/cases/example_cbl/INPUT/example_cbl_p3d JOBS/example_cbl/INPUT/

# Run PALM using the 'example_cbl' case and your local build configuration
# -r: run ID / case name
# -c: config name ('default', as built earlier)
# -X4: use 4 --ntasks-per-node
# -a "d3#": additional execution flags (3D domain decomposition)
palmrun -r example_cbl -c default -X4 -a "d3#"
if [ $? -ne 0 ]; then
  echo "PALM run failed."
  exit 1
fi

echo "PALM example run completed at: $(date)"