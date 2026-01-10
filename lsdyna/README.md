# LS-DYNA

LS-DYNA is a general-purpose finite element program capable of simulating complex real-world problems. It is used by the automobile, aerospace, construction, military, manufacturing, and bioengineering industries. The code origins lie in highly nonlinear, transient dynamic finite element analysis using explicit time integration. LS-DYNA is optimized for shared and distributed memory Unix, Linux, and Windows-based platforms.

On ARC systems, LS-DYNA can be run as a **Standalone** application (requiring a specific research group license server) or via the **Ansys** module (using the University's central research license).

## Contents

These are the files included for this example:

* **lsdyna_standalone.slurm** is the Slurm batch submit script to run the standalone MPP version of LS-DYNA.
  * *Note:* This script works on **Tinkercliffs** (AMD/Intel) and **Owl** (Genoa/Milan).
  * *Note:* Users **must** edit this file to include their group's `LSTC_LICENSE_SERVER` address.
  * *Note:* Includes automatic hardware detection to select the correct executable (AVX2 vs AVX512).

* **lsdyna_ansys.slurm** is the Slurm batch submit script to run LS-DYNA via the Ansys environment.

* **main.k** is a simple single-element drop test input file used to verify that the solver and license are communicating correctly.

## How to run

The following are steps to run the LS-DYNA examples. Run these commands once you have logged into the cluster.

Before you submit your batch script, you will need to:

1. Change the `#SBATCH --account=...` line to your specific ARC allocation.
2. (For Standalone) Edit the `LSTC_LICENSE_SERVER` variable in the script.
3. (For Standalone) Uncomment the `#SBATCH --constraint=...` and core count sections matching the cluster you are using.

```bash
# To run the Standalone version (Group License)
sbatch lsdyna_standalone.slurm

# To run the Ansys version (Central License)
sbatch lsdyna_ansys.slurm

```

## Cluster and Partition Info

LS-DYNA is compute-intensive and performance depends heavily on the CPU architecture. You must choose the correct constraints and core counts for your job to run efficiently.

### Tinkercliffs

* **AMD Zen2 ("Rome"):**
  * Partition: `normal_q`
  * Constraint: `--constraint=amd`
  * Cores per Node: **128**
  * Executable: Uses **AVX2** (Auto-detected)


* **Intel Cascade Lake:**
  * Partition: `normal_q`
  * Constraint: `--constraint=intel`
  * Cores per Node: **96** 
  * Executable: Uses **AVX512** (Auto-detected)



### Owl

* **AMD Zen4 ("Genoa"):**
  * Partition: `normal_q`
  * Constraint: `--constraint=genoa`
  * Cores per Node: **96**
  * Executable: Uses **AVX512** (Auto-detected)


* **AMD Zen3 ("Milan"):**
  * Partition: `normal_q`
  * Constraint: `--constraint=milan`
  * Cores per Node: **64** (Standard) or **128** (Large/Huge Memory)
  * Executable: Uses **AVX2** (Auto-detected)



The list of available resources and associated partitions can be found in ARC's documentation for [Tinkercliffs](https://www.docs.arc.vt.edu/resources/compute/00tinkercliffs.html) and [Owl](https://www.docs.arc.vt.edu/resources/compute/01owl.html).

## Notes

* **Job Status:** Once you submit your Slurm job, you can check the status by typing `squeue -u <your_pid>`.
* **Documentation:** For standard Slurm command options, please refer to ARC's documentation on Slurm. For further details about LS-DYNA keywords, visit the [LSTC Documentation](https://lsdyna.ansys.com/).
