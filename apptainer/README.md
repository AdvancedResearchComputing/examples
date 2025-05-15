# Apptainer

Apptainer (formerly known as singularity) is a containerization software that works well on HPC systems.

Image files can be pulled from various container repositories including docker:
```
apptainer pull docker://cp2k/cp2k:2025.1_openmpi_generic_psmp
```

Please see the apptainer documentation for more details: https://apptainer.org/docs/user/main/
