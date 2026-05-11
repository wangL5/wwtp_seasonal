#!/bin/bash
#SBATCH --job-name=run_gtdbtk
#SBATCH --time=168:00:00
#SBATCH --mem=500G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=40
#SBATCH --partition=highmem
#SBATCH --output=slurm_gtdbtk_%A.out

# activate conda environment
eval "$(conda shell.bash hook)"
conda activate gtdbtk-2.7.1 

