#!/usr/bin/env python3

import pandas as pd
from pathlib import Path

# merge on name, keep fraction_total_reads 
# merge 12 dataframes 
# fill in zero for NaNs

import argparse
parser = argparse.ArgumentParser()
parser.add_argument("rank", help="Taxonomic rank for Bracken to use. Options: Domain (D), Kingdom (K), Phylum (P), Class (C), Order (O), Family (F), Genus (G), Species (S)")
args = parser.parse_args()

work_dir = Path("/home/910904506/lwang/ww_seasonality_metagenomes/kraken")

df_list=[]

for file in work_dir.glob(f"*.{args.rank}.bracken"):
    df = pd.read_csv(file, sep='\t')
    samp_name = Path(file).with_suffix("").stem
    df = df[['name', 'fraction_total_reads']]
    df.set_index('name', inplace=True)
    df.rename(columns={'fraction_total_reads' : samp_name}, inplace=True)
    df_list.append(df)


merged_df = pd.concat(df_list, axis=1)
merged_df = merged_df.fillna(0)

merged_df.to_csv(f'bracken_{args.rank}_merged.tsv', sep='\t', index=True)
