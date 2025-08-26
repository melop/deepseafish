#!/bin/bash
#SBATCH -p himem,blade,long
#SBATCH -o slurmlog3/genewise_slurm-%a.out
#SBATCH -e slurmlog3/genewise_slurm-%a.err
#SBATCH -a 0-199
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1


TOTALPARTS=${SLURM_ARRAY_TASK_COUNT}
THISJOB=${SLURM_ARRAY_TASK_ID}

module load genewise
export WISECONFIGDIR=/public3/group_crf/software/genewise/wisecfg
ROOT=/public3/group_crf/home/g22yaodj3/Data/pachycara/07_genewise/Orthogroups

nCounter=-1

	for hmm in $ROOT/*/*.2.hmm;do
		sBase=`basename $hmm`
		sName=${sBase/.2.hmm/}
    nCounter=$(( nCounter + 1 ))
    if (( $nCounter % $TOTALPARTS == $THISJOB )); then
      echo job $nCounter $TOTALPARTS $THISJOB

		for fa1 in $ROOT/$sName/*_1_fasta/targetzone_1_*;do
			  faBase=`basename $fa1`
			  faName=${faBase}
			  mkdir -p $ROOT/$sName/${sName}_genewise1_b3_out
			  cd $ROOT/$sName/${sName}_genewise1_b3_out
			  doneflag1=${sName}_${faName}.genewise.done
				echo job $nCounter $TOTALPARTS $THISJOB
				if [[ ! -f "$doneflag1"  ]]; then
					genewise -alg 2193L -silent -tfor -hmmer $hmm $fa1 -cdna > ${sName}_${faName}.out && touch $doneflag1
				else
					echo "genewise -alg 2193L -silent -tfor -hmmer $hmm $fa1 -cdna > ${sName}_${faName}.out already done, skip"

				fi
		done;
		for fa2 in $ROOT/$sName/*_2_fasta/targetzone_2_*;do
			  faBase=`basename $fa2`
			  faName=${faBase}
			  mkdir -p $ROOT/$sName/${sName}_genewise2_b3_out
			  cd $ROOT/$sName/${sName}_genewise2_b3_out
			  doneflag2=${sName}_${faName}.genewise.done
				echo job $nCounter $TOTALPARTS $THISJOB
				if [[ ! -f "$doneflag2"  ]]; then
					genewise -alg 2193L -silent -trev -hmmer $hmm $fa2 -cdna > ${sName}_${faName}.out && touch $doneflag2
				else
					echo "genewise -alg 2193L -silent -trev -hmmer $hmm $fa2 -cdna > ${sName}_${faName}.out already done, skip"

				fi
		done;

    fi
	done;
wait
exit


