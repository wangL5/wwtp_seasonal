#!/bin/bash
#SBATCH --job-name=run_tiger
#SBATCH --time=8:00:00
#SBATCH --mem=50G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=5
#SBATCH --partition=cpucluster
#SBATCH --output=slurm_tiger_%A.out

# running on high quality MAGs

# activate conda environment
eval "$(conda shell.bash hook)"
conda activate tiger

