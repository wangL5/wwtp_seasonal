#!/bin/bash
#SBATCH --job-name=run_tiger
#SBATCH --time=8:00:00
#SBATCH --mem=50G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=5
#SBATCH --partition=cpucluster
#SBATCH --output=slurm_tiger_%A.out

# running on high quality MAGs

# activate conda environment
eval "$(conda shell.bash hook)"
conda activate tiger

/Users/910904506/wwtp_seasons_assembly/checkm2/drep/gtdb/rep_mag_amr.txt


awk -F',' 'NR>1 {print $2,$1}' drep/data_tables/Cdb.csv | grep "^14_1" | while read cluster mag; do
    if echo $mag | grep -q "7_.*_23"; then
        season="dry"
    else
        season="wet"
    fi
    echo "=== $mag ($season) ==="
    grep "^${mag}" /Users/910904506/wwtp_seasons_assembly/checkm2/drep/gtdb/rep_mag_amr.txt | awk -F'\t' '{print $2, $3}'
done