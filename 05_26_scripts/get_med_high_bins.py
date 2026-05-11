#!/usr/bin/env python3

import pandas as pd 
from pathlib import Path
import shutil

checkm2_outputs = Path("/Users/910904506/wwtp_seasons_assembly/checkm2")
all_bins = Path("/Users/910904506/wwtp_seasons_assembly/comebin/results")
good_bins = Path("/Users/910904506/wwtp_seasons_assembly/checkm2/good_bins")

# grab medium and high quality bins from checkM2 results:

for file in checkm2_outputs.glob("*/quality_report.tsv"):
    samp_name = file.parent.name
    full_dir_path = good_bins.joinpath(samp_name)
    full_dir_path.mkdir(exist_ok=True)
    df = pd.read_csv(file, sep='\t')
    filtered_df = df[(df['Completeness'] > 50) & (df['Contamination'] < 10)]

    for name in filtered_df['Name']:
        med_high_bin = all_bins / samp_name / "comebin_res" / "comebin_res_bins"/ f'{name}.fa'
        med_high_bin_dest = good_bins / samp_name
        shutil.copy(med_high_bin, med_high_bin_dest)

print("Done!")
