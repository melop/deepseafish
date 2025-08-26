#20221106 pachycara_NGS genomesize

sga=/data/software/sga/src/SGA/sga
sp=pachycara
r1=pachycara.paired_1.fq.gz
r2=pachycara.paired_2.fq.gz
CPU=32


mkdir -p $sp

(
mkfifo $sp/r1.fastq
mkfifo $sp/r2.fastq

zcat -f $r1 > $sp/r1.fastq &
zcat -f $r2 > $sp/r2.fastq &


$sga preprocess --pe-mode 1  $sp/r1.fastq $sp/r2.fastq > $sp/$sp.fastq
$sga index -a ropebwt --no-reverse -t $CPU  $sp/$sp.fastq
mv $sp.* $sp/
$sga preqc -v -t $CPU  $sp/$sp.fastq >  $sp/$sp.preqc
/data/software/sga/src/bin/sga-preqc-report.py *.preqc

) >> $sp/log.txt 2>&1

