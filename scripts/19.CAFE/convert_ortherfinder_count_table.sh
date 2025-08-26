IN=/data2/projects/dyao/compare/mcmctree/hyphy/01_genespace/rundir/orthofinder/Results_Dec30/Orthogroups/Orthogroups.GeneCount.tsv
cat $IN | cut -f1-22 | awk '{if ($1=="Orthogroup") {print "Desc\t"$0 } else {print "(null)\t"$0 } }' > orthogroups.genecount.txt
