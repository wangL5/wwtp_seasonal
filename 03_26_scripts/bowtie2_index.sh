#!/bin/bash

# bowtie2 is memory efficient - will typically require 3.2GB ram for human genome

ASSEMBLY_DIR="/home/910904506/lwang/ww_seasonality_metagenomes/nmdc_assembly"
OUTPUT_DIR="/usr/data/archanand/lwang/ww_seasonality_metagenomes/read_mapping/results/index"

# bowtie2-index output is the basename for .bt2 files 

for FILE in ${ASSEMBLY_DIR}/*/final.contigs.fa; do
    DIR_NAME=$(basename $(dirname $FILE))
    mkdir -p ${OUTPUT_DIR}/${DIR_NAME}
    bowtie2-build "$FILE" ${OUTPUT_DIR}/${DIR_NAME}/${DIR_NAME} -p 6 
done

echo "All done!" 