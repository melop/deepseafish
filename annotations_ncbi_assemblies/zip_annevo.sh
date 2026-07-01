
mkdir -p annevo

for i in ../../../cellpaper/annevo/*/genes.gff; do
	sp=`dirname $i`
	sp=`basename $sp`
	echo $sp
	filesize=`ls -l $i | awk '{ print $5 }'`
	minsize=$((1024*50))
if [ $filesize -gt $minsize ]
then
	cat $i | gzip -c > annevo/$sp.annevo.gff3.gz
else 
    echo "$i too small"
fi

done
