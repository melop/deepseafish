CPU=16
REF=/data2/projects/dyao/pachycara/compare/gatk/pachycara/ref/pachycara_sort.fa
for sR1 in /data/projects/dyao/Data/pachycara/pachycara_trim/*.paired_1.fq.gz; do
	sDir=`dirname $sR1`
	sBase=`basename $sR1`
	sSample=${sBase/.paired_1.fq.gz/}
	sR2=${sDir}/${sSample}.paired_2.fq.gz
	( bwa mem -t $CPU $REF $sR1 $sR2 \
        | samtools view  -u - | samtools sort - -m 30g -o $sSample.bam ) > $sSample.log 2>&1 &
#       echo $sR1
#       echo $sDir
#	echo $sBase
#	echo $sSample
#	echo $sR2
done
wait
