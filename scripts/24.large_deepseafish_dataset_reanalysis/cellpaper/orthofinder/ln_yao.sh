for i in ../../genomes/*; do
	sp=`basename $i`
	echo $sp
	ln -sf `realpath ../../genomes/$sp/*.longest_isoform.prot.fa` highqual/$sp.fa
done
