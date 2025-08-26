
genome=Bassozetus.softmasked.fa
species=Bassozetus_sp
gff=Basso_add_lostgene.gff3

perl5.30.0 /data/software/PASApipeline.v2.4.1/misc_utilities/gff3_file_single_longest_isoform.pl Basso_add_lostgene.gff3 > longest_isoform.gff3

perl5.30.0 /data/software/PASApipeline.v2.4.1/misc_utilities/gff3_file_to_proteins.pl longest_isoform.gff3 $genome cDNA > $species.longest_isoform.mrna.fa
perl5.30.0 /data/software/PASApipeline.v2.4.1/misc_utilities/gff3_file_to_proteins.pl longest_isoform.gff3 $genome prot > $species.longest_isoform.prot.fa
perl5.30.0 /data/software/PASApipeline.v2.4.1/misc_utilities/gff3_file_to_proteins.pl longest_isoform.gff3 $genome CDS > $species.longest_isoform.cds.fa

