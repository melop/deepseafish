setwd("/data2/projects/dyao/compare/gene_loss_all_new/05_venn")

library(VennDiagram)

geneloss_pachy <- read.table("./pachycara_loss_confirmed.txt", header=F, sep="\t", fill = T, quote = "")
geneloss_basso <- read.table("./Bassozetus_loss_confirmed.txt", header=F, sep="\t", fill = T, quote = "")

dat_genespace_orig <- read.table("genespace.orthogroups.txt", header=T, sep="\t", fill = T, quote = "")

venn.plot2 <- venn.diagram(
  x = list(
    Pachy=geneloss_pachy$V1,
    Basso=geneloss_basso$V1,
    total=dat_genespace_orig$OrthoID
    
  ),
  filename = NULL,
  col = "transparent",
  fill = c(rgb(153/255, 50/255, 204/255, alpha = 0.85),
           rgb(100/255, 149/255, 237/255, alpha = 0.85),
           rgb(169/255, 169/255, 169/255, alpha = 0.75)),  # cornflowerblue with 50% transparency
  alpha = 0.5,
  label.col = c("darkred", "white", "darkblue", "white",
                "white", "white", "darkgreen"),
  cex = 2.5,
  fontfamily = "serif",
  fontface = "bold",
  cat.default.pos = "text",
  cat.col = c("darkred", "darkblue", "darkgreen"),
  cat.cex = 2.5,
  cat.fontfamily = "serif",
  cat.dist = c(0.06, 0.06, 0.03),
  cat.pos = 0
);
grid.draw(venn.plot2)

phyper(10, 232, 21262-232, 346,lower.tail = FALSE)


