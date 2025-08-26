for i in /data2/projects/dyao/compare/gene_loss_all_new/00_add_gff/*; do
{	sStem=$(basename $i)
	if [ -d "$i" ]
	then
		echo $sStem
		php prep_funannotate_genome.php $sStem $i/$sStem.longest_isoform.prot.fa
	else
		echo "this file is not directory"
	fi
} &	
done
wait

