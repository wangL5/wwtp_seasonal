#!/bin/bash

# takes genomad outputs and creates a table 
# eventually combines the genomad output data with ARG data 
# sample | contig | classification | ARG


touch mge_arg_contig_summary.txt
echo -e "SAMPLE\tCONTIG\tCLASSIFICATION" > mge_arg_contig_summary.txt

GENOMAD_DIR="/home/910904506/lwang/ww_seasonality_metagenomes/genomad/results"

for DIR in ${GENOMAD_DIR}/Influent_WWTP_*/; do
    SAMP_NAME=$(basename $DIR)

    awk -v sample="$SAMP_NAME" -v classification="virus" -v OFS="\t" 'NR>1 {print sample, $1, classification}'  \
    ${DIR}/final.contigs_summary/final.contigs_virus_summary.tsv >> mge_arg_contig_summary.txt

    awk -v sample="$SAMP_NAME" -v classification="plasmid" -v OFS="\t" 'NR>1 {print sample, $1, classification}' \
     ${DIR}/final.contigs_summary/final.contigs_plasmid_summary.tsv >> mge_arg_contig_summary.txt

done


echo "All Done!" 