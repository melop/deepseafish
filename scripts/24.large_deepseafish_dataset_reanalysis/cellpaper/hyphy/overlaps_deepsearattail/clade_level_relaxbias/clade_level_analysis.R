# =============================================================================
#  Clade-level analysis of the relaxed-versus-intensified contrast
#
#  Design
#    Pairwise hypergeometric tests of overlap between significantly relaxed and
#    intensified gene sets, for every pair among the 8 independent deep-sea
#    teleost clades (28 pairs per table; hadal-only comparisons involving
#    Bathypterois_sp and Coryphaenoides_yaquinae excluded).
#
#    Tables
#      S13a  p < 0.05 relaxed / intensified gene sets
#      S13b  p < 0.05, adjusted for substitution opportunities (SO)
#      S14a  p < 0.05 and FDR < 0.1
#      S14b  p < 0.05 and FDR < 0.1, adjusted for SO
#
#  Measures (--- 8 rows per table ---)
#    PHyper        hypergeometric p, overlap of relaxed vs intensified gene sets
#    PHyperAA      the same for convergent amino-acid substitutions
#    PHyperFDR     as PHyper, FDR-corrected across the pairwise overlap tests
#    PHyperAAFDR   as PHyperAA, FDR-corrected across the pairwise overlap tests
#    The last two rows are the multiplicity check requested in review: the
#    correction applies to the pairwise overlap tests themselves rather than to
#    the gene-level RELAX tests that defined the gene sets.
#
#  Statistic
#    d   = log10(p_relax) - log10(p_intens)      one value per clade pair
#    The 28 pairs are not independent, because each clade appears in 7 of them.
#    Each clade is therefore collapsed to a single number, the MEDIAN of the
#    log10 p differences of its 7 pairs, giving 8 independent observations, one
#    per clade.  All inference is carried out on those 8 numbers.
#
#  Tests
#    (1) one-sample t test on the 8 per-clade medians, df = 8 - 1 = 7.
#        Uses magnitude; assumes the 8 values are approximately normal.
#    (2) exact sign test: 2 * P(Binomial(8, 0.5) >= number in the observed
#        direction).  Uses only the direction of each clade, so it is exact and
#        assumption-free.  With 8 clades its smallest attainable two-sided value
#        is 2 * (1/2)^8 = 0.0078.
#    Normality of the 8 values is checked with the Shapiro-Wilk test and a
#    Wilcoxon signed-rank test is added as a rank-based companion.
#
#  INPUT   <workdir>/pairs_<table>.csv  for table in S13a, S13b, S14a, S14b
#          columns: clade1, clade2, relax_PHyper, int_PHyper,
#                   relax_PHyperAA, int_PHyperAA,
#                   relax_PHyperFDR, int_PHyperFDR,
#                   relax_PHyperAAFDR, int_PHyperAAFDR
#  OUTPUT  <workdir>/clade_level_<table>.csv
#          <workdir>/clade_level_all.csv
#          <workdir>/clade_level_values.csv   (the 8 per-clade values per row)
#          <workdir>/clade_level_fdr_comparison.csv
#
#  Run:  Rscript clade_level_analysis.R [workdir]
# =============================================================================

options(stringsAsFactors = FALSE)

args   <- commandArgs(trailingOnly = TRUE)
OUT    <- if (length(args) >= 1) args[1] else "."
TABLES <- c("S13a", "S13b", "S14a", "S14b")

## measures: label -> column suffix in the pairs_*.csv files
MEAS <- c(
  "PHyper"      = "gene-set overlap, raw p",
  "PHyperAA"    = "convergent amino acids, raw p",
  "PHyperFDR"   = "gene-set overlap, FDR-corrected p",
  "PHyperAAFDR" = "convergent amino acids, FDR-corrected p"
)

## ---------------------------------------------------------------------------
clade_values <- function(dd, diff) {
  clades <- sort(unique(c(dd$clade1, dd$clade2)))
  vapply(clades, function(g) median(diff[dd$clade1 == g | dd$clade2 == g]), numeric(1))
}

analyse_table <- function(tag) {
  d <- read.csv(file.path(OUT, paste0("pairs_", tag, ".csv")))
  d <- d[is.finite(d$relax_PHyper) & is.finite(d$int_PHyper) &
         d$relax_PHyper > 0 & d$int_PHyper > 0, ]
  stopifnot(length(unique(c(d$clade1, d$clade2))) == 8, nrow(d) == 28)
  cat(sprintf("\n%s : %d clade pairs, %d clades\n", tag, nrow(d),
              length(unique(c(d$clade1, d$clade2)))))

  res <- list(); vals <- list()
  for (m in names(MEAS)) {
    rc <- paste0("relax_", m); ic <- paste0("int_", m)
    dd <- d[is.finite(d[[rc]]) & is.finite(d[[ic]]) & d[[rc]] > 0 & d[[ic]] > 0, ]
    if (nrow(dd) != 28) {
      cat(sprintf("   %-12s SKIPPED: only %d usable pairs\n", m, nrow(dd)))
      next
    }
    diff <- log10(dd[[rc]]) - log10(dd[[ic]])
    pc   <- clade_values(dd, diff)
    G    <- length(pc)
    n_neg <- sum(pc < 0)

    tt  <- t.test(pc)
    wt  <- suppressWarnings(wilcox.test(pc, exact = TRUE))
    st  <- binom.test(n_neg, G, 0.5)
    sw  <- shapiro.test(pc)

    m_est <- mean(pc); s <- sd(pc); se <- s / sqrt(G)
    scale <- ifelse(grepl("FDR", m), "FDR-corrected", "raw")

    cat(sprintf("   %-12s (%s)  G = %d  [%s]\n", m, MEAS[[m]], G, scale))
    cat(sprintf("      per-clade medians: %s\n", paste(sprintf("%+.2f", sort(pc)), collapse = " ")))
    cat(sprintf("      mean %+.3f, SD %.3f, SE %.3f   t(%d) = %+.3f, p = %.4f, 95%% CI [%.2f, %.2f]\n",
                m_est, s, se, G - 1, m_est / se, tt$p.value,
                tt$conf.int[1], tt$conf.int[2]))
    cat(sprintf("      exact sign test: %d of %d negative, p = %.4f\n", n_neg, G, st$p.value))
    cat(sprintf("      Wilcoxon signed-rank p = %.4f (companion)\n", wt$p.value))
    cat(sprintf("      Shapiro-Wilk W = %.3f, p = %.3f  (%s)\n", sw$statistic, sw$p.value,
                ifelse(sw$p.value > 0.05, "no evidence against normality",
                       "evidence against normality")))
    cat(sprintf("      fold change implied by the mean: 10^%.2f = %.1e\n", m_est, 10^abs(m_est)))

    res[[m]] <- data.frame(table = tag, measure = m, label = MEAS[[m]], scale = scale,
      n_pairs = nrow(dd), n_clades = G,
      clade_mean = m_est, clade_sd = s, clade_se = se,
      t_statistic = m_est / se, df = G - 1, p_t = tt$p.value,
      ci_lo = tt$conf.int[1], ci_hi = tt$conf.int[2],
      n_negative = n_neg, p_sign = st$p.value,
      p_wilcoxon = wt$p.value,
      shapiro_W = as.numeric(sw$statistic), shapiro_p = sw$p.value,
      fold_change = 10^abs(m_est),
      clade_min = min(pc), clade_max = max(pc))
    vals[[m]] <- data.frame(table = tag, measure = m, scale = scale,
                            clade = names(pc), value = as.numeric(pc))
  }
  out <- do.call(rbind, res)
  write.csv(out, file.path(OUT, paste0("clade_level_", tag, ".csv")), row.names = FALSE)
  cat(sprintf("   wrote clade_level_%s.csv\n", tag))
  list(res = out, vals = do.call(rbind, vals))
}

all <- lapply(TABLES, analyse_table)
res  <- do.call(rbind, lapply(all, `[[`, "res"))
vls  <- do.call(rbind, lapply(all, `[[`, "vals"))
res$table <- factor(res$table, levels = TABLES)
res <- res[order(res$table, match(res$measure, names(MEAS))), ]

## write the combined files; if an output is locked by another program (for
## example an open Excel window) fall back to a suffixed name rather than
## aborting the run
safe_write <- function(x, path) {
  ok <- tryCatch({ write.csv(x, path, row.names = FALSE); TRUE },
                 error = function(e) FALSE, warning = function(w) FALSE)
  if (!ok) {
    alt <- sub("\\.csv$", "_new.csv", path)
    write.csv(x, alt, row.names = FALSE)
    cat(sprintf("   NOTE: %s is locked by another program; wrote %s instead\n",
                basename(path), basename(alt)))
  }
  invisible(NULL)
}
safe_write(res, file.path(OUT, "clade_level_all.csv"))
safe_write(vls, file.path(OUT, "clade_level_values.csv"))

## ---- raw versus FDR-corrected, side by side --------------------------------
comp <- do.call(rbind, lapply(c("PHyper", "PHyperAA"), function(m) {
  a <- res[res$measure == m, ]; b <- res[res$measure == paste0(m, "FDR"), ]
  a <- a[order(a$table), ]; b <- b[order(b$table), ]
  data.frame(table = a$table, measure = m,
             p_t_raw = a$p_t, p_t_fdr = b$p_t,
             mean_raw = a$clade_mean, mean_fdr = b$clade_mean,
             n_neg_raw = a$n_negative, n_neg_fdr = b$n_negative,
             p_sign_raw = a$p_sign, p_sign_fdr = b$p_sign,
             shapiro_p_raw = a$shapiro_p, shapiro_p_fdr = b$shapiro_p,
             significant_both = (a$p_t < 0.05) & (b$p_t < 0.05),
             conclusion_changed = (a$p_t < 0.05) != (b$p_t < 0.05))
}))
write.csv(comp, file.path(OUT, "clade_level_fdr_comparison.csv"), row.names = FALSE)

cat("\n", strrep("=", 118), "\n", sep = "")
cat("SUMMARY - clade-level analysis, one observation per clade (G = 8)\n")
cat(strrep("=", 118), "\n", sep = "")
print(res[, c("table", "measure", "clade_mean", "clade_se", "t_statistic", "p_t",
              "n_negative", "p_sign", "shapiro_p")], row.names = FALSE)

cat("\nRAW versus FDR-CORRECTED\n")
print(comp[, c("table", "measure", "p_t_raw", "p_t_fdr", "mean_raw", "mean_fdr",
               "significant_both", "conclusion_changed")], row.names = FALSE)
cat("\nwrote clade_level_all.csv, clade_level_values.csv and clade_level_fdr_comparison.csv\n")
