#!/usr/bin/env python3

# normalize ARG abundance by rpoB abundance across samples
# analyzing by element type (plasmid, virus, chromosome), and season (wet, dry)

"""
normalization formula

(sum_i N_i_ARG / L_ARG) / (sum_i N_i_rpoB / L_i_rpoB)

N_i_ARG  = reads mapping to contig i carrying ARG
L_ARG    = CARD reference length (aa * 3)
N_i_rpoB = reads mapping to contig i carrying rpoB
L_i_rpoB = rpoB reference protein length * 3

"""

import os
import re
import glob
import pandas as pd
from Bio import SeqIO

# paths 
RGI_DIR = "/usr/data/archanand/lwang/ww_seasonality_metagenomes/card/results"
COVERM_DIR = "/usr/data/archanand/lwang/ww_seasonality_metagenomes/read_mapping/results/coverm"
RPOB_DIR = "/usr/data/archanand/lwang/ww_seasonality_metagenomes/card/assembly_rpob"
RPOB_REF = "/usr/data/archanand/lwang/ww_seasonality_metagenomes/card/RpoB.ref.fasta"
GENOMAD_FILE = "/usr/data/archanand/lwang/ww_seasonality_metagenomes/summarize_mges/mge_arg_contig_summary.txt"
OUT_DIR = "/home/910904506/lwang/ww_seasonality_metagenomes/summarize_mges"

os.makedirs(OUT_DIR, exist_ok=True)

# get season from sample name 
def get_season(sample_name):
    # example sample name: Influent_WWTP_7_10_23_MH1_S357_L008
    # month 7 = dry, months 1 or 2 = wet

    match = re.search(r'WWTP_(\d+)_', sample_name)
    if match:
        month = int(match.group(1))
        return "dry" if month == 7 else "wet"
    return "unknown"

# grab rpoB reference seqs and lengths 
rpob_ref_lengths = {}
for record in SeqIO.parse(RPOB_REF, "fasta"):
    # multiply by 3 for nucleotides
    rpob_ref_lengths[record.id] = len(record.seq) * 3

print(f"Loaded {len(rpob_ref_lengths)} rpoB reference sequences") 

# load in genomad classifications 
genomad = pd.read_csv(GENOMAD_FILE, sep="\t", header=0)
genomad.columns = [c.strip().lower() for c in genomad.columns]
genomad_dict = {
    (row.sample, row.contig): row.classification
    for row in genomad.itertuples()
}

# if the sample/contig combo is not in the genomad_dict for plasmid/virus, return chromosome
def get_classification(sample, contig):
    return genomad_dict.get((sample, contig), "chromosome")

# process the samples 
all_results = []

rgi_files = glob.glob(os.path.join(RGI_DIR, "*.txt"))

# get CARD RGI output for each sample
for rgi_path in sorted(rgi_files):
    sample = os.path.basename(rgi_path).replace(".txt", "")
    season = get_season(sample)
    print(f"  {sample} ({season})")

    try:
        rgi = pd.read_csv(rgi_path, sep="\t", header=0, low_memory=False)
    except Exception as e:
        print(f"WARNING: Could not load RGI file: {e}")
        continue

    # skip if empty
    if rgi.empty:
        print(f"WARNING: Empty RGI file, skipping")
        continue

    # get ARG reference length from CARD protein sequence
    rgi["ARG_ref_length"] = rgi["CARD_Protein_Sequence"].apply(
        lambda x: len(str(x)) * 3 if pd.notna(x) else None
    )

    # add MGE type to rgi dataframe 
    # Example contig name: k141_76318
    rgi["classification"] = rgi["Contig"].apply(
        lambda c: get_classification(sample, c)
    )

    # load coverM coverage data for that sample 
    coverm_path = os.path.join(COVERM_DIR, f"{sample}.coverm")
    try:
        coverm = pd.read_csv(coverm_path, sep="\t", header=0)
        # Rename cols: col 0 = contig, col 4 = read_count
        cols = list(coverm.columns)
        rename_map = {cols[0]: "contig", cols[4]: "read_count"}
        coverm = coverm.rename(columns=rename_map)[["contig", "read_count"]]
    except Exception as e:
        print(f"WARNING: Could not load CoverM file: {e}")
        continue

    # load in rpoB diamond output for that sample 
    rpob_path = os.path.join(RPOB_DIR, f"{sample}.assembly.rpob.tsv")
    try:
        rpob = pd.read_csv(rpob_path, sep="\t", header=None, names=[
            "contig", "ref", "pident", "length", "mismatch", "gapopen",
            "qstart", "qend", "sstart", "send", "evalue", "bitscore"
        ])
        # get top hit per contig (highest bitscore)
        rpob_top = rpob.sort_values("bitscore", ascending=False)\
                       .groupby("contig").first().reset_index()

        # Look up rpoB reference length
        rpob_top["rpob_ref_length"] = rpob_top["ref"].map(rpob_ref_lengths)

        # Warn if any refs not found
        missing = rpob_top["rpob_ref_length"].isna().sum()
        if missing > 0:
            print(f"WARNING: {missing} rpoB reference lengths not found")

        # Merge with read counts
        rpob_top = rpob_top.merge(coverm, on="contig", how="left")

        # get rpoB denominator: sum(N_i_rpoB / L_i_rpoB)
        rpob_top = rpob_top.dropna(subset=["rpob_ref_length", "read_count"])
        if rpob_top.empty:
            print("WARNING: No valid rpoB hits, skipping")
            continue

        rpob_denominator = (rpob_top["read_count"] / rpob_top["rpob_ref_length"]).sum()

    except Exception as e:
        print(f"WARNING: Could not load rpoB file: {e}")
        continue

    if rpob_denominator == 0:
        print("WARNING: rpoB denominator is 0, skipping")
        continue

    # merge CARD RGI with read counts
    rgi = rgi.merge(coverm, left_on="Contig", right_on="contig", how="left")

    # get per-ARG-type normalized abundance
    # group by ARG type (Best_Hit_ARO), Drug Class, AMR Gene Family, classification
    rgi = rgi.dropna(subset=["ARG_ref_length", "read_count"])

    # for each row get read_count / ARG_ref_length
    rgi["normalized_count"] = rgi["read_count"] / rgi["ARG_ref_length"]

    # sum across contigs carrying same ARG type + classification
    grouped = rgi.groupby([
        "Best_Hit_ARO",
        "Drug Class",
        "AMR Gene Family",
        "classification"
    ])["normalized_count"].sum().reset_index()

    # Normalize by rpoB denominator
    grouped["abundance"] = grouped["normalized_count"] / rpob_denominator

    # Add metadata
    grouped["sample"] = sample
    grouped["season"] = season

    all_results.append(grouped)

# combine all the results 
results = pd.concat(all_results, ignore_index=True)

#  save outputs

# full results table
out_full = os.path.join(OUT_DIR, "arg_abundance_full.tsv")
results.to_csv(out_full, sep="\t", index=False)
print(f"Saved full results to {out_full}")

# mean abundance per ARG type x drug class x classification x season
summary = results.groupby([
    "Best_Hit_ARO",
    "Drug Class",
    "AMR Gene Family",
    "classification",
    "season"
])["abundance"].agg(["mean", "median", "std", "count"]).reset_index()

out_summary = os.path.join(OUT_DIR, "arg_abundance_summary.tsv")
summary.to_csv(out_summary, sep="\t", index=False)
print(f"Saved summary to {out_summary}")

# heatmap table: drug class x (season x classification) MEAN abundance
heatmap_data = results.groupby([
    "Drug Class",
    "season",
    "classification"
])["abundance"].mean().reset_index()

heatmap_pivot = heatmap_data.pivot_table(
    index="Drug Class",
    columns=["season", "classification"],
    values="abundance",
    fill_value=0
)

out_heatmap = os.path.join(OUT_DIR, "arg_abundance_heatmap.tsv")
heatmap_pivot.to_csv(out_heatmap, sep="\t")
print(f"Saved heatmap data to {out_heatmap}")

print("\nDone!")
print(f"Total ARG-sample combinations: {len(results)}")
print(f"Unique ARG types: {results['Best_Hit_ARO'].nunique()}")
print(f"Unique drug classes: {results['Drug Class'].nunique()}")
print(f"Samples processed: {results['sample'].nunique()}")