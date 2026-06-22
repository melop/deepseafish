currdir=`pwd`
for i in annevo/*; do
	cd $currdir;
	sp=`basename $i`
	echo $sp
		if [ -f $i/$sp.full.prot.fa ]; then
			if [ ! -f $i/getfinal.done ]; then
			echo "Convert ..."
			cp getfinal.template.annevo.sh $i/getfinal.sh
			cd $i/
			bash getfinal.sh > getfinal.log 2>&1 && touch getfinal.done &
			else
			echo skip
			fi
		else
			echo "No ANNEVO output"
		fi
done
wait
