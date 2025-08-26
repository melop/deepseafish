cut -f17 genespace.orthogroups.txt | grep 'Group' > pachycara_unloss.txt
cut -f6 genespace.orthogroups.txt | grep 'Group' > Bassozetus_unloss.txt


awk -F'|' '{split($3, a, "_"); print a[1]"_"a[2]"_1"}' pachycara_unloss.txt > pachycara_unloss_fmt.txt
awk -F'|' '{split($3, a, "_"); print a[1]"_"a[2]"_1"}' Bassozetus_unloss.txt > Bassozetus_unloss_fmt.txt


grep -v -f pachycara_unloss_fmt.txt Pachycara_geneloss_orig.txt > pachycara_loss_confirmed.txt
grep -v -f Bassozetus_unloss_fmt.txt Bassozetus_geneloss_orig.txt > Bassozetus_loss_confirmed.txt
 
#The reason the number of lines in Bassozetus_loss_confirm.txt + the number of lines in Bassozetus_unloss_fmt.txt does not equal the number of lines in Bassozetus_geneloss_orig.txt is because there are 2 genes which have dup transcripts, but these transcripts are named as "Group_22548_1***(3transcripts)" and "Group_22613_1(2 transcripts)" in Bassozetus_unloss.txt, while in Bassozetus_geneloss_orig.txt, they are specifically referred to as "Group_22548_1 and Group_22613_1.". Anyway, it means that they exist in Bassozetus's genome, so they are not loss genes.
