#!/bin/bash

# replace .fa with .fna for MAGs so I can run MetaVF on them

BIN_DIR="/Users/910904506/wwtp_seasons_assembly/checkm2/good_bins_renamed"

for FILE in ${BIN_DIR}/*.fa; do
    SAMP_NAME=$(basename $FILE .fa)
    mv $FILE ${BIN_DIR}/${SAMP_NAME}.fna
done 