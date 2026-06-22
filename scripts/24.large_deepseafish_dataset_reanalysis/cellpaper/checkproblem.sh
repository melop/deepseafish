currdir=`pwd`

for i in galba/*/galba.sbatch; do
	cd $currdir
	scriptpath=`realpath $i`
	bRunning=`squeue -u $USER -o "%o" | grep $scriptpath | wc -l`
	#echo $bRunning
	if [ "$bRunning" == "0" ]; then
		cd `dirname $i`;
		if [ ! -f GALBA/galba.aa ]; then
			echo "ERROR $i"
		else 
			echo "OK $i"
		fi
	else 
		echo "RUNNING $i"
	fi
done
