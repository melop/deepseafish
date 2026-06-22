<?php
//reformat N1.tsv to remove all spaces within sequence names
$sIn = "highqual/OrthoFinder/Results_Apr29/Phylogenetic_Hierarchical_Orthogroups/N1.tsv";
$sOut = "N1.simp.tsv";

$h = fopen($sIn, 'r');
$hO = fopen($sOut, 'w');

while(false !== ($sLn = fgets($h))) {
	$sLn = trim($sLn, "\n\r");
	$arrF = explode("\t", $sLn);
	$arrO = array();
	foreach($arrF as $i => $v) {
		$arrGenes = explode(",", $v);
		$arrGenesClean = array();
		foreach($arrGenes as $sGeneID) {
			list($sFirstID) = explode(" ", trim($sGeneID));
			$arrGenesClean[] = $sFirstID;
		}
		$arrO[$i] = implode(",", $arrGenesClean);
	}

	fwrite($hO, implode("\t", $arrO)."\n");
}

?>
