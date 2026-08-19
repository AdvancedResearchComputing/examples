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
1. _sbatch_sqlite.slurm_ : sbatch slurm script.  This same file works with TC and Owl.
2. _run.me_ : run script (because I like to separate slurm resource requests and env from
code execution).
3. _sqlite_driver.py_ : Python code that does simple database manipulations using Sqlite.

### To Run the Code

This code has been run on TC and on Owl.
On both clusters, the normal_q is used.
See the sbatch slurm script.

As is the case for ALL examples, you must enter your account name
in files so that the (Slurm) jobs will run with one of your valid
accounts.

In these codes, the text is:
```
account=<account_name_no_beaks>
```
You must change this to have a valid account for you.
Say your account name is named hyper_performance, then you must change each
occurrence of the above to:
```
account=hyper_performance
```


Steps:

1. Place the three files in the same directory.
2. Submit the job by typing on the command line:  _sbatch sbatch.sql.slurm_

Note:  each time you run the code with the same DB file (see the flag
and filename in the run.me file), new records are appended to the existing
file.

The results are written to the slurm output file.
