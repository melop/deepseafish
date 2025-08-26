#setwd("/data/projects/yshao/psmc/Tbifasciatus/");
pdf("pachycara_chr.pdf", width=7, height=6);
sMainFolder <- "msmc2ret";
sBSFolder <- "bootstrapped"
nBSReps <- 30;

arrYLim <- c(5e3, 4e6);
arrXLim <- c(3e3, 4e6);
nMu <- 3e-9;


fnPlotPopPair <- function(sSp, sPop1, arrCol, bBSPlot = T, nSplitTime=0, sThisBSFile1='',sThisBSFile2='', sRealFile="") {
 
  sInFile1 <- paste(sMainFolder,"/",sPop1, ".final.txt", sep="");
  #sInFile2 <- paste(sMainFolder,"/",sPop2, ".final.txt", sep="");
  
  cat("Open ", sInFile1,"\n");
  datMSMC1 <- read.table(sInFile1, header=T, sep="\t" );
  datMSMC1$gen <- datMSMC1$left_time_boundary/nMu;
  datMSMC1$gen[1] <- 0.01;
  datMSMC1$popsize <- (1/datMSMC1$lambda)/(2*nMu);
  
  #cat("Open ", sInFile2,"\n");
  #datMSMC2 <- read.table(sInFile2, header=T, sep="\t" );
  #datMSMC2$gen <- datMSMC2$left_time_boundary/nMu;
  #datMSMC2$gen[1] <- 0.01;
  #datMSMC2$popsize <- (1/datMSMC2$lambda)/(2*nMu);
  
  
#  if (bBSPlot == F) {
  plot( x=datMSMC1$gen , y=datMSMC1$popsize , main=sSp,  type = 's' , log='xy', xlim=arrXLim, ylim = arrYLim, xlab="Generations" , ylab = "Pop size", lwd=5, col=arrCol[1])
    #legend("topright", legend = c(sPop1),
    #        text.width = strwidth("1,000,000"),
    #        lty = 1, lwd=3, col = arrCol[2:3],  xjust = 1, yjust = 1,
    # )
     
    #abline(v= nSplitTime , col=arrCol[1], lwd=2);
    
#  } else {
    #plot( x=datMSMC1$gen , y=datMSMC1$popsize , main=sSp,  type = 's' , log='xy', xlim=arrXLim, ylim = arrYLim, xlab="Generations" , ylab = "Pop size", lwd=3, col=arrCol[1])
    
#  }
  
  #lines( datMSMC2$gen ,datMSMC2$popsize ,  type = 's' , lwd=3, col=arrCol[3])
  if (bBSPlot) {
    cat("bs: ", sThisBSFile1,"\n");
    sInFile1 <- sThisBSFile1;
    #sInFile2 <- sThisBSFile2;
    arrCol <- add.alpha(arrCol[2], 0.2);
    for (nRep in 1:nBSReps) {
      sBSF1 <- paste(sBSFolder,'/',sPop1, '/_', nRep, '/out.final.txt' , sep="");
      #sBSF2 <- paste(sBSFolder,'/',sPop2, '/_', nRep, '/out.final.txt' , sep="");
      #cat(sBSF1);
      datMSMC1 <- read.table(sBSF1, header=T, sep="\t" );
      datMSMC1$gen <- datMSMC1$left_time_boundary/nMu;
      datMSMC1$gen[1] <- 0.01;
      datMSMC1$popsize <- (1/datMSMC1$lambda)/(2*nMu);
      #fnPlotPopPair(sSp, sPop1, arrCol, bBSPlot = T, sThisBSFile1=sBSF1);
      #plot( x=datMSMC1$gen , y=datMSMC1$popsize , main=sSp,  type = 's' , log='xy', xlim=arrXLim, ylim = arrYLim, xlab="Generations" , ylab = "Pop size", lwd=3, col=arrCol[1]);
      lines( datMSMC1$gen ,datMSMC1$popsize ,  type = 's' , lwd=1, col=arrCol)
      }
    return();
  }
  
  #construct output table:
  #return(datMSMC1);
  return();
  
}

add.alpha <- function(col, alpha=1){
  if(missing(col))
    stop("Please provide a vector of colours.")
  apply(sapply(col, col2rgb)/255, 2, 
        function(x) rgb(x[1], x[2], x[3], alpha=alpha))  
}

fnPlotPopPair(sSp = 'pachycara', sPop1 = 'pachycara.sort.rmdup', arrCol = c('purple', 'red', 'blue'), sRealFile="pachycara.sort.rmdup.final.txt", sThisBSFile1='bootstrapped')
while (!is.null(dev.list()))  dev.off()

