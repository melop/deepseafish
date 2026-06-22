currdir=`pwd`

for i in annevo/*/annevo.sbatch; do
	cd $currdir
	scriptpath=`realpath $i`
	bRunning=`squeue -u $USER -o "%o" | grep $scriptpath | wc -l`
	#echo $bRunning
	if [ "$bRunning" != "0" ]; then
		echo "$scriptpath is already running in squeue skip"
	else
		cd `dirname $i`;
		if [ -f annevo.done ];then
			continue;
		fi
		sbatch annevo.sbatch
		echo `pwd` submited
		sleep 1
	fi
done
