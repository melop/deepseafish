#20221129 youwei rm adapter

trimjar=/data/software/Trimmomatic-0.39/trimmomatic-0.39.jar
adapterfa=/data/software/Trimmomatic-0.39/adapters/bgi_adapter.fa

in1=/data/projects/shareddata/deepsea_animals/raw_data_2022-11-29/raw_data_20221128/MGI/DNA/FDZ-2-jirou/65.41G/D221000013A_1.fq.gz
in2=/data/projects/shareddata/deepsea_animals/raw_data_2022-11-29/raw_data_20221128/MGI/DNA/FDZ-2-jirou/65.41G/D221000013A_2.fq.gz
i=youwei
java -jar $trimjar PE -threads 20 -phred33 $in1 $in2 $i.paired_1.fq.gz $i.unpaired_1.fq.gz  $i.paired_2.fq.gz $i.unpaired_2.fq.gz  ILLUMINACLIP:$adapterfa:2:30:10 LEADING:3 TRAILING:3 SLIDINGWINDOW:4:15 MINLEN:36 > trim.$i.log 2>&1 &
wait;

