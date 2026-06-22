for i in genomes/*; do
	sp=`basename $i`
	bGalbaErr=`cat check.log | grep ERROR | grep $sp | wc -l`

	if [ $bGalbaErr -eq 0 ]; then
		echo "Galba ok for $sp, do not use annevo"
		continue;
	fi
	echo "$sp has error in galba try annevo"
	spdir="annevo/$sp"

	annevoscript="$spdir/annevo.sbatch"

	if [ ! -f $annevoscript ]; then
		if [ ! -f $i/*.gff ]; then
			echo "Creating annevo script"
			mkdir -p $spdir
			cp annevo.sbatch.template $annevoscript
		else
			echo "This species contains NCBI annotation, no need to run galba"
		fi
	else
		echo "$annevoscript exists, skip"
	fi
done
