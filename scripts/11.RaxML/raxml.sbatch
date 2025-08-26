#!/usr/bin/bash
#SBATCH -c 48
#SBATCH -p blade,gpu,himem,hugemem,long
#SBATCH --mem=100G

module load raxml

raxmlHPC-PTHREADS-AVX -s in.phy -T 48 -f a -x 23333 -N 100 -m GTRGAMMA -n allcodons -p 23333

