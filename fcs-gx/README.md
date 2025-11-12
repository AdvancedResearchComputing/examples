
[https://github.com/ncbi/fcs/wiki/FCS-GX-quickstart]

# Components on ARC systems
1. This tool uses a database which is about 470GiB. ARC has downloaded a reference copy available on the clusters so that you do not need to download or store an additional copy.
```/common/data/ncbi/fcs-gx/2025-11-11/gxdb```
FCS-GX will only perform well when the database is stored in memory on a compute node, so the example Slurm script requests enough memory to host the database and copies it from ```/common``` to the compute node as part of the job.
2. The FCS-GX tool uses a small, containerized app which works with Apptainer. ARC provides a copy of the container at
```/common/containers/fcs-gx.sif```

# Required Setup
Retrieve the `fcs.py` runner script from GitHub. A copy must be in the current working directory when the job is submitted.
```
curl -LO https://github.com/ncbi/fcs/raw/main/dist/fcs.py
```{code}