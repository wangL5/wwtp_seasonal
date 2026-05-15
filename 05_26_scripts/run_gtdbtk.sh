#!/bin/bash
#SBATCH --job-name=run_gtdbtk
#SBATCH --time=168:00:00
#SBATCH --mem=500G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=40
#SBATCH --partition=highmem
#SBATCH --output=slurm_gtdbtk_%A.out

# activate conda environment
eval "$(conda shell.bash hook)"
conda activate gtdbtk-2.7.1 

GOOD_BINS="/Users/910904506/wwtp_seasons_assembly/checkm2/good_bins"
OUTPUT="/Users/910904506/wwtp_seasons_assembly/gtdb"

for DIR in ${GOOD_BINS}/*; do 
    SAMP_NAME=$(basename $DIR)
    gtdbtk classify_wf \
        -x .fa \
        --cpus $SLURM_CPUS_PER_TASK \
        --genome_dir $DIR \
        --out_dir ${OUTPUT}/${SAMP_NAME}
done

echo "All done with GTDB-Tk!"

