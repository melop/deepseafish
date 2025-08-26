#!/usr/bin/bash
#SBATCH -p long
#SBATCH -c 16
#SBATCH --mem=100G

source /public/apps/miniconda3/etc/profile.d/conda.sh
conda activate flye

flye --nano-raw  `ls /public3/group_crf/home/g22yaodj3/Data/pachycara/00_rawONT/pachycara*.gz` --genome-size 684.4m --threads 16 --scaffold -o out > flye.log 2>&1

