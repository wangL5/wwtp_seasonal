#!/bin/bash
#SBATCH --job-name=defense-finder
#SBATCH --time=8:00:00
#SBATCH --mem=50G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20
#SBATCH --partition=cpucluster
#SBATCH --output=slurm_defense-finder_%A.out

# activate conda environment
eval "$(conda shell.bash hook)"
conda activate defensefinder

MAG_DIR="/Users/910904506/wwtp_seasons_assembly/checkm2/good_bins"
OUT_DIR="/Users/910904506/wwtp_seasons_assembly/defense-finder"

for MAG in ${MAG_DIR}/*/*.fa; do
    SAMP_NAME=$(basename $(dirname $MAG))
    MAG_NAME=$(basename $MAG .fa)

    mkdir -p ${OUT_DIR}/${SAMP_NAME}

    defense-finder run ${MAG} \
        -o ${OUT_DIR}/${SAMP_NAME}/${MAG_NAME} \
        -w $SLURM_CPUS_PER_TASK \
        --db-type unordered \
        --antidefensefinder 
done

echo "All done!"