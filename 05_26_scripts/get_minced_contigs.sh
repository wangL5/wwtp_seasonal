#!/bin/bash

# Minced outputs: 
# Sequence 'k141_75212' (1790 bp)
# Sequence 'k141_76400' (607 bp)

# want for each minced output, the list of contigs 
# and then to pull those contigs out of the assembly files
# and make a new contig file per sample, of just the crispr spacers 

# activate conda environment
eval "$(conda shell.bash hook)"
conda activate misc_tools

MINCED_DIR="/Users/910904506/wwtp_seasons_assembly/spacerextractor/minced_out"
ASSEMBLY_DIR="/Users/910904506/wwtp_seasons_assembly/nmdc_assembly"
TMP_DIR="/Users/910904506/wwtp_seasons_assembly/spacerextractor/minced_out/tmp"
MINCED_SPACER_CONTIGS="/Users/910904506/wwtp_seasons_assembly/spacerextractor/minced_out/minced_spacer_contigs"

for FILE in ${MINCED_DIR}/*.minced.txt; do 
    SAMP_NAME=$(basename $FILE .minced.txt)
    grep "Sequence" $FILE | grep -oP "'\K[^']*(?=')" > ${TMP_DIR}/${SAMP_NAME}.contigs.txt

    seqtk subseq ${ASSEMBLY_DIR}/${SAMP_NAME}/final.contigs.fa \
        ${TMP_DIR}/${SAMP_NAME}.contigs.txt > \
        ${MINCED_SPACER_CONTIGS}/${SAMP_NAME}.minced.fa
done 

echo "All done!"
