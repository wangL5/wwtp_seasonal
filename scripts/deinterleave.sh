#!/bin/bash

# run on 3/12/2026
# deinterleave fastq files using bbmap's reformat.sh
# these are the missing fastqs from CZID, found on NMDC in interleaved format

for FILE in *_R1_001.fastq.gz_*_R2_001.fastq.gz; do
    # get file names
    OUT1="${FILE%%_R1*}_R1_001.fastq.gz"
    OUT2="${FILE%%_R1*}_R2_001.fastq.gz"

    echo "Processing: $FILE"

    micromamba run -n bbtools reformat.sh \
    in="$FILE"
    out1="$OUT1"
    out2="$OUT2"

    echo "OUT1: $OUT1"
    echo "OUT2: $OUT2"
    echo "---"
done