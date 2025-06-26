# OpenMolcas
OpenMolcas is an open-source quantum chemistry package that provides access to various methods to assist in studying molecular systems. 

## Contents
There are three files in this example
1. `openmolcas.slurm` is the slurm batch submit script. User may have to change the account name based on what resources are available to them. 
2. `water.input` is the openmolcas job submission script that holds the inforamtion/parameters for the type of computational chemistry job. Our example is running a simple SCF calculation. 
3. `water.xyz` is the xyz coordinates for the molecular system which is water in our example.

## How to run
The following are steps to run our OpenMolcas example. This will give you access to all examples in our GitHub repo. Run these commands once you have logged into a cluster. 

``` 
    git clone https://github.com/AdvancedResearchComputing/examples.git
    cd examples
    cd openmolcas
    sbatch openmolcas.slurm
```

You then should be able to check the status of the job submission by typing `squeue`. 
OpenMolcas generates a large number of other files that may be of interest to the user, but the file with the `.log` extension will hold the output from the calculation.
The OpenMolcas manual can be found [here](https://molcas.gitlab.io/OpenMolcas/sphinx/intro.html).
To see what other types of quantum chemistry programs that OpenMolcas has to offer, please refer to the articles in the following References section. 

## References
1. Fdez. Galván, I. et al., OpenMolcas: From Source Code to Insight. Journal of Chemical Theory and Computation 2019, 15 (11), 5925-5964. [https://pubs.acs.org/doi/10.1021/acs.jctc.9b00532](https://pubs.acs.org/doi/10.1021/acs.jctc.9b00532)
2. Li Manni, G. et al., The OpenMolcas Web: A Community-Driven Approach to Advancing Computational Chemistry. Journal of Chemical Theory and Computation 2023, 19 (20), 6933-6991.[https://pubs.acs.org/doi/10.1021/acs.jctc.3c00182](https://pubs.acs.org/doi/10.1021/acs.jctc.3c00182)
