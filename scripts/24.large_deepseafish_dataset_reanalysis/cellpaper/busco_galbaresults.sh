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
			echo "OK $i, submit busco"

			if [ ! -f GALBA/busco/busco.prot.sh ]; then
				mkdir -p GALBA/busco
				cp $currdir/busco.template.sh GALBA/busco/busco.prot.sh
				cd GALBA/busco;
				sbatch busco.prot.sh
			else
				echo $i busco already run

			fi
		fi
	else 
		echo "RUNNING $i"
	fi
done
