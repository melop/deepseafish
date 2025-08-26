genome1=Basso.softmasked.fa
genome2=Bmul.softmasked.fa
sp1=Bassozetus_sp
sp2=Brotula_multibarbata

paftools=/data/software/minimap2-2.20/misc/paftools.js

minimap2 -t36 -cx asm20 --cs $genome1 $genome2 | sort -k6,6 -k8,8n --parallel=4 > pairwise.aln.$sp1.$sp2.paf

 cut -f1,3,4,5,6,8,9,12 pairwise.aln.$sp1.$sp2.paf | awk '$8>=60 {print}' > pairwise.simp.$sp1.$sp2.txt

( $paftools call -q 60 -f $genome1 -L10000 -l1000 pairwise.aln.$sp1.$sp2.paf | bgzip -c > out.$sp1.$sp2.vcf.gz ) 2>out.vcf.info
tabix out.$sp1.$sp2.vcf.gz

