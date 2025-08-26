#!/usr/bin/bash
#SBATCH -p himem,hugemem,long,blade
#SBATCH -c 50
#SBATCH --mem=100G

source /public/apps/miniconda3/etc/profile.d/conda.sh
conda activate mafft
conda activate --stack sy_py
orthofinder=/data2/projects/yshao/funannotate/genewise/tblastn/longest_prt/longest_pro/NoM_fasta/ortho2/input/OrthoFinder/Results_Jul28/Orthogroup_Sequences/*.fa
ROOT=/data2/projects/yshao/funannotate/genewise/Orthogroups

#01 mkdir
for sR1 in $orthofinder; do
	sBase=`basename $sR1`
        sSample=${sBase/.fa/}
	sName=${sSample}.fa
	mkdir -p ${ROOT}/$sSample
	cp $sR1 ${ROOT}/$sSample/$sName
done
wait;
    if [  "$?" -ne  "0" ]; then
      exit 1;
    fi

#02 align
python3 02a_Filter2Std.py

for sR2 in ${ROOT}/*/*.c1.fa
do
        sBase=`basename $sR2`
        sName=${sBase/.c1.fa/}
        cd ${ROOT}/$sName
	mafft --anysymbol --thread 10 $sR2 > ${sName}_align

done
wait;
    if [  "$?" -ne  "0" ]; then
      exit 1;
    fi

python3 02c_FilterMft.py
