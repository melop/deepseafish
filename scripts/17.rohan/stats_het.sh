sP=/data2/projects/dyao/compare/rohan
for i in $sP/*_*; do
	if [[ -d $i ]]; then
	# 获取目录名的第一个字符
		first_char=$(basename $i | cut -c 1)	    
	# 使用正则表达式检查第一个字符是否为大写字母
		if [[ "$first_char" =~ [A-Z] ]]; then
			sStem=$(basename $i)
			echo $sStem
			less $i/$sStem.hEst.gz | awk -v OFS="\t" '{if(substr($1,1,6)=="TbaScf"){split($1,arr,"_");if (arr[2]<24 && ($3 % 50000 == 0) && $4>=25000){print $1,$2,$3,$5}}}' > $sP/$sStem.filtered.het.bed
			less $sP/$sStem.filtered.het.bed | awk -v OFS="\t" -v sStem=$sStem 'BEGIN {n=0;het=0};{n+=1;if($4 > 0.00082){het += $4}};END {print(sStem, "average_het:", het/n)}' >> $sP/part3.filtered.het.txt
			rm $sP/$sStem.filtered.het.bed
		fi
	fi
done
