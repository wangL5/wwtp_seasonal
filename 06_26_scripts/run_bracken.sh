#!/bin/bash
#SBATCH --job-name=run_bracken
#SBATCH --time=18:00:00
#SBATCH --mem=50G
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=5
#SBATCH --partition=cpucluster
#SBATCH --output=slurm_run_bracken_%A.out

# activate conda environment
eval "$(conda shell.bash hook)"
conda activate  krakenuniq

# use bracken database included in the krakenuniq download

# run bracken
# -t threshold. default 10 reads 
# -l is level classification. so S (species), K (kingdom level), P (phylum), C (class), O (order), F (family), and G (genus)
# r is read length

WORK_DIR="/home/910904506/lwang/suisun_kraken"
KRAKEN_DIR="/home/910904506/lwang/ww_seasonality_metagenomes/kraken"

for FILE in ${WORK_DIR}/*/*.kreport; do
    SAMP_NAME=$(basename $FILE .kreport)
    bracken -d $KRAKEN_DIR \
        -i $FILE \
        -o ${WORK_DIR}/${SAMP_NAME}/${SAMP_NAME}.family.bracken \
        -r 150 \
        -l F
    bracken -d $KRAKEN_DIR \
        -i $FILE \
        -o ${WORK_DIR}/${SAMP_NAME}/${SAMP_NAME}.genus.bracken \
        -r 150 \
        -l S
done 

echo "All done!"