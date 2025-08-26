.libPaths("/data/projects/rcui/R/x86_64-pc-linux-gnu-library/4.1")
library(GENESPACE)
runwd <- file.path("/data2/projects/dyao/compare/gene_loss_all_new/07_cart4_synteny/01_genespace/rundir")

gpar <- init_genespace(
  genomeIDs = c("AXiphophorusMaculatus", "BBrotulaMultibarbata", "CBassozetusSp", "DDanioRerio", "EPachycaraSp", "FPholisNebulosa", "GDictyosomaTongyeongensis"),
  speciesIDs = c("1Xiphophorus_maculatus", "2Brotula_multibarbata", "3Bassozetus_sp", "4Danio_rerio", "5Pachycara_sp", "6Pholis_nebulosa", "7Dictyosoma_tongyeongensis"),
  versionIDs = c("1", "1", "1","1" , "1", "1", "1"),
  ploidy = rep(1,7),
  diamondMode = "default",
  orthofinderMethod = "default",
  wd = runwd,
  nCores = 60,
  minPepLen = 30,
  gffString = "gff",
  pepString = "pep",
  path2orthofinder = "/opt/miniconda3/bin/orthofinder",
  path2diamond = "/opt/miniconda3/bin/diamond",
  path2mcscanx = "/data/software/MCScanX/",
  rawGenomeDir = file.path(runwd, "rawGenomes"))
  
parse_annotations(
  gsParam = gpar,
  gffEntryType = "gene",
  gffIdColumn = "locus",
  gffStripText = "locus=",
  headerEntryIndex = 1,
  headerSep = " ",
  headerStripText = "locus=")

gpar <- run_orthofinder(gsParam = gpar)

gpar <- set_syntenyParams(gpar, onlyOgAnchors = FALSE, blkSize = 2, nGaps = 20)
gpar <- synteny(gpar)

#gpar <- synteny(gsParam = gpar)

ripdat <- plot_riparianHits(gpar)

arrCol <- rainbow(24);
regs <- data.frame(
  genome = rep('EPachycaraSp', 24),
  chr =1:24)

#datInvert <- data.frame(genome="MacropodusHongkongensis", chr=c(1, 4, 8, 10, 6, 18,19,20, 22) )

ripdat <- plot_riparianHits(
  gpar,onlyTheseRegions = regs, refChrCols = arrCol,minGenes2plot=50,
  blackBg = F, chrFill = "orange",returnSourceData=T,
  chrBorder = "grey", useOrder=F, labelTheseGenomes = c('EPachycaraSp', 'CBassozetusSp') )

#dump('ripdat', file="ripdata.R");

pg <- pangenome(gpar)
