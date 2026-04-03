#!/bin/bash

# April 2, 2026
# need to rename megahit or metaspades assemblies using the directory name
# problem is the megahit/metaspades assemblies are all in directories with the sample names
# while the assembly names all have the same times (i.e. final.contigs.fa)

ASSEMBLY_DIR="/usr/data/archanand/lwang/ww_seasonality_metagenomes/nmdc_assembly"
OUTPUT_DIR="/home/910904506/lwang/ww_seasonality_metagenomes/nmdc_assembly"
mkdir -p ${OUTPUT_DIR}/renamed_assemblies

for FILE in ${ASSEMBLY_DIR}/*/final.contigs.fa; do
    SAMP_NAME=$(basename $(dirname $FILE))
    cp $FILE ${OUTPUT_DIR}/renamed_assemblies/${SAMP_NAME}.fa
done

echo "All done!"