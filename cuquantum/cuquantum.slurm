#!/bin/bash
#SBATCH --job-name=cuquantum
#SBATCH --partition=a100_normal_q
#SBATCH --constraint=dgx-A100
#SBATCH --nodes=1
#SBATCH --gres=gpu:1
#SBATCH --cpus-per-task=8
#SBATCH --account=arcadm
##SBATCH --account=<your slurm account here>
## This requests 1 node from the a100_normal_q partition, 1 DGX 8x A100-80G GPU on that node, and 8 cores which provides 125.44GB memory (15.68GB/core)

module load apptainer

#Ensure shell variable USER is set correctly and that /globalscratch directory is set up.
USER=`whoami`

# Set which container sif to use, there are two available.
# More information is here: https://catalog.ngc.nvidia.com/orgs/nvidia/containers/cuquantum-appliance
CTNR=/common/containers/cuquantum-appliance:25.03-x86_64.sif
CTNR_CUDA=/common/containers/cuquantum-appliance:25.03-cuda12.8.1-devel-ubuntu24.04-x86_64.sif

#Set bind options to map directories into the container
BOPTS="--bind /home/$USER,/projects"
[[ -d /scratch/$USER ]] && BOPTS="$BOPTS,/scratch/$USER"
echo "$BOPTS will be used to bind-mount directories into the container"

cd $SLURM_SUBMIT_DIR

# First a local example is run with both types of containers defined by the CTNR and CTNR_CUDA values.
# "exec" runs the requested commands inside the container and then exits
# "--nv" turns on apptainers's nvidia GPU support which maps libraries and variables into the container
# BOPTS, CTNR, and CTNR_CUDA are expanded to values set above
# /home/cuquantum/examples is a directory inside the container supplied by Nvidia

# Set the path to the working directory inside the container
WORKDIR=/home/cuquantum/examples

echo "Running three examples in the Nvidia cuQuantum container"
echo "jobid: $SLURM_JOBID, current directory: `pwd`"

apptainer exec --nv $BOPTS $CTNR_CUDA python benchmark.py > benchmark_cuda_out.$SLURM_JOBID.txt
echo "Ran local example with CUDA Container, output written to benchmark_cuda_out.$SLURM_JOBID.txt"

apptainer exec --nv $BOPTS $CTNR python benchmark.py > benchmark_out.$SLURM_JOBID.txt
echo "Ran local example with non-cuda Container, output written to benchmark_out.$SLURM_JOBID.txt"

echo "Running two examples in the Nvidia cuQuantum container with cuda"
# We now show the commands to run two examples within the Nvidia cuQuantum container.
# "run" runs the user-defined default command within a container and then exits
# "--fakeroot" is needed inorder to access the examples within the Nvidia cuQuantm container
# "--nv" turns on apptainers's nvidia GPU support which maps libraries and variables into the container

apptainer run --fakeroot --nv $BOPTS $CTNR_CUDA python $WORKDIR/simon.py --nbits 15 --ngpus 1 > simon_cuda_out.$SLURM_JOBID.txt
echo "Ran Simon example with CUDA container, output written to simon_cuda_out.$SLURM_JOBID.txt"

apptainer run --fakeroot --nv $BOPTS $CTNR_CUDA python $WORKDIR/hidden_shift.py --nqubits 20 --nsamples 10000 --ngpus 1 > hidden_shift_cuda_out.$SLURM_JOBID.txt
echo "Ran Hidden Shift example with CUDA container, output written to hidden_shift_cuda_out.$SLURM_JOBID.txt"
