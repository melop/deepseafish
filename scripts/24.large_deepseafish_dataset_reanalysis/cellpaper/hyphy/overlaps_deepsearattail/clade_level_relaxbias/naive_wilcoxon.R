# =============================================================================
#  Naive Wilcoxon values treating all 28 pairs as independent
#
#  Two variants are computed, because "Wilcoxon on the 28 pairs" can mean
#  either of two things:
#    (a) Wilcoxon signed-rank test on the 28 paired differences
#        d = log10(p_relax) - log10(p_intens)          [paired, ignores clades]
#    (b) Wilcoxon rank-sum (Mann-Whitney) test comparing the 28 relaxed p
#        values with the 28 intensified p values            [two-sample]
#  Both are reported.  The clade-level sign test value (0.0078) would arise at
#  the pair level only by treating the 28 pairs as 28 independent units.
# =============================================================================
OUT <- "D:/Users/platy/deepsea/ms1013/work"

MEAS <- c(PHyper = "gene-set overlap, raw p",
          PHyperAA = "convergent amino acids, raw p",
          PHyperFDR = "gene-set overlap, FDR-corrected p",
          PHyperAAFDR = "convergent amino acids, FDR-corrected p")

rows <- list()
for (tag in c("S13a", "S13b", "S14a", "S14b")) {
  d <- read.csv(file.path(OUT, paste0("pairs_", tag, ".csv")))
  for (m in names(MEAS)) {
    rc <- paste0("relax_", m); ic <- paste0("int_", m)
    dd <- d[is.finite(d[[rc]]) & is.finite(d[[ic]]) & d[[rc]] > 0 & d[[ic]] > 0, ]
    stopifnot(nrow(dd) == 28)
    diff <- log10(dd[[rc]]) - log10(dd[[ic]])

    ## (a) signed-rank test on the 28 differences
    ws <- suppressWarnings(wilcox.test(diff, exact = TRUE))
    ws_n <- suppressWarnings(wilcox.test(diff, exact = FALSE))
    ## (b) rank-sum test comparing relaxed with intensified p values
    wr <- suppressWarnings(wilcox.test(dd[[rc]], dd[[ic]], paired = FALSE, exact = TRUE))
    wr_n <- suppressWarnings(wilcox.test(dd[[rc]], dd[[ic]], paired = FALSE, exact = FALSE))
    ## for reference: one-sample t test on the 28 differences
    tt <- t.test(diff)

    cat(sprintf("%-5s %-12s  signed-rank V = %3.0f  p(exact) = %.4f  p(normal app.) = %.4f\n",
                tag, m, ws$statistic, ws$p.value, ws_n$p.value))
    cat(sprintf("            rank-sum W = %4.0f  p(exact) = %.4f  p(normal app.) = %.4f\n",
                wr$statistic, wr$p.value, wr_n$p.value))
    cat(sprintf("            t test on the 28 differences: t(%d) p = %.4g\n", tt$parameter, tt$p.value))

    rows[[paste(tag, m)]] <- data.frame(
      table = tag, measure = m,
      n_pairs = nrow(dd),
      signedrank_V = as.numeric(ws$statistic),
      p_wilcox_signedrank = ws$p.value,
      p_wilcox_signedrank_normal = ws_n$p.value,
      ranksum_W = as.numeric(wr$statistic),
      p_wilcox_ranksum = wr$p.value,
      p_wilcox_ranksum_normal = wr_n$p.value,
      t_28 = as.numeric(tt$statistic), p_t_28 = tt$p.value)
  }
}
out <- do.call(rbind, rows)
write.csv(out, file.path(OUT, "naive_wilcoxon.csv"), row.names = FALSE)
cat("\nwrote naive_wilcoxon.csv\n")
print(out[, c("table", "measure", "p_wilcox_signedrank", "p_wilcox_signedrank_normal",
              "p_wilcox_ranksum", "p_t_28")], row.names = FALSE)
