#!/usr/bin/bash
#SBATCH -p gpu,short,blade,himem,hugemem
#SBATCH -c 24
source /public/apps/miniconda3/etc/profile.d/conda.sh
conda activate /public4/software/conda_env/busco6.0.0

busco -c $SLURM_CPUS_PER_TASK -i ../galba.aa  -m prot -o prot -l actinopterygii_odb12 \
--offline --download_path /public2/shareddatabase/busco/download/ > busco.prot.log 2>&1
