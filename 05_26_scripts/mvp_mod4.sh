#!/bin/bash

# activate conda environment
eval "$(conda shell.bash hook)"
conda activate mvip

WORK_DIR="/Users/910904506/wwtp_seasons_assembly/mvp"
METADATA="/Users/910904506/wwtp_seasons_assembly/mvp/wwtp_metadata.txt"

mvip MVP_04_do_read_mapping -i $WORK_DIR -m $METADATA --delete_files

echo "All done!"
