#!/bin/bash
#SBATCH --job-name=sqlite_job
#SBATCH --time=00:10:00
#SBATCH --account=<account_name_no_beaks>
#SBATCH --partition=normal_q
## Constraint not needed here.
#### #SBATCH --constraint=amd
#SBATCH --ntasks=1
#SBATCH --tasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --output=job_%j.out
#SBATCH --error=job_%j.err

# Load the modules.
module purge
module reset
module load Python/3.14.2-GCCcore-15.2.0

# Always print the resources on which your job actually runs.
echo " "
echo "scontrol show job --details"
echo " "
scontrol show job --details $SLURM_JOB_ID
echo " "

echo "python version"
python --version
echo " "

# Run the job.
sh run.me

