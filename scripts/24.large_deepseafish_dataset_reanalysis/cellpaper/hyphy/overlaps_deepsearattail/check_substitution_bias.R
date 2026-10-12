setwd("/public4/group_crf/home/cuirf/deepsea/cellpaper/hyphy/overlaps_deepsearattail/");
library(MatchIt)

arrClades <- c("Anoplogaster_cornuta",  "DeepseaBeryciformes",  "Pachycara",
               "Bassozetus",            "Ilyophis",             "Pseudoliparis",
               "DeepseaAulopiformes",   "DeepseaCoryphaenoides");

# fnMatchDist <- function(A, B) {
#   df <- data.frame(
#     value = c(A, B),
#     group = c(rep(1, length(A)), rep(0, length(B)))
#   )
#   
#   # Estimate propensity scores using logistic regression
#   m_out <- matchit(group ~ value, data = df, method = "nearest", replace=F, caliper = log10(2))
#   
#   # Extract matched data
#   matched_data <- match.data(m_out)
#   
#   # Get the matched vectors
#   A_matched <- matched_data$value[matched_data$group == 1]
#   B_matched <- matched_data$value[matched_data$group == 0]
#   
#   return(list(A=A_matched, B=B_matched))
#   
# }

# Tuning Guidelines
# Goal: preserve as many samples as possible
# Decrease alpha (e.g., 0.01) — relaxes the convergence criterion, stops earlier
# Increase bw_adjust (e.g., 1.5–2.0) — smooths densities, reduces over-removal
# Decrease batch_frac (e.g., 0.005) — finer-grained removal decisions
# Goal: achieve the tightest possible match
# Increase alpha (e.g., 0.10–0.20) — demands a higher p-value, tighter match
# Decrease bw_adjust (e.g., 0.5–0.8) — captures fine density differences
# Increase grid_size (e.g., 1024) — higher density resolution
# Goal: maximize speed for large vectors (n > 5000)
# Decrease grid_size to 256
# Increase batch_frac to 0.05
# Increase bw_adjust to 1.5–2.0 (fewer iterations needed)
# When distributions barely overlap
# Decrease alpha (e.g., 0.01) — a strict match may not be achievable without discarding nearly all samples


fnMatchDist <-  function(A, B, alpha = ks.alpha, grid_size = 1024, 
                         batch_frac = 0.005, bw_adjust = 1.0, max_iter = 200,
                         dens_floor = 1e-10, priority_remove = NULL,
                         priority_preserve = NULL) {
  
  cat("======= Start matching======\n");
  active_A <- rep(TRUE, length(A))
  active_B <- rep(TRUE, length(B))
  
  # Pre-compute priority masks
  has_priority_remove <- FALSE
  has_priority_preserve <- FALSE
  
  nA <- names(A)
  nB <- names(B)
  
  if (!is.null(priority_remove) && length(priority_remove) > 0) {
    if (is.null(nA) || is.null(nB)) {
      warning("priority_remove provided but A and/or B have no names. Ignoring.")
    } else {
      priority_remove_mask_A <- nA %in% priority_remove
      priority_remove_mask_B <- nB %in% priority_remove
      has_priority_remove <- TRUE
      cat(sprintf("Priority remove: %d in A, %d in B\n",
                  sum(priority_remove_mask_A), sum(priority_remove_mask_B)))
    }
  }
  
  if (!is.null(priority_preserve) && length(priority_preserve) > 0) {
    if (is.null(nA) || is.null(nB)) {
      warning("priority_preserve provided but A and/or B have no names. Ignoring.")
    } else {
      priority_preserve_mask_A <- nA %in% priority_preserve
      priority_preserve_mask_B <- nB %in% priority_preserve
      has_priority_preserve <- TRUE
      cat(sprintf("Priority preserve: %d in A, %d in B\n",
                  sum(priority_preserve_mask_A), sum(priority_preserve_mask_B)))
    }
  }
  
  grid_from <- min(A, B)
  grid_to   <- max(A, B)
  
  for (iter in seq_len(max_iter)) {
    A_act <- A[active_A]
    B_act <- B[active_B]
    
    if (length(A_act) < 10 || length(B_act) < 10) {
      warning("Too few samples remaining. Stopping early.")
      break
    }
    
    ks_result <- ks.test(A_act, B_act)
    if (ks_result$p.value > alpha) {
      cat(sprintf("Converged at iteration %d\n", iter))
      cat(sprintf("KS stat: %.4f, p-value: %.4f\n", 
                  ks_result$statistic, ks_result$p.value))
      cat(sprintf("Kept: A = %d / %d, B = %d / %d\n",
                  sum(active_A), length(A), sum(active_B), length(B)))
      break
    }
    
    bw_A <- bw.nrd0(A_act) * bw_adjust
    bw_B <- bw.nrd0(B_act) * bw_adjust
    
    if (!is.finite(bw_A) || bw_A <= 0 || !is.finite(bw_B) || bw_B <= 0) {
      warning("Bandwidth calculation failed. Stopping.")
      break
    }
    
    dens_A <- density(A_act, bw = bw_A, n = grid_size, from = grid_from, to = grid_to)
    dens_B <- density(B_act, bw = bw_B, n = grid_size, from = grid_from, to = grid_to)
    
    dens_A$y <- pmax(dens_A$y, dens_floor)
    dens_B$y <- pmax(dens_B$y, dens_floor)
    
    fA_at_A <- approx(dens_A$x, dens_A$y, xout = A_act, rule = 2)$y
    fB_at_A <- approx(dens_B$x, dens_B$y, xout = A_act, rule = 2)$y
    fA_at_B <- approx(dens_A$x, dens_A$y, xout = B_act, rule = 2)$y
    fB_at_B <- approx(dens_B$x, dens_B$y, xout = B_act, rule = 2)$y
    
    p_remove_A <- pmax(0, 1 - fB_at_A / fA_at_A)
    p_remove_B <- pmax(0, 1 - fA_at_B / fB_at_B)
    
    p_remove_A[!is.finite(p_remove_A)] <- 0
    p_remove_B[!is.finite(p_remove_B)] <- 0
    
    n_remove_A <- max(1, round(sum(active_A) * batch_frac))
    n_remove_B <- max(1, round(sum(active_B) * batch_frac))
    
    idx_A <- which(active_A)
    idx_B <- which(active_B)
    
    # Remove from A
    sum_pA <- sum(p_remove_A)
    if (sum_pA > 0) {
      probs_A <- p_remove_A / sum_pA
      
      if (has_priority_remove) {
        is_pr <- priority_remove_mask_A[active_A]
        if (any(is_pr) && any(probs_A[is_pr] > 0)) {
          probs_A[is_pr] <- probs_A[is_pr] * 1000
          probs_A <- probs_A / sum(probs_A)
        }
      }
      
      if (has_priority_preserve) {
        is_pp <- priority_preserve_mask_A[active_A]
        if (any(is_pp)) {
          probs_A[is_pp] <- probs_A[is_pp] / 1000
          probs_A <- probs_A / sum(probs_A)
        }
      }
      
      n_to_remove <- min(n_remove_A, sum(p_remove_A > 0))
      if (n_to_remove > 0) {
        remove_A <- sample(idx_A, size = n_to_remove,
                           prob = probs_A, replace = FALSE)
        active_A[remove_A] <- FALSE
      }
    }
    
    # Remove from B
    sum_pB <- sum(p_remove_B)
    if (sum_pB > 0) {
      probs_B <- p_remove_B / sum_pB
      
      if (has_priority_remove) {
        is_pr <- priority_remove_mask_B[active_B]
        if (any(is_pr) && any(probs_B[is_pr] > 0)) {
          probs_B[is_pr] <- probs_B[is_pr] * 1000
          probs_B <- probs_B / sum(probs_B)
        }
      }
      
      if (has_priority_preserve) {
        is_pp <- priority_preserve_mask_B[active_B]
        if (any(is_pp)) {
          probs_B[is_pp] <- probs_B[is_pp] / 1000
          probs_B <- probs_B / sum(probs_B)
        }
      }
      
      n_to_remove <- min(n_remove_B, sum(p_remove_B > 0))
      if (n_to_remove > 0) {
        remove_B <- sample(idx_B, size = n_to_remove,
                           prob = probs_B, replace = FALSE)
        active_B[remove_B] <- FALSE
      }
    }
  }
  
  return(list(A = A[active_A], B = B[active_B]))
}



for(sClade in arrClades) {

arrExcludePCutoffs <- c( 0.05, 1); #always list the most stringent criteria first!
arrExcludeFDRCutoffs <- c( 1, 1);

arrExcludePCutoffs <- c(0.05, 1);
arrExcludeFDRCutoffs <- c(0.1, 1);

ks.alpha <- 0.2

sOutStem <- paste0("match_distr_exclude.", sClade , ".p_",arrExcludePCutoffs[1], ".fdr_", arrExcludeFDRCutoffs[1] )

pdf(file=paste0(sOutStem, ".pdf"), width=6, height=6)
sink(file=paste0(sOutStem, ".log"))


datBrLen <- NULL;


if (sClade == "DeepseaCoryphaenoides") {
  datBrLen <- read.table("/public4/group_crf/home/cuirf/deepsea/cellpaper/exportaln_hadalrattail/root_to_tip_brlens/root2tip.dist.tsv", sep="\t", header=T)
} else {
  datBrLen <- read.table("/public4/group_crf/home/cuirf/deepsea/cellpaper/exportaln/root_to_tip_brlens/root2tip.dist.tsv", sep="\t", header=T)
}
datRelaxRet <- read.table(paste0("relaxret.", sClade, ".tsv"), header = T, sep="\t")
datRelaxBrLenMerge <- merge(datRelaxRet, datBrLen[,c("ID", "meanbrlenAA")], by.x="V1", by.y="ID", all.x=F, all.y= F);
datRelaxBrLenMerge$estAAsub <- datRelaxBrLenMerge$V4 * datRelaxBrLenMerge$meanbrlenAA
hist(datRelaxBrLenMerge$estAAsub)
arrExcludedGenes <- c();
arrPreservedGenes <- c();

for(nCutoffCondition in 1:length(arrExcludePCutoffs)) {
  nPCutoff <- arrExcludePCutoffs[nCutoffCondition];
  nFDRCutoff <- arrExcludeFDRCutoffs[nCutoffCondition];
  
  expRelax <- datRelaxBrLenMerge$V5 <= nPCutoff & datRelaxBrLenMerge$V9 < 1 & datRelaxBrLenMerge$fdr <= nFDRCutoff;
  expIntense <- datRelaxBrLenMerge$V5 <= nPCutoff & datRelaxBrLenMerge$V9 >= 1 & datRelaxBrLenMerge$fdr <= nFDRCutoff;
  
  arrAAsubRelax <- log10(datRelaxBrLenMerge$estAAsub[expRelax]);
  names(arrAAsubRelax) <- datRelaxBrLenMerge$V1[expRelax];
  arrAAsubIntense <- log10(datRelaxBrLenMerge$estAAsub[expIntense]);
  names(arrAAsubIntense) <- datRelaxBrLenMerge$V1[expIntense];
  
  length(arrAAsubRelax)
  length(arrAAsubIntense)
  cat("=============Before matching=========");
  print(ks.test(arrAAsubRelax, arrAAsubIntense))
  hist(arrAAsubRelax, col = rgb(0,0,1,0.5), breaks=50, freq = F, main=paste0("Before matching, p <=",nPCutoff, " fdr<=",nFDRCutoff ), xlab="Log10(Mean Root-to-tip AA substitutions)" )
  hist(arrAAsubIntense, col = rgb(1,0,0,0.5), add =T, breaks=50, freq=F)
  
  oMatched <- fnMatchDist(A=arrAAsubRelax, B=arrAAsubIntense , priority_remove=arrExcludedGenes, priority_preserve=arrPreservedGenes);
  length(oMatched$A)
  length(unique(names(oMatched$A)))
  length(oMatched$B)
  length(unique(names(oMatched$B)))
  #print(ks.test(oMatched$A, oMatched$B))
  
  hist(oMatched$A, col = rgb(0,0,1,0.5), breaks=50, freq = F, main=paste0("After matching, p <=",nPCutoff, " fdr<=",nFDRCutoff ),  xlab="Log10(Mean Root-to-tip AA substitutions)")
  hist(oMatched$B, col = rgb(1,0,0,0.5), add =T, breaks=50, freq=F)
  arrExcludedGenes <- c(arrExcludedGenes, setdiff(names(arrAAsubRelax), unique(names(oMatched$A))));
  arrExcludedGenes <- c(arrExcludedGenes, setdiff(names(arrAAsubIntense), unique(names(oMatched$B))));
  arrExcludedGenes <- unique(arrExcludedGenes);
  arrPreservedGenes <- unique(c(arrPreservedGenes, unique(names(oMatched$A)), unique(names(oMatched$B))));
}

arrExcludedGenes <- unique(arrExcludedGenes);

#validation
for(nCutoffCondition in 1:length(arrExcludePCutoffs)) {
  nPCutoff <- arrExcludePCutoffs[nCutoffCondition];
  nFDRCutoff <- arrExcludeFDRCutoffs[nCutoffCondition];
  
  expRelax <- datRelaxBrLenMerge$V5 <= nPCutoff & datRelaxBrLenMerge$V9 < 1 & datRelaxBrLenMerge$fdr <= nFDRCutoff;
  expIntense <- datRelaxBrLenMerge$V5 <= nPCutoff & datRelaxBrLenMerge$V9 >= 1 & datRelaxBrLenMerge$fdr <= nFDRCutoff;
  
  arrAAsubRelax <- log10(datRelaxBrLenMerge$estAAsub[expRelax]);
  names(arrAAsubRelax) <- datRelaxBrLenMerge$V1[expRelax];
  arrAAsubIntense <- log10(datRelaxBrLenMerge$estAAsub[expIntense]);
  names(arrAAsubIntense) <- datRelaxBrLenMerge$V1[expIntense];
  
  
  oMatched <- list(A=arrAAsubRelax[!(names(arrAAsubRelax) %in% arrExcludedGenes)] , B=arrAAsubIntense[!(names(arrAAsubIntense) %in% arrExcludedGenes)]);
  length(oMatched$A)
  length(unique(names(oMatched$A)))
  length(oMatched$B)
  length(unique(names(oMatched$B)))
  print(ks.test(oMatched$A, oMatched$B))
  
  hist(oMatched$A, col = rgb(0,0,1,0.5), breaks=50, freq = F, main=paste0("After matching validate, p <=",nPCutoff, " fdr<=",nFDRCutoff ),  xlab="Log10(Mean Root-to-tip AA substitutions)")
  hist(oMatched$B, col = rgb(1,0,0,0.5), add =T, breaks=50, freq=F)

}

cat("excluded genes:", length(arrExcludedGenes) ,"\n");
write.table(data.frame(g=arrExcludedGenes), file = paste0(sOutStem, ".txt" ) ,  col.names = F, row.names = F, sep="", quote = F)

sink();
dev.off();
}
