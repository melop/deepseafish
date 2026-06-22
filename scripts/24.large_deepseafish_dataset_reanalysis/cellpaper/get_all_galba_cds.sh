currdir=`pwd`
for i in galba/*; do
	cd $currdir;
	sp=`basename $i`
	echo $sp
		if [ -f $i/GALBA/galba.aa ]; then
			if [ ! -f $i/GALBA/getfinal.done ]; then
			echo "Convert ..."
			cp getfinal.template.galba.sh $i/GALBA/getfinal.sh
			cd $i/GALBA/
			bash getfinal.sh > getfinal.log 2>&1 && touch getfinal.done &
			else
			echo skip
			fi
		else
			echo "No GALBA output"
		fi
done
wait
