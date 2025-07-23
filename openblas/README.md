# OpenBLAS

This repository provides a test example to demonstrate the usage of **[OpenBLAS](https://www.openblas.net/)** on ARC clusters. It includes a SLURM batch job script (`openblas_test_example.slurm`) that, in turn, runs a test C program (`openblas_test_c.c`) using the OpenBLAS library available on ARC clusters. The C program itself performs a BLAS operation (dgemm for matrix-matrix multiplication) on large matrices. Finally, we demonstrate how OpenBLAS scales on ARC by varying the number of CPU cores (16, 32, and 64), which can be configured in the SLURM batch job script.

## Contents

This repository includes the following files:

1. **`openblas_test_c.c`**  
   A C program that performs a simple matrix-matrix multiplication (`dgemm`) utilizing OpenBLAS. Since we test the entire setup with large matrices, the C program also initializes large matrices in parallel using OpenMP to better scale across multiple CPU threads.


2. **`openblas_test_example.slurm`**  
   A SLURM batch job script to compile and run the test C program using OpenBLAS available on ARC clusters.  

   **Important:**  
   - Users must edit the SLURM directives at the top of the script to match their SLURM account name and the desired ARC cluster and it's partition they want to use for their work. You can check your SLURM account name on ColdFront: https://coldfront.arc.vt.edu/ Look for 'slurm_account_name' under your project allocations. Additionally, refer to the ARC compute resource guide to select the cluster and it's partition: https://www.docs.arc.vt.edu/resources/compute.html


3. **`Scaling_cpu_per-task=16, Scaling_cpu_per-task=32, and Scaling_cpu_per-task=64`**
   Screenshots from Grafana's node-utilization (obtained through dashboard.arc.vt.edu) showing OpenBLAS scaling on ARC compute node from 16->32->64 cores.
   
## How to Run

**After logging into an ARC cluster,** follow these steps:

```bash
git clone https://github.com/AdvancedResearchComputing/examples.git
cd examples/openblas
sbatch openblas_test_example.slurm
```

The results of the test example run can be found in the generated file named openblas.txt

The very last command submits a SLURM batch job via the script - you can monitor the status and check the job_ID of your submitted batch job using the command 'squeue -u <your_vt_username>' When the batch job completes, check the output logs named like 'slurm-<job_ID>.out' For more on monitoring SLURM batch jobs on ARC, see: https://www.docs.arc.vt.edu/usage/more-slurm.html
