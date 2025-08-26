rohan="/data/software/ROHan-1.0.1/bin/rohan"
ref="/data2/projects/dyao/compare/annotation/pachycara/pachycara.softmasked.fa"
sBam_path="/data2/projects/dyao/compare/rohan/00_bam"

for i in $sBam_path/pachycara.filtered.bam; do
	sF=$(basename $i)
	sStem=${sF/.filtered.bam/}
	$rohan --rohmu 2e-5 -t 16 --size 50000 --step 100 -o $sStem $ref $i > run.log 2>&1 &
done;
wait


#$rohan --rohmu 2e-5 -t 32 -o YN-15 $ref ./YN-15.sorted.bam
