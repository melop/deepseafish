#.libPaths("/data/projects/rcui/R/x86_64-pc-linux-gnu-library/4.1")
setwd("/public4/group_crf/home/cuirf/deepsea/cellpaper/hyphy/overlaps/GO");
library(org.Dr.eg.db)
library(tidyr)

#library(org.Hs.eg.db)
library(clusterProfiler)

nFDRCutoff <- 0.1
nRawPCutoff <- 0.05
bRelaxed <- F; #True  - relaxed genes, False - intensified genes
sClade <- "Bassozetus";
sClade <- "Anoplogaster_cornuta";
sClade <- "DeepseaAulopiformes"
sClade <- "DeepseaBeryciformes";
sClade <- "Ilyophis"
sClade <- "Macrourus_sp"
sClade <- "Pachycara"
sClade <- "Pseudoliparis"
sCategory <- 'BP' ; #biological process
datPGID2Ref <- read.table("/public4/group_crf/home/cuirf/deepsea/cellpaper/assigngenesymbols/ortho.filtered.genesymbol.tsv", header = T, stringsAsFactors = F, sep="\t", quote="", na.strings = "")

datRNAID2ZebraFishHuman <- datPGID2Ref[, c("HOG", 'Danio_rerio' ) ];
colnames(datRNAID2ZebraFishHuman) <- c("HOG", 'Zebrafish' );
datRNAID2ZebraFishHuman <- datRNAID2ZebraFishHuman[!is.na(datRNAID2ZebraFishHuman[, 'Zebrafish']) , ];
colnames(datRNAID2ZebraFishHuman)[1] <- "Gene";
datRNAID2ZebraFishHuman$Zebrafish <- gsub("\\.[0-9]+", "", gsub("rna-","", datRNAID2ZebraFishHuman$Zebrafish)) 


datRelax <- read.table(paste0("../relaxret.", sClade, ".tsv"), header=T, sep="\t", fill = T, quote = "")
datRelax$fdr <- p.adjust(datRelax$V5, method = "fdr")

colnames(datRelax)[1] <- "OrthoID"

datOnlyCompHighImpact <- datRNAID2ZebraFishHuman; #merge(datConsurf, datRNAID2ZebraFishHuman, by.x = "Gene", by.y=1 , all.x = T, all.y =F)

datOnlyCompHighImpact <- separate_rows(datOnlyCompHighImpact, "Zebrafish", sep = "," )

datZebrafishTrans2GeneID <- as.data.frame( org.Dr.egREFSEQ2EG)
colnames(datZebrafishTrans2GeneID)[1] <- "ZebrafishGeneID";
colnames(datZebrafishTrans2GeneID)[2] <- "trans_id";

datOnlyCompHighImpact <- merge(datOnlyCompHighImpact, datZebrafishTrans2GeneID, by.x="Zebrafish", by.y = "trans_id", all.x =T, all.y =F);


datZebrafishGOMap <- as.data.frame(org.Dr.egGO)


datMap <- datOnlyCompHighImpact[, c('Gene', "ZebrafishGeneID")]
datMap <- datMap[complete.cases(datMap) , ];

datMap <- merge(datMap, datZebrafishGOMap[datZebrafishGOMap$Ontology == sCategory,1:2], by.y="gene_id", by.x="ZebrafishGeneID", all.x=T, all.y=F )
datMap <- datMap[complete.cases(datMap) , c(3,2)];

datMap <- datMap[!duplicated(datMap),];

colnames(datMap) <- c("term", "gene");

#get gene symbol map
datZebrafishSymbolMap <- as.data.frame(org.Dr.egSYMBOL)

datSymbol <- datOnlyCompHighImpact[, c('Gene', "ZebrafishGeneID")]
datSymbol <- datSymbol[complete.cases(datSymbol) , ];
datSymbol <- merge(datSymbol, datZebrafishSymbolMap[,1:2], by.y="gene_id", by.x="ZebrafishGeneID", all.x=T, all.y=F )
datSymbol <- datSymbol[complete.cases(datSymbol) , c(3,2)];
datSymbol <- datSymbol[!duplicated(datSymbol),];

fnAddGeneSymbols <- function(datOut) {
  arrSymbolStr <- c();
  if (nrow(datOut) ==0) {
    return(datOut)
  }
  for(nRow in 1:nrow(datOut)) {
    
    arrPGIDs <- unlist(strsplit(datOut$geneID[nRow] ,'/'));
    arrGeneSymbols <- datSymbol[datSymbol$Gene %in% arrPGIDs, 1];
    sStr <- "";
    if (length(arrGeneSymbols)>0) {
      sStr <- paste(arrGeneSymbols, collapse = '/');
    }
    arrSymbolStr <- c(arrSymbolStr, sStr);
  }
  datOut$genesymbols <- arrSymbolStr;
  return(datOut)
}
#get gene symbol

#for(sHap in arrSamples) {
  
  arrIsRelaxed <- datRelax$V9 < 1;
  sRelaxed <- "relaxed";
  if ( ! bRelaxed ) {
    arrIsRelaxed <- datRelax$V9 > 1;
    sRelaxed <- "intensified";
  }
  arrTargetGenes <- unique(datRelax[ datRelax$V5<= nRawPCutoff & datRelax$fdr <= nFDRCutoff & arrIsRelaxed , 'OrthoID']);
  oEnrichRet <- enricher(
    as.character(arrTargetGenes),
    pvalueCutoff = 0.05,
    pAdjustMethod = "BH",
    as.character(unique(datRelax[ , 'OrthoID'])),
    minGSSize = 10,
    maxGSSize = 500,
    qvalueCutoff = 1,
    TERM2GENE = datMap ,
    TERM2NAME = go2term(unique(datMap$term) )
  )
  
  sOut <- paste0(sRelaxed , "_",sClade, "_fdr_", nFDRCutoff, "_p_", nRawPCutoff, "_GO_",sCategory,".txt");
  datOut <- oEnrichRet@result[ oEnrichRet@result$p.adjust <=1, ]
 # View(fnAddGeneSymbols(datOut))
  write.table(fnAddGeneSymbols(datOut), file=sOut, quote = F, sep="\t", col.names = T, row.names = F);
#}


