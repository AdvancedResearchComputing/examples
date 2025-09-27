#!/bin/bash
#SBATCH --account=arcadm
#SBATCH --partition=l40s_normal_q
#SBATCH --nodes=1
#SBATCH --gres=gpu:1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=4
#SBATCH --time=0-1:00:00

module reset
module load Tinker9/1.4.0-NVHPC-25.1

WORKDIR="/scratch/${USER}/t9-example"
mkdir -p "$WORKDIR"
cd "$WORKDIR"

# Confirm Tinker9 root
echo "EBROOTTINKER9=$EBROOTTINKER9"
ls -l $EBROOTTINKER9

# Try to copy example and params
if [ -d "$EBROOTTINKER9/example" ]; then
  cp -vr $EBROOTTINKER9/{example,params} .
elif [ -d "$EBROOTTINKER9/tinker9/example" ]; then
  cp -vr $EBROOTTINKER9/tinker9/{example,params} .
else
  echo "ERROR: Cannot locate example or params directories."
  exit 1
fi

cd example || { echo "example dir not found"; exit 1; }

# GPU monitor and run
/apps/common/useful_scripts/gpumon > $SLURM_SUBMIT_DIR/job-${SLURM_JOB_ID}-gpu.log &
tinker9 info
echo "-------- Starting tinker9: `date` -------"
tinker9 dynamic dhfr2.xyz 5000 2 1 2 298
echo "------- tinker9 has exited: `date` --------"

