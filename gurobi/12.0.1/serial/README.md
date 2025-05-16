# Gurobi

Version of Gurobi:  12.0.1

## Codes


------------------------------------------
------------------------------------------
### code01

This is a serial code.

module:  Gurobi/12.0.1-GCCcore-13.3.0

Comes from:  /projects/kuhlman-project-storage/system-maint/y2025/2025-05/test-gurobi/test01

Cluster:  TC.

Partition:  normal_q

Compute node:  tc285

The example is shown on this web page:

https://support.gurobi.com/hc/en-us/articles/14078115039121-Coins-Tutorial-Solving-the-Model-using-gurobi-cl#:~:text=The%20name%20of%20the%20Gurobi,command%2Dline%20window...

----------------------
To set up to run.

ssh to compute node tc285 on TC. 

Do:

module reset

module load Gurobi/12.0.1-GCCcore-13.3.0


----------------------
To run code.

We use the command line.

First we determine the value of $GUROBI_HOME, according to:

_echo $GUROBI_HOME_

which is:  /apps/arch/software/Gurobi/12.0.1-GCCcore-13.3.0

Use invocation (this will run VERY fast):

gurobi_cl ResultFile=coins.sol $GUROBI_HOME/examples/data/coins.lp

It will generate this output to stdout.

```
Set parameter TokenServer to value "gurobi.software.vt.edu"
Set parameter LogFile to value "gurobi.log"
Using license file /apps/arch/software/Gurobi/12.0.1-GCCcore-13.3.0/gurobi.lic

Gurobi Optimizer version 12.0.1 build v12.0.1rc0 (linux64 - "Rocky Linux 9.5 (Blue Onyx)")
Copyright (c) 2025, Gurobi Optimization, LLC

Read LP format model from file /apps/arch/software/Gurobi/12.0.1-GCCcore-13.3.0/examples/data/coins.lp
Reading time = 0.00 seconds
: 4 rows, 9 columns, 16 nonzeros

Using Gurobi shared library /apps/arch/software/Gurobi/12.0.1-GCCcore-13.3.0/lib/libgurobi.so.12.0.1

CPU model: AMD EPYC 7702 64-Core Processor, instruction set [SSE2|AVX|AVX2]
Thread count: 128 physical cores, 128 logical processors, using up to 32 threads

Optimize a model with 4 rows, 9 columns and 16 nonzeros
Model fingerprint: 0x06e334a4
Variable types: 4 continuous, 5 integer (0 binary)
Coefficient statistics:
  Matrix range     [6e-02, 7e+00]
  Objective range  [1e-02, 1e+00]
  Bounds range     [5e+01, 1e+03]
  RHS range        [0e+00, 0e+00]
Found heuristic solution: objective -0.0000000
Presolve removed 1 rows and 5 columns
Presolve time: 0.00s
Presolved: 3 rows, 4 columns, 9 nonzeros
Variable types: 0 continuous, 4 integer (0 binary)
Found heuristic solution: objective 25.2000000

Root relaxation: objective 1.134615e+02, 2 iterations, 0.00 seconds (0.00 work units)

    Nodes    |    Current Node    |     Objective Bounds      |     Work
 Expl Unexpl |  Obj  Depth IntInf | Incumbent    BestBd   Gap | It/Node Time

     0     0  113.46154    0    1   25.20000  113.46154   350%     -    0s
H    0     0                     112.5000000  113.46154  0.85%     -    0s
H    0     0                     113.3000000  113.46154  0.14%     -    0s
H    0     0                     113.4500000  113.46154  0.01%     -    0s
     0     0  113.46154    0    1  113.45000  113.46154  0.01%     -    0s

Explored 1 nodes (2 simplex iterations) in 0.04 seconds (0.00 work units)
Thread count was 32 (of 128 available processors)

Solution count 5: 113.45 113.3 112.5 ... -0

Optimal solution found (tolerance 1.00e-04)
Best objective 1.134500000000e+02, best bound 1.134500000000e+02, gap 0.0000%

Wrote result file 'coins.sol'
```

And it will generate this output file, coins.sol:

```
# Objective value = 113.45
Pennies 0
Nickels 0
Dimes 2
Quarters 53
Dollars 100
Cu 999.8
Ni 46.9
Zi 50
Mn 30
```

The output file is in this directory as coins.sol.valid.


Diff output:  diff coins.sol   coins.sol.valid

**There could be very minor discrepancies due to rounding.**


