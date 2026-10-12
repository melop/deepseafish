<?php
require_once(dirname(__FILE__) . "/lib.php");

/*
Modified from Test for monophyly constraints present in monophyly_desc.txt
branch marking styles:
hyphy relax: target NodeName{T}, or (A{T},B{T}){T} . reference {R}, do not use {U}
Codeml style: marks all child branches as foreground: $1 (not used in this script) , marks only the one branch as foreground: #1 
CHANGE: 2026-5-7 only exclude taxa with internal stops , instead of whole gene

Refit gene tree branch length with AA substitutions


*/

$sMonoDesc = "monophyly_desc.txt";
//$sPremadeFasta = "ret_cleanDNA.fasta"; //ret_improved_cleanDNA.fasta
//$sOutDIR = "genetrees";

$sPremadeFasta = "ret_improved_cleanDNA.fasta";
$sOutDIR = "AA_alignments_by_gene";


$nThisPart = 0;
$nTotalPart = 1;

//print_r($oTree);

//$arrMarkBranchesCodeml = array("Nothobranchius" => array(true , "1"), "Callopanchax" => array( true, "1") );
//$arrMarkBranchesHyphy = array("Nothobranchius" => array(true , "T"), "Callopanchax" => array( true, "T"), "Aplocheilidae" => array(true , "U") );

//echo(fnTree2Newick($oTree, array() ) .";\n" );
//echo(fnTree2Newick($oTree, $arrMarkBranchesHyphy, 1) .";\n" );
//echo(fnTree2Newick($oTree, $arrMarkBranchesCodeml, 2) .";\n" );

//Now parse through the premade fasta file

while(count($argv) > 0) {
    $arg = array_shift($argv);
    switch($arg) {
        case '-m':
            $sMonoDesc = trim(array_shift($argv));
            break;
        case '-p':
            $sPremadeFasta = trim(array_shift($argv));
            break;
        case '-o':
            $sOutDIR  = trim(array_shift($argv));
            break;
        case '-N':
            $nTotalPart  = trim(array_shift($argv));
            break;
        case '-f':
            $nThisPart  = trim(array_shift($argv));
            break;

    }
}



exec("mkdir -p $sOutDIR");
$hPremadeFasta = fopen($sPremadeFasta , "r");
$sLn = "";

$sSeqName = "";
$sSeq = "";
$arrFullCodingSeq = array();
$sCurrentGene = "";
$nGeneCount = -1;


do {
	$sLn = fgets($hPremadeFasta);

	if ($sLn==false) {
		fnProcessRecord($sSeqName, $sSeq);
		break;
	}

	$sLn = trim($sLn);
	if (substr($sLn , 0,1) == ">") {
		fnProcessRecord($sSeqName, $sSeq);
		$sSeqName = substr($sLn , 1);
		$sSeq = "";
		
	} else {
		$sSeq .= $sLn;
	}

} while (true);
fnProcessAln($sCurrentGene,$arrFullCodingSeq);


function fnProcessRecord($sSeqName, $sSeq) {
	global $arrFullCodingSeq , $sCurrentGene;
	if (strpos($sSeqName , "direction") !== false  ) {
		return; //don't process fragments
	}

	preg_match("/Ortho:(\S+);Sp:(\S+);MappedToRef:(\S+);SpGeneId:(\S+);GroupId:(\S+)/",  $sSeqName, $arrParsed);
/*
array(6
0	=>	Ortho:0;Sp:AAU;MappedToRef:AAU;SpGeneId:029799;GroupId:Group_0_0
1	=>	0
2	=>	AAU
3	=>	AAU
4	=>	029799
5	=>	Group_0_0
)

*/

	if (count($arrParsed)!=6 ) {
		return;
	}
	$sGeneName = $arrParsed[5];
	$sSpecies = $arrParsed[2];

	if ($sCurrentGene == $sGeneName ) {
		if (!array_key_exists($sSpecies , $arrFullCodingSeq)) {
			$arrFullCodingSeq[$sSpecies] = "";
		}

		$arrFullCodingSeq[$sSpecies] .= $sSeq;
	} else {
		if (count($arrFullCodingSeq) > 0) {
			fnProcessAln($sCurrentGene,$arrFullCodingSeq);
		}
		$arrFullCodingSeq = array();
		$sCurrentGene = $sGeneName;
		$arrFullCodingSeq[$sSpecies] = $sSeq;
	}

}


function fnProcessAln($sGeneName,$arrFullCodingSeq) {
	global $sOutDIR, $sMonoDesc, $nThisPart, $nTotalPart, $nGeneCount,$hOut;

  
	$nGeneCount++;
	if ($nGeneCount % $nTotalPart != $nThisPart) return;


		$arrFullCodingSeq = fnMaskLastStop($arrFullCodingSeq);
		$arrAlnRet = fnTranslateAlignment($arrFullCodingSeq , true); //exclude last stop if exists.
    $arrAAAln = $arrAlnRet["proteins"];
		//Check if all sequences are identical, if so then no need to continue with codeml to save time
		$bDiff = false;
		$sTempSeq = -1;
		foreach($arrFullCodingSeq as $sTaxon => $sSeq) {
			if ($sTempSeq == -1) {
				$sTempSeq = $sSeq;
				continue;
			}
			if ($sTempSeq != $sSeq) {
				$bDiff = true;
				break;
			}
		}

		if (!$bDiff) {
			//fwrite($hOutTable, "$sGeneName\tAll sequences identical.".PHP_EOL);
			echo("$sGeneName : all sequences identical \n");
			//fwrite($hOut , "$sGeneName\tAllSeqIdentical\n");
			return;
		}
			
    $arrRemoveTaxa = array();
    //remove taxa consist of internal stop codons:
    if ($arrAlnRet["stopcodon"]) {
      $arrRemoveTaxa = $arrAlnRet['stoptaxa'];
      echo("Removing the following taxa due to internal stops: ".implode(", ", $arrAlnRet['stoptaxa'])."\n");
    }
		//remove taxa consist of only N's or gaps:
		
		foreach($arrAAAln as $sTaxon => $sSeq) {
			if ( preg_replace("/[N\-n]/", "", $sSeq) == '') {
				$arrRemoveTaxa[] = $sTaxon;
			}
		}

		foreach($arrRemoveTaxa as $sRemoveTaxon) {
      if (array_key_exists($sRemoveTaxon, $arrAAAln)) {
			  unset($arrAAAln[$sRemoveTaxon]);
      }
		}


		//if (!$arrAlnRet["stopcodon"] ) { //there is no stop codon, do raxml ; CHANGE: only exclude taxa with internal stops
			$arrTaxa = array_keys($arrAAAln);
			echo(count($arrTaxa) . " taxa included for $sGeneName \n" );

			

			$sAln = "";
			foreach($arrAAAln as $sTaxon => $sSeq) {
				$sAln .= ">$sTaxon\n" . wordwrap($sSeq, 75, "\n", true) . "\n";
			}

			$hOut = fopen("$sOutDIR/$sGeneName.fasta", 'w');

			fwrite($hOut , $sAln);
			fclose($hOut);

			//die();
	/*	}
		else {
			echo("$sGeneName : internal stop codon found, skip \n");
			fwrite($hOut , "$sGeneName\tStopFound\n");
			return;
		}*/
		


	
}



function fnParseMonoDesc($sIn, $arrIncludeTaxon = true) {
	$hIn = fopen($sIn, 'r');

	$arrMap = array();
	while( false !== ($sLn = fgets($hIn) ) ) {
		$sLn = trim($sLn);
		$arrF = explode("\t" , $sLn);
		if (count($arrF) !=2) continue;
		$arrMap[$arrF[0]] = explode(",", $arrF[1]);
	}

	//print_r($arrMap);
	//now build tree, starting from root:
	$arrTree = fnBuildTree('root', $arrMap , $arrIncludeTaxon);

	return $arrTree;
}

function fnBuildTree($sNodeName, &$arrMap, &$arrIncludeTaxon) {

	$arrTree = array();

	if (!array_key_exists($sNodeName , $arrMap) ) {
    print_r($arrMap);
		die("Node name $sNodeName undefined in map\n");
	}

	$arrChilds = $arrMap[$sNodeName];

	
	foreach($arrChilds as $sChild) {
		$sChild = trim($sChild);
		if ( $sChild[0] == '*' ) { //expand it
			$sChildNodeName = substr($sChild, 1); //delete * from taxon name
			//echo($sChildNodeName."\n");
			$oChildNode = fnBuildTree($sChildNodeName , $arrMap , $arrIncludeTaxon);
			if ( count($oChildNode) > 0 ) {
				$arrTree[$sChildNodeName] = $oChildNode;
			} 
		} else {
			if ($arrIncludeTaxon === true || array_key_exists($sChild, $arrIncludeTaxon) ) {
				$arrTree[$sChild] = true; //terminal taxon
			}
		}
	}

	return $arrTree;
}

function fnTree2Newick(&$oNode , $arrMarkBranches, $nStyle = 0, $bMark=false, $sMark="") { //arrMarkBranches : branch name => array( bMarkChild? , mark) . style 0 - turn off marking. style 1 - hyphy relax, 2 - codeml, $bMark and $sMark are used inernally, do not set
	$sOut = (count($oNode)>1) ? "(" : "";
	$nCount = -1;

	//print_r($arrMarkBranches) ;
	foreach($oNode as $sNodeName => $arrNodeContent) {
		$nCount++;
		if ($nCount > 0) {
			$sOut .= ",";
		}

		$bMarkChild = false;
		$bMarkNode = (array_key_exists($sNodeName , $arrMarkBranches) || $bMark) ;


		if (!$bMark) { //check if instructed to mark

			if ($bMarkNode) {
				$sMark = ($nStyle==1)? '{'.$arrMarkBranches[$sNodeName][1].'}' : ( ($nStyle == 2)? '#'.$arrMarkBranches[$sNodeName][1] : '');
			} 

			//echo("$sNodeName style $nStyle, mark: $sMark\n");
		} else {
			$bMarkChild = true;
		}

		if (array_key_exists($sNodeName , $arrMarkBranches) && $arrMarkBranches[$sNodeName][0] ) {
			$bMarkChild = true;
		}

		if ($arrNodeContent === true) { // terminal node
			$sOut .= $sNodeName;
		} else {
			$sOut .= fnTree2Newick( $arrNodeContent , $arrMarkBranches, $nStyle, $bMarkChild, $sMark );
		}

		if ($bMarkNode) {
			$sOut .= (count($arrNodeContent)>1 || $arrNodeContent === true)? $sMark:'';
		}

		if ( (!$bMarkNode) && $nStyle == 1) {
			$sOut .= (count($arrNodeContent)>1 || $arrNodeContent === true)? '{R}':'';
		}


	}

	$sOut .= (count($oNode)>1) ? ")" : "";

	return $sOut;
}



?>
