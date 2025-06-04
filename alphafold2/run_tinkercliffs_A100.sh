#!/bin/bash
#SBATCH --account=<your Slurm account>
#SBATCH --partition=a100_normal_q
#SBATCH --nodes=1
#SBATCH --gres=gpu:1
#SBATCH --ntasks-per-node=16
#SBATCH --cpus-per-task=1
#SBATCH --time=1-00:00:00

echo "AlphaFold2 job launched on `hostname`"

module reset
module load AlphaFold/2.3.2-foss-2023a-CUDA-12.1.1

cd $SLURM_SUBMIT_DIR
echo "Working directory is `pwd`"

INPUTFASTA="Melanogaster_GR28BD_tetramer.fasta"

echo "Checking for existence of input fasta file: $INPUTFASTA"
if [[ -a "./$INPUTFASTA" ]] 
then
    echo "Input fasta found, continuing... "
else 
    echo "Fasta file not found in current directory, exiting ..."
    exit 1;
fi 

mkdir -p ./output

gpumon ()
{
    nvidia-smi --query-gpu=timestamp,pci.bus_id,temperature.gpu,utilization.gpu,utilization.memory,memory.used --format=csv -lms 100 | grep --color=auto -v " 0 %, 0 %"
}

echo "Logging gpu utilization in the background to $SLURM_JOBID.gpu.log"
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
          --max_template_date=3000-01-01
