setwd("/data2/projects/dyao/compare/hyphy/06_relax_genespace_Basso/GO");
.libPaths("/data/projects/rcui/R/x86_64-pc-linux-gnu-library/4.1")
library(org.Dr.eg.db)
library(org.Hs.eg.db)
library(clusterProfiler)
library(enrichplot)
library(ggplot2)

nFDRCutoff <- 0.05
nRawPCutoff <- 0.05
bRelaxed <- T; #True  - relaxed genes, False - intensified genes
sRefSp <- "BassozetusSp";
sCategory <- 'BP' ; #biological process
datPGID2Ref <- read.table("/data2/projects/dyao/compare/hyphy/01_genespace_forGO/synorthos.txt", header = T, stringsAsFactors = F)

datRNAID2ZebraFishHuman <- datPGID2Ref[, c(sRefSp, paste0(sRefSp,'.1'), 'Human', 'Human.1', 'Zebrafish', 'Zebrafish.1') ];
datRNAID2ZebraFishHuman[is.na(datRNAID2ZebraFishHuman[, sRefSp]) , sRefSp ] <- datRNAID2ZebraFishHuman[is.na(datRNAID2ZebraFishHuman[, sRefSp]) , paste0(sRefSp,'.1') ]
datRNAID2ZebraFishHuman[is.na(datRNAID2ZebraFishHuman[, 'Human']) , 'Human' ] <- datRNAID2ZebraFishHuman[is.na(datRNAID2ZebraFishHuman[, "Human"]) , 'Human.1' ]
datRNAID2ZebraFishHuman[is.na(datRNAID2ZebraFishHuman[, 'Zebrafish']) , 'Zebrafish' ] <- datRNAID2ZebraFishHuman[is.na(datRNAID2ZebraFishHuman[, 'Zebrafish']) , 'Zebrafish.1' ]
datRNAID2ZebraFishHuman <- datRNAID2ZebraFishHuman[, c(sRefSp, 'Human', 'Zebrafish') ]
datRNAID2ZebraFishHuman <- datRNAID2ZebraFishHuman[!is.na(datRNAID2ZebraFishHuman[,sRefSp]) , ];
datRNAID2ZebraFishHuman <- datRNAID2ZebraFishHuman[!(is.na(datRNAID2ZebraFishHuman[, 'Human']) & is.na(datRNAID2ZebraFishHuman[, 'Zebrafish']) ), ];
datRNAID2ZebraFishHuman$Human <- sub(";.*", "", datRNAID2ZebraFishHuman$Human)
datRNAID2ZebraFishHuman$Zebrafish <- sub(";.*", "", datRNAID2ZebraFishHuman$Zebrafish)

colnames(datRNAID2ZebraFishHuman)[1] <- "Gene";

datRelax <- read.table("../sum_Basso.txt", header=F, sep="\t", fill = T, quote = "")
datRelax$fdr <- p.adjust(datRelax$V5, method = "fdr")

datGroupID2TransID <- read.table("/data2/projects/dyao/compare/hyphy/04_exportAln_genespace/groupid2transid.Basso.txt", sep="\t", header=T)
colnames(datGroupID2TransID) <- c("OrthoID", 'Gene');
datRelax <- merge(datRelax, datGroupID2TransID, by.x = "V1", by.y="OrthoID", all.x=T, all.y=F)
write.table(datRelax, file="relax.fdr1.tsv", sep="\t" , col.names=T, row.names=F, quote=F);
datOnlyCompHighImpact <- datRNAID2ZebraFishHuman; #merge(datConsurf, datRNAID2ZebraFishHuman, by.x = "Gene", by.y=1 , all.x = T, all.y =F)

datZebrafishTrans2GeneID <- as.data.frame( org.Dr.egENSEMBLTRANS)
colnames(datZebrafishTrans2GeneID)[1] <- "ZebrafishGeneID";

datOnlyCompHighImpact <- merge(datOnlyCompHighImpact, datZebrafishTrans2GeneID, by.x="Zebrafish", by.y = "trans_id", all.x =T, all.y =F);



datHumanTrans2GeneID <- as.data.frame( org.Hs.egENSEMBLTRANS)
colnames(datHumanTrans2GeneID)[1] <- "HumanGeneID";


datOnlyCompHighImpact <- merge(datOnlyCompHighImpact, datHumanTrans2GeneID, by.x="Human", by.y = "trans_id", all.x =T, all.y =F);

datHumanGOMap <- as.data.frame(org.Hs.egGO)
datZebrafishGOMap <- as.data.frame(org.Dr.egGO)


datMap <- datOnlyCompHighImpact[, c('Gene', "ZebrafishGeneID")]
datMap <- datMap[complete.cases(datMap) , ];

datMap <- merge(datMap, datZebrafishGOMap[datZebrafishGOMap$Ontology == sCategory,1:2], by.y="gene_id", by.x="ZebrafishGeneID", all.x=T, all.y=F )
datMap <- datMap[complete.cases(datMap) , c(3,2)];

datMapHs <- datOnlyCompHighImpact[, c('Gene', "HumanGeneID")]
datMapHs <- datMapHs[complete.cases(datMapHs) , ];

datMapHs <- merge(datMapHs, datHumanGOMap[datHumanGOMap$Ontology ==sCategory ,1:2], by.y="gene_id", by.x="HumanGeneID", all.x=T, all.y=F )
datMapHs <- datMapHs[complete.cases(datMapHs) , c(3,2)];

datMap <- rbind(datMap, datMapHs);

datMap <- datMap[!duplicated(datMap),];

colnames(datMap) <- c("term", "gene");

#get gene symbol map
datHumanSymbolMap <- as.data.frame(org.Hs.egSYMBOL)
datZebrafishSymbolMap <- as.data.frame(org.Dr.egSYMBOL)

datSymbol <- datOnlyCompHighImpact[, c('Gene', "ZebrafishGeneID")]
datSymbol <- datSymbol[complete.cases(datSymbol) , ];
datSymbol <- merge(datSymbol, datZebrafishSymbolMap[,1:2], by.y="gene_id", by.x="ZebrafishGeneID", all.x=T, all.y=F )
datSymbol <- datSymbol[complete.cases(datSymbol) , c(3,2)];

datSymbolHs <- datOnlyCompHighImpact[, c('Gene', "HumanGeneID")]
datSymbolHs <- datSymbolHs[complete.cases(datSymbolHs) , ];
datSymbolHs <- merge(datSymbolHs, datHumanSymbolMap[,1:2], by.y="gene_id", by.x="HumanGeneID", all.x=T, all.y=F )
datSymbolHs <- datSymbolHs[complete.cases(datSymbolHs) , c(3,2)];

datSymbol <- rbind(datSymbol , datSymbolHs[ !(datSymbolHs$Gene %in% datSymbol$Gene),] );
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
  arrTargetGenes <- unique(datRelax[ datRelax$V5<= nRawPCutoff & datRelax$fdr <= nFDRCutoff & arrIsRelaxed , 'Gene']);
  ego <- enricher(
    as.character(arrTargetGenes),
    pvalueCutoff = 0.05,
    pAdjustMethod = "BH",
    as.character(unique(datRelax[ , 'Gene'])),
    minGSSize = 10,
    maxGSSize = 500,
    qvalueCutoff = 1,
    TERM2GENE = datMap ,
    TERM2NAME = go2term(unique(datMap$term) )
  )
  
  
  
  datOut <- ego@result[ ego@result$p.adjust <=1, ]
  View(fnAddGeneSymbols(datOut))
  filterego <- fnAddGeneSymbols(datOut)
  #top_10_filtered_ego <- head(filterego, 10)
  top_10_filtered_ego <- filterego[c(1:5, 11, 14, 16, 26, 28, 30), ]

  sorted_ego <- top_10_filtered_ego[order(-top_10_filtered_ego$pvalue), ]
  par(mar = c(5, 20, 8, 2))
  barplot(sorted_ego$Count, names.arg = sorted_ego$Description, horiz = TRUE, col = "skyblue", main = "Top 10 EnrichmentGO_BP_barplot")

  # 调整文字方向为水平
  par(las = 2)
  
  
  colors <- colorRampPalette(c("red", "blue"))(20)   # 20为颜色级别，可以根据需要调整
  
  # 映射 p.adjust 到颜色渐变
  color_index <- cut(sorted_ego$pvalue, breaks = 20, labels = FALSE)
  
  # 调整边距
  par(mar = c(5, 28, 4, 8))  # 增加 right 参数
  
  # 使用 barplot 函数绘制横向的条形图，根据 p.adjust 显示颜色深浅
  barplot(sorted_ego$Count, names.arg = sorted_ego$Description, horiz = TRUE, col = colors[color_index], main = "EnrichmentGO_BP", cex.axis = 1.5, cex.names = 1.5, xlim = c(0, 50))

  

