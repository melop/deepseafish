sp=`realpath ..`
sp=`basename $sp`
genome=`ls ../../../genomes/$sp/*.fna`
tooldir=/public/apps/miniconda3/envs/funannotate/opt/pasa-2.5.2/misc_utilities/
gff=galba.gff3

source /public/apps/miniconda3/etc/profile.d/conda.sh
conda activate /public4/software/conda_env/agat

#use this script to get the longest isoforms to avoid CDS phase problems
agat_sp_keep_longest_isoform.pl -gff $gff -o $sp.longest_isoform.gff3

#$tooldir/gff3_file_to_proteins.pl $gff $genome cDNA > $sp.full.mrna.fa
#$tooldir/gff3_file_to_proteins.pl $gff $genome prot > $sp.full.prot.fa
#$tooldir/gff3_file_to_proteins.pl $gff $genome CDS > $sp.full.cds.fa

#$tooldir/gff3_file_to_proteins.pl $sp.longest_isoform.gff3 $genome cDNA > $sp.longest_isoform.mrna.fa
$tooldir/gff3_file_to_proteins.pl $sp.longest_isoform.gff3 $genome prot > $sp.longest_isoform.prot.fa
$tooldir/gff3_file_to_proteins.pl $sp.longest_isoform.gff3 $genome CDS > $sp.longest_isoform.cds.fa
