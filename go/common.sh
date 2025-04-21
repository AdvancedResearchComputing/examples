#!/bin/bash
#SBATCH --account=personal
#SBATCH --partition=normal_q
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --output=output.log
#SBATCH --time=0-00:30:00

module load Go/1.23.6
go run main.go