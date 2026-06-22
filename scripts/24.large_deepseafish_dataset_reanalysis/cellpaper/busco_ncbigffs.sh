currdir=`pwd`

for i in genomes/*/*.gff; do
	cd $currdir
	genomepath=`dirname $i`
	scriptpath=`realpath $genomepath/busco/busco.prot.sh`
	bRunning=`squeue -u $USER -o "%o" | grep $scriptpath | wc -l`
	#echo $bRunning
	if [ "$bRunning" == "0" ]; then
		cd $genomepath;
		sProtFa=`ls *.full.prot.fa 2>/dev/null`
		if [ "$sProtFa" != "" ]; then
			if [ ! -f busco/busco.prot.sh ]; then
				mkdir -p busco
				cp $currdir/busco.template2.sh busco/busco.prot.sh
				cd busco;
				sbatch busco.prot.sh
				sleep 1
			else
				echo $i busco already run

			fi
		fi
	else 
		echo "RUNNING $i"
	fi
done
