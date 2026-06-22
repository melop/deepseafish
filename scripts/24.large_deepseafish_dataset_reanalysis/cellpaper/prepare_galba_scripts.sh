for i in genomes/*; do
	sp=`basename $i`
	echo $sp
	spdir="galba/$sp"
	mkdir -p $spdir

	galbascript="$spdir/galba.sbatch"

	if [ ! -f $galbascript ]; then
		if [ ! -f $i/*.gff ]; then
			echo "Creating galba script"
			cp galba.sbatch.template $galbascript
		else
			echo "This species contains NCBI annotation, no need to run galba"
		fi
	else
		echo "$galbascript exists, skip"
	fi
done
