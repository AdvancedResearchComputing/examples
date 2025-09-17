# Quantum ESPRESSO
Quantum ESPRESSO is an integrated suite of Open-Source computer codes for electronic-structure calculations and materials modeling at the nanoscale. It is based on density-functional theory, plane waves, and pseudopotentials. For more detailed information about the software, here is the link to their website, [Quantum ESPRESSO](https://www.quantum-espresso.org/).
The example we provide here uses planewaves to calculate the total energy and band structure of four simple systems: aluminum (Al), copper (Cu), nickel (Ni), and silicon (Si).

## Contents
There is a cpu_only and gpu examples (each in its own folder):
- cpu_only:
    1. `quantum_espresso.slurm` is the slurm batch submit script. User may have to change the account name based on what resources are available to them. 
    2. `run_example` is a bash script that generates the input files and directs the output files into a `results` directory.
    3. `environment_variables` is where all the settings information for running Quantum ESPRESSO is defined. This is also where parallelization parameters can be set. 
    4. `pseudo` is a directory that contains the pseudopotential information for aluminum, copper, nickel, and silicon.

- gpu:
    1. `quantum_espresso_gpu.slurm` is the slurm batch submit script. User may have to change the account name based on what resources are available to them. 
    2. `ausurf.in` is the input file taken from https://github.com/QEF/benchmarks/tree/master/AUSURF112.
    3. `Au.pbe-nd-van.UPF` is the file that contains the parameters for the pseudopotentials..

## How to run
The following are steps to run our Quantum ESPRESSO example for the cpu_only version (works as is on clusters Tinkercliffs or Owl). This will give you access to all examples in our GitHub repo. Run these commands once you have logged into a cluster. 

``` 
git clone https://github.com/AdvancedResearchComputing/examples.git
cd examples/quantum_espresso/cpu_only
sbatch quantum_espresso.slurm
```

To run the GPU version (works as is on Falcon, but may also run on Tinkercliffs, need to change the partition name if running on Tinkercliffs)

```
git clone https://github.com/AdvancedResearchComputing/examples.git
cd examples/quantum_espresso/gpu
sbatch quantum_espresso_gpu.slurm
```

### Notes
The cpu_only example here is taken from example01 from the Quantum ESPRESSO source tarball.
Note that we set Espresso's `TMP_DIR` variable to $TMPDIR, which on ARC systems
points to the local hard drive. One might also try $TMPFS (memory) for a faster
calculation, depending on how much temporary storage is required (note that putting 
`TMP_DIR` in memory will eat up memory assigned to the job).

You then should be able to check the status of the job submission by typing `squeue`.
Once the job has finished, all the results for the cpu_only example are located in the `results` directory that was generated during the calculation.
This `results` directory has both the input and output files of each simple example that was run. 

The output for the GPU example will be stored in the slurm output file. 
Note that the GPU-version of Quantum ESPRESSO using an apptainer build is version 7.3.1 while the CPU-only version of Quantum ESPRESSO is using version 7.4.1 provided via EasyBuild.

The Quantum ESPRESSO documentation can be found [here](https://www.quantum-espresso.org/documentation/).

