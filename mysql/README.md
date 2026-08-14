# MySQL (and MariaDB)

### Background 

MariaDB is an open source version of MySQL; both are DBMS (database management systems).

There are two examples here:
1. for Tinkercliffs (TC), normal_q, constraint=amd.
2. for Owl, normal_q, constraint=avx512.

The constraint parameter dictates the type of compute node on which 
a code runs or on which work is done.

We will be using virtual environments (VEs) here.
This means that the compute node type on which we build the
VE **_must_** be the same as the type we run our code on.

So, we have set this up so that you are using the most numerous type
of compute node on TC and on Owl, so your job has more
nodes to choose from. 

### Files

Each job---the one for TC and the one for Owl---requires three files.

The three files:
1. A _run.build.ve.*_ script.  This script builds the virtual environment
which the python code will use.
There is one file for each cluster:  one for TC and one for Owl.
2. _few_records.py_ : Python code that does simple database manipulations using MySQL/MariaDB.
This is the single code used for both the TC execution and the Owl execution.
3. An _sbatch.maria.04.*_ sbatch slurm script. 
There is one file for each cluster:  one for TC and one for Owl.

### What is Going On Here?

This is sorta cool.

To run a code with a DBMS, you need to run two things (processes):
- an instance of the DBMS server
- an instance of your code; here, a python code.

The sbatch slurm scripts (one for TC, one for Owl) are a bit more
complex than normal because each has to run the server and the
python code.
The latter will look familiar to you; the former may not.
The former (running the server) takes several commands in the
sbatch slurm script.
The process of running the job fully is this---and it is all
done in the sbatch slurm script:
1. Start up the DBMS server instance.
2. Wait for a bit to make sure the server is running.
3. Run your python (client) code, which interacts with the DBMS.
4. When the python code finishes, then shut down the DBMS server instance.



### Generic Setup and Run Steps

As is the case for ALL examples, you must enter your account name
in files so that the (Slurm) jobs will run with one of your valid
accounts.

In these codes, the text is:
```
account=<account_name_no_beaks>
```
You must change this to have a valid account for you.
Say my account is named hyper_performance, then you must change each
occurrence of the above to:
```
account=hyper_performance
```

For this example, this will be in two _sbatch.maria.04*slurm_ files
and two _run.build.ve.*.heredoc_ files.


1. Setup (done once)
   - We must build a VE for the particular (cluster, constraint).
      - Here we have one VE for (TC, amd) and one VE for (Owl, avx512).
      - We only do this step one time; once the VE is built for each cluster, it can be used over and over.
2. Run (done any number of times)
   - We submit the sbatch slurm script.




### To Run the Code on TC Cluster

We assume all files referred to here are in one directory.
And that the root directory for the VE is in this directory, too.


1. Create the VE.  This is done one time.
   - Execute the command:  _./run.build.ve.tc.amd.heredoc_
   - When this command completes ... it will take a while ... there
     should be a directory py314_mf_mariadb_tc_amd.
2. Submit the job.  This is done any number of times.
   - Type on the command line:  _sbatch sbatch.maria.04.tc.amd.slurm_
   - When this job is done, there should be two output files.


### To Run the Code on Owl Cluster

We assume all files referred to here are in one directory.
And that the root directory for the VE is in this directory, too.


1. Create the VE.  This is done one time.
   - Execute the command:  _./run.build.ve.owl.genoa.heredoc_
   - When this command completes ... it will take a while ... there
     should be a directory py314_mf_mariadb_owl_genoa.
2. Submit the job.  This is done any number of times.
   - Type on the command line:  _sbatch sbatch.maria.04.owl.genoa.slurm_
   - When this job is done, there should be two output files.


### Outputs from Running the Slurm Job

This output is geneated for each of the Slurm jobs.

Log information is written to the slurm output file.

There are two output files:
1. _all_records.tsv_ : a tab separated value file of all DB table records.
2. _selected_records.tsv_ : a tab separated value file of results of one DB query.

For each of these two files, there is an _all_records.tsv.valid_ file
and a _selected_records.tsv_ file, to "diff" with the results you generate.


### Aside

You can diff the two sbatch slurm scripts _sbatch.maria.04.*slurm_ 
and the two _run.build.ve*heredoc_ scripts
to see how similar these two files are for the two clusters.
You could make up one of each of these files to take CLAs 
(command line arguments) so you only need one file of each type.
