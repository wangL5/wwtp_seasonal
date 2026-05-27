#!/bin/bash
#SBATCH --job-name=spacerextractor_db
#SBATCH --time=18:00:00
#SBATCH --mem=50G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=10
#SBATCH --partition=cpucluster
#SBATCH --output=slurm_spacerextractor_db_%A.out

# activate conda environment
eval "$(conda shell.bash hook)"
conda activate spacerextractor

# enrich the repeat database with CRISPR arrays found in your own data 
# run crispr-cas typer to predict CRISPR arrays 
# can present a directory with multiple fasta files in the folder to process all of them 
# note - setuptools needs to be <v82 due to pkg_resources being deprecated after v82

MINCED_OUTPUT="/Users/910904506/wwtp_seasons_assembly/spacerextractor/minced_out/minced_repeats"
WORK_DIR="/Users/910904506/wwtp_seasons_assembly/spacerextractor/minced_out/wwtp_minced_db_additions"
CUSTOM_DB_DIR="/Users/910904506/wwtp_seasons_assembly/spacerextractor/wwtp_custom_db"
EXISTING_DB="/Users/910904506/wwtp_seasons_assembly/spacerextractor/SE_Db_r214GBIMG_0.9"

spacerextractor run_cctyper \
    -i ${MINCED_OUTPUT} \
    -w ${WORK_DIR} \
    -p \
    -t $SLURM_CPUS_PER_TASK

echo "All done with CC Typer!"

spacerextractor build_database \
    -d ${CUSTOM_DB_DIR} \
    -c ${WORK_DIR}/all_refined_repeats.tab \
    -r ${EXISTING_DB} \
    -t $SLURM_CPUS_PER_TASK

echo "All done with building custom database!"
echo "All done!"