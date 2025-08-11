#!/bin/bash
#SBATCH --account=personal
#SBATCH --partition=normal_q
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=64
#SBATCH --output=output-%j.log
#SBATCH --time=0-00:30:00

module load CellRanger
cellranger count --id=run_count_1kpbmcs \
   --fastqs=/common/data/cellranger/fastqs/pbmc_1k_v3_fastqs \
   --sample=pbmc_1k_v3 \
   --transcriptome=/common/data/cellranger/references/refdata-gex-GRCh38-2024-A \
   --create-bam false
