OpenFOAM 

Multiple versions of OpenFOAM are available on ARC clusters.

The examples here are provided with the installation. Different versions have different working environments and input definitions. The parallelization and mesh-blocking setup for OpenFOAM must be well designed according to the specific version requirements.

OpenFOAM has a unique way of setting up the working environment. Upon loading the module, $FOAM_BASH is defined and must be sourced. Please see OpenFOAM documentation for proper configuration.

As a numerical integration ("simulation") software, the most efficent way to use this software is in batch mode. Alternatively, jobs can be run in interactively. See the attached documentation `desktop.pdf` for running this example with the Desktop App on the owl cluster.
