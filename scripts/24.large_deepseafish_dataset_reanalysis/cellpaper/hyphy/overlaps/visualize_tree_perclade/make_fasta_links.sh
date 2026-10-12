sInDir=/public4/group_crf/home/cuirf/deepsea/cellpaper/exportaln/AA_alignments_by_gene
sPairDir=clade
ListFilePrefix=genelist.p_0.05.fdr_0.1.

for i in $sPairDir/*/; do
	sPairName=`basename $i`
	echo $sPairName

	for sList in $sPairDir/$sPairName/${ListFilePrefix}*.txt; do
		sFolder=${sList/.txt/}
		mkdir -p $sFolder
		echo $sFolder
		while read -r gene; do
			ln -sf $sInDir/$gene.fasta $sFolder/$gene.fas
		done < "$sList"
	done

done
