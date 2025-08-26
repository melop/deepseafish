cat relax.fdr1.tsv | awk -F'\t' '{if ($5<0.01 && $9>1 && $25<0.05) print $0}'
