for i in clade/*/*/; do 
echo $i; 
 ( cd $i; sbatch raxml.sbatch; )
 sleep 2
done
