#!/bin/bash
echo "parameter $1, running on `hostname`"  #prints to the SLURM Job's output file
echo "parameter $1, running on `hostname`" > ${SLURM_JOB_ID}-task${1}.out #send task output to a separate file


stress -c $SLURM_CPUS_PER_TASK -t 15 >> ${SLURM_JOB_ID}-task${1}.out

# per-task gpu utilization logging
gpumon > gpu-util-${1}.log &
LOGGING_PID=$!

echo "GPU Device Info:" >> ${SLURM_JOB_ID}-task${1}.out
nvidia-smi --query-gpu=index,name,gpu_bus_id --format=csv >> ${SLURM_JOB_ID}-task${1}.out

#### run your gpu-enabled code here:



# stop gpu utilization logging for this task
kill ${LOGGING_PID}