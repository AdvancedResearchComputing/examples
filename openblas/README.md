# OpenBLAS

This repository provides a test example to demonstrate the usage of **[OpenBLAS](https://www.openblas.net/)** on ARC clusters. It includes a SLURM batch job script (`openblas_test_example.slurm`) that, in turn, runs a test C program (`openblas_test_c.c`) containing various BLAS routines, using the OpenBLAS library installed on ARC clusters.

## Contents

This repository includes the following files:

1. **`openblas_test_c.c`**  
   A C program that tests selected BLAS routines. It contains implementations for:
   - Matrix-matrix multiplication (`dgemm`)
   - Triangular matrix-matrix multiplication (`dtrmm`)
   - Triangular matrix solve (`dtrsm`)
   - Vector norm computation (`dnrm2`)

2. **`openblas_test_example.slurm`**  
   A SLURM batch job script to compile and run the test C program using OpenBLAS on ARC clusters.  

   **Important:**  
   - Users must edit the SLURM directives at the top of the script to match their SLURM account name and the desired ARC cluster and it's partition they want to use for their work. You can check your SLURM account name on ColdFront: https://coldfront.arc.vt.edu/ Look for 'slurm_account_name' under your project allocations. Additionally, refer to the ARC compute resource guide to select the cluster and it's partition: https://www.docs.arc.vt.edu/resources/compute.html

## How to Run

**After logging into an ARC cluster,** follow these steps:

```bash
git clone https://github.com/AdvancedResearchComputing/examples.git
cd examples/openblas
sbatch openblas_test_example.slurm
```

The results of the test example run can be found in the generated file named openblas.txt

The very last command submits a SLURM batch job via the script - you can monitor the status and check the job_ID of your submitted batch job using the command 'squeue -u <your_vt_username>' When the batch job completes, check the output logs named like 'slurm-<job_ID>.out' For more on monitoring SLURM batch jobs on ARC, see: https://www.docs.arc.vt.edu/usage/more-slurm.html
