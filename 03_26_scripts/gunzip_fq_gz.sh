#!/bin/bash

# need to unzip and rename the fastq.gz files
# comebin's get coverage script needs the fastqs to be named in a very particular way 

FASTQ_DIR="/home/910904506/lwang/ww_seasonality_metagenomes/nmdc_downloads"

for FILE1 in ${FASTQ_DIR}/*_R1_001.fastq.gz; do
    SAMP_NAME=$(basename $FILE1 _R1_001.fastq.gz)
    gunzip -c $FILE1 > ${SAMP_NAME}_1.fastq
done 

for FILE2 in ${FASTQ_DIR}/*_R2_001.fastq.gz; do
    SAMP_NAME=$(basename $FILE2 _R2_001.fastq.gz)
    gunzip -c $FILE2 > ${SAMP_NAME}_2.fastq
done

echo "All done!"