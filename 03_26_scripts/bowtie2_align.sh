#!/bin/bash

# bowtie2 align, sort bam files, and coverM coverage calculation 

INDEX_DIR="/usr/data/archanand/lwang/ww_seasonality_metagenomes/read_mapping/results/index"
READS_DIR="/usr/data/archanand/lwang/ww_seasonality_metagenomes/nmdc_downloads"
BAM_DIR="/usr/data/archanand/lwang/ww_seasonality_metagenomes/read_mapping/results/bam"
COVERM="/usr/data/archanand/lwang/ww_seasonality_metagenomes/read_mapping/results/coverm"

# bowtie2-index output is the basename for .bt2 files 

for SAMP in ${INDEX_DIR}/*; do

    SAMP_NAME=$(basename $SAMP)
    
    bowtie2 -x ${INDEX_DIR}/${SAMP_NAME}/${SAMP_NAME} \
    -1 ${READS_DIR}/${SAMP_NAME}_R1_001.fastq.gz \
    -2 ${READS_DIR}/${SAMP_NAME}_R2_001.fastq.gz -p 6 | samtools sort -o ${BAM_DIR}/${SAMP_NAME}.sorted.bam 

    coverm contig -b ${BAM_DIR}/${SAMP_NAME}.sorted.bam \
    -m length covered_bases covered_fraction count mean rpkm tpm metabat \
    -t 6 > ${COVERM}/${SAMP_NAME}.coverm
   
done

echo "All done!" 