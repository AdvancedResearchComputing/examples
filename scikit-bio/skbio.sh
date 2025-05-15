#!/bin/bash
#SBATCH --account=personal
#SBATCH --job-name=skbio_distance
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --time=00:05:00
#SBATCH --partition=normal_q

module reset
module load Miniforge3/24.1.2-0
module load scikit-bio/0.5.7-foss-2022a

# Activate your virtual environment if needed
#source activate path/to/venv/bin/activate

# Run the test
python skbio_dist.py
