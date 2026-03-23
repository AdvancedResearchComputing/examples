# LAMMPS with ML-IAP
This is an example to run ML-IAP with LAMMPS. ML-IAP takes a MACE potential and integrates it with LAMMPS.

ML-IAP supports both cuEquivariance acceleration and multi-GPU inference, and atomic virials. See futher documentation [here](https://mace-docs.readthedocs.io/en/latest/guide/lammps_mliap.html). 

## Contents
These are the files/directories included for this example:
- `in.mliap` is the input file that uses a `pair_style` for mliap
- `lammps_mliap.slurm` is the slurm batch script to run in parallel with Kokkos. Includes a python script line that creates the .pt file. Only include python script if you don't already have the mliap formatted .pt file.
- `mace-omat-0-small.model` is a pre-trained MACE model (more details below).   
- `mace-omat-0-small.model-mliap_lammps.pt` generated with a python script to create a ML-IAP checkpoint for LAMMPS  
- `structure.data` data file for the LAMMPS calculation

## Model Details
Model: MACE-OMAT-0 (small), Training dataset: OMAT, Level of Theory: DFT (PBE+U) VASP 54
Downloaded from [https://github.com/ACEsuit/mace-foundations/tree/main](https://github.com/ACEsuit/mace-foundations/tree/main).

```bib
@article{batatia2023foundation,
      title={A foundation model for atomistic materials chemistry},
      author={Ilyes Batatia and Philipp Benner and Yuan Chiang and Alin M. Elena and Dávid P. Kovács and Janosh Riebesell and Xavier R. Advincula and Mark Asta and William J. Baldwin and Noam Bernstein and Arghya Bhowmik and Samuel M. Blau and Vlad Cărare and James P. Darby and Sandip De and Flaviano Della Pia and Volker L. Deringer and Rokas Elijošius and Zakariya El-Machachi and Edvin Fako and Andrea C. Ferrari and Annalena Genreith-Schriever and Janine George and Rhys E. A. Goodall and Clare P. Grey and Shuang Han and Will Handley and Hendrik H. Heenen and Kersti Hermansson and Christian Holm and Jad Jaafar and Stephan Hofmann and Konstantin S. Jakob and Hyunwook Jung and Venkat Kapil and Aaron D. Kaplan and Nima Karimitari and Namu Kroupa and Jolla Kullgren and Matthew C. Kuner and Domantas Kuryla and Guoda Liepuoniute and Johannes T. Margraf and Ioan-Bogdan Magdău and Angelos Michaelides and J. Harry Moore and Aakash A. Naik and Samuel P. Niblett and Sam Walton Norwood and Niamh O'Neill and Christoph Ortner and Kristin A. Persson and Karsten Reuter and Andrew S. Rosen and Lars L. Schaaf and Christoph Schran and Eric Sivonxay and Tamás K. Stenczel and Viktor Svahn and Christopher Sutton and Cas van der Oord and Eszter Varga-Umbrich and Tejs Vegge and Martin Vondrák and Yangshuai Wang and William C. Witt and Fabian Zills and Gábor Csányi},
      year={2023},
      eprint={2401.00096},
      archivePrefix={arXiv},
      primaryClass={physics.chem-ph}
}

MACE-Universal by Yuan Chiang, 2023, Hugging Face, Revision e5ebd9b, DOI: 10.57967/hf/1202, URL: https://huggingface.co/cyrusyc/mace-universal
```

## How to run
The following are steps to run the LAMMPS ML-IAP example on the A100 GPUs of Tinkercliffs. This will give you access to all examples in our GitHub repo. Run these commands once you have logged into a cluster. 
Before you submit your batch script, you will need to change the account name to the account you have access to. This name can be found in your [ColdFront account](https://coldfront.arc.vt.edu/).
```
git clone https://github.com/AdvancedResearchComputing/examples.git
cd examples/lammps/gpu/MLIAP
sbatch lammps_mliap.slurm 
```
### Cluster and Partition Info
LAMMPS-MLIAP requires a GPU but is available on all GPU partitions (both Tinkercliffs and Falcon). 
In order to run on other clusters or different partitions make sure you are logged into the cluster of choice, and then change the partition name to the parition you would like to use.
The list of available resources and associated names of the paritions can be found in ARC's documentation [here](https://www.docs.arc.vt.edu/resources/compute.html). 

### Notes
Once you submit your slurm job, you are able to check the status of the job submission by typing `squeue`. 
For other slurm commands options please refer to [ARC's documentation](https://www.docs.arc.vt.edu/usage/more-slurm.html#more-slurm) on Slurm.
For further details about LAMMPS, you can visit their documentation site [here](https://www.lammps.org).
