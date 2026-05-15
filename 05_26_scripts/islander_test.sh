#!/bin/bash
#SBATCH --job-name=run_islander
#SBATCH --time=8:00:00
#SBATCH --mem=50G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=5
#SBATCH --partition=cpucluster
#SBATCH --output=slurm_islander_%A.out

# run tiger/islander
# islander and tiger both default assumes you have contigs instead of complete genomes 
# since these are med/high quality mags, I'm leaving them as contigs 

# activate conda environment
eval "$(conda shell.bash hook)"
conda activate tiger

WORK_DIR="/Users/910904506/wwtp_seasons_assembly/tiger_islander/Influent_WWTP_1_24_24_MH2_S478_L008"
TIGER_BIN="/Users/910904506/wwtp_seasons_assembly/tiger_islander/TIGER/bin"

cd ${WORK_DIR}
${TIGER_BIN}/islander.pl \
    -verbose \
    -outDir ${WORK_DIR} \
    -tax B \
    -gencode 11 \
    -cpu $SLURM_CPUS_PER_TASK \
    1036.fa

echo "All done with Islander!"