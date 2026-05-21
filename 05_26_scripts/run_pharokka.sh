#!/bin/bash
#SBATCH --job-name=run_pharokka
#SBATCH --time=8:00:00
#SBATCH --mem=500G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=40
#SBATCH --partition=cpucluster

# using pharokka pipeline to annotate phage genomes 

# activate conda environment
eval "$(conda shell.bash hook)"
conda activate phage_annot

ANNOUNCEMENT_CONTIGS="/Users/910904506/genome_announcement/announcement_contigs/announcement_contigs.fna"
OUTPUT_DIR="/Users/910904506/genome_announcement/announcement_contigs"
DB_DIR="/Users/910904506/genome_announcement/pharokka"

pharokka.py -i "$ANNOUNCEMENT_CONTIGS" \
    -o ${OUTPUT_DIR}/pharokka_output \
    -d "$DB_DIR" \
    -t $SLURM_CPUS_PER_TASK

echo "All done!"