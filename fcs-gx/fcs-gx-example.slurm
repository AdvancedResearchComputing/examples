#!/bin/bash
#SBATCH --account=personal
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=12
#SBATCH --mem=500G
#SBATCH --time=0:30:00

# This script follows the Usage Example provided by the developers
# https://github.com/ncbi/fcs/wiki/FCS-GX-quickstart#usage-examples

# ARC's Owl cluster is the recommended target for this app. The Tinkercliffs
# cluster has only 8 nodes which can support this app's memory needs

cd $SLURM_SUBMIT_DIR

# fcs.py runs from a container image, and we need the apptainer runtime
module load apptainer 
module list

# copy FCS-GX database to memory on the compute node (10 minutes)
echo "copying FCS-GX database to local TMPFS mount in RAM"
echo "start time: `date`"
cp -r /common/data/ncbi/fcs-gx/2025-11-11/ $TMPFS
echo "end time: `date`"

GXDB_LOC=$TMPFS
if [ ! -f ${GXDB_LOC}/gxdb/all.gxi ]; then
    echo "FCS-GX database not found. This job will likely fail."
fi

# download the test FASTA for the FCS-GX Usage Example
curl -LO https://zenodo.org/records/10932013/files/FCS_combo_test.fa

# check for the FCS Runner Script and download fi not found
if [ ! -f fcs.py ]; then
    echo "FCS runner script not found in working directory `pwd`."
    echo "Downloading it now."
    curl -LO https://github.com/ncbi/fcs/raw/main/dist/fcs.py
fi

# screen the genome
echo "=== Starting the screen: `date`"
python3 ./fcs.py \
    --image /common/containers/fcs-gx.sif \
    screen genome \
    --fasta FCS_combo_test.fa \
    --out-dir ./gx_out/ \
    --gx-db $GXDB_LOC/gxdb \
    --tax-id 4932
echo "=== Screen completed: `date`"

# clean the genome
cat FCS_combo_test.fa | python3 ./fcs.py \
    --image /common/containers/fcs-gx.sif \
    clean genome \
    --action-report ./gx_out/FCS_combo_test.4932.fcs_gx_report.txt \
    --output clean.fasta \
    --contam-fasta-out contam.fasta