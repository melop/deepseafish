fasconcat=`realpath FASconCAT_v1.11.pl`
for i in clade/*/*/; do 
echo $i; 
  ( cd $i; perl $fasconcat -s )>$i/fasconcat.log 2>&1 &
done
wait
