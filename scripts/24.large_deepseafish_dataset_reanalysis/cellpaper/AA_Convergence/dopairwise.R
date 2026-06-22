setwd("/public4/group_crf/home/cuirf/deepsea/cellpaper/AA_Convergence");
datTaxaGrp <- read.table("taxagroup_desc.txt", sep = "\t", header=F)

arrClades <- datTaxaGrp$V1[1:(nrow(datTaxaGrp)-2)]

cat("module load clusterbasics\nmkdir -p logs\n");
for(nClade1 in 1:(length(arrClades)-1)) {
  sClade1 <- arrClades[nClade1];
  for (nClade2 in (nClade1+1):length(arrClades) ) {
    sClade2 <- arrClades[nClade2];
    cat("php annotateAAchange_percentcutoff.php ", sClade1, " ", sClade2, " > logs/",sClade1,".",sClade2,".log 2>&1 & \n", sep = "");
  }
}

cat("wait;\n");
