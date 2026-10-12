#setwd("/public4/group_crf/home/cuirf/deepsea/cellpaper/exportaln");
library(ape)
library(phytools)
library(castor)

bMidPointRootNoOutgroup <- T; #root the tree at midpoint when no outgroup
#setwd("/beegfs/group_dv/home/RCui/killifish_genomes/hyphyrelax/export_protein_multiref_23_july_2017");

arrAUResults <- Sys.glob("genetrees_relaxed/ret_part*.txt"); #c("genetrees/ret_part0.of.200.txt");#Sys.glob("genetrees/ret_part*.txt")
arrAABrlenResults <- Sys.glob("genetrees_AAbrlens//ret_part*.txt")
############ Change this ##############################
sOutDIR <- "root_to_tip_brlens";
arrOutgroupSpp <- c('Scleropages_formosus');
############ Change this ##############################

args = commandArgs(trailingOnly=TRUE);

nArgCount <- 0;

nArgCount <- nArgCount + 1;
if (length(args) >= nArgCount) {
  arrOutgroupSpp <- unlist(strsplit(args[nArgCount] , split = ","));
}


dir.create(sOutDIR, recursive = T , mode = "0777")

datAU <- NULL;
for( sAUFile in arrAUResults) {
  datAU <- rbind(datAU, read.table(sAUFile,header=F, fill = T, strip.white = F, stringsAsFactors = F, na.strings = "") );
}

datBrlens <- NULL;
for( sAABrlenFile in arrAABrlenResults) {
  datBrlens <- rbind(datBrlens, read.table(sAABrlenFile,header=F, fill = T, strip.white = F, stringsAsFactors = F, na.strings = "") );
}

datBrlens <- datBrlens[datBrlens$V2!="BrlenOptmFailed" , ]

colnames(datAU) <- c('GeneId' , 'nTaxa' , 'status' , 'obs', 'au' , 'tree_free', 'tree_constraint');

datAUFilter <- datAU[datAU$status=='accepted_monophyly', ];

datAUFilter$GeneId[!datAUFilter$GeneId %in% datBrlens$V1]

nBefore <- nrow(datAUFilter);
datAUFilter <- merge(datAUFilter, datBrlens[, c(1,3)], by.x = "GeneId", by.y="V1", all.x = F, all.y =F )
nAfter <- nrow(datAUFilter);

if (nBefore != nAfter) {
  cat("Some AA br len did not optimize, please check.\n");
}
#View(datAUFilter[is.na(datAUFilter$V3), ]);

fnGetBrLen <- function(sTree) {
  oTree <- read.tree(text=sTree);
  
  if (is.null(oTree)) {
    cat("Error reading tree for ", sGeneId, "\n", "Tree:", sTree , "\n");
    next;
  }
  oTree <- unroot( oTree );
  arrOutgroupSppFound <- intersect(arrOutgroupSpp, oTree$tip.label);
  cat("Doing " , sGeneId,"\n");
  if (length(arrOutgroupSppFound) ==0 && (!bMidPointRootNoOutgroup)) {
    cat("ERROR: All outgroup species are missing, cannot root\n");
    next;
  }
  
  if (length(arrOutgroupSppFound ) == 1) {
    cat( sGeneId," only one outgroup \n");
    
    oTree <- reroot(tree = oTree, node.number = which(oTree$tip.label == arrOutgroupSppFound[1]));
  } else if (length(arrOutgroupSppFound ) > 1){
    oTree <- reroot(tree = oTree, node.number = findMRCA(oTree, tips=arrOutgroupSppFound,type = 'node' ));
  } else if (length(arrOutgroupSppFound ) == 0 && bMidPointRootNoOutgroup)  {
    cat("WARNING: All outgroup species are missing, root at midpoint\n");
    oTree <- midpoint_root(oTree);
  }
  
  #plot(oTree)
  arrRoot2TipDist <- get_all_distances_to_root(oTree)
  nTips <- length(oTree$tip.label)
  arrRoot2TipDist <- arrRoot2TipDist[1:nTips]
  return(list(dist=arrRoot2TipDist, outgroups=arrOutgroupSppFound))
}

bAppend <- F;
sOutFile <- paste0(sOutDIR, '/root2tip.dist.tsv');
for(nR in 1:nrow(datAUFilter)) {
#for(nR in 1) {
    
  sGeneId <- datAUFilter[nR, 'GeneId'];
  sTree <- datAUFilter[nR, 'tree_constraint'];
  sTreeAA <- datAUFilter[nR, 'V3'];

  oLenDNA <- fnGetBrLen(sTree);
  arrRoot2TipDist <- oLenDNA$dist;
  arrOutgroupSppFound <- oLenDNA$outgroups;
  
  oLenAA <- fnGetBrLen(sTreeAA);
  arrRoot2TipDistAA <- oLenAA$dist;
  
  write.table(data.frame(ID=sGeneId, meanbrlen=mean(arrRoot2TipDist), meanbrlenAA=mean(arrRoot2TipDistAA), sdbrlen=sd(arrRoot2TipDist), sdbrlenAA=sd(arrRoot2TipDistAA), outgroupcount=length(arrOutgroupSppFound ), rawlenlist=paste(arrRoot2TipDist, collapse = ";"), rawlenlistAA=paste(arrRoot2TipDistAA, collapse = ";")), 
              file = sOutFile, append = bAppend, row.names = F, col.names = !bAppend, sep="\t", quote = F)
  bAppend <- T;
}


datBrLens <- read.table(sOutFile, header=T, sep="\t")
datBrLens <- datBrLens[datBrLens$outgroupcount==1,]
hist(datBrLens$meanbrlen, breaks=1000, xlim=c(0,5))
hist(datBrLens$meanbrlenAA, breaks=100, xlim=c(0,3))
plot(datBrLens$meanbrlen, datBrLens$meanbrlenAA, xlim=c(0,1), ylim=c(0,1) )
quantile(datBrLens$meanbrlen, c(0.025, 0.975));
quantile(datBrLens$meanbrlenAA, c(0.025, 0.975));
length(datBrLens$meanbrlen);
mean(datBrLens$meanbrlen);
