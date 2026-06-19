#!/usr/bin/env python3

# this script combines RPKM and TPM outputs from coverM with an existing table 
# goal is to compare normalized abundance of contigs carrying multiple ARGs 

import pandas as pd
from pathlib import Path

# paths
coverm_dir = Path("/home/910904506/lwang/ww_seasonality_metagenomes/read_mapping/results/coverm")
arg_table = Path("/usr/data/archanand/lwang/ww_seasonality_metagenomes/summarize_mges/mge_arg_contig_summary_amr_sorted.txt")

# want to first get a concatenated coverm file of sample | contig | RPKM | TPM

"""
coverM header:
Contig\tInfluent_WWTP_7_31_23_MH4_S347_L008.sorted Length\tInfluent_WWTP_7_31_23_MH4_S347_L008.sorted Covered Bases\tInfluent_WWTP_7_31_23_MH4_S347_L008.sorted Covered Fraction\tInfluent_WWTP_7_31_23_MH4_S347_L008.sorted Read Count\tInfluent_WWTP_7_31_23_MH4_S347_L008.sorted Mean\tInfluent_WWTP_7_31_23_MH4_S347_L008.sorted RPKM\tInfluent_WWTP_7_31_23_MH4_S347_L008.sorted TPM
"""

df_list = []

for file in coverm_dir.glob("*.coverm"):
    df = pd.read_csv(file, sep="\t")
    samp_name = Path(file).stem
    df_new = df[['Contig', f'{samp_name}.sorted RPKM', f'{samp_name}.sorted TPM']].copy()
    df_new['SAMPLE'] = samp_name
    df_new.rename(columns={f'{samp_name}.sorted RPKM' : 'RPKM', f'{samp_name}.sorted TPM': 'TPM', 'Contig' : 'CONTIG'}, inplace=True)
    df_list.append(df_new)

merged_df = pd.concat(df_list, axis=0, ignore_index=True)
merged_df = merged_df.fillna(0)

merged_df.to_csv('samp_contig_coverM.tsv', sep='\t')

# then merge coverm with arg_table, on classication and contig 
# do a left merge with arg_table --> keep only what's in arg_table, not in the larger coverm file, though save that too 

# arg_table_df: SAMPLE | CONTIG | CLASSIFICATION | num_amr_genes
# want to merge on SAMPLE and CONTIG. Keep CLASSICATION and num_amr_genes 
# do not want extra lines from merged_df 

arg_table_df = pd.read_csv(arg_table, sep="\t")


merged_df_all = pd.merge(arg_table_df, merged_df, on=['SAMPLE', 'CONTIG'], how='left')

merged_df_all.to_csv('samp_contig_mge_coverM.tsv', sep='\t')