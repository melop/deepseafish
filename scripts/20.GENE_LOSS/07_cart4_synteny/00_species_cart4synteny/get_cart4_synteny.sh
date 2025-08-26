grep 'mRNA' *longest_isoform.gff3 | awk '$1 == "BmulScf_4"' | sort -k4,4n | grep -C 5 'FUN_003966-T1' | cut -f9 > genes.txt

grep -f genes.txt Brotula_multibarbata.longest_isoform.gff3 > Brotula_multibarbata.longest_cart4synteny.gff3

perl5.30.0 /data/software/PASApipeline.v2.4.1/misc_utilities/gff3_file_to_proteins.pl Brotula_multibarbata.longest_cart4synteny.gff3 Brotula_multibarbata.softmasked.fa prot > Brotula_multibarbata.longest_cart4synteny.prot.fa
