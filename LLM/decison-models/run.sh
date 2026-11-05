#!/bin/bash
#SBATCH --account=<slurm_allocation_name>
#SBATCH --partition=a30_normal_q
#SBATCH --job-name=decision-model
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --gres=gpu:1
#SBATCH --mem=32G
#SBATCH --time=00:15:00
#SBATCH --output=decision-%j.out
#SBATCH --error=decision-%j.err

set -euo pipefail
cd "${SLURM_SUBMIT_DIR:?Submit from the example folder}"

# Use  CUDA 12 build .
module unload llama.cpp
module load llama.cpp/server-cuda12-latest

model="${1:?Usage: sbatch run.sh /full/path/model.gguf}"
[[ -r "$model" && -r request.json ]] || {
  echo "Model or request.json is missing or unreadable." >&2
  exit 1
}

# Allow container to read the model directory.
model="$(readlink -f "$model")"
export APPTAINER_BINDPATH="${APPTAINER_BINDPATH:+$APPTAINER_BINDPATH,}$(dirname "$model")"

results="$PWD/results/$SLURM_JOB_ID"
mkdir -p "$results"
port=$((20000 + SLURM_JOB_ID % 40000))
url="http://127.0.0.1:$port"
if curl --noproxy '*' --silent --max-time 1 "$url/health" >/dev/null 2>&1; then
  echo "Port $port is already in use. Resubmit the job." >&2
  exit 1
fi

# full prompt must fit in the processing batch.
llama-server --model "$model" --alias local-decision \
  --host 127.0.0.1 --port "$port" \
  --n-gpu-layers 99 --threads "$SLURM_CPUS_PER_TASK" \
  --parallel 1 --ctx-size 4096 --batch-size 4096 --ubatch-size 4096 \
  > "$results/server.log" 2>&1 &
pid=$!
cleanup() {
  kill "$pid" 2>/dev/null || true
  wait "$pid" 2>/dev/null || true
}
trap cleanup EXIT
trap 'exit 130' INT
trap 'exit 143' TERM

# Wait for startup, with a timeout and an early-exit check.
ready=0
for attempt in {1..90}; do
  kill -0 "$pid" 2>/dev/null || {
    echo "Server exited. Check $results/server.log" >&2
    exit 1
  }
  if curl --noproxy '*' --silent --fail --max-time 2 "$url/health" >/dev/null; then
    ready=1
    break
  fi
  sleep 2
done
[[ "$ready" == 1 ]] || {
  echo "Startup timed out. Check $results/server.log" >&2
  exit 1
}

curl --noproxy '*' --silent --show-error --fail-with-body --max-time 120 \
  "$url/v1/systemone" -H 'Content-Type: application/json' \
  --data-binary @request.json > "$results/response.json"

cat "$results/response.json"
echo
echo "Response and server log: $results"
