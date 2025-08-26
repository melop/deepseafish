for i in *.filtered.het.bed; do
	#echo "$i"
	sSP=${i/.filtered.het.bed/}
	awk '{print $4}' "$i" > "$sSP.het.txt"
done
wait

