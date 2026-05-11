#!/bin/bash
#SBATCH --job-name=run_eggnog_wwtp
#SBATCH --time=168:00:00
#SBATCH --mem=500G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=40
#SBATCH --partition=highmem
#SBATCH --output=slurm_eggnog_%A.out

# activate conda environment
eval "$(conda shell.bash hook)"
conda activate eggnog

# directories
ASSEMBLY_DIR="/Users/910904506/wwtp_seasons_assembly/nmdc_assembly"
OUT_DIR="/Users/910904506/wwtp_seasons_assembly/eggnog"

# run eggnog-mapper

for FILE in ${ASSEMBLY_DIR}/*/final.contigs.fa; do
    SAMP_NAME=$(basename $(dirname $FILE))
    emapper.py -m diamond \
    --dbmem \
    --itype metagenome \
    --genepred prodigal \
    -i $FILE \
    -o $SAMP_NAME \
    --output_dir $OUT_DIR
done 

echo "All done!"