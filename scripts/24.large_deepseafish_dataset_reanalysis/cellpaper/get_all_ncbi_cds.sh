currdir=`pwd`
for i in genomes/*; do
	cd $currdir;
	sp=`basename $i`
	echo $sp
		if [ ! -f $i/*.gff ]; then
			echo "No ncbi annotations"
			
		else
			echo "This species contains NCBI annotation, export cds"
			cp getfinal.template.sh $i/getfinal.sh
			cd $i
			bash getfinal.sh
		fi
done
