#!/bin/bash
#SBATCH --job-name=iphop_run
#SBATCH --time=18:00:00
#SBATCH --mem=50G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=10
#SBATCH --partition=cpucluster
#SBATCH --output=slurm_iphop_%A.out

# activate conda environment
eval "$(conda shell.bash hook)"
conda activate iphop




iphop predict --fa_file my_input_phages.fasta --db_dir path/to/iphop_db/Jun_2025_pub_rw/ --out_dir iphop_output/

/Users/910904506/wwtp_seasons_assembly/iphop/Jun_2025_pub_rw