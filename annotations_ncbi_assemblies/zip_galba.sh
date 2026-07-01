
mkdir -p galba

for i in ../../../cellpaper/galba/*/GALBA/galba.gff3; do
	sp=`dirname $i`
	sp=`dirname $sp`
	sp=`basename $sp`
	echo $sp
	filesize=`ls -l $i | awk '{ print $5 }'`
	minsize=$((1024*10))
if [ $filesize -gt $minsize ]
then
	cat $i | gzip -c > galba/$sp.galba.gff3.gz
else 
    echo "$i too small"
fi

done
