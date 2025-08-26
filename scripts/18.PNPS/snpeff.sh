snpeffjar=/data/projects/dyao/App/snpEff/snpEff.jar
REF=pachycara_1.0

bcftools view -O z -o pachycara.filter.snp.vcf.gz -i 'QUAL>=60 && TYPE=="snp" && INFO/DP > 10 && FILTER!="LowQual"' ../pachycara.genotyped.g.vcf.gz
tabix pachycara.filter.snp.vcf.gz
java -Xmx26g -jar $snpeffjar $REF pachycara.filter.snp.vcf.gz | bgzip -c > pachycara.filter.snp.snpeff.vcf.gz

