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
#  This container was created on 11/01/2023 from Nvidia's docker registry using the following command:
#  "apptainer pull cuquantum-appliance_23.06.sif docker://nvcr.io/nvidia/cuquantum-appliance:23.06"
# More information is here: https://catalog.ngc.nvidia.com/orgs/nvidia/containers/cuquantum-appliance
CTNR=/global/arcsingularity/cuquantum-appliance_23.06.sif

#Set bind options to map directories into the container
BOPTS="--bind /home/$USER,/projects"
[[ -d /globalscratch/$USER ]] && BOPTS="$BOPTS,/globalscratch/$USER"

cd $SLURM_SUBMIT_DIR

# Run the three examples included with cuQuantum and sends output to files in the submission directory
# "exec" runs the requested commands inside the container and then exits
# "--nv" turns on singularity's nvidia GPU support which maps libraries and variables into the container
# BOPTS and CTNR are expanded to values set above
# /home/cuquantum/examples is a directory inside the container supplied by Nvidia

# Set the path to the working directory inside the container
WORKDIR=/home/cuquantum/examples

echo "Running three examples in the Nvidia cuQuantum container"
echo "jobid: $SLURM_JOBID, working directory: `pwd`"
apptainer exec --nv $BOPTS $CTNR python $WORKDIR/ghz.py --nqubits 20 --nsamples 10000 --ngpus 1 > ghz_out.$SLURM_JOBID.txt
echo "Ran GHZ example, output written to ghz_out.$SLURM_JOBID.txt"
apptainer exec --nv $BOPTS $CTNR python $WORKDIR/hidden_shift.py --nqubits 20 --nsamples 100000 --ngpus 1 > hidden_shift_out.$SLURM_JOBID.txt
echo "Ran Hidden-Shift example, output written to hidden_shift_out.$SLURM_JOBID.txt"
apptainer exec --nv $BOPTS $CTNR python $WORKDIR/simon.py --nbits 15 --ngpus 1 > simon_out.$SLURM_JOBID.txt
echo "Ran Simon example, output written to simon_out.$SLURM_JOBID.txt"
