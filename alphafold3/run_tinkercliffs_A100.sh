#!/bin/bash

#SBATCH --account=<your Slurm account>
#SBATCH --partition=a100_normal_q
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --cpus-per-task=1
#SBATCH --gres=gpu:1
#SBATCH --time=4:00:00

module reset
module load AlphaFold/3.0.1

# ----- READ THIS TO UNDERSTAND HOW ALPHAFOLD RUNS ON ARC CLUSTERS -----
# On ARC clusters, AlphaFold3 is not installed as a plain Python package. It is
# provided as a containerized application (via 'Apptainer') and exposed/run through
# a helper command named `alphafold3` that you will see at the end of this script.
# This ensures all users run against a tested, consistent environment with the 
# correct CUDA/toolchain stack and model/database layout.
# You can learn more about 'Apptainer' on ARC clusters here:
# https://www.docs.arc.vt.edu/software/apptainer.html
#
# The `alphafold3` wrapper mounts ONLY these host directories into the container:
#   $HOME/AlphaFold3/af_input  -> which is available inside the container as /root/af_input
#   $HOME/AlphaFold3/af_output -> which is available inside the container as /root/af_output
#
# What are the implications of this?:
# • Your inputs (e.g., your FASTA and the required  AlphaFold3 JSON) must be placed in
#   ~/AlphaFold3/af_input so the container can see them at /root/af_input
#   A simple copy (cp) command as in the script below can do the trick.
# • AlphaFold3 writes results into ~/AlphaFold3/af_output on the host
#   (visible inside the container as /root/af_output). You can copy or
#   move those results to your /projects directory as done in the script below.
# • Unlike AlphaFold2, AlphaFold3 does NOT accept CLI flags like
#   --fasta_paths or --model_preset. Instead, it reads a single JSON job file
#   at a fixed path: ~/AlphaFold3/af_input/fold_input.json.
# ----------------------------------------------------------------------

# --- User inputs ---
FASTA_INPUT_PATH="$PWD"                                  # Full path to your FASTA file
FASTA_INPUT_FILENAME="Melanogaster_GR28BD_tetramer"      # Your FASTA file
MODE="multimer"                                          # "monomer" or "multimer"
OUTPUT_DIR="output"                                      # Where to copy results after the run is complete

# --- Container bind points expected by the ARC wrapper ---

IN="$HOME/AlphaFold3/af_input"      # Host path the container will see at /root/af_input
OUT="$HOME/AlphaFold3/af_output"    # Host path the container will see at /root/af_output
mkdir -p "$IN" "$OUT" "$OUTPUT_DIR" # Create all the directories

# Place (copy) the FASTA in the bound input directory so AlphaFold3 (inside the container) can read it.
# Inside the container, it will be referenced as /root/af_input/<filename>.

cp -f "$FASTA_INPUT_PATH/$FASTA_INPUT_FILENAME.fasta" "$IN/"

# Create the required AlphaFold3 job JSON at the exact path ARC wrapper expects..

FAST2JSON_SCRIPT="fasta2json.py"

python "$FAST2JSON_SCRIPT" "$IN/$FASTA_INPUT_FILENAME.fasta" 

cp "$IN/$FASTA_INPUT_FILENAME.json" "$IN/fold_input.json"
echo "[INFO] Generated fold_input.json:"
cat "$IN/fold_input.json"

# Run AlphaFold3 via the ARC wrapper. This launches the container, mounts the
# input/output directories, and executes the pipeline based on fold_input.json.

alphafold3

# After completion, results are in ~/AlphaFold3/af_output on the host.
# Copy them into your project directory for persistence and sharing.
cp -r "$OUT"/* "$OUTPUT_DIR"/ 2>/dev/null || true
