<?php
//reformat N1.simp.tsv to mask a species if it contains more than one gene copy
$sIn = "N1.simp.tsv";
$sOut = "N1.simp.maskedparalogspp.tsv";

$h = fopen($sIn, 'r');
$hO = fopen($sOut, 'w');

while(false !== ($sLn = fgets($h))) {
	$sLn = trim($sLn, "\n\r");
	$arrF = explode("\t", $sLn);
	$arrO = array();
	foreach($arrF as $i => $v) {
		$arrGenes = explode(",", $v);
		if (count($arrGenes)>1) {
			$arrO[$i] = 'NA';
		} else if (count($arrGenes)==1 && $arrGenes[0]!="") {
			$arrO[$i] = $arrGenes[0];
		} else {
			$arrO[$i] = 'NA';
		}

	}

	fwrite($hO, implode("\t", $arrO)."\n");
}

?>
