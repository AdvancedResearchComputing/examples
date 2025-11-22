# FCS-GX

This repository provides SLURM batch job scripts that demonstrate how to run **[FCS-GX](https://github.com/ncbi/fcs/wiki/FCS-GX-quickstart)**, a genome screening and cleaning tool provided by NCBI, on Virginia Tech's ARC clusters. These examples show you how to:
1) Use the 470 GiB FCS-GX reference database that ARC has downloaded so that you do not need to download and store your own copy. On ARC, it is located at ```/common/data/ncbi/fcs-gx/2025-11-11/gxdb``` Since FCS-GX performs best when the database resides in memory on a compute node, the example SLURM batch job scripts request sufficient memory and copy the database from ```/common``` into node-local RAM ($TMPFS) at job runtime.
2) Run the official NCBI FCS-GX tool using the small containerized application provided on ARC clusters via Apptainer at ```/common/containers/fcs-gx.sif```
3) Screen and clean the genome following NCBI’s recommended workflow.

## Contents

This repository contains two SLURM batch job scripts:

1. **`fcs-gx-hs1.slurm`**  
   This script runs FCS-GX on the human genome (hs1). This script demonstrates:
	- Copying the database from ```/common``` into node-local RAM ($TMPFS) for speed
	- Downloading a large (~930 MB) FASTA file
	- Screening the genome using fcs.py runner script
	- Producing the FCS-GX output directory ```gx_out/```

   **Important:**  
        - Users must edit the SLURM directives at the top of the script to match their SLURM account name and the desired ARC cluster and it's partition they want to use for their work. You can check your SLURM account name on ColdFront: https://coldfront.arc.vt.edu/ Look for 'slurm_account_name' under your project allocations. Additionally, refer to the ARC compute resource guide to select the cluster and it's partition: https://www.docs.arc.vt.edu/resources/compute.html

2. **`fcs-gx-example.slurm`**  
   This script runs the official NCBI example case, matching the Usage Examples in the FCS-GX Quickstart guide. This script demonstrates:
	- How to ensure fcs.py is available
	- How to run both screen genome and clean genome
	- How to verify the presence of the database
	- How to record start/end timestamps for each step

   **Important:**  
        - Users must edit the SLURM directives at the top of the script to match their SLURM account name and the desired ARC cluster and it's partition they want to use for their work. You can check your SLURM account name on ColdFront: https://coldfront.arc.vt.edu/ Look for 'slurm_account_name' under your project allocations. Additionally, refer to the ARC compute resource guide to select the cluster and it's partition: https://www.docs.arc.vt.edu/resources/compute.html
  
## How to Run

**After logging into an ARC cluster,** follow these steps:

1. Before submitting an FCS-GX batch job, you must download the fcs.py runner script from GitHub into your working directory:
```bash
curl -LO https://github.com/ncbi/fcs/raw/main/dist/fcs.py
```
You only need to download this once unless NCBI updates the script.

2. Submit a job to run the human genome example:
```bash
sbatch fcs-gx-hs1.slurm
```
Or to run the NCBI example workflow:
```bash
sbatch fcs-gx-example.slurm
```

The above two commands submit a SLURM batch job via the script, you can monitor the status and check the job_ID of your submitted batch job using the command ```squeue -u <your_vt_username>``` When the batch job completes, check the output logs named like ```slurm-<job_ID>.out``` For more on monitoring SLURM batch jobs on ARC, see: https://www.docs.arc.vt.edu/usage/more-slurm.html

## Final Notes for ARC Users

- Memory requirements: FCS-GX needs enough memory to load the 470 GiB database into RAM. For this reason, the scripts request 500 GiB (--mem=500G) and recommend using Owl cluster, which has large-memory nodes.

- Where the database lives: Copying from ```/common``` → $TMPFS takes ~10 minutes. This is expected and necessary for performance.

- Where results go: Results are written to ```gx_out/``` in your submission directory.

- Apptainer requirement: FCS-GX only runs through the container; no local installation is needed.
