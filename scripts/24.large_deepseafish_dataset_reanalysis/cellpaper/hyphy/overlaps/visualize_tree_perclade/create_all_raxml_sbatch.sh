fasconcat=`realpath FASconCAT_v1.11.pl`
CPU=30
for i in clade/*/*/; do 
echo $i; 
 sO=$i/raxml.sbatch
  echo "#!/usr/bin/bash" > $sO
  echo "#SBATCH -p blade,gpu" >> $sO
  echo "#SBATCH -c $CPU" >> $sO
  echo "/public/software/raxml/standard-RAxML/raxmlHPC-PTHREADS-AVX -T $CPU -t ../../../tree.newick -s FcC_smatrix.fas -m PROTGAMMAJTTX -f e -n output" >> $sO
done

