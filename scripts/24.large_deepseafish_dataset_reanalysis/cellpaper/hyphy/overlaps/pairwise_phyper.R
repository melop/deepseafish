setwd("/public4/group_crf/home/cuirf/deepsea/cellpaper/hyphy/overlaps")
library(pheatmap)
library(stringr)
nPCutoff <- 0.05;
nFDRCutoff <- 0.1;
nAsteriksCutoff <- log10(0.05)
sPlotVal <- "PHyper" #"PHyper"; #"PHyperFDR"
sPlotValAA <- "PHyperAA"; #"PHyperAA"; #"PHyperFDR"
bOutputRelaxTable <- F;

sAAConvergePrefix <- "../../AA_Convergence/annotate_aa_changes."
sAAConvergeSuffix <- "/ret_minintaxaPerc0.3.maxAAout4.part0.of.1.txt";
#sAAConvergeSuffix <- "/ret_minintaxaPerc1.maxAAout4.part0.of.1.txt";

arrCladeDirs <- Sys.glob("../Relax_*")
arrClades <- unlist(str_split(arrCladeDirs, "Relax_"))
arrClades <- arrClades[!grepl("bak",arrClades)]
arrClades <- arrClades[seq(2,length(arrClades),2)]

names(arrCladeDirs) <- arrClades

lsRelaxRet <- list();
for (sClade in arrClades) {
  sCladeDir <- arrCladeDirs[sClade];
  oConn <- pipe(paste0("zcat -f ", sCladeDir, "/Relax_*/ret*"), open="r" );
  lsRelaxRet[[sClade]] <- read.table(file=oConn, header=F, sep="\t", quote="", fill=T);
  lsRelaxRet[[sClade]] <- lsRelaxRet[[sClade]][!is.na(lsRelaxRet[[sClade]]$V5), ]
  lsRelaxRet[[sClade]]$fdr <- p.adjust(lsRelaxRet[[sClade]]$V5, method = "fdr")
  if (bOutputRelaxTable) {
  write.table(lsRelaxRet[[sClade]], file = paste0("relaxret.",sClade, ".tsv") , sep="\t", col.names = T, row.names = F, quote = F)
  }
}
#View(lsRelaxRet[[arrClades[1]]])
# length(lsRelaxRet[[arrClades[1]]]$V1)
# length(unique(lsRelaxRet[[arrClades[1]]]$V1))

fnHyperTestGenes <- function(arrTarget1, arrUniverse1, arrTarget2, arrUniverse2 ) {
  arrAllUniverse <- intersect(arrUniverse1, arrUniverse2)
  #get them to the same universe
  arrTarget1 <- arrTarget1[arrTarget1 %in% arrAllUniverse]
  arrTarget2 <- arrTarget2[arrTarget2 %in% arrAllUniverse]
  nIntersect <- length(intersect(arrTarget1, arrTarget2))
  nP <- phyper(nIntersect-1, length(arrTarget2), length(arrAllUniverse)-length(arrTarget2), length(arrTarget1) ,lower.tail = F )
  #print(paste0("phyper(", nIntersect-1 , ", ", length(arrTarget2) , ",", length(arrAllUniverse)-length(arrTarget2), ",",  length(arrTarget1), " )"));
  return(list(length(arrAllUniverse), length(arrTarget1), length(arrTarget2), nIntersect, nP ))
}

datRet <- NULL;
for(nClade1 in 1:length(arrClades)) {
  sClade1 <- arrClades[nClade1];
  datRelax1 <- lsRelaxRet[[sClade1]];
  arrRelax1 <- datRelax1[datRelax1$V5 < nPCutoff & datRelax1$V9 < 1 & datRelax1$fdr < nFDRCutoff, 'V1'];
  arrIntense1 <- datRelax1[datRelax1$V5 < nPCutoff & datRelax1$V9 > 1 & datRelax1$fdr < nFDRCutoff, 'V1'];
  arrUniverse1 <- datRelax1$V1;
  
  for(nClade2 in 2:length(arrClades)) {
    if (nClade1 >= nClade2) {
      next;
    }
    
    sClade2 <- arrClades[nClade2];
    datRelax2 <- lsRelaxRet[[sClade2]];
    arrRelax2 <- datRelax2[datRelax2$V5 < nPCutoff & datRelax2$V9 < 1 & datRelax2$fdr < nFDRCutoff, 'V1'];
    arrIntense2 <- datRelax2[datRelax2$V5 < nPCutoff & datRelax2$V9 > 1 & datRelax2$fdr < nFDRCutoff, 'V1'];
    arrUniverse2 <- datRelax2$V1;
    
    arrHyperTestRelax <- fnHyperTestGenes(arrRelax1, arrUniverse1, arrRelax2, arrUniverse2);
    arrHyperTestIntense <- fnHyperTestGenes(arrIntense1, arrUniverse1, arrIntense2, arrUniverse2);
    
    #Read in AA Convergence file
    sGenus1 <- unlist(str_split(sClade1,pattern = "_"))[1]
    sGenus2 <- unlist(str_split(sClade2,pattern = "_"))[1]
    sAAConverge <- paste0(sAAConvergePrefix, sGenus1, ".", sGenus2, sAAConvergeSuffix);
    if (!file.exists(sAAConverge)) {
      sAAConverge <- paste0(sAAConvergePrefix, sGenus2, ".", sGenus1, sAAConvergeSuffix);
      if (!file.exists(sAAConverge)) {
        cat("Error: ", sAAConverge, " does not exist\n")
      }
    }
    
    datAAconverge <- read.table(sAAConverge, header=F, sep="\t")
    arrGenesAAConverge <- datAAconverge$V1
    
    
    arrRelaxBoth <- intersect(arrRelax1, arrRelax2 );
    arrIntenseBoth <- intersect(arrIntense1, arrIntense2)
    arrUniverse <- intersect(arrUniverse1, arrUniverse2)
    
    arrHyperTestRelaxAA <- fnHyperTestGenes(arrGenesAAConverge ,arrUniverse , arrRelaxBoth ,  arrUniverse);
    arrHyperTestIntenseAA <- fnHyperTestGenes(arrGenesAAConverge , arrUniverse, arrIntenseBoth , arrUniverse);
    
    
    datRelaxRet <- data.frame("Clade1" = sClade1, 
                             "Clade2" = sClade2, 
                             "Type" = "Relaxed", 
                             "Count1" = length(arrRelax1), 
                             "Universe1" = length(arrUniverse1) , 
                             "Count2" = length(arrRelax2), 
                             "Universe2" = length(arrUniverse2) ,
                             "CommonCount1" = arrHyperTestRelax[[2]], 
                             "CommonCount2" = arrHyperTestRelax[[3]], 
                             "Intersect" = arrHyperTestRelax[[4]], 
                             "CommonUniverse" = arrHyperTestRelax[[1]],
                             "PHyper" = arrHyperTestRelax[[5]],
                             "AAConvergeGeneCount" = length(arrGenesAAConverge), 
                             "CommonAAConvergeGeneCount" = arrHyperTestRelaxAA[[2]], 
                             "CommonIntersectCount" = arrHyperTestRelaxAA[[3]], 
                             "AAConvergeAndRelaxIntenseConverge" = arrHyperTestRelaxAA[[4]], 
                             "CommonUniverseAA" = arrHyperTestRelaxAA[[1]],
                             "PHyperAA" = arrHyperTestRelaxAA[[5]]
                             
                             )
    
    datIntensifiedRet <- data.frame("Clade1" = sClade1, 
                              "Clade2" = sClade2, 
                              "Type" = "Intensified", 
                              "Count1" = length(arrIntense1), 
                              "Universe1" = length(arrUniverse1) , 
                              "Count2" = length(arrIntense2), 
                              "Universe2" = length(arrUniverse2) ,
                              "CommonCount1" = arrHyperTestIntense[[2]], 
                              "CommonCount2" = arrHyperTestIntense[[3]], 
                              "Intersect" = arrHyperTestIntense[[4]], 
                              "CommonUniverse" = arrHyperTestIntense[[1]],
                              "PHyper" = arrHyperTestIntense[[5]],
                              "AAConvergeGeneCount" = length(arrGenesAAConverge), 
                              "CommonAAConvergeGeneCount" = arrHyperTestIntenseAA[[2]], 
                              "CommonIntersectCount" = arrHyperTestIntenseAA[[3]], 
                              "AAConvergeAndRelaxIntenseConverge" = arrHyperTestIntenseAA[[4]], 
                              "CommonUniverseAA" = arrHyperTestIntenseAA[[1]],
                              "PHyperAA" = arrHyperTestIntenseAA[[5]]
                              )
    
    datRet <- rbind(datRet, datRelaxRet)
    datRet <- rbind(datRet, datIntensifiedRet)
    
  }
}

#View(datRet)
datRet$PHyperFDR <- p.adjust(datRet$PHyper, method = "fdr")
datRet$PHyperAAFDR <- p.adjust(datRet$PHyperAA, method = "fdr")

datMatrix <- datMatrixAA <- matrix(data=0, nrow = length(arrClades), ncol= length(arrClades) )
colnames(datMatrixAA) <- rownames(datMatrixAA) <- colnames(datMatrix) <- rownames(datMatrix) <- arrClades;
nExtremeVal <- 0;
nExtremeValAA <- 0;
for(i in 1:nrow(datRet)) {
  sTaxon1 <- datRet[i, 'Clade2'];
  sTaxon2 <- datRet[i, 'Clade1'];
  nVal <- log10(datRet[i, sPlotVal]);
  nValAA <- log10(datRet[i, sPlotValAA]);
  
  nExtremeVal <- max(nExtremeVal, abs(nVal));
  nExtremeValAA <- max(nExtremeValAA, abs(nValAA));
  
  if(datRet[i, 'Type'] == "Intensified") {
    sTaxon1 <- datRet[i, 'Clade1'];
    sTaxon2 <- datRet[i, 'Clade2'];
    nVal <- -log10(datRet[i, sPlotVal]);
    nValAA <- -log10(datRet[i, sPlotValAA]);
  }
  
  datMatrix[sTaxon1, sTaxon2 ] <- nVal;
  datMatrixAA[sTaxon1, sTaxon2 ] <- nValAA;
  
}

datText <- datMatrix
datText[datMatrix> -nAsteriksCutoff] <- paste0("*-",signif(datMatrix[datMatrix> -nAsteriksCutoff], 2) )
datText[datMatrix<= -nAsteriksCutoff & datMatrix>=0 ] <- paste0("-",signif(datMatrix[datMatrix <= -nAsteriksCutoff & datMatrix>=0],2 ) )
datText[datMatrix < nAsteriksCutoff] <- paste0("*",signif(datMatrix[datMatrix < nAsteriksCutoff],2))
datText[datMatrix>=nAsteriksCutoff & datMatrix<=0 ] <- paste0("",signif(datMatrix[datMatrix>=nAsteriksCutoff & datMatrix<=0 ],2 ) )
diag(datText)  <- "-"


datTextAA <- datMatrixAA
datTextAA[datMatrixAA> -nAsteriksCutoff] <- paste0("*-",signif(datMatrixAA[datMatrixAA> -nAsteriksCutoff], 2) )
datTextAA[datMatrixAA<= -nAsteriksCutoff & datMatrixAA>=0 ] <- paste0("-",signif(datMatrixAA[datMatrixAA <= -nAsteriksCutoff & datMatrixAA>=0],2 ) )
datTextAA[datMatrixAA < nAsteriksCutoff] <- paste0("*",signif(datMatrixAA[datMatrixAA < nAsteriksCutoff],2))
datTextAA[datMatrixAA>=nAsteriksCutoff & datMatrixAA<=0 ] <- paste0("",signif(datMatrixAA[datMatrixAA>=nAsteriksCutoff & datMatrixAA<=0 ],2 ) )
diag(datTextAA)  <- "-"


custom_font_color <- matrix(
  ifelse(abs(datMatrix) > -nAsteriksCutoff, "black", "darkgrey"),
  nrow = nrow(datMatrix)
)

custom_font_colorAA <- matrix(
  ifelse(abs(datMatrixAA) > -nAsteriksCutoff, "black", "darkgrey"),
  nrow = nrow(datMatrixAA)
)

pdf(file=paste0("hypertest.relaxP", nPCutoff, ".relaxFDR", nFDRCutoff  , ".", sPlotVal, ".", sPlotValAA, ".matrix.pdf"), width=6, height = 6)

#arrScaleBreaks <- seq(-nExtremeVal, nExtremeVal, length.out=100);
arrScaleBreaks <- seq(-15,15,length.out=100)

pheatmap(datMatrix,scale = "none", number_color = custom_font_color, fontsize_number = 12, display_numbers = datText, cluster_rows = FALSE, 
         cluster_cols = FALSE, colorRampPalette(c("#002099", "white", "#992000"))(100), breaks=arrScaleBreaks )

#arrScaleBreaksAA <- seq(-nExtremeValAA, nExtremeValAA, length.out=100)
arrScaleBreaksAA <- seq(-15,15,length.out=100)
pheatmap(datMatrixAA,scale = "none", number_color = custom_font_colorAA, fontsize_number = 12, display_numbers = datTextAA, cluster_rows = FALSE, 
         cluster_cols = FALSE, colorRampPalette(c("#002099", "white", "#992000"))(100), breaks=arrScaleBreaksAA )


arrRelaxIntersectP <- datRet$PHyper[datRet$Type=="Relaxed"]
arrIntenIntersectP <- datRet$PHyper[datRet$Type=="Intensified"]
datCompareIntersectP <- data.frame(relaxP=arrRelaxIntersectP, intenseP=arrIntenIntersectP);
datCompareIntersectP <- datCompareIntersectP[log10(datCompareIntersectP$relaxP) < nAsteriksCutoff | log10(datCompareIntersectP$intenseP) < nAsteriksCutoff , ]
datCompareIntersectP$pDiff <- datCompareIntersectP$relaxP - datCompareIntersectP$intenseP
hist(datCompareIntersectP$pDiff, breaks=5, xlim = c(-1,1), main="", xlab = "Hypergeometric P(Relax - Intense)", col="#992510");
median(datCompareIntersectP$pDiff);
mean(datCompareIntersectP$pDiff);

wilcox.test(datCompareIntersectP$relaxP, datCompareIntersectP$intenseP, paired = T)




arrRelaxIntersectP <- datRet$PHyperAA[datRet$Type=="Relaxed"]
arrIntenIntersectP <- datRet$PHyperAA[datRet$Type=="Intensified"]
datCompareIntersectP <- data.frame(relaxP=arrRelaxIntersectP, intenseP=arrIntenIntersectP);
datCompareIntersectP <- datCompareIntersectP[log10(datCompareIntersectP$relaxP) < nAsteriksCutoff | log10(datCompareIntersectP$intenseP) < nAsteriksCutoff , ]
datCompareIntersectP$pDiff <- datCompareIntersectP$relaxP - datCompareIntersectP$intenseP
hist(datCompareIntersectP$pDiff, breaks=5, xlim = c(-1,1), main="", xlab = "Hypergeometric P(Relax - Intense)", col="#992510");
median(datCompareIntersectP$pDiff);
mean(datCompareIntersectP$pDiff);

wilcox.test(datCompareIntersectP$relaxP, datCompareIntersectP$intenseP, paired = T)



dev.off()

write.table(datRet, file=paste0("pairwise_overlap.relaxP", nPCutoff, ".relaxFDR", nFDRCutoff  ,  ".tsv"), sep="\t", row.names = F, col.names = T, quote=F)
