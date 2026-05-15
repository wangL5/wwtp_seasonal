#!/bin/bash
#SBATCH --job-name=defense-finder
#SBATCH --time=18:00:00
#SBATCH --mem=50G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=40
#SBATCH --partition=cpucluster
#SBATCH --output=slurm_defense-finder_%A.out

# activate conda environment
eval "$(conda shell.bash hook)"
conda activate defensefinder

ASSEMBLY_DIR="/Users/910904506/wwtp_seasons_assembly/nmdc_assembly"
OUT_DIR="/Users/910904506/wwtp_seasons_assembly/defense-finder/assemblies"

for ASSEMBLY in ${ASSEMBLY_DIR}/*/final.contigs_1000.fa; do
    SAMP_NAME=$(basename $(dirname $ASSEMBLY))

    defense-finder run ${ASSEMBLY} \
        -o ${OUT_DIR}/${SAMP_NAME} \
        -w $SLURM_CPUS_PER_TASK \
        --db-type unordered \
        --antidefensefinder 
    
    echo "Done with $SAMP_NAME!"
done

echo "All done!"