<?php
//match the HOG ID between two different runs
$sOldList = "N1.simp.maskedparalogspp.tsv";
$sNewList = "N1.simp.hadalrattail.maskedparalogspp.tsv";
$sOut = "N1.simp.hadalrattail.maskedparalogspp.HOGID.matched.list";
$sOutList = "N1.simp.hadalrattail.maskedparalogspp.HOGID.matched.tsv";
$hO = popen("sort -k1,1 -k3,3nr > $sOut", "w");
$hOList = fopen($sOutList, 'w');
$oOldMeta = array();
$arrOldHOGList = fnGetVotes($sOldList, true);
$arrNewHOGList = fnGetVotes($sNewList);
$nMinLink = 10; //liftover HOG if min link exceeds this


$arrLinkMap = array();

foreach($arrOldHOGList as $sSpGene => $sOldHOG) {

  if (!array_key_exists($sSpGene, $arrNewHOGList)) {
    continue;
  }
  
  if (!array_key_exists($sOldHOG, $arrLinkMap)) {
    $arrLinkMap[$sOldHOG] = array();
  }
  
  $sNewHOG = $arrNewHOGList[$sSpGene];
  if (!array_key_exists($sNewHOG, $arrLinkMap[$sOldHOG])) {
    $arrLinkMap[$sOldHOG][$sNewHOG] = 0;
  }
  
  $arrLinkMap[$sOldHOG][$sNewHOG] += 1;
}

$arrPrunedLinkMap = array();

foreach($arrLinkMap as $sOldHOG => $oInfo) {
  foreach($oInfo as $sNewHOG => $nCount) {
    fwrite($hO, "$sOldHOG\t$sNewHOG\t$nCount\n");
    if ($nCount < $nMinLink) continue;
    if (!array_key_exists($sNewHOG, $arrPrunedLinkMap)) {
      $arrPrunedLinkMap[$sNewHOG] = array('linkcount' => 0, 'OldHOG' => '');
    }
    if ($arrPrunedLinkMap[$sNewHOG]['linkcount'] < $nCount) {
      $arrPrunedLinkMap[$sNewHOG]['linkcount'] = $nCount;
      $arrPrunedLinkMap[$sNewHOG]['OldHOG'] = $sOldHOG;
    }
  } 
}

echo("Mapped ".count($arrPrunedLinkMap)." HOGs between runs\n");
//print_r($arrPrunedLinkMap);
$hNewList = fopen($sNewList, 'r');
while(false !== ($sLn = fgets($hNewList))) {
		$sLn = trim($sLn);
		if ($sLn == '') continue;
    $arrF = explode("\t", $sLn);
    if ($arrF[0] == "HOG") {
      fwrite($hOList, implode("\t", $arrF)."\n");
    } else {
      $sNewHOG = $arrF[0];
      if (!array_key_exists($sNewHOG, $arrPrunedLinkMap)) continue;
      if ($arrPrunedLinkMap[$sNewHOG]['linkcount'] == 0) continue;
      $arrF[0] = $arrPrunedLinkMap[$sNewHOG]['OldHOG'];
      $arrF[1] = $oOldMeta[$arrF[0]][0];
      $arrF[2] = $oOldMeta[$arrF[0]][1];
      fwrite($hOList, implode("\t", $arrF)."\n");
    }
}


function fnGetVotes($sF, $bGetOldInfo=false) {
  global $oOldMeta;
  
	$h = fopen($sF, 'r');
	$arrRet = array();
  $arrSp = array();
	while(false !== ($sLn = fgets($h))) {
		$sLn = trim($sLn);
		if ($sLn == '') continue;
		$arrF = explode("\t", $sLn);
		if ($arrF[0] == "HOG") {
			$arrSp = array_slice($arrF, 3 );
			continue;
		}

    if ($bGetOldInfo) {
      $oOldMeta[$arrF[0]] = array_slice($arrF, 1,2);
    }
    
		$arrGenes = array_slice($arrF, 3 );
   
    foreach($arrGenes as $nIdx => $sGeneID) {
      if ($sGeneID == 'NA') continue;
      $sSp = $arrSp[$nIdx];
      $arrRet[$sSp.":".$sGeneID] = $arrF[0];
    }
	}

	return $arrRet;
}
?>
