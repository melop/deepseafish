arrSamples=(pachycara.sort.rmdup)
arrChr=(Chromosome1 Chromosome2 Chromosome3 Chromosome4 Chromosome5 Chromosome6 Chromosome7 Chromosome8 Chromosome9 Chromosome10 Chromosome11 Chromosome12 Chromosome13 Chromosome14 Chromosome15 Chromosome16 Chromosome17 Chromosome18 Chromosome19 Chromosome20 Chromosome21 Chromosome22 Chromosome23 Chromosome24 )
outdir=depthcounts
mkdir $outdir
for sSample in "${arrSamples[@]}"; do
	for sChr in "${arrChr[@]}"; do
		samtools depth -r $sChr ${sSample}.bam | awk '{sum += $3} END {print sum / NR}' > $outdir/${sSample}_${sChr}.txt &
	done
done

wait
