#!/bin/bash

# >> Checking report file: /home/910904506/lwang/ww_seasonality_metagenomes/kraken/Influent_WWTP_7_31_23_MH4_S347_L008/Influent_WWTP_7_31_23_MH4_S347_L008.kreport
# Error: no reads found. Please check your Kraken report
# use krakenuniq mamba env 

# paths 
KRAKEN_DB="/usr/data/archanand/lwang/ww_seasonality_metagenomes/kraken"
WWTP_READS="/home/910904506/lwang/snakemake/qc/results/nmdc_downloads/bbmap"
WWTP_ASSEMBLY="/home/910904506/lwang/ww_seasonality_metagenomes/nmdc_assembly"
OUTPUT_DIR="/home/910904506/lwang/ww_seasonality_metagenomes/kraken"

# run krakenuniq
# mamba env: krakenuniq

# for WWTP seasonality:

# Influent_WWTP_7_31_23_MH4_S347_L008_R2_001.fastq.gz
# Influent_WWTP_7_31_23_MH4_S347_L008_R1_001.fastq.gz
# Influent_WWTP_2_1_24_MH3_S346_L008

for FILE in ${WWTP_ASSEMBLY}/Influent_WWTP_7_31_23_MH4_S347_L008/final.contigs.fa; do
    SAMP_NAME=$(basename $(dirname $FILE))
    mkdir -p ${OUTPUT_DIR}/${SAMP_NAME}
    krakenuniq --db ${KRAKEN_DB} \
        --threads 6 \
        --report ${OUTPUT_DIR}/${SAMP_NAME}/${SAMP_NAME}.kreport \
        --unclassified-out ${OUTPUT_DIR}/${SAMP_NAME}/${SAMP_NAME}.unclassified \
        --classified-out ${OUTPUT_DIR}/${SAMP_NAME}/${SAMP_NAME}.classified \
        --output ${OUTPUT_DIR}/${SAMP_NAME}/${SAMP_NAME}.output \
        --preload-size 50G \
        --paired \
        --check-names \
        ${WWTP_READS}/${SAMP_NAME}_R1_001.fastp.bbmap.fastq.gz \
        ${WWTP_READS}/${SAMP_NAME}_R2_001.fastp.bbmap.fastq.gz &> ${OUTPUT_DIR}/${SAMP_NAME}/kraken.log
done

echo "All done with kraken!"

# run bracken
# -t threshold. default 10 reads 
# -l is level classification. so S (species), K (kingdom level), P (phylum), C (class), O (order), F (family), and G (genus)
# r is read length

WORK_DIR="/home/910904506/lwang/ww_seasonality_metagenomes/kraken"

for FILE in ${WORK_DIR}/Influent_WWTP_7_31_23_MH4_S347_L008/*_L008.kreport; do
    SAMP_NAME=$(basename $FILE .kreport)
    bracken -d $WORK_DIR \
        -i $FILE \
        -o ${WORK_DIR}/${SAMP_NAME}.genus.bracken \
        -r 150 \
        -l G
    bracken -d $WORK_DIR \
        -i $FILE \
        -o ${WORK_DIR}/${SAMP_NAME}.family.bracken \
        -r 150 \
        -l F
done 

echo "All done with bracken!"

