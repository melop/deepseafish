#setwd("/public4/group_crf/home/cuirf/deepsea/cellpaper/hyphy/overlaps_deepsearattail");
library(ape)
sSpTree <- "visualize_tree_perclade/tree.newick";
sMonophylyDesc <- "../../exportaln_hadalrattail/monophyly_desc.relaxed.txt";
sEnrichFile <- "exclded.p_0.05.fdr_0.1pairwise_overlap.relaxP0.05.relaxFDR0.1.tsv"

datEnrich <- read.table(sEnrichFile, header=T, sep = "\t")
oTree <- read.tree(sSpTree)

D <- cophenetic(oTree)
Dist <- as.matrix(D)

datMono <- read.table(sMonophylyDesc, header=F, sep="\t");

arrClades <- unique(c(datEnrich$Clade1, datEnrich$Clade2));
datClade2Taxa <- datMono[datMono$V1 %in% arrClades, ]
arrSingleTaxon <- setdiff(arrClades, datClade2Taxa$V1)
oClade2Taxa <- list();
for (sTaxon in arrSingleTaxon) {
  oClade2Taxa[[sTaxon]] <- sTaxon
}
for (nRow in 1:nrow(datClade2Taxa)) {
  
  oClade2Taxa[[datClade2Taxa[nRow,1]]] <- unlist(strsplit(datClade2Taxa[nRow,2], ",") )
}

fnPhyloDist <- function(sClade1, sClade2) {
  arrDists <- c();
  for(sTax1 in oClade2Taxa[[sClade1]]) {
    for(sTax2 in oClade2Taxa[[sClade2]]) {
      arrDists <- c(arrDists, Dist[sTax1, sTax2]);
    }
  }
  return(mean(arrDists))
}

datEnrich$phylodist <- apply(datEnrich[,c('Clade1', 'Clade2')], 1, function(x) {fnPhyloDist(x[1], x[2])})

datEnrichRelax <- datEnrich[datEnrich$Type=="Relaxed",]
summary(lm(log10(datEnrichRelax$PHyper) ~ datEnrichRelax$phylodist))
summary(lm(log10(datEnrichRelax$PHyperAA) ~ datEnrichRelax$phylodist))

plot(log10(datEnrichRelax$PHyper) ~ datEnrichRelax$phylodist)
