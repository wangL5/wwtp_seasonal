#!/bin/bash
#SBATCH --job-name=iphop_run
#SBATCH --time=18:00:00
#SBATCH --mem=500G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=100
#SBATCH --partition=cpucluster
#SBATCH --output=slurm_iphop_%A.out

# activate conda environment
eval "$(conda shell.bash hook)"
conda activate iphop

INPUT_PHAGE="/Users/910904506/wwtp_seasons_assembly/mvp/03_CLUSTERING/MVP_03_All_Sample_Filtered_Relaxed_Representative_Virus_Provirus_Sequences.fna"
IPHOP_DB="/Users/910904506/wwtp_seasons_assembly/iphop/Jun_2025_pub_rw"
IPHOP_WORK_DIR="/Users/910904506/wwtp_seasons_assembly/iphop"

iphop predict \
    --fa_file ${INPUT_PHAGE} \
    --db_dir ${IPHOP_DB} \
    --out_dir ${IPHOP_WORK_DIR} \
    --num_threads $SLURM_CPUS_PER_TASK

echo "All done!"
