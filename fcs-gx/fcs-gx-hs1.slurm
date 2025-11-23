#!/bin/bash
#SBATCH --account=personal
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=12
#SBATCH --mem=500G
#SBATCH --time=0:30:00

module load apptainer
cd $SLURM_SUBMIT_DIR

# copy FCS-GX database to memory on the compute node (10 minutes)
cp -r /common/data/ncbi/fcs-gx/2025-11-11/gxdb $TMPFS
GXDB_LOC=$TMPFS

# download the FASTA (930MB download: 3-5 minutes)
wget https://hgdownload.soe.ucsc.edu/goldenPath/hs1/bigZips/hs1.fa.gz

# screen the genome (3-5 minutes)
python3 ./fcs.py \
    --image /common/containers/fcs-gx.sif \
    screen genome \
    --fasta hs1.fa.gz \
    --out-dir ./gx_out/ \
    --gx-db $GXDB_LOC/gxdb \
    --tax-id 9606
