mkdir -p optm_brln_trees
for i in clade/*/*/RAxML_result.output; do
	sD=`dirname $i`
	sParam=`basename $sD`
	sSp=`dirname $sD`
	sSp=`basename $sSp`
	echo $sParam
	echo $sSp
	ln -sf `realpath $i` optm_brln_trees/$sSp.$sParam.tre
done
