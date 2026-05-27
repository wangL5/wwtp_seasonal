#!/bin/bash

# activate conda environment
eval "$(conda shell.bash hook)"
conda activate spacerextractor

spacerextractor extract_spacers \
 -d SE_Db_r214GBIMG_0.9/ \
 -o SE_example_results/ \
 -f Test_package/Example_reads.fastq.gz \
 -t 4


 echo "All done!"