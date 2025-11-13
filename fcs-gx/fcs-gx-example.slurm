#!/bin/bash
#SBATCH --account=personal
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=12
#SBATCH --mem=500G
#SBATCH --time=0:30:00

# This script follows the Usage Example provided by the developers
# https://github.com/ncbi/fcs/wiki/FCS-GX-quickstart#usage-examples
module load apptainer
cd $SLURM_SUBMIT_DIR

# copy FCS-GX database to memory on the compute node (10 minutes)
cp -r /common/data/ncbi/fcs-gx/2025-11-11/ $TMPFS
GXDB_LOC=$TMPFS

# download the test FASTA
curl -LO https://zenodo.org/records/10932013/files/FCS_combo_test.fa

# screen the genome
python3 ./fcs.py \
    --image /common/containers/fcs-gx.sif \
    screen genome \
    --fasta FCS_combo_test.fa \
    --out-dir ./gx_out/ \
    --gx-db $GXDB_LOC/gxdb \
    --tax-id 4932
    
# clean the genome
cat FCS_combo_test.fa | python3 ./fcs.py \
    --image /common/containers/fcs-gx.sif \
    clean genome \
    --action-report ./gx_out/FCS_combo_test.4932.fcs_gx_report.txt \
    --output clean.fasta \
    --contam-fasta-out contam.fasta