#!/usr/bin/env python3

import pandas as pd
from pathlib import Path

# merge on name, keep fraction_total_reads 
# merge 12 dataframes 
# fill in zero for NaNs

work_dir = Path("/home/910904506/lwang/ww_seasonality_metagenomes/kraken")

df_list=[]

for file in work_dir.glob("*.family.bracken"):
    df = pd.read_csv(file, sep='\t')
    samp_name = Path(file).with_suffix("").stem
    df = df[['name', 'fraction_total_reads']]
    df.set_index('name', inplace=True)
    df.rename(columns={'fraction_total_reads' : samp_name}, inplace=True)
    df_list.append(df)


merged_df = pd.concat(df_list, axis=1)
merged_df = merged_df.fillna(0)

merged_df.to_csv('bracken_family_merged.tsv', sep='\t', index=True)
