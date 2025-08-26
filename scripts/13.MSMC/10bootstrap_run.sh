MSMC2=/data/software/msmc2-2.1.3/build/release/msmc2

nReps=30
nChunkSize=5000000


arrPops=( pachycara.sort.rmdup )

sOutDir=bootstrapped


for sPop in "${arrPops[@]}"; do
	for i in $(seq 1 $nReps); do 

		sBSFolder="$sOutDir/$sPop/_${i}";
		[ ! -s $sBSFolder/out.final.txt ] && $MSMC2 -o $sBSFolder/out -i 40 -t 1 -r 2.61976354 $sBSFolder/bootstrap_multihetsep.*.txt 2> /dev/null &
	done

done

wait
