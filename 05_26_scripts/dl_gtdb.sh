#!/bin/bash
#SBATCH --job-name=download_gtdb_db
#SBATCH --time=168:00:00
#SBATCH --mem=500G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --partition=cpucluster
#SBATCH --output=slurm_gtdb_dl_%A.out

# activate conda environment
eval "$(conda shell.bash hook)"
conda activate gtdbtk-2.7.1

download-db.sh