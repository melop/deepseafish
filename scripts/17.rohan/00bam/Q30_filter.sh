sPath="/data2/projects/dyao/compare/rohan/00_bam"
for i in $sPath/*.dedup.bam; do
{	sFile=$(basename $i)
	sStem=${sFile%%\.*}
#	echo $sStem
	samtools view -q 30 -o $sStem.filtered.bam -O bam $i
	samtools index $sStem.filtered.bam
}&
done
wait
