#!/bin/bash
#SBATCH -p himem,blade,long
#SBATCH -o slurmlog/tblastn_slurm-%a.out
#SBATCH -e slurmlog/tblastn_slurm-%a.err
#SBATCH -a 0-19
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=10


TOTALPARTS=${SLURM_ARRAY_TASK_COUNT}
THISJOB=${SLURM_ARRAY_TASK_ID}

ROOT=/public3/group_crf/home/g22yaodj3/Data/pachycara/07_genewise/Orthogroups
genome=/public3/group_crf/home/g22yaodj3/Data/pachycara/07_genewise/scf.softmasked.fa
index_addr=/public3/group_crf/home/g22yaodj3/Data/pachycara/07_genewise

module load blast
module load samtools
#makeblastdb -in $genome -dbtype nucl -out ${index_addr}/index
#samtools faidx $genome -o $index_addr

#cut -f 1,2 ${genome}.fai > ${genome}.len 

nCounter=-1

	for fa in $ROOT/*/*.c2.fa;do
		sBase=`basename $fa`
		sName=${sBase/.c2.fa/}
    nCounter=$(( nCounter + 1 ))
    if (( $nCounter % $TOTALPARTS == $THISJOB )); then
      echo job $nCounter $TOTALPARTS $THISJOB

		cd ${ROOT}/$sName

    doneflag=${sName}.tblastn.done
		if [[ ! -f "$doneflag"  ]]; then
		  tblastn -query $fa -db ${index_addr}/index -evalue 1e-6 -outfmt 6 -num_threads 10 -out ${sName}_tblastn  && touch $doneflag
		else
		  echo "tblastn -query $fa -db ${index_addr}/index -evalue 1e-6 -outfmt 6 -num_threads 10 -out ${sName}_tblastn already done, skip"

    fi

    fi
  done;
wait
exit


