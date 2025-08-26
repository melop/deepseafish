<?php
$sRunDir = "rundir";
$bSortScfAsNum = true; // sort scffold name as number

/*
$sScfPrefix = ""; //to be removed from scaffold names, leaving only numbers
$sSp = "Betta_splendens";
$sVersion = "104";
$sLongestIsoformProt = "/data/projects/rcui/macropodus_compare/ensembl/betta/longest_isoform.prot.fa";
*/
/*
$bSortScfAsNum = false;
$sScfPrefix = ""; //to be removed from scaffold names, leaving only numbers
$sSp = "Channa_argus";
$sVersion = "104";
$sLongestIsoformProt = "/data/projects/rcui/macropodus_compare/ensembl/channa_argus/longest_isoform.prot.fa";
*/

$sScfPrefix = "pachyScf_"; //to be removed from scaffold names, leaving only numbers
$sSp = "5Pachycara_sp";
$sVersion = "1";
$sLongestIsoformProt = "/data2/projects/dyao/compare/gene_loss_all_new/07_cart4_synteny/00_species_cart4synteny/5Pachycara_sp/5Pachycara_sp.longest_isoform.prot.fa";

/*
$sScfPrefix = "BassoScf_"; //to be removed from scaffold names, leaving only numbers
$sSp = "3Bassozetus_sp";
$sVersion = "1";
$sLongestIsoformProt = "/data2/projects/dyao/compare/gene_loss_all_new/07_cart4_synteny/00_species_cart4synteny/3Bassozetus_sp/3Bassozetus_sp.longest_isoform.prot.fa";
*/

$sWD = "$sRunDir/rawGenomes/$sSp/$sVersion/annotation";
exec("mkdir -p $sWD");

$hGFF = false;
if ($bSortScfAsNum) {
	$hGFF = popen("sort -k1,1n -k4,4n | gzip -c > $sWD/$sSp.gene.gff.gz", 'w');
} else {
	$hGFF = popen("sort -k1,1 -k4,4n | gzip -c > $sWD/$sSp.gene.gff.gz", 'w');
}

$hFas = popen("gzip -c > $sWD/$sSp.pep.fa.gz", 'w');

$hIn = popen("zcat -f $sLongestIsoformProt", 'r');

while(false!== ($sLn = fgets($hIn) )) {
	$sLn = trim($sLn);
	if ($sLn == '') {
		continue;
	}

	if ($sLn[0] == '>') {
		$arrF = explode(' ', substr($sLn, 1));
		$sSeqName = $arrF[0];
		$sSeqName = preg_replace('/[:|]/', '_', $sSeqName);
		$sPos = $arrF[count($arrF)-1];
		preg_match('/([^:]+):([^-]+)-([^(]+)\\((\\S)\\)/', $sPos, $arrM);
		if (count($arrM) != 5) {
			die("Failed to parse header: $sLn\n");
		}

		list($sChr, $nStart, $nEnd, $sOrient) = array_slice($arrM, 1);
		$sChr = str_replace($sScfPrefix, '', $sChr);
		fwrite($hGFF, "$sChr\tfunannotate\tgene\t$nStart\t$nEnd\t\t$sOrient\t\tlocus=$sSeqName\n");
		fwrite($hFas, ">$sSeqName\n");
	} else {
		$sLn = str_replace('*', '', $sLn);
		fwrite($hFas, $sLn."\n");
	}

	
}

?>
