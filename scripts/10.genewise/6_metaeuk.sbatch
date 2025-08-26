#!/usr/bin/bash
#SBATCH -p himem,long,blade
#SBATCH -c 64

source /public/apps/miniconda3/etc/profile.d/conda.sh
conda activate busco5.3.2

metaeuk easy-predict ./scf.softmasked.fa ./all.prot.fa ./result ./temp



