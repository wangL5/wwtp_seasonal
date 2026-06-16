#!/bin/bash
#SBATCH --job-name=anti-defense-finder
#SBATCH --time=18:00:00
#SBATCH --mem=50G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=40
#SBATCH --partition=cpucluster
#SBATCH --output=slurm_phage-anti-defense-finder_%A.out

# run defense finder's antidefensefinder on phage vOTUs 

# activate conda environment
eval "$(conda shell.bash hook)"
conda activate defensefinder

PHAGES="/Users/910904506/wwtp_seasons_assembly/mvp/03_CLUSTERING/MVP_03_All_Sample_Filtered_Relaxed_Representative_Virus_Provirus_Sequences.fna"
OUT_DIR="/Users/910904506/wwtp_seasons_assembly/mvp/antidefense"

defense-finder run ${PHAGES} \
    -o ${OUT_DIR} \
    -w $SLURM_CPUS_PER_TASK \
    --db-type unordered \
    --antidefensefinder 
    
echo "All done with defense finder and anti defense finder for phage representative clusters!"