# Apptainer

This example uses a container with the CP2K software and runs a simple case from https://github.com/cp2k/cp2k-examples/blob/master/gw/1_H2O_GW100/H2O_GW100_def2-QZVP.inp.

Image files can be pulled from various container repositories including docker:
```
apptainer pull docker://cp2k/cp2k:2025.1_openmpi_generic_psmp
```

Please see the NVIDIA NGC for GPU-enabled CP2K: https://catalog.ngc.nvidia.com/orgs/hpc/containers/cp2k
