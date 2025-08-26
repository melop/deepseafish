for i in /data2/projects/dyao/compare/gene_loss_all_new/07_cart4_synteny/00_species_cart4synteny/*; do
{	sStem=$(basename $i)
	if [ -d "$i" ]
	then
		echo $sStem
		php prep_funannotate_genome.php $sStem $i/$sStem.*prot.fa
	else
		echo "this file is not directory"
	fi
} &	
done
wait

