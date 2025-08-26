MSMC2=/data/software/msmc2-2.1.3/build/release/msmc2

arrPops=( pachycara.sort.rmdup )
sIn=formsmc2_in
sOut=msmc2ret
mkdir -p $sOut


for sPop in "${arrPops[@]}"; do
	sFiles="${sIn}/${sPop}*/chr*/formsmc2.multihetsep.txt"
	sCmd="$MSMC2 -o $sOut/$sPop -i 40 -t 32 -r 2.61976354 $sFiles > /dev/null "
	eval $sCmd &
done

wait
