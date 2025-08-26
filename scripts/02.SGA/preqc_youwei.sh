#20221129 youwei_NGS genomesize

sga=/data/software/sga/src/SGA/sga
sp=youwei
r1=youwei.paired_1.fq.gz
r2=youwei.paired_2.fq.gz
CPU=20


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

