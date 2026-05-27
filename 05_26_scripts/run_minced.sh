#!/bin/bash

# activate conda environment
eval "$(conda shell.bash hook)"
conda activate spacerextractor

ASSEMBLY_DIR="/Users/910904506/wwtp_seasons_assembly/nmdc_assembly"
OUT_DIR="/Users/910904506/wwtp_seasons_assembly/spacerextractor/minced_out"

for FILE in ${ASSEMBLY_DIR}/*/final.contigs.fa; do
    SAMP_NAME=$(basename $(dirname $FILE))
    minced ${FILE} ${OUT_DIR}/${SAMP_NAME}.minced.txt
done 

echo "All done!"