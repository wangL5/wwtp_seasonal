#!/bin/bash
#SBATCH --job-name=run_card
#SBATCH --time=168:00:00
#SBATCH --mem=500G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=40
#SBATCH --partition=highmem
#SBATCH --output=slurm_card_%A.out

# activate conda environment
eval "$(conda shell.bash hook)"
conda activate rgi

BINS="/Users/910904506/wwtp_seasons_assembly/checkm2/good_bins"
OUT="/Users/910904506/wwtp_seasons_assembly/card_rgi"

# run card rgi 

for FILE in ${BINS}/*/*.fa; do
    SAMP_NAME=$(basename $(dirname $FILE))
    FASTA_NAME=$(basename $FILE .fa)
    mkdir -p ${OUT}/${SAMP_NAME}
    rgi main -i $FILE \
        -o ${OUT}/${SAMP_NAME}/${FASTA_NAME} \
        -t contig \
        -a BLAST \
        --low_quality \
        -n $SLURM_CPUS_PER_TASK
done

echo "All done with CARD RGI for wwtp seasonality bins!" 