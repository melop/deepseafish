ref="/data2/projects/dyao/compare/annotation/pachycara/pachycara.softmasked.fa"
vcf=/data2/projects/dyao/pachycara/compare/gatk/pachycara/pachycara.genotyped.g.vcf.gz

bcftools consensus -i 'TYPE=="snp"' -H 1 -f $ref $vcf > pachycara_pseudogenome_1.fa
bcftools consensus -i 'TYPE=="snp"' -H 2 -f $ref $vcf > pachycara_pseudogenome_2.fa
