setwd("/public4/group_crf/home/cuirf/deepsea/cellpaper/orthofinder");

arrImportantSpp <- c("Macrourus_sp", "Cetomimus_sp","Anoplogaster_cornuta", "Coryphaenoides_rupestris" ); #these species have few genes but are important
nMinTaxaCompleteness <- 40; #min num of taxa
nMinTaxaCompletenessOnImportantSpp <- 30;

arrExcludeSpp <- c("Lepisosteus_oculatus");

datOrth <- read.table("N1.simp.maskedparalogspp.tsv" , sep="\t", header=T)
datOrthFilter <- datOrth[, ! (colnames(datOrth) %in% arrExcludeSpp) ]

nSp <- ncol(datOrthFilter) - 3;
arrValidData <- nSp - apply(datOrthFilter[,4:ncol(datOrthFilter)], 1, function(x) {sum(is.na(x))} )
min(arrValidData)
max(arrValidData)
hist(arrValidData)

sum(arrValidData>=40)

arrSpCompleteness <- nrow(datOrthFilter)- apply(datOrthFilter[,4:ncol(datOrthFilter)], 2, function(x) {sum(is.na(x))} ) 

hist(arrSpCompleteness)
arrSpCompleteness[order(arrSpCompleteness)]

arrContainedImportantSpp <- rep(FALSE, nrow(datOrthFilter));
for (sSp in arrImportantSpp) {
  arrContainedImportantSpp <- arrContainedImportantSpp | (!is.na(datOrthFilter[, sSp]))
}

sum(arrContainedImportantSpp)
arrMeetTaxCutoff1 <- ( arrValidData>=nMinTaxaCompleteness)
arrMeetTaxCutoff2 <- ( arrValidData>=nMinTaxaCompletenessOnImportantSpp)

arrKeep <- (arrMeetTaxCutoff1 | (arrContainedImportantSpp & arrMeetTaxCutoff2) )
sum(arrKeep)

write.table(datOrthFilter[arrKeep,], file="orthologs.filtered.txt", col.names = T, row.names = F, quote = F, sep="\t")
