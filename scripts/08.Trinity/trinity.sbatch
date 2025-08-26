#!/usr/bin/bash
#SBATCH -c 20
#SBATCH --mem=80G
#SBATCH -p himem

Trinity --CPU 20 --seqType fq --max_memory 80G --samples_file allsample.txt --jaccard_clip --output youwei_trinity_assm > out.log 2>&1

