BAMCALLER=/data/software/msmc-tools/bamCaller.py
CONVERT=/data/software/msmc-tools/generate_multihetsep.py

arrSamples=( pachycara.sort.rmdup )
arrCov=( 51.7508 )
arrChr=( Chromosome1 Chromosome2 Chromosome3 Chromosome4 Chromosome5 Chromosome6 Chromosome7 Chromosome8 Chromosome9 Chromosome10 Chromosome11 Chromosome12 Chromosome13 Chromosome14 Chromosome15 Chromosome16 Chromosome17 Chromosome18 Chromosome19 Chromosome20 Chromosome21 Chromosome22 Chromosome23 Chromosome24 )

sOutDir=formsmc2_in


for nSample in "${!arrSamples[@]}"; do 
	sSample=${arrSamples[$nSample]};
	nCov=${arrCov[$nSample]};

	for nChr in "${arrChr[@]}"; do 
		sChrDir=$sOutDir/$sSample/chr$nChr
		mkdir -p $sChrDir
		( if [ ! -s $sChrDir/out_mask.bed.gz ];then samtools mpileup -q 20 -Q 20 -C 50 -u -r $nChr -f pachycara_chr.fasta $sSample.bam | bcftools call -c -V indels | $BAMCALLER $nCov $sChrDir/out_mask.bed.gz | gzip -c > $sChrDir/out.vcf.gz 2> $sChrDir/log.txt; fi; \
		if [ ! -e $sChrDir/done.txt ]; then $CONVERT --mask $sChrDir/out_mask.bed.gz $sChrDir/out.vcf.gz > $sChrDir/formsmc2.multihetsep.txt 2> $sChrDir/formsmc2.multihetsep.log && touch $sChrDir/done.txt; fi; ) &
	done

done

wait
