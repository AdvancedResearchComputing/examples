# SQLite

### Background 

SQLite is a DBMS (database management system).

It is designed to work with Python.

In fact, the current versions of python (e.g., 3.14) have sqlite built into the
python package itself, so no need to create a virtual environment and load 
any packages.

I still cannot believe it.

### Files

There are three files:
1. _sbatch_sqlite.slurm_ : sbatch slurm script.
2. _run.me_ : run script (because I like to separate slurm resource requests and env from
code execution).
3. _sqlite_driver.py : Python code that does simple database manipulations using Sqlite.

### To Run the Code

This code has been run on TC and on Owl.
On both clusters, the normal_q is used.
See the sbatch slurm script.

1. Place the three files in the same directory.
2. Submit the job by typing on the command line:  Issue _sbatch sbatch.sql.slurm_

Note:  each time you run the code with the same DB file (see the flag
and filename in the run.me file), new records are appended to the existing
file.

The results are written to the slurm output file.
