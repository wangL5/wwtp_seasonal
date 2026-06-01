#!/bin/bash
#SBATCH --job-name=drep_MAGs
#SBATCH --time=18:00:00
#SBATCH --mem=100G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=50
#SBATCH --partition=cpucluster
#SBATCH --output=slurm_drep_MAGs_%A.out

# activate conda environment
eval "$(conda shell.bash hook)"
conda activate checkm2

MAGS="/Users/910904506/wwtp_seasons_assembly/checkm2/good_bins_renamed"
DREP_OUTPUT="/Users/910904506/wwtp_seasons_assembly/checkm2/drep"
GENOME_INFO="/Users/910904506/wwtp_seasons_assembly/checkm2/checkM_info.csv"

dRep dereplicate --genomeInfo ${GENOME_INFO} \
                 -g ${MAGS}/*.fa \
                 -p $SLURM_CPUS_PER_TASK \
                 -sa 0.95 \
                 -comp 50 -con 10 \
                 ${DREP_OUTPUT}

echo "All done!"