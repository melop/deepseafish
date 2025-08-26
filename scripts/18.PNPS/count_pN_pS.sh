awk -F'\t' '$8 ~ /missense_variant/ {print $0}' protein_coding_variants.vcf > pN_variants.vcf
awk -F'\t' '$8 ~ /synonymous_variant/ {print $0}' protein_coding_variants.vcf > pS_variants.vcf
pN_count=$(wc -l pN_variants.vcf | awk '{print $1}')
pS_count=$(wc -l pS_variants.vcf | awk '{print $1}')
pNpS_ratio=$(echo "scale=4; $pN_count / $pS_count" | bc)
echo "pN/pS ratio: $pNpS_ratio"
