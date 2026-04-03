#!/bin/bash

# run comebin on multi-sample bam files

# activate conda environment
eval "$(conda shell.bash hook)"
conda activate comebin_env

CONFIG_FILE=
OUTPUT_BINS=
BAM_DIR=

run_comebin.sh -a ${CONTIG_FILE} \
 -o ${OUTPUT_BINS} \
 -p ${BAM_DIR} \
 -t 6

 echo "All done!" 