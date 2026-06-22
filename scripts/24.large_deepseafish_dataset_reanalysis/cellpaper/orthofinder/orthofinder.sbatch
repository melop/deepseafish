#!/usr/bin/bash
#SBATCH -p blade
#SBATCH -c 64
#SBATCH --mem=220G
source /public/apps/miniconda3/etc/profile.d/conda.sh
conda activate /public4/software/conda_env/orthofinder3/

orthofinder -t ${SLURM_CPUS_PER_TASK} -a 16 -f highqual -n Core
