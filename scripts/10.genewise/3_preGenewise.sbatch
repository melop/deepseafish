#!/usr/bin/bash
#SBATCH -p himem,hugemem,long,blade
#SBATCH -c 40
#SBATCH --mem=80G

source /public/apps/miniconda3/etc/profile.d/conda.sh
conda activate /public3/group_crf/home/g21shaoy23/.conda/envs/bedtools
hmmer=/public3/group_crf/software/hmmer-2.4i/src/hmmbuild
ROOT=/public3/group_crf/home/g22yaodj3/Data/pachycara/07_genewise/Orthogroups
len=/public3/group_crf/home/g22yaodj3/Data/pachycara/07_genewise/scf.softmasked.fa.len
genome=/public3/group_crf/home/g22yaodj3/Data/pachycara/07_genewise/scf.softmasked.fa

#01 get bed
for sR1 in ${ROOT}/*/*_tblastn
do
	sBase=`basename $sR1`
        sName=${sBase/_tblastn/}
	cd ${ROOT}/$sName
	cut -f 1,2,9,10 $sR1 | awk -F '\t' '{print $2,$3,$4,$1}' > ${sName}_bed
	cat ${sName}_bed | awk '$2<$3{print $0}'| awk '{print $1"\t"$2-1"\t"$3-1"\t"$4}' | sort -k1,1 -k2,2n >${sName}.1.bed
	cat ${sName}_bed | awk '$2>$3{print $0}'| awk '{print $1"\t"$3-1"\t"$2-1"\t"$4}' | sort -k1,1 -k2,2n > ${sName}.2.bed
	find ./*  -type f -size 0c |xargs -n 1 rm -rf

done;
wait
    if [  "$?" -ne  "0" ]; then
      exit 1;
    fi

#02 merge
for sR1m in ${ROOT}/*/*.1.bed
do
        sBase=`basename $sR1m`
        sName=${sBase/.1.bed/}
        cd /${ROOT}/$sName
        bedtools merge -i $sR1m -d 300000 -c 1,4 -o count,collapse > ${sName}_merge.1.bed

done;
wait
    if [  "$?" -ne  "0" ]; then
      exit 1;
    fi

for sR2m in ${ROOT}/*/*.2.bed
do
        sBase=`basename $sR2m`
        sName=${sBase/.2.bed/}
        cd ${ROOT}/$sName
        bedtools merge -i $sR2m -d 300000 -c 1,4 -o count,collapse > ${sName}_merge.2.bed
done;
wait
    if [  "$?" -ne  "0" ]; then
      exit 1;
    fi

#03 slop
for sR1sl in ${ROOT}/*/*_merge.1.bed
do
	sBase=`basename $sR1sl`
	sName=${sBase/_merge.1.bed/}
	cd ${ROOT}/$sName
	bedtools slop -g ${len} -i $sR1sl -l 3000 -r 3000 -s > ${sName}_add3kb_merge.1.bed
done;
wait
    if [  "$?" -ne  "0" ]; then
      exit 1;
    fi

for sR2sl in ${ROOT}/*/*_merge.2.bed
do
	sBase=`basename $sR2sl`
	sName=${sBase/_merge.2.bed/}
	cd ${ROOT}/$sName
	bedtools slop -g ${len} -i $sR2sl -l 3000 -r 3000 -s > ${sName}_add3kb_merge.2.bed
done;
wait
    if [  "$?" -ne  "0" ]; then
      exit 1;
    fi

#04 getFasta
for sR1g in ${ROOT}/*/*_add3kb_merge.1.bed
do
        sBase=`basename $sR1g`
        sName=${sBase/_add3kb_merge.1.bed/}
        cd ${ROOT}/$sName
        bedtools getfasta -fi ${genome} -bed $sR1g -fo ${sName}.1.fasta
done;
wait
    if [  "$?" -ne  "0" ]; then
      exit 1;
    fi

for sR2g in ${ROOT}/*/*_add3kb_merge.2.bed
do
        sBase=`basename $sR2g`
        sName=${sBase/_add3kb_merge.2.bed/}
        cd ${ROOT}/$sName
        bedtools getfasta -fi ${genome} -bed $sR2g -fo ${sName}.2.fasta
done;
wait
    if [  "$?" -ne  "0" ]; then
      exit 1;
    fi

#05 makeHmm
for sR1h in ${ROOT}/*/*_align
do
        sBase=`basename $sR1h`
        sName=${sBase/_align/}
        cd ${ROOT}/$sName
	      $hmmer --amino ${sName}.2.hmm $sR1h
done;
wait
    if [  "$?" -ne  "0" ]; then
      exit 1;
    fi

#06 split
for sR1sp in ${ROOT}/*/*.1.fasta
do
        sBase=`basename $sR1sp`
        sName=${sBase/.1.fasta/}
	mkdir -p ${ROOT}/$sName/${sName}_1_fasta
        cd ${ROOT}/$sName/${sName}_1_fasta
	      split -l 2 $sR1sp -d -a 4 targetzone_1_modified_
done;
wait
    if [  "$?" -ne  "0" ]; then
      exit 1;
    fi

for sR2sp in ${ROOT}/*/*.2.fasta
do
        sBase=`basename $sR2sp`
        sName=${sBase/.2.fasta/}
	mkdir -p ${ROOT}/$sName/${sName}_2_fasta
        cd ${ROOT}/$sName/${sName}_2_fasta
        split -l 2 $sR2sp -d -a 4 targetzone_2_modified_
done;
wait
    if [  "$?" -ne  "0" ]; then
      exit 1;
    fi
