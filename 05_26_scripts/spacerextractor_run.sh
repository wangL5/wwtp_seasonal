#!/bin/bash
#SBATCH --job-name=spacerextractor_run
#SBATCH --time=18:00:00
#SBATCH --mem=50G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=10
#SBATCH --partition=cpucluster
#SBATCH --output=slurm_spacerextractor_run_%A.out

# activate conda environment
eval "$(conda shell.bash hook)"
conda activate spacerextractor

READS_DIR="/Users/910904506/wwtp_seasons/interleaved"
OUT_DIR="/Users/910904506/wwtp_seasons_assembly/spacerextractor/wwtp_out"
CUSTOM_DB_DIR="/Users/910904506/wwtp_seasons_assembly/spacerextractor/wwtp_custom_db"

for FILE in ${READS_DIR}/*.fastq.gz; do 
    SAMP_NAME=$(basename $FILE _L008_interleaved.fastp.bbmap.fastq.gz)

    spacerextractor extract_spacers \
        -d "$CUSTOM_DB_DIR" \
        -o ${OUT_DIR}/${SAMP_NAME} \
        -f $FILE \
        -t $SLURM_CPUS_PER_TASK
    
    spacerextractor filter_hq_spacers \
        -d "$CUSTOM_DB_DIR" \
        -w ${OUT_DIR}/${SAMP_NAME} \
        -t $SLURM_CPUS_PER_TASK
    
done

echo "All done!"