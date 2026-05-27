#!/bin/bash

# activate conda environment
eval "$(conda shell.bash hook)"
conda activate misc_tools

READS_DIR="/Users/910904506/wwtp_seasons"
OUT_DIR="/Users/910904506/wwtp_seasons/interleaved"

# Influent_WWTP_7_24_23_MH4_S358_L008_R1_001.fastp.bbmap.fastq.gz

for READS in ${READS_DIR}/*_R1_001.fastp.bbmap.fastq.gz; do 
    SAMP_NAME=$(basename $READS _R1_001.fastp.bbmap.fastq.gz)
    reformat.sh in1=${READS_DIR}/${SAMP_NAME}_R1_001.fastp.bbmap.fastq.gz \
        in2=${READS_DIR}/${SAMP_NAME}_R2_001.fastp.bbmap.fastq.gz \
        out=${OUT_DIR}/${SAMP_NAME}_interleaved.fastp.bbmap.fastq.gz
done 

echo "All done!"