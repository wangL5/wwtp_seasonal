#!/bin/bash

# get genome_name, completeness, and contamination

GOODBINS="/Users/910904506/wwtp_seasons_assembly/checkm2/good_bins"
CHECKM2_OUT="/Users/910904506/wwtp_seasons_assembly/checkm2"
GOODBINS_RENAMED="/Users/910904506/wwtp_seasons_assembly/checkm2/good_bins_renamed"

echo -e "genome,completeness,contamination" > checkM_info.csv

for FASTA in ${GOODBINS}/*/*.fa; do
    SAMP_NAME=$(basename $(dirname $FASTA))
    genome=$(basename $FASTA .fa)

    completeness=$(awk -F'\t' -v g="${genome}" '$1 == g {print $2}' ${CHECKM2_OUT}/${SAMP_NAME}/quality_report.tsv)
    contamination=$(awk -F'\t' -v g="${genome}" '$1 == g {print $3}' ${CHECKM2_OUT}/${SAMP_NAME}/quality_report.tsv)

    echo -e "${SAMP_NAME}_${genome}.fa,${completeness},${contamination}" >> checkM_info.csv

    cp $FASTA ${GOODBINS_RENAMED}/${SAMP_NAME}_${genome}.fa
done

echo "All done!"