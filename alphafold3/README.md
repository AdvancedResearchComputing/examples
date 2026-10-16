# AlphaFold3

AlphaFold3 is a structure prediction system developed by Google DeepMind for proteins and other biomolecular complexes. This example separates CPU data processing from GPU inference. The CPU stage generates multiple sequence alignments (MSAs) and finds templates. The GPU stage uses the processed JSON files to predict structures.

On ARC clusters, AlphaFold3 is not installed as a plain Python package. It is
provided as a containerized application through Apptainer. Loading the
AlphaFold module gives access to ARC's tested AlphaFold3 software stack and
the ARC-hosted model/database files.

This two-stage example calls the ARC-provided AlphaFold3 container directly so the
CPU data pipeline and GPU inference can be submitted as separate Slurm jobs:

```
af3_cpu.slurm : data pipeline only  (--norun_inference)      [CPU only]
af3_gpu.slurm : inference only      (--norun_data_pipeline)  [1 GPU]
```

Separating the stages avoids having to reserve a GPU while AlphaFold3 is performing
CPU-only database/MSA/template work.

This CPU stage uses fasta2json.py to convert each FASTA file to the AlphaFold3
JSON input format before running the data pipeline.

Learn more about Apptainer on ARC clusters:
https://www.docs.arc.vt.edu/software/apptainer.html

## Contents

These are the files/directories used for this example:

1. `af3_cpu_single_input.slurm` is the Slurm batch script for the CPU data pipeline for a single input file.
2. `af3_cpu_multiple_inputs.slurm` is the Slurm batch script for the CPU data pipeline for multiple input files.
3. `af3_gpu.slurm` is the Slurm batch script for GPU inference. 
4. `fasta2json.py` converts FASTA inputs to AlphaFold3 JSON format. 
5. Example FASTA files provide inputs for testing the workflow.

## How to run

Run these commands after logging onto an ARC cluster. Before submitting, change the account name in both Slurm scripts to an allocation you can access. Your allocations can be found in your [ColdFront account](https://coldfront.arc.vt.edu/).

```
git clone https://github.com/AdvancedResearchComputing/examples.git
cd examples/alphafold3
```

If you already have this repository, use your existing checkout instead of cloning again.

### 1. Submit CPU job

#### Single Input - CPU job:

```
sbatch af3_cpu_single_input.slurm monomer.fasta
```

You should replace `monomer.fasta` with your input file or path to your input file that you would like to run. 

#### Multiple Inputs - CPU job:

```
sbatch --export=ALL,INPUT_DIR="/path/to/input/directory" af3_cpu_multiple_inputs.slurm
```

You should replace `/path/to/input/directory` with the path to the directory that holds all the input `.fasta` files. 
**This requires that all `.fasta` files are in the same directory before you run your job.**

This script will create a new directory named `CPU_XXXXXX` where `XXXXXX` is the slurm job id for that job. Inside this `CPU_XXXXXX`, there will be sub-directories, one for each input file. Inside each of these input file directories will be a file with the extension `_data.json`. This is the output of the CPU pipeline that the GPU inference step will need. 

### 2. Submit the GPU job

For this example, assume that the CPU job id is `7908286`.

#### Not as a dependency job:

This means you will have to manually submit this gpu script once your cpu job finishes. 

```
sbatch --export=ALL,INPUT_DIR="/path/to/cpu_results/CPU_7908286" af3_gpu.slurm
```

You should replace `/path/to/cpu_results/CPU_7908286` with the path to the CPU results you would like to use for the GPU AF3 inference step.

#### As a dependency job:

This means you can submit this job at the same time as your cpu job. This job will not start until the cpu job finishes.

```bash
sbatch --dependency=afterok:7908286 --export=ALL,INPUT_DIR="/path/to/cpu_results/CPU_7908286" af3_gpu.slurm
```
You should replace `/path/to/cpu_results/CPU_7908286` with the path to the CPU results you would like to use for the GPU AF3 inference step.



Submit this shortly after the CPU array, while it is still active. The GPU job waits until every CPU task completes successfully. It does not allocate a GPU while pending on this dependency.

### Cluster and Partition Info

These scripts are configured for TinkerCliffs with `AlphaFold/3.0.4`. The CPU stage uses `normal_q`; the GPU stage uses `a100_normal_q` and requests one GPU. You can also run this GPU step on our A30 GPUs on our Falcon cluster but be aware this AlphaFold container is optimized for our A100 GPUs on Tinkercliffs.
To use another cluster or partition, you must modify the partition, QoS, and resource settings in the slurm batch script. See [ARC computational resources](https://www.docs.arc.vt.edu/resources/compute.html) and [ARC AlphaFold documentation](https://www.docs.arc.vt.edu/software/alphafold.html).

### Notes

Check job status with:

```
squeue
sacct -j <JOB_ID> --format=JobID,State,ExitCode,Elapsed
```

Replace `<JOB_ID>` with the relevant CPU or GPU job number. 

Final copied results are stored under `INPUT_DIR/GPU_JOBID/` in the submission directory. The top-level `*_model.cif` in each prediction folder is the highest-ranked structure; confidence JSON and ranking CSV files support assessment of its reliability.

For Slurm guidance, see [ARC's Slurm documentation](https://www.docs.arc.vt.edu/usage/more-slurm.html#more-slurm). More information about AlphaFold3 is available in the [official repository](https://github.com/google-deepmind/alphafold3). Use is subject to the applicable [AlphaFold3 terms](https://github.com/google-deepmind/alphafold3/blob/main/WEIGHTS_TERMS_OF_USE.md).

### Should I use Slurm Array Jobs?

We tested this workflow with and without using Slurm Array Jobs. With these array jobs, every input file was it's own array task.

We compared the performance of doing a 5-task array job verses a single job with 5 inputs on Tinkercliffs AMD CPUs.
What we found was that the single job (5 input) was almost 2x faster in respect to cpu core hours per input file. Therefore, we suggest that you do not use array jobs. Additionally, array jobs are very wasteful on the cluster as it fragments the entire pool of resources for very short jobs. 








