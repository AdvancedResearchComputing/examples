#!/bin/bash
#SBATCH --account=<your Slurm account>
#SBATCH --partition=dgx_normal_q
#SBATCH --nodes=1
#SBATCH --gres=gpu:1
#SBATCH --ntasks-per-node=16
#SBATCH --cpus-per-task=1
#SBATCH --time=1-00:00:00

echo "AlphaFold job launched on `hostname`"
echo "Slurm environment: "
env | grep SLURM

module reset
module load AlphaFold/2.2.2-foss-2021a-CUDA-11.3.1

cd $SLURM_SUBMIT_DIR
echo "working directory is `pwd`"

INPUTFASTA="Melanogaster_GR28BD_tetramer.fasta"

echo "checking for existence of input fasta file: $INPUTFASTA"
if [[ -a "./$INPUTFASTA" ]] 
then
    echo "input fasta found, continuing... "
else 
    echo "fasta file not found in current directory, exiting ..."
    exit 1;
fi 

mkdir -p ./output

gpumon ()
{
    nvidia-smi --query-gpu=timestamp,pci.bus_id,temperature.gpu,utilization.gpu,utilization.memory,memory.used --format=csv -lms 100 | grep --color=auto -v " 0 %, 0 %"
}

echo "logging gpu utilization in the background to $SLURM_JOBID.gpu.log"
gpumon > $SLURM_JOBID.gpu.log &

export ALPHAFOLD_HHBLITS_N_CPU=$SLURM_NTASKS
export ALPHAFOLD_JACKHMMER_N_CPU=$SLURM_NTASKS
echo "HHBLITS CPUS=$ALPHAFOLD_HHBLITS_N_CPU and HMMR CPUS=$ALPHAFOLD_JACKHMMER_N_CPU"

TMPDIR=$TMPNVME
echo "TMPDIR set to $TMPDIR"
alphafold --model_preset=multimer \
          --test_tmpdir=$TMPNVME \
          --fasta_paths=./$INPUTFASTA \
          --output_dir=./output \
          --max_template_date=2022-10-01