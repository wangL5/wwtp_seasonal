#!/bin/bash

# run bracken to check on the virus/bacteria/archaea breakdown in the wwtp samples

WORK_DIR="/home/910904506/lwang/ww_seasonality_metagenomes/kraken"

for FILE in ${WORK_DIR}/Influent_*_L008/*_L008.kreport; do
    SAMP_NAME=$(basename $FILE .kreport)
    bracken -d $WORK_DIR \
        -i $FILE \
        -o ${WORK_DIR}/${SAMP_NAME}.domain.bracken \
        -r 150 \
        -l D
done 

echo "All done with bracken!"