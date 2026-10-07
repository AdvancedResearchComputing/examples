# AlphaFold3

AlphaFold3 is a structure prediction system developed by Google DeepMind for proteins and other biomolecular complexes. This example separates CPU data processing from GPU inference. The CPU stage generates multiple sequence alignments (MSAs) and finds templates. The GPU stage uses the processed JSON files to predict structures.

## Contents

These are the files/directories used for this example:

1. `af3_cpu.slurm` is the Slurm batch script for the CPU data pipeline. Each CPU array element processes one FASTA input without requesting a GPU.
2. `af3_gpu_batched.slurm` is the Slurm batch script for GPU inference. Each GPU batch processes several inputs sequentially on one GPU.
3. `af3_fasta_list.txt` contains one FASTA path per line, with no blank lines. Absolute paths are recommended.
4. `fasta2json.py` converts FASTA inputs to AlphaFold3 JSON format. Obtain it from the existing ARC example or the [AlphaFold3 tools repository](https://github.com/snufoodbiochem/Alphafold3_tools) if it is not included. Preserve the converter's attribution.
5. Example FASTA files provide inputs for testing the workflow.
6. `archived_examples`, if included, holds older scripts and additional examples.

## How to run

Run these commands after logging into TinkerCliffs. Before submitting, change the account name in both Slurm scripts to an allocation you can access. Your allocations can be found in your [ColdFront account](https://coldfront.arc.vt.edu/).

```bash
git clone https://github.com/AdvancedResearchComputing/examples.git
cd examples/alphafold3
```

If you already have this repository, use your existing checkout instead of cloning again.

### 1. Prepare the FASTA list

For the five example inputs, create the manifest in the example directory:

```bash
printf '%s\n' \
    "$PWD/01_monomer.fasta" \
    "$PWD/02_homodimer.fasta" \
    "$PWD/03_heterodimer.fasta" \
    "$PWD/04_homotetramer.fasta" \
    "$PWD/Melanogaster_GR28BD_tetramer.fasta" \
    > af3_fasta_list.txt
```

Use your own FASTA paths if these example files are not included. Keep the manifest unchanged between CPU and GPU submissions. Place `fasta2json.py` in the same submission directory, or set `FAST2JSON_SCRIPT` to its path.

### 2. Submit the CPU array

For five inputs:

```bash
sbatch --array=0-4%5 af3_cpu.slurm
```

Record the returned CPU array job ID. Each task writes a processed `*_data.json` under:

```text
$HOME/AlphaFold3/af_output_cpu/<CPU_JOB_ID>/task_<input_index>/
```

### 3. Submit the batched GPU stage

The GPU script must use:

```bash
CPU_JOB_ID="${CPU_JOB_ID:-}"
```

Remove any old hard-coded dependency from the public example. Replace `123456` below with the CPU array job ID returned in step 2:

```bash
sbatch --dependency=afterok:123456 \
    --export=ALL,CPU_JOB_ID=123456,BATCH_SIZE=5 \
    af3_gpu_batched.slurm
```

Submit this shortly after the CPU array, while it is still active. The GPU job waits until every CPU task completes successfully. It does not allocate a GPU while pending on this dependency.

`BATCH_SIZE=5` runs up to five inputs sequentially on one GPU. The GPU stage reads the processed CPU JSON files and skips the data pipeline. No submission wrapper is required.

### Larger input lists

For `N` inputs, the CPU array indices are `0` through `N-1`. The number of GPU batches is `ceil(N / BATCH_SIZE)`; GPU array indices start at zero.

For example, 12 inputs with batch size 5 require three GPU batches:

```bash
sbatch --array=0-11%5 af3_cpu.slurm
```

Using the returned CPU job ID in place of `123456`:

```bash
sbatch --array=0-2%2 \
    --dependency=afterok:123456 \
    --export=ALL,CPU_JOB_ID=123456,BATCH_SIZE=5 \
    af3_gpu_batched.slurm
```

GPU batches process inputs 0–4, 5–9, and 10–11. `%2` permits at most two GPU batches to run at once, subject to allocation and QoS limits. Without a GPU array option, only the first batch is processed. Allow enough wall time for all inputs within a batch.

### Cluster and Partition Info

These scripts are configured for TinkerCliffs with `AlphaFold/3.0.4`. The CPU stage uses `normal_q`; the GPU stage uses `a100_normal_q` and requests one GPU per batch. To use another cluster or partition, verify the module, container paths, partition, QoS, and resource settings. See [ARC computational resources](https://www.docs.arc.vt.edu/resources/compute.html) and [ARC AlphaFold documentation](https://www.docs.arc.vt.edu/software/alphafold.html).

### Notes

Check job status with:

```bash
squeue -u "$USER"
sacct -j <JOB_ID> --format=JobID,State,ExitCode,Elapsed
```

Replace `<JOB_ID>` with the relevant CPU or GPU job number. `afterok` is used because each GPU batch needs multiple CPU outputs. `aftercorr` is appropriate for a separate one-input-per-GPU-array-element workflow, where CPU and GPU indices match.

Final copied results are stored under `output/<GPU_JOB_ID>/task_<input_index>/` in the submission directory. Each GPU input has separate `inference.out` and `inference.err` logs. The top-level `*_model.cif` in each prediction folder is the highest-ranked structure; confidence JSON and ranking CSV files support assessment of its reliability.

If a CPU task fails, inspect its logs before changing dependencies. Do not automatically ignore nonzero exit codes. If CPU results are already complete and an older job can no longer be used as a dependency, verify the CPU tasks and processed JSON files before submitting inference without a dependency.

For Slurm guidance, see [ARC's Slurm documentation](https://www.docs.arc.vt.edu/usage/more-slurm.html#more-slurm). More information about AlphaFold3 is available in the [official repository](https://github.com/google-deepmind/alphafold3). Use is subject to the applicable [AlphaFold3 terms](https://github.com/google-deepmind/alphafold3/blob/main/WEIGHTS_TERMS_OF_USE.md).
