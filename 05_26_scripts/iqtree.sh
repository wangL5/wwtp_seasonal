#!/bin/bash
#SBATCH --job-name=make_iqtree
#SBATCH --time=18:00:00
#SBATCH --mem=50G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=50
#SBATCH --partition=cpucluster
#SBATCH --output=slurm_make_iqtree_%A.out


# activate conda environment 
eval "$(conda shell.bash hook)" 
conda activate checkm2

# iqtree will use modelfinder to test the best model for the tree 

MSA_FILE="/Users/910904506/wwtp_seasons_assembly/checkm2/drep/gtdb/align/gtdbtk.bac120.user_msa.fasta.gz"

iqtree -s ${MSA_FILE} \
    -T $SLURM_CPUS_PER_TASK \
    -B 1000 \
    --prefix wwtp_iqtree

echo "All done!"
