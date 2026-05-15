#!/bin/bash

# make snakemake folders

mkdir -p workflow
mkdir -p workflow/envs
touch workflow/snakefile
mkdir -p config
touch config/config.yaml
mkdir -p results 

echo "All done!"
