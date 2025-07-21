# PALM [In Progress]

This repository provides scripts and instructions to build and run the [PALM model system](https://palm-model.org/) on the ARC clusters at Virginia Tech.

## Contents

- Access to [ARC](https://arc.vt.edu) resources and a valid SLURM account (Coldfront allocation)
- PALM module installed (`PALM/23.10-foss-2023a`)
- Basic familiarity with submitting SLURM jobs on VT HPC systems

---

## How to run

Run the provided SLURM job script to build PALM from the centrally installed source into your own `$HOME` space.

```bash
sbatch build_palm_vt.sh
