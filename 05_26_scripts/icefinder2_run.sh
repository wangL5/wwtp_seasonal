#!/bin/bash
#SBATCH --job-name=run_icefinder_metag
#SBATCH --time=18:00:00
#SBATCH --mem=400G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20
#SBATCH --partition=cpucluster
#SBATCH --output=slurm_icefinder_%A.out

# run icefinder on WWTP seasonality metagenomes 

# activate conda environment
eval "$(conda shell.bash hook)"
conda activate icefinder2

ASSEMBLY_DIR="/Users/910904506/wwtp_seasons_assembly/nmdc_assembly"
RESULTS_DIR="/Users/910904506/wwtp_seasons_assembly/icefinder/icefinder2/result"


for FILE in ${ASSEMBLY_DIR}/*/final.contigs_1000.fa; do
    SAMP=$(basename $(dirname $FILE))
    mkdir -p ${RESULTS_DIR}/${SAMP}
    python ICEfinder2.py \
        -i ${FILE} \
        -t Metagenome
    mv ${RESULTS_DIR}/final.contigs_1000/* ${RESULTS_DIR}/${SAMP}
    rm -rf tmp/*
    echo "Done with $SAMP!"
done

echo “All done!”