#!/bin/bash

# activate conda environment
eval "$(conda shell.bash hook)"
conda activate mvip

WORK_DIR="/Users/910904506/wwtp_seasons_assembly/mvp"
METADATA="/Users/910904506/wwtp_seasons_assembly/mvp/wwtp_metadata.txt"

mvip mvip MVP_06_do_functional_annotation -i $WORK_DIR -m $METADATA

echo "All done!"
