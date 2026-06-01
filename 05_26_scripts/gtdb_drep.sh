#!/bin/bash
#SBATCH --job-name=gtdb-drep
#SBATCH --time=18:00:00
#SBATCH --mem=50G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=50
#SBATCH --partition=cpucluster
#SBATCH --output=slurm_gtdb-drep_%A.out

DREP_GENOMES="/Users/910904506/wwtp_seasons_assembly/checkm2/drep/dereplicated_genomes"
GTDB_OUT="/Users/910904506/wwtp_seasons_assembly/checkm2/drep/gtdb"

# activate conda environment
eval "$(conda shell.bash hook)"
conda activate gtdbtk-2.7.1

gtdbtk classify_wf \
    --genome_dir ${DREP_GENOMES} \
    --out_dir ${GTDB_OUT} \
    -x .fa \
    --cpus $SLURM_CPUS_PER_TASK

echo "All done with GTDB-tk on dereplicated MAGs!"