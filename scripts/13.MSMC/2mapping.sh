pachycara=/data/projects/dyao/Data/pachycara/pachycara_trim
ref=/data/projects/dyao/Data/pachycara/06_psmc/pachycara_chr.fasta
id=pachycara
cpu=32

bwa mem -t $cpu -R "@RG\tID:$id\tPL:illumina\tSM:$id" $ref \
$pachycara/pachycara.paired_1.fq.gz $pachycara/pachycara.paired_2.fq.gz \
| samtools view -@ $cpu -Sb - > $id.bam &
