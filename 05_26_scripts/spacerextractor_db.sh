#!/bin/bash
#SBATCH --job-name=spacerextractor_db
#SBATCH --time=18:00:00
#SBATCH --mem=50G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=50
#SBATCH --partition=cpucluster
#SBATCH --output=slurm_spacerextractor_db_%A.out

# activate conda environment
eval "$(conda shell.bash hook)"
conda activate spacerextractor

IMG_PR_FNA="/Users/910904506/wwtp_seasons_assembly/spacerextractor/Cus_PR/IMG_VR_2023-08-08_1/IMGPR_nucl.fna"
IMG_VR_FNA="/Users/910904506/wwtp_seasons_assembly/spacerextractor/Cus_VR/IMG_VR_2022-12-19_7.1/IMGVR_all_nucleotides-high_confidence.fna"
WORKDIR="/Users/910904506/wwtp_seasons_assembly/spacerextractor"
MAP_TO_PR_OUT="/Users/910904506/wwtp_seasons_assembly/spacerextractor/map_to_pr_out"
MAP_TO_VR_OUT="/Users/910904506/wwtp_seasons_assembly/spacerextractor/map_to_vr_out"
SPACEREXTRACTOR_OUT="/Users/910904506/wwtp_seasons_assembly/spacerextractor/wwtp_out"

# prep plasmid db 
spacerextractor create_target_db \
    -i ${IMG_PR_FNA} \
    -d ${WORKDIR}/plasmid_targets_db \
     -t $SLURM_CPUS_PER_TASK \
     --replace_spaces

# prep virus db 
spacerextractor create_target_db \
    -i ${IMG_VR_FNA} \
    -d ${WORKDIR}/viral_targets_db \
     -t $SLURM_CPUS_PER_TASK \
     --replace_spaces

# map to plasmid db 
for FILE in ${SPACEREXTRACTOR_OUT}/*/Final_spacers.nr.denoised.hq.fna; do 
    SAMP_NAME=$(basename $(dirname $FILE))
    mkdir -p ${MAP_TO_PR_OUT}/${SAMP_NAME}
    mkdir -p ${MAP_TO_VR_OUT}/${SAMP_NAME}

    spacerextractor map_to_target \
        -i $FILE \
        -d ${WORKDIR}/plasmid_targets_db \
        -o ${MAP_TO_PR_OUT}/${SAMP_NAME} \
        -t $SLURM_CPUS_PER_TASK

    spacerextractor map_to_target \
        -i $FILE \
        -d ${WORKDIR}/viral_targets_db \
        -o ${MAP_TO_VR_OUT}/${SAMP_NAME} \
        -t $SLURM_CPUS_PER_TASK
done

echo "All done!"