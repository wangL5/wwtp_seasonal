#!/bin/bash
#SBATCH --job-name=run_icefinder_troubleshoot
#SBATCH --time=18:00:00
#SBATCH --mem=400G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20
#SBATCH --partition=cpucluster
#SBATCH --output=slurm_icefinder_troubleshoot_%A.out

# run icefinder on WWTP seasonality metagenomes 

# activate conda environment
eval "$(conda shell.bash hook)"
conda activate icefinder2

ASSEMBLY_DIR="/Users/910904506/wwtp_seasons_assembly/nmdc_assembly"
RESULTS_DIR="/Users/910904506/wwtp_seasons_assembly/icefinder/icefinder2/result"

python ICEfinder2.py \
    -i ${ASSEMBLY_DIR}/Influent_WWTP_1_24_24_MH2_S478_L008/final.contigs_1000.fa \
    -t Metagenome

echo “All done!”