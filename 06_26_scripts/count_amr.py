#!/usr/bin/env python3

import os
import pandas as pd

# this script adds arg counts to the mge_arg_contig_summary.txt file 
# counts args per contig x sample (could have multiple genes per contig)
# this will tell you how many AMR genes on 1 contig, and if those were plasmid, virus, or chromosome 

# directories 
rgi_dir = "/home/910904506/lwang/ww_seasonality_metagenomes/card/results"
summary_file = "/home/910904506/lwang/ww_seasonality_metagenomes/summarize_mges/mge_arg_contig_summary.txt"
output_file = "/home/910904506/lwang/ww_seasonality_metagenomes/summarize_mges/mge_arg_contig_summary_amr.txt"

# concatenate all CARD RGI annotated samples and contigs 
dfs = []
for fname in os.listdir(rgi_dir):
    if not fname.endswith(".txt"):
        continue
    sample = fname.replace(".txt", "")
    df = pd.read_csv(os.path.join(rgi_dir, fname), sep="\t", usecols=["Contig"])
    df["SAMPLE"] = sample
    dfs.append(df)

rgi = pd.concat(dfs)

# count AMR genes by grouping by sample, contig
amr_counts = rgi.groupby(["SAMPLE", "Contig"]).size().reset_index(name="num_amr_genes")
amr_counts = amr_counts.rename(columns={"Contig": "CONTIG"})

# outer merge with summary file, generated previously
summary = pd.read_csv(summary_file, sep="\t")
merged = summary.merge(amr_counts, on=["SAMPLE", "CONTIG"], how="outer") 

# fill in missing in NAs
merged["num_amr_genes"] = merged["num_amr_genes"].fillna(0).astype(int)
merged["CLASSIFICATION"] = merged["CLASSIFICATION"].fillna("chromosome")

merged.to_csv(output_file, sep="\t", index=False)
print("Done! Output written to", output_file)