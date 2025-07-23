# PALM

This repository provides SLURM batch job scripts to demonstrate the usage of **[PALM](https://palm.muk.uni-hannover.de/trac/wiki/palm)** on ARC clusters. These scripts are designed to help users to 1) successfully build PALM in their ARC \home directory and 2) verify the build and run an example test case to grasp the entire PALM workflow on ARC which will eventually help them with their own customized workloads.

## Contents

This repository contains two SLURM batch job scripts:

1. **`PALM_build_home.slurm`**  
   This script builds PALM in your ARC `/home` directory using the PALM version that we have already centrally installed on ARC.
   
   **Important:**  
   - Users must edit the SLURM directives at the top of the script to match their SLURM account name and the desired ARC cluster and it's partition they want to use for their work. You can check your SLURM account name on ColdFront: https://coldfront.arc.vt.edu/ Look for 'slurm_account_name' under your project allocations. Additionally, refer to the ARC compute resource guide to select the cluster and it's partition: https://www.docs.arc.vt.edu/resources/compute.html
   - This build script only needs to be run **once**, unless you want to rebuild PALM again from scratch.

3. **`PALM_test_example.slurm`**  
   This script runs a simple test example (`example_cbl`) to demonstrate PALM functionality on ARC. Like the build script, users should customize the SLURM directives for their account and ARC cluster and it's partition.
   
## How to Run

**After logging into an ARC cluster,** follow these steps to clone the repository and build PALM in your ARC /home directory:

```bash
git clone https://github.com/AdvancedResearchComputing/examples.git
cd examples/PALM
sbatch PALM_build_home.slurm
```
The last command submits a SLURM batch job via the script to build PALM, you can monitor the status and check the job_ID of your submitted batch job using the command 'squeue -u <your_vt_username>' When the batch job completes, check the output logs named like 'slurm-<job_ID>.out' For more on monitoring SLURM batch jobs on ARC, see: https://www.docs.arc.vt.edu/usage/more-slurm.html

After the build finishes, you can run the test example:

```bash
sbatch PALM_test_example.slurm
```

Monitor it as before using squeue and examine the output files to verify a successful run of the example test case.
