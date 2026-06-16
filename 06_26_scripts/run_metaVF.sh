#!/bin/bash
#SBATCH --job-name=MetaVF_on_MAGs
#SBATCH --time=18:00:00
#SBATCH --mem=500G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=40
#SBATCH --partition=cpucluster
#SBATCH --output=slurm_MetaVF_on_MAGs_%A.out

# running MetaVF to find virulence factors in bacterial MAGs

# activate conda environment
eval "$(conda shell.bash hook)"
conda activate MetaVF_toolkit

METAVF_DIR="/Users/910904506/wwtp_seasons_assembly/MetaVF_toolkit"
OUT_DIR="/Users/910904506/wwtp_seasons_assembly/MetaVF_toolkit/wwtp_out"
MAG_BINS="/Users/910904506/wwtp_seasons_assembly/checkm2/good_bins_renamed"

# run the below for draft genomes 

python ${METAVF_DIR}/metaVF.py -p ${METAVF_DIR} -pjn metaVF_on_MAGs -id ${MAG_BINS} -outd ${OUT_DIR} -m draft -c $SLURM_CPUS_PER_TASK -ti 90 -tc 80

#attention: the file should ends with ".fna"

#for pair-end short reads, please run 

#metaVF.py -p /path/to/MetaVF_toolkit -pjn PE_test -id /path/to/MetaVF_toolkit/example_data/data -o 
#/path/to/MetaVF_toolkit/example_data/test_PE -m PE -c 10

#attention: the file should ends with ".fastq.gz"

#the output files are located in /path/to/MetaVF_toolkit/example_data/result_test.