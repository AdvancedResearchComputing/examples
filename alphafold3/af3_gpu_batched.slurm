#!/bin/bash

#SBATCH --job-name=af3_gpu_batch
#SBATCH --account=<your Slurm account>
#SBATCH --partition=a100_normal_q
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=64G
#SBATCH --gres=gpu:1
#SBATCH --time=4:00:00
#SBATCH --output=af3_gpu_batch_%A_%a.out
#SBATCH --error=af3_gpu_batch_%A_%a.err

set -u -o pipefail

module reset
module load AlphaFold/3.0.4

# ----- READ THIS TO UNDERSTAND THE BATCHED GPU STAGE -----
# This is an OPTIONAL alternative to af3_gpu.slurm for very large numbers of
# AlphaFold3 inference jobs.
#
# Run af3_cpu.slurm first. Each CPU array element performs only the data pipeline
# and writes one processed *_data.json file. This batched GPU script then groups
# several of those processed JSON files into each GPU array element.
#
# IMPORTANT:
#   * Different GPU array elements may run in parallel on different GPUs.
#   * Inputs WITHIN one GPU array element are run SEQUENTIALLY on the same GPU.
#   * Batching reduces the number of Slurm jobs, but it does not reduce the total
#     amount of GPU computation required by the inputs.
#
# Example with BATCH_SIZE=5:
#
#   GPU array task 0 -> CPU outputs/tasks 0-4   (run sequentially on one GPU)
#   GPU array task 1 -> CPU outputs/tasks 5-9   (run sequentially on one GPU)
#   GPU array task 2 -> CPU outputs/tasks 10-14 (run sequentially on one GPU)
#
# Because each GPU batch depends on several CPU array elements, the simplest
# dependency is `afterok` on the ENTIRE CPU array.
# That means the batched GPU array starts only after the whole CPU array has
# completed successfully.
# ============================================================
# USER SETTINGS
# ============================================================

# Use the SAME FASTA list file used for af3_cpu.slurm.
# The file must contain ONE FASTA path per line and no blank lines (We call it MANIFEST).
MANIFEST="${MANIFEST:-${SLURM_SUBMIT_DIR:-$PWD}/af3_fasta_list.txt}"

# Number of processed AlphaFold inputs handled sequentially by each GPU array
# element. Override at submission time with, for example, BATCH_SIZE=5.
BATCH_SIZE="${BATCH_SIZE:-5}"

AF3_ROOT="${AF3_ROOT:-$HOME/AlphaFold3}"
CPU_OUT_ROOT="${CPU_OUT_ROOT:-$AF3_ROOT/af_output_cpu}"
GPU_OUT_ROOT="${GPU_OUT_ROOT:-$AF3_ROOT/af_output_gpu_batched}"

# Where completed prediction files are copied for persistence/sharing.
FINAL_OUTPUT_ROOT="${OUTPUT_DIR:-${SLURM_SUBMIT_DIR:-$PWD}/output}"

# CPU_JOB_ID must be exported when submitting this GPU array. It identifies the
# matching CPU array output directory produced by af3_cpu.slurm.
CPU_JOB_ID="${CPU_JOB_ID:-}"

# ARC AlphaFold3 paths.
ALPHAFOLD_VERSION="3.0.4"
ALPHAFOLD_SIF="/apps/common/software/AlphaFold/${ALPHAFOLD_VERSION}/alphafold3-${ALPHAFOLD_VERSION}.sif"
MODEL_DIR="/common/data/alphafold/3/model"
DB_DIR="/common/data/alphafold/3/public_databases"

# ============================================================
# VALIDATE SETTINGS AND DETERMINE THIS BATCH'S INPUT RANGE
# ============================================================

BATCH_ID="${SLURM_ARRAY_TASK_ID:-0}"
GPU_ARRAY_JOB_ID="${SLURM_ARRAY_JOB_ID:-${SLURM_JOB_ID:-manual}}"

if [[ -z "$CPU_JOB_ID" ]]; then
    echo "[ERROR] CPU_JOB_ID is not set."
    echo "Submit this GPU array with CPU_JOB_ID=<CPU array job ID>."
    exit 1
fi

if [[ ! -f "$MANIFEST" ]]; then
    echo "[ERROR] Manifest not found: $MANIFEST"
    exit 1
fi

if ! [[ "$BATCH_SIZE" =~ ^[1-9][0-9]*$ ]]; then
    echo "[ERROR] BATCH_SIZE must be a positive integer. Received: $BATCH_SIZE"
    exit 1
fi

if [[ ! -f "$ALPHAFOLD_SIF" ]]; then
    echo "[ERROR] AlphaFold3 container not found: $ALPHAFOLD_SIF"
    exit 1
fi

# Count manifest entries. The CPU script expects one input per line and no blank
# lines, so the line number is also the CPU array-task mapping.
TOTAL_INPUTS=$(awk 'END {print NR}' "$MANIFEST")

if [[ "$TOTAL_INPUTS" -eq 0 ]]; then
    echo "[ERROR] Manifest is empty: $MANIFEST"
    exit 1
fi

if [[ -n "${START_ID_OVERRIDE:-}" ]] && ! [[ "$START_ID_OVERRIDE" =~ ^(0|[1-9][0-9]*)$ ]]; then
    echo "[ERROR] START_ID_OVERRIDE must be a nonnegative integer."
    exit 1
fi
if [[ -n "${START_ID_OVERRIDE:-}" && -n "${SLURM_ARRAY_TASK_ID:-}" ]]; then
    echo "[ERROR] Use START_ID_OVERRIDE only for a single recovery job, not an array."
    exit 1
fi
START_ID="${START_ID_OVERRIDE:-$(( BATCH_ID * BATCH_SIZE ))}"
END_ID=$(( START_ID + BATCH_SIZE - 1 ))

if (( START_ID >= TOTAL_INPUTS )); then
    echo "[ERROR] Batch $BATCH_ID starts at input index $START_ID, but the manifest"
    echo "        contains only $TOTAL_INPUTS inputs."
    exit 1
fi

if (( END_ID >= TOTAL_INPUTS )); then
    END_ID=$(( TOTAL_INPUTS - 1 ))
fi

GPU_BATCH_OUT="$GPU_OUT_ROOT/$GPU_ARRAY_JOB_ID/batch_$BATCH_ID"
mkdir -p "$GPU_BATCH_OUT" "$FINAL_OUTPUT_ROOT" || exit 1

# Check every input BEFORE running any inference. The submission wrapper uses
# afterok on the entire CPU array; this also catches accidental early submission.
python - "$CPU_OUT_ROOT/$CPU_JOB_ID" "$START_ID" "$END_ID" <<'CHECK_INPUTS'
import json, sys
from pathlib import Path
root, start, end = Path(sys.argv[1]), int(sys.argv[2]), int(sys.argv[3])
errors = []
for task in range(start, end + 1):
    files = list((root / f"task_{task}").rglob("*_data.json"))
    if len(files) != 1:
        errors.append(f"task {task}: expected one processed JSON; found {len(files)}")
        continue
    try:
        data = json.loads(files[0].read_text())
        if not data.get("sequences"):
            raise ValueError("no sequences")
        for entry in data["sequences"]:
            if "protein" in entry:
                protein = entry["protein"]
                for key, kind in (("unpairedMsa", str), ("pairedMsa", str), ("templates", list)):
                    if not isinstance(protein.get(key), kind):
                        raise ValueError(f"missing/unprocessed protein field: {key}")
    except Exception as error:
        errors.append(f"task {task}: {error}")
if errors:
    print("[ERROR] CPU inputs are not ready; no inference was started.", file=sys.stderr)
    print("\n".join(errors), file=sys.stderr)
    print("Use submit_af3_batched.sh to submit with the CPU dependency.", file=sys.stderr)
    sys.exit(1)
print(f"[INFO] All CPU inputs {start}-{end} passed preflight checks.")
CHECK_INPUTS
if [[ $? -ne 0 ]]; then
    exit 1
fi

# ============================================================
# JOB INFORMATION
# ============================================================

echo "============================================================"
echo "AlphaFold 3 batched GPU-only inference"
echo "Job ID: ${SLURM_JOB_ID:-N/A}"
echo "GPU array job ID: $GPU_ARRAY_JOB_ID"
echo "GPU batch/array task ID: $BATCH_ID"
echo "Matching CPU array job ID: $CPU_JOB_ID"
echo "Node: $(hostname)"
echo "CPUs per task: ${SLURM_CPUS_PER_TASK:-8}"
echo "CUDA_VISIBLE_DEVICES=${CUDA_VISIBLE_DEVICES:-N/A}"
echo "Manifest: $MANIFEST"
echo "Total inputs: $TOTAL_INPUTS"
echo "Batch size: $BATCH_SIZE"
echo "This batch handles CPU task IDs: $START_ID through $END_ID"
echo "Batch output root: $GPU_BATCH_OUT"
echo "Start: $(date)"
echo "============================================================"

echo
echo "[INFO] Initial GPU state:"
nvidia-smi

# ============================================================
# RUN EACH INPUT IN THIS BATCH SEQUENTIALLY ON THE SAME GPU
# ============================================================

SUCCESS_COUNT=0
FAIL_COUNT=0
BATCH_START=$(date +%s)

for (( INPUT_TASK_ID=START_ID; INPUT_TASK_ID<=END_ID; INPUT_TASK_ID++ )); do

    echo
    echo "============================================================"
    echo "Processing input index $INPUT_TASK_ID"
    echo "Time: $(date)"
    echo "============================================================"

    # Read the corresponding original FASTA path for logging.
    FASTA_INPUT=$(sed -n "$((INPUT_TASK_ID + 1))p" "$MANIFEST")
    FASTA_INPUT="${FASTA_INPUT%$'\r'}"

    if [[ -z "$FASTA_INPUT" ]]; then
        echo "[ERROR] No FASTA entry found for input index $INPUT_TASK_ID."
        FAIL_COUNT=$((FAIL_COUNT + 1))
        continue
    fi

    CPU_TASK_OUT="$CPU_OUT_ROOT/$CPU_JOB_ID/task_$INPUT_TASK_ID"
    GPU_INPUT_OUT="$GPU_BATCH_OUT/task_$INPUT_TASK_ID"
    FINAL_TASK_OUT="$FINAL_OUTPUT_ROOT/$GPU_ARRAY_JOB_ID/task_$INPUT_TASK_ID"

    if [[ ! -d "$CPU_TASK_OUT" ]]; then
        echo "[ERROR] Matching CPU output directory not found:"
        echo "        $CPU_TASK_OUT"
        FAIL_COUNT=$((FAIL_COUNT + 1))
        continue
    fi

    mapfile -t DATA_JSONS < <(find "$CPU_TASK_OUT" -type f -name '*_data.json' | sort)

    if [[ ${#DATA_JSONS[@]} -eq 0 ]]; then
        echo "[ERROR] No processed *_data.json file found under:"
        echo "        $CPU_TASK_OUT"
        FAIL_COUNT=$((FAIL_COUNT + 1))
        continue
    fi

    if [[ ${#DATA_JSONS[@]} -gt 1 ]]; then
        echo "[ERROR] More than one processed *_data.json file was found under:"
        echo "        $CPU_TASK_OUT"
        printf '  %s\n' "${DATA_JSONS[@]}"
        FAIL_COUNT=$((FAIL_COUNT + 1))
        continue
    fi

    PROCESSED_JSON_HOST="${DATA_JSONS[0]}"
    PROCESSED_JSON_RELATIVE="${PROCESSED_JSON_HOST#"$CPU_TASK_OUT"/}"
    PROCESSED_JSON_CONTAINER="/root/af_input/$PROCESSED_JSON_RELATIVE"

    if ! mkdir -p "$GPU_INPUT_OUT" "$FINAL_TASK_OUT"; then
        echo "[ERROR] Cannot create output directories for input $INPUT_TASK_ID."
        FAIL_COUNT=$((FAIL_COUNT + 1))
        continue
    fi

    echo "[INFO] Original FASTA: $FASTA_INPUT"
    echo "[INFO] Processed JSON: $PROCESSED_JSON_HOST"
    echo "[INFO] GPU output directory: $GPU_INPUT_OUT"

    INPUT_START=$(date +%s)

    JOB_TMP="$GPU_INPUT_OUT/tmp"
    if ! mkdir -p "$JOB_TMP"; then
    	echo "[ERROR] Cannot create temporary directory: $JOB_TMP"
    	FAIL_COUNT=$((FAIL_COUNT + 1))
    	continue
    fi

    apptainer exec \
    	--pwd /app/alphafold \
    	--nv \
    	--bind "$CPU_TASK_OUT:/root/af_input:ro" \
    	--bind "$GPU_INPUT_OUT:/root/af_output" \
    	--bind "$MODEL_DIR:/root/models" \
    	--bind "$DB_DIR:/root/public_databases" \
    	--bind "$JOB_TMP:/root/af_tmp" \
    	--env TMPDIR=/root/af_tmp \
    	--env TMP=/root/af_tmp \
    	--env TEMP=/root/af_tmp \
    	"$ALPHAFOLD_SIF" \
    	python run_alphafold.py \
           --json_path="$PROCESSED_JSON_CONTAINER" \
           --model_dir=/root/models \
           --db_dir=/root/public_databases \
           --output_dir=/root/af_output \
	   --norun_data_pipeline \
           > "$GPU_INPUT_OUT/inference.out" \
           2> "$GPU_INPUT_OUT/inference.err"
    EXIT_CODE=$?
    INPUT_END=$(date +%s)
if [[ $EXIT_CODE -eq 0 ]]; then
    if ! cp -a "$GPU_INPUT_OUT"/. "$FINAL_TASK_OUT"/; then
    	echo "[ERROR] Input $INPUT_TASK_ID: inference succeeded, but copying results failed."
    	echo "[INFO] Original results remain in: $GPU_INPUT_OUT"
    	FAIL_COUNT=$((FAIL_COUNT + 1))
    	continue
    fi

    SUCCESS_COUNT=$((SUCCESS_COUNT + 1))

    echo "[INFO] Input $INPUT_TASK_ID completed successfully."
    echo "[INFO] Runtime: $((INPUT_END - INPUT_START)) seconds"
    echo "[INFO] Final results copied to: $FINAL_TASK_OUT"
else
    FAIL_COUNT=$((FAIL_COUNT + 1))
    echo "[ERROR] Input $INPUT_TASK_ID failed with exit code $EXIT_CODE."
fi

done

BATCH_END=$(date +%s)

# ============================================================
# SUMMARY
# ============================================================

echo
echo "============================================================"
echo "Batched GPU inference finished"
echo "Batch ID: $BATCH_ID"
echo "Input range: $START_ID-$END_ID"
echo "Successful inputs: $SUCCESS_COUNT"
echo "Failed inputs: $FAIL_COUNT"
echo "Total batch runtime: $((BATCH_END - BATCH_START)) seconds"
echo "End: $(date)"
echo "============================================================"

echo
echo "[INFO] Final GPU state:"
nvidia-smi

# Mark the Slurm array element as failed if any input in the batch failed. This
# makes failed batches easy to identify and rerun.
if [[ $FAIL_COUNT -gt 0 ]]; then
    exit 1
fi

exit 0
