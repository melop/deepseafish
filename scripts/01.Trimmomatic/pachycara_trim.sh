
#20221106 pachycara1105 rm adapter

trimjar=/data/software/Trimmomatic-0.39/trimmomatic-0.39.jar
adapterfa=/data/software/Trimmomatic-0.39/adapters/bgi_adapter.fa

in1=D220900357A_1.fq.gz
in2=D220900357A_2.fq.gz
i=pachycara
java -jar $trimjar PE -threads 20 -phred33 $in1 $in2 $i.paired_1.fq.gz $i.unpaired_1.fq.gz  $i.paired_2.fq.gz $i.unpaired_2.fq.gz  ILLUMINACLIP:$adapterfa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36 > trim.$i.log 2>&1 &
wait;

