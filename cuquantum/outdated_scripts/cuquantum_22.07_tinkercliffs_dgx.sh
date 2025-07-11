#!/bin/bash
#SBATCH --job-name=cuquantum
#SBATCH --partition=dgx_normal_q
#SBATCH --nodes=1
#SBATCH --gres=gpu:1
#SBATCH --cpus-per-task=8
#SBATCH --account=<your slurm account here>
## This requests 1 node from the dgx_normal_q partition, 1 gpu on that node, and 8 cores which provides 256GB memory

module load containers/apptainer

#Ensure shell variable USER is set correctly and that /globalscratch directory is set up.
USER=`whoami`

#Set which container sif to use
#  This container was created on 8/23/2022 from Nvidia's docker registry using the following command:
#  "singularity pull --dir /localscratch/brownm12/ cuquantum-appliance_22.07-cirq.sif docker://nvcr.io/nvidia/cuquantum-appliance_22.07-cirq"
CTNR=/global/arcsingularity/cuquantum-appliance_22.07-cirq.sif

#Set bind options to map directories into the container
BOPTS="--bind /home/$USER,/projects"
[[ -d /globalscratch/$USER ]] && BOPTS="$BOPTS,/globalscratch/$USER"

cd $SLURM_SUBMIT_DIR

# Run the three examples included with cuQuantum and sends output to files in the submission directory
# "exec" runs the requested commands inside the container and then exits
# "--nv" turns on singularity's nvidia GPU support which maps libraries and variables into the container
# BOPTS and CTNR are expanded to values set above
# /workspace/examples is a directory inside the container supplied by Nvidia

echo "Running three examples in the Nvidia cuQuantum container"
echo "jobid: $SLURM_JOBID, working directory: `pwd`"
apptainer exec --nv $BOPTS $CTNR python /workspace/examples/ghz.py --nqubits 20 --nsamples 10000 --ngpus 1 > ghz_out.$SLURM_JOBID.txt
echo "Ran GHZ example, output written to ghz_out.$SLURM_JOBID.txt"
apptainer exec --nv $BOPTS $CTNR python /workspace/examples/hidden_shift.py --nqubits 20 --nsamples 100000 --ngpus 1 > hidden_shift_out.$SLURM_JOBID.txt
echo "Ran Hidden-Shift example, output written to hidden_shift_out.$SLURM_JOBID.txt"
apptainer exec --nv $BOPTS $CTNR python /workspace/examples/simon.py --nbits 15 --ngpus 1 > simon_out.$SLURM_JOBID.txt
echo "Ran Simon example, output written to simon_out.$SLURM_JOBID.txt"
