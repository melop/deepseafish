for i in ../../genomes/*; do
	sp=`basename $i`
	echo $sp
	ln -sf `realpath ../../genomes/$sp/*.longest_isoform.cds.fa` cds/$sp.fa
done
