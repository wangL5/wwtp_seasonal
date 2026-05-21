#!/bin/bash

ASSEMBLY_DIR="/Users/910904506/wwtp_seasons_assembly/nmdc_assembly"
READS_DIR="/Users/910904506/wwtp_seasons"
WORK_DIR="/Users/910904506/wwtp_seasons_assembly/mvp"

# make metadata table for MVP phage pipeline

# samp name: Influent_WWTP_7_17_23_MH3_S351_L008
# assembly path: /nmdc_assembly/Influent_WWTP_1_24_24_MH1_S480_L008/final.contigs.fa
# read name: Influent_WWTP_7_31_23_MH1_S475_L008_R1_001.fastp.bbmap.fastq.gz

cd ${WORK_DIR}

echo -e "Sample_number\tSample\tAssembly_Path\tRead_Path" > wwtp_metadata.txt

for FILE in ${ASSEMBLY_DIR}/*/final.contigs.fa; do 
    SAMP_NAME=$(basename $(dirname $FILE))
    
    if [[ $SAMP_NAME == *WWTP_7* ]]; then
        SAMP_NUM=2
    else
        SAMP_NUM=1
    fi
    
    ASSEMBLY_PATH=${FILE}

    READ_PATH=${READS_DIR}/${SAMP_NAME}_R1_001.fastp.bbmap.fastq.gz

    echo -e "$SAMP_NUM\t$SAMP_NAME\t$ASSEMBLY_PATH\t$READ_PATH" >> wwtp_metadata.txt 
done 

echo "All done!"
    



