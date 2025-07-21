#!/bin/bash
######################## Start of SLURM Directives for Batch Job #########################################

# To understand each of the SLURM directives below (lines beginning with #SBATCH),
# please refer to the ARC documentation:
# https://www.docs.arc.vt.edu/usage/more-slurm.html#most-commonly-used-job-configuration-options

########################################
# Batch Job Identification & Runtime Specifications
# [PLEASE CUSTOMIZE THIS SECTION WITH ATLEAST YOUR OWN ACCOUNT NAME AND SELECTION OF AN APPROPRIATE ARC CLUSTER AND PARTITION FOR THAT CLUSTER BASED ON YOUR NEEDS]
########################################
#SBATCH --job-name=palm_build                     # Descriptive job name
#SBATCH --account=HPCBIGDATA                      # SLURM account name (see your project allocation in Coldfront: https://coldfront.arc.vt.edu, and search for 'slurm_account_name' under the allocation)
#SBATCH --time=01:00:00                           # Walltime limit for the batch job (format: HH:MM:SS)
#SBATCH --partition=normal_q                      # Partition/queue to submit batch job to (adjust as needed for the ARC cluster you are running the batch job on)

#######################################
# Compute Node and CPU Configuration for the Batch Job
#######################################
#SBATCH --nodes=1                                 # Number of compute nodes to request for the batch job
#SBATCH --ntasks-per-node=4                       # Number of tasks per node
########################## End of SLURM Directives for Batch Job #########################################

echo "PALM build started at: $(date)"

# Reset all modules and load the centrally installed PALM module
module reset
module load PALM/23.10-foss-2023a

# Set up a working build directory in your home space
export PALM_HOME=$HOME/PALM/23.10-foss-2023a
mkdir -p "$PALM_HOME"
cd "$PALM_HOME"

# Copy the default PALM config file from the central installation
cp /apps/arch/software/PALM/23.10-foss-2023a/.palm.config.default .

# Create the 'src' directory and copy PALM source files into your local tree
mkdir -p "$PALM_HOME/palm_model_system-v23.10/packages/palm/model/src"
cp -R /apps/arch/software/PALM/23.10-foss-2023a/palm_model_system-v23.10/packages/palm/model/src "$PALM_HOME/palm_model_system-v23.10/packages/palm/model/"

# Update hardcoded paths in the config file to reflect your local environment
sed -i "s|~/PALM/23.10-foss-2023a/|$PALM_HOME/|g" .palm.config.default
sed -i "s|/apps/arch/software/PALM/23.10-foss-2023a/palm_model_system-v23.10/packages/palm/model/src|$PALM_HOME/palm_model_system-v23.10/packages/palm/model/src|g" .palm.config.default

# Build PALM using your local configuration
yes | palmbuild -c default
if [ $? -ne 0 ]; then
  echo "PALM build failed."
  exit 1
fi

echo "PALM build completed at: $(date)"
