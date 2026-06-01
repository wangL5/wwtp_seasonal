#!/bin/bash

# grab CARD RGI information for ALL medium/high quality MAGs 
# apply this to the dereplicated MAGs and ultimately the phylogenetic tree

# MAG names are: Influent_WWTP_7_31_23_MH4_S347_L008_0.fa
# dereplicated genomes: Influent_WWTP_7_24_23_MH4_S358_L008_500.fa


RGI_OUTPUT="/Users/910904506/wwtp_seasons_assembly/card_rgi"
# clusters and the representative genome
WDB="/Users/910904506/wwtp_seasons_assembly/checkm2/drep/data_tables/Wdb.csv"
# all MAGs and their clusters 
CDB="/Users/910904506/wwtp_seasons_assembly/checkm2/drep/data_tables/Cdb.csv"

echo -e "MAG\tBest_Hit_ARO\tDrug_Class\tResistance_Mechanism\tAMR_Gene_Family\tRepresentative" > rep_mag_amr.txt

for FILE in ${RGI_OUTPUT}/*/*.txt; do
    MAG=$(basename $FILE .txt)
    SAMPLE=$(basename $(dirname $FILE))
    MAG_NAME=${SAMPLE}_${MAG}.fa

    CLUSTER=$(awk -F',' -v mag="$MAG_NAME" '$1 == mag {print $2}' $CDB)

    REP=$(awk -F',' -v clust="$CLUSTER" '$2 == clust {print $1}' $WDB)

    # skip header and extract AMR info
    tail -n +2 $FILE | awk -F'\t' -v mag="$MAG_NAME" -v rep="$REP" \
        '{print mag"\t"$9"\t"$15"\t"$16"\t"$17"\t"rep}' >> rep_mag_amr.txt
done

echo "All done!"
