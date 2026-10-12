#setwd("/public4/group_crf/home/cuirf/deepsea/cellpaper/hyphy/overlaps/visualize_tree")
library(pheatmap)
library(stringr)
nPCutoff <- 0.05;
nFDRCutoff <- 0.1;
nAsteriksCutoff <- log10(0.05)
sPlotVal <- "PHyper" #"PHyper"; #"PHyperFDR"
sPlotValAA <- "PHyperAA"; #"PHyperAA"; #"PHyperFDR"
bOutputRelaxTable <- F;

sAAConvergePrefix <- "../../../AA_Convergence/annotate_aa_changes."
sAAConvergeSuffix <- "/ret_minintaxaPerc0.3.maxAAout4.part0.of.1.txt";
#sAAConvergeSuffix <- "/ret_minintaxaPerc1.maxAAout4.part0.of.1.txt";

arrCladeDirs <- Sys.glob("../../Relax_*")
arrClades <- unlist(str_split(arrCladeDirs, "Relax_"))
arrClades <- arrClades[!grepl("bak",arrClades)]
arrClades <- arrClades[seq(2,length(arrClades),2)]

names(arrCladeDirs) <- arrClades

lsRelaxRet <- list();
lsExclusionList <- list();
for (sClade in arrClades) {
  sCladeDir <- arrCladeDirs[sClade];
  sExcludeList <- paste0("../match_distr_exclude.",sClade,".p_",nPCutoff,".fdr_",nFDRCutoff,".txt");
  if (!file.exists(sExcludeList)) {
	cat(sClade, " excluded\n");
	next;
  }
  oConn <- pipe(paste0("zcat -f ", sCladeDir, "/Relax_*/ret*"), open="r" );
  lsRelaxRet[[sClade]] <- read.table(file=oConn, header=F, sep="\t", quote="", fill=T);
  lsRelaxRet[[sClade]] <- lsRelaxRet[[sClade]][!is.na(lsRelaxRet[[sClade]]$V5), ]
  lsRelaxRet[[sClade]]$fdr <- p.adjust(lsRelaxRet[[sClade]]$V5, method = "fdr")
  nRowBefore <- nrow(lsRelaxRet[[sClade]]);
  datExcludeList <- read.table(sExcludeList, header=F, sep="\t");
  lsRelaxRet[[sClade]] <- lsRelaxRet[[sClade]][!(lsRelaxRet[[sClade]]$V1 %in% datExcludeList$V1),]; #Exclude
  nRowAfter <- nrow(lsRelaxRet[[sClade]]);
  cat(sClade, " In exclusion list: ", nrow(datExcludeList), ", before exclusion:", nRowBefore, ", after: ", nRowAfter, ", excluded: ", nRowBefore - nRowAfter, "\n" );
  if (bOutputRelaxTable) {
  write.table(lsRelaxRet[[sClade]], file = paste0(sOutFilePrefix,".relaxret.",sClade, ".tsv") , sep="\t", col.names = T, row.names = F, quote = F)
  }
}

for(nClade1 in 1:length(arrClades)) {
  sClade1 <- arrClades[nClade1];
  datRelax1 <- lsRelaxRet[[sClade1]];
  arrRelax1 <- datRelax1[datRelax1$V5 < nPCutoff & datRelax1$V9 < 1 & datRelax1$fdr < nFDRCutoff, 'V1'];
  arrIntense1 <- datRelax1[datRelax1$V5 < nPCutoff & datRelax1$V9 > 1 & datRelax1$fdr < nFDRCutoff, 'V1'];
  arrUniverse1 <- datRelax1$V1;
  arrBg <- setdiff(arrUniverse1, c(arrRelax1, arrIntense1));
    #write gene list
    sOutFilePfx <- paste0("clade/",sClade1, "/genelist.p_",nPCutoff,".fdr_",nFDRCutoff, ".");
#    dir.create(paste0("clade/",sClade1, "/phyliplinks"), recursive=T, "");
    write.table(data.frame(a=arrBg), file=paste0(sOutFilePfx,"bg.txt"), col.names=F, row.names=F, quote=F );
    write.table(data.frame(a=arrRelax1), file=paste0(sOutFilePfx,"relax.txt"), col.names=F, row.names=F, quote=F );
    write.table(data.frame(a=arrIntense1), file=paste0(sOutFilePfx,"intense.txt"), col.names=F, row.names=F, quote=F );
    
}
