#!/bin/bash

GTDB_OUTPUT="/Users/910904506/wwtp_seasons_assembly/checkm2/drep/gtdb/classify/gtdbtk.bac120.summary.tsv"
OUTFILE="gtdb_taxonomy.txt"

awk 'BEGIN {
    OFS="\t";
    print "Genome","Domain","Phylum","Class","Order","Family","Genus","Species"
}
NR > 1 {
    split($2, a, ";");

    gsub("d__", "", a[1]);
    gsub("p__", "", a[2]);
    gsub("c__", "", a[3]);
    gsub("o__", "", a[4]);
    gsub("f__", "", a[5]);
    gsub("g__", "", a[6]);
    gsub("s__", "", a[7]);

    print $1, a[1], a[2], a[3], a[4], a[5], a[6], a[7];
}' "$GTDB_OUTPUT" > "$OUTFILE"