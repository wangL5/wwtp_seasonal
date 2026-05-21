#!/bin/bash

seqtk subseq Pooled_contigs.fna announcement_contigs.txt > announcement_contigs.fna

seqkit split --by-id announcement_contigs.fna --out-dir announcement_contigs/

echo "all done!"