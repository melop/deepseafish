mkdir -p highqual
mkdir -p lowqual

highqualfile="highqual.txt"
for i in ../genomes/* ; do
sp=`basename $i`
echo "$sp"

bHQ=`grep "$sp" $highqualfile | wc -l`

sDir=highqual
if [ "$bHQ" == "0" ]; then
	sDir=lowqual
fi

if [ -f ../genomes/$sp/*.longest_isoform.prot.fa ]; then
	ln -sf `realpath ../genomes/$sp/*.longest_isoform.prot.fa` $sDir/$sp.fa
else

  if [ -f ../galba/$sp/GALBA/*.longest_isoform.prot.fa ]; then
	ln -sf `realpath ../galba/$sp/GALBA/*.longest_isoform.prot.fa` $sDir/$sp.fa
  else
	if [ -f ../annevo/$sp/*.longest_isoform.prot.fa ]; then
		ln -sf `realpath ../annevo/$sp/*.longest_isoform.prot.fa` $sDir/$sp.fa
	fi 
  fi
fi
done 
