#!/bin/bash

# April 2, 2026
# using semibin's concatenate fasta on my individual wwtp assemblies 
# this is a step in multi-sample binning using comebin
# Concatenated contigs written to /home/910904506/lwang/ww_seasonality_metagenomes/read_mapping_multi/concatenated.fa.gz

ASSEMBLY_DIR="/usr/data/archanand/lwang/ww_seasonality_metagenomes/nmdc_assembly/renamed_assemblies"
OUTPUT_DIR="/home/910904506/lwang/ww_seasonality_metagenomes/read_mapping_multi"

# activate conda environment
eval "$(conda shell.bash hook)"
conda activate semibin_env

SemiBin2 concatenate_fasta \
--input-fasta $(ls ${ASSEMBLY_DIR}/* | tr '\n' ' ') \
--output ${OUTPUT_DIR}

echo "All Done!"