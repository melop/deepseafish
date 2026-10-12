mkdir -p cds

for i in ../genomes/* ; do
sp=`basename $i`
echo "$sp"


sDir=cds

if [ -f ../genomes/$sp/*.longest_isoform.cds.fa ]; then
	ln -sf `realpath ../genomes/$sp/*.longest_isoform.cds.fa` $sDir/$sp.fa
else

  if [ -f ../galba/$sp/GALBA/*.longest_isoform.cds.fa ]; then
	ln -sf `realpath ../galba/$sp/GALBA/*.longest_isoform.cds.fa` $sDir/$sp.fa
  else
	if [ -f ../annevo/$sp/*.longest_isoform.cds.fa ]; then
		ln -sf `realpath ../annevo/$sp/*.longest_isoform.cds.fa` $sDir/$sp.fa
	fi 
  fi
fi
done 
