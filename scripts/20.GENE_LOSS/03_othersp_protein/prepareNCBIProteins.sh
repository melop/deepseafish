for i in /data2/projects/dyao/compare/gene_loss_all_new/00_add_gff/*; do
	if [ -d $i ]; then
		sp=`basename $i`
		if [ -f $i/*longest_isoform.prot.fa ]; then
			echo $i
			cat $i/*longest_isoform.prot.fa | php preprocessAA.php > $i.filtered.fa 2> $i.filtered.tab
			/data/software/UPhO/minreID.py $i.filtered.fa $sp \|
		fi
	fi
done

cat *.fst > allNCBIproteins.fa
