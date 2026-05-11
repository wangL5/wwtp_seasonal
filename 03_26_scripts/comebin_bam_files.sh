#!/bin/bash

# April 2, 2026 
# generate bam files for comebin 
# gen_cov_file.sh won't take fastq.gz files, and require paired-end reads to end in _1.fastq and _2.fastq

# activate conda environment
eval "$(conda shell.bash hook)"
conda activate comebin_env

CBIN_DIR="/home/910904506/mamba/envs/comebin_env/bin/COMEBin/scripts"
CONTIG_FILE="/usr/data/archanand/lwang/ww_seasonality_metagenomes/read_mapping_multi/concatenated_1000.fa"
OUTPUT_BAM_DIR="/usr/data/archanand/lwang/ww_seasonality_metagenomes/read_mapping_multi/multi_bam"
READS_DIR="/home/910904506/lwang/ww_seasonality_metagenomes/nmdc_downloads"

bash ${CBIN_DIR}/gen_cov_file.sh -a ${CONTIG_FILE} \
-o ${OUTPUT_BAM_DIR} \
 ${READS_DIR}/*.fastq

echo "All done!"
