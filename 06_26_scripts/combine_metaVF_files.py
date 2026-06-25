#!/usr/bin/env python3

"""
This script combines MetaVF output
Running MetaVF on all my MAGs, saw four results:

-rw-r--r-- 1 910904506 domain users 552 Jun 15 17:06 ./Influent_WWTP_2_1_24_MH4_S341_L008_8264/Influent_WWTP_2_1_24_MH4_S341_L008_8264.VF.fasta
-rw-r--r-- 1 910904506 domain users 9.4K Jun 15 17:05 ./Influent_WWTP_2_1_24_MH3_S346_L008_916/Influent_WWTP_2_1_24_MH3_S346_L008_916.VF.fasta
-rw-r--r-- 1 910904506 domain users 3.1K Jun 15 17:06 ./Influent_WWTP_2_10_24_MH4_S337_L008_0/Influent_WWTP_2_10_24_MH4_S337_L008_0.VF.fasta
-rw-r--r-- 1 910904506 domain users 6.0K Jun 15 17:06 ./Influent_WWTP_2_1_24_MH4_S341_L008_4784/Influent_WWTP_2_1_24_MH4_S341_L008_4784.VF.fasta

Combine these outputs

"""


import pandas as pd
from pathlib import Path

metavf_dir = Path("")
pos_files = ["Influent_WWTP_2_1_24_MH4_S341_L008_8264", 
             "Influent_WWTP_2_1_24_MH3_S346_L008_916",
             "Influent_WWTP_2_10_24_MH4_S337_L008_0",
             "Influent_WWTP_2_1_24_MH4_S341_L008_4784"]

