genome1=pachycara_pseudogenome_1.fa
genome2=pachycara_pseudogenome_2.fa
species=Pachycara

gffread longest_isoform.gff3 -g $genome1 -y $species.pseudo.prot_1.fa
gffread longest_isoform.gff3 -g $genome2 -y $species.pseudo.prot_2.fa
