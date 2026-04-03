#!/bin/bash

# April 2, 2026
# using comebin's Filter_tooshort.py to keep only contigs >1000bp
# this is a step in multi-sample binning for comebin

# output: 

# activate conda environment
eval "$(conda shell.bash hook)"
conda activate comebin_env

CBIN_DIR="/home/910904506/mamba/envs/comebin_env/bin/COMEBin/scripts"
ASSEMBLY_DIR="/home/910904506/lwang/ww_seasonality_metagenomes/read_mapping_multi"

gunzip -k ${ASSEMBLY_DIR}/concatenated.fa.gz
python ${CBIN_DIR}/Filter_tooshort.py ${ASSEMBLY_DIR}/concatenated.fa 1000
rm ${ASSEMBLY_DIR}/concatenated.fa

echo "All done!" 