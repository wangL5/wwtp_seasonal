#!/bin/bash
#SBATCH --job-name=run_checkm2
#SBATCH --time=168:00:00
#SBATCH --mem=500G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=40
#SBATCH --partition=highmem
#SBATCH --output=slurm_checkm2_%A.out

# activate conda environment
eval "$(conda shell.bash hook)"
conda activate checkm2

# v1.1.0

# paths
COMEBIN_RESULTS="/Users/910904506/wwtp_seasons_assembly/comebin/results"
OUT_DIR="/Users/910904506/wwtp_seasons_assembly/checkm2"

# run checkm2

for DIR in ${COMEBIN_RESULTS}/*/comebin_res/comebin_res_bins; do
    SAMP_NAME=$(basename $(dirname $(dirname $DIR)))
    mkdir -p ${OUT_DIR}/${SAMP_NAME}
    checkm2 predict \
    --threads $SLURM_CPUS_PER_TASK \
    -x .fa \
    --input $DIR \
    --output-directory ${OUT_DIR}/${SAMP_NAME}
done 

echo "All done with checkm2 on comebin wwtp bins!"