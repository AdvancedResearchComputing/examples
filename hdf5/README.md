# HDF5

This directory provides a SLURM batch job script and a sample C program that demonstrate how to compile and run a basic HDF5 application on ARC's Tinkercliffs AMD nodes. It also shows how to use several command-line HDF5 utilities to inspect and validate the generated `.h5` file.

This example is intended to help users understand:
- How to write/read data to/from HDF5 files in C
- How to compile HDF5 programs using `h5pcc`
- How to use tools like `h5dump`, `h5ls`, `h5copy`, `h5diff`, and `h5stat`

---

## Contents

This directory contains:

1. **`hdf5_test.c`**  
   C program that:
   - Creates a 2D integer array
   - Writes it to an HDF5 file (`hdf5_test.h5`)
   - Reads the file back
   - Compares the original and read values

2. **`	hdf5_example.sbatch`**  
   A SLURM batch job script that:
   - Compiles the program using `h5pcc`
   - Runs the binary
   - Uses `h5dump`, `h5ls`, `h5copy`, `h5diff`, and `h5stat` to explore and verify file contents

3. **`hdf5_tinkercliffs_rome.txt`**  
   Output file produced by the script, capturing all program and tool outputs.

---

## How to Run

After logging into the Tinkercliffs cluster:

```bash
git clone https://github.com/AdvancedResearchComputing/examples.git
cd examples/HDF5
sbatch hdf5_example.sbatch
```

After job completion, check the job output file (e.g. `slurm-<jobid>.out`) and the `hdf5_tinkercliffs_rome.txt` log file to review the results.

---

## SLURM Settings

The script is configured to run on AMD nodes of the `normal_q` partition with 4 CPU cores:

```bash
#SBATCH -t 00:10:00
#SBATCH -N1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=4
#SBATCH -p normal_q
#SBATCH -A <your_slurm_account_name>    # Replace with your allocation name
#SBATCH --constraint=amd
```

If you're unsure of your SLURM account name, you can find it by logging into [ColdFront](https://coldfront.arc.vt.edu/) and checking your project allocations.

---

## Notes

- All necessary modules (HDF5) are loaded inside the script.
- To monitor your job, run `squeue -u <your_vt_username>`.
- To inspect the generated HDF5 file manually, use:
  ```bash
  h5dump hdf5_test.h5
  h5ls -r hdf5_test.h5
  ```

For more SLURM job monitoring options, see the ARC guide: https://www.docs.arc.vt.edu/usage/more-slurm.html
For more on HDF5, visit: https://portal.hdfgroup.org/display/HDF5


If you intend to run on a different ARC cluster or partition, you should customize the `#SBATCH` directives accordingly.

For example, if you're targeting a GPU partition like `h200_normal_q`, include:

```bash
#SBATCH -p h200_normal_q
#SBATCH --gres=gpu:1         # Request one GPU
```

Refer to ARC’s resource documentation for more details on clusters, partitions, and capabilities:  
https://www.docs.arc.vt.edu/resources.html
