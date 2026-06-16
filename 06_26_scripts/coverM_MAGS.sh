#!/bin/bash
#SBATCH --job-name=drep_MAGS_coverM
#SBATCH --time=18:00:00
#SBATCH --mem=50G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=20
#SBATCH --partition=cpucluster
#SBATCH --output=slurm_coverm_drep_MAGs_%A.out


### GOAL: RUN COVERM ON DEREPLICATED MAGS 

# activate conda environment
eval "$(conda shell.bash hook)"
conda activate read_mapping

### BUILD BOWTIE2 INDICES ###

DREP_MAGS="/Users/910904506/wwtp_seasons_assembly/checkm2/drep/dereplicated_genomes"
OUTPUT_DIR="/Users/910904506/wwtp_seasons_assembly/checkm2/drep/drep_readmapping/index"

# bowtie2-index output is the basename for .bt2 files, and each directory will contain 6 index files 

for FILE in ${DREP_MAGS}/*.fa; do
    MAG_NAME=$(basename $FILE .fa)
    mkdir -p ${OUTPUT_DIR}/${MAG_NAME}
    bowtie2-build "$FILE" ${OUTPUT_DIR}/${MAG_NAME}/${MAG_NAME} -p $SLURM_CPUS_PER_TASK
done

echo "All done with bowtie2 build."

### RUN BOWTIE2 ALIGN, SORT BAM FILES, AND COVERM COVERAGE CALCULATION ###

INDEX_DIR="/Users/910904506/wwtp_seasons_assembly/checkm2/drep/drep_readmapping/index"
READS_DIR="/Users/910904506/wwtp_seasons"
BAM_DIR="/Users/910904506/wwtp_seasons_assembly/checkm2/drep/drep_readmapping/bam"
COVERM="/Users/910904506/wwtp_seasons_assembly/checkm2/drep/drep_readmapping/coverm"

# bowtie2-index output is the basename for .bt2 files 

### reads file name format 
# Influent_WWTP_7_31_23_MH4_S347_L008_R1_001.fastp.bbmap.fastq.gz
# Influent_WWTP_7_31_23_MH4_S347_L008_R2_001.fastp.bbmap.fastq.gz

### index basename example
# Influent_WWTP_7_17_23_MH4_S350_L008_10153

for SAMP in ${INDEX_DIR}/*; do

    SAMP_NAME=$(basename $SAMP)
    READ_NAME=${SAMP_NAME%_*}
    
    bowtie2 -x ${INDEX_DIR}/${SAMP_NAME}/${SAMP_NAME} \
    -1 ${READS_DIR}/${READ_NAME}_R1_001.fastp.bbmap.fastq.gz \
    -2 ${READS_DIR}/${READ_NAME}_R2_001.fastp.bbmap.fastq.gz -p $SLURM_CPUS_PER_TASK | samtools sort -o ${BAM_DIR}/${SAMP_NAME}.sorted.bam 

    coverm contig -b ${BAM_DIR}/${SAMP_NAME}.sorted.bam \
    -m length covered_bases covered_fraction count mean rpkm tpm \
    -t $SLURM_CPUS_PER_TASK > ${COVERM}/${SAMP_NAME}.coverm
   
done

echo "All done!" 