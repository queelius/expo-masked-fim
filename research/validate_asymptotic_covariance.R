#!/usr/bin/env Rscript
# Monte Carlo validation of asymptotic covariance for exponential series
# systems with masked failure data (m=3, w=2, uniform masking).
#
# Reproduces the numerical validation in Section 5.4 of the paper:
#   "Statistical Inference for Series Systems from Masked Failure Time Data"
#
# Self-contained: no external packages required beyond base R.
#
# Key design choice: samples where any MLE component is non-positive are
# discarded. These violate the identifiability assumption (the sample's
# candidate sets do not separate all component pairs), which can happen
# by random chance for small n. The rejection rate is reported.

set.seed(42)

# --- Theoretical asymptotic covariance (equation 30) ---
# I^{-1}(lambda | w=2) / n
theoretical_cov <- function(lambda, n) {
  L <- sum(lambda)
  (L / n) * matrix(c(
     L,          -lambda[3], -lambda[2],
    -lambda[3],   L,         -lambda[1],
    -lambda[2],  -lambda[1],  L
  ), nrow = 3, byrow = TRUE)
}

# --- Identifiability check ---
# A sample is "identifiable" when the closed-form MLE yields all positive
# components. For m=3, w=2 this is equivalent to the triangle inequality
# on candidate set counts: each count is less than the sum of the other two.
# Equivalently, all three candidate sets must contribute enough observations
# to separate the component failure rates.
is_identifiable <- function(n12, n13, n23) {
  (n12 + n13 > n23) & (n12 + n23 > n13) & (n13 + n23 > n12)
}

# --- Vectorized Monte Carlo (batch-processed for memory portability) ---
# Generates R samples of size n, computes closed-form MLE for each,
# filters to identifiable samples, returns empirical covariance and stats.
# Processing in batches of BATCH_SIZE keeps peak memory under ~1 GB
# regardless of R or n, enabling reproducibility on modest hardware.
BATCH_SIZE <- 10000L

mc_covariance <- function(lambda, n, R) {
  Lambda <- sum(lambda)
  probs <- lambda / Lambda
  others <- matrix(c(2L, 3L, 1L, 3L, 1L, 2L), nrow = 3, byrow = TRUE)

  mle_chunks <- vector("list", ceiling(R / BATCH_SIZE))
  n_rejected_total <- 0L
  chunk_idx <- 0L

  R_remaining <- R
  while (R_remaining > 0L) {
    B <- min(BATCH_SIZE, R_remaining)
    R_remaining <- R_remaining - B
    chunk_idx <- chunk_idx + 1L

    # Generate system lifetimes: B samples of n observations
    t_bars <- rowMeans(matrix(rexp(B * n, rate = Lambda), nrow = B))

    # Failed components for all B*n observations
    K_all <- sample.int(3, size = B * n, replace = TRUE, prob = probs)

    # For each failed component, pick one other uniformly
    extra_idx <- sample.int(2, B * n, replace = TRUE)
    extra_all <- others[cbind(K_all, extra_idx)]

    # Encode candidate set as sorted pair
    lo <- pmin(K_all, extra_all)
    hi <- pmax(K_all, extra_all)
    cand_code <- lo * 10L + hi  # 12, 13, or 23

    # Reshape into B x n matrix and count candidate sets per sample
    cand_mat <- matrix(cand_code, nrow = B)
    n12 <- rowSums(cand_mat == 12L)
    n13 <- rowSums(cand_mat == 13L)
    n23 <- rowSums(cand_mat == 23L)

    # Filter to identifiable samples.
    # Note: for small n with high rejection rates, the empirical covariance
    # is conditional on identifiability and may systematically differ from
    # the unconditional theoretical value. This bias vanishes as n grows
    # (rejection rate -> 0).
    keep <- is_identifiable(n12, n13, n23)
    n_rejected_total <- n_rejected_total + sum(!keep)

    n12 <- n12[keep]
    n13 <- n13[keep]
    n23 <- n23[keep]
    t_bars <- t_bars[keep]

    # Closed-form MLE (Corollary 5.2)
    mle_chunks[[chunk_idx]] <- cbind(
      (n12 + n13 - n23) / (n * t_bars),
      (n12 - n13 + n23) / (n * t_bars),
      (-n12 + n13 + n23) / (n * t_bars)
    )
  }

  mle_mat <- do.call(rbind, mle_chunks)
  R_eff <- nrow(mle_mat)
  reject_rate <- n_rejected_total / R

  list(cov = cov(mle_mat), R_eff = R_eff, reject_rate = reject_rate)
}

# --- Configuration ---
configs <- list(
  list(lambda = c(3, 3, 3), label = "Symmetric (3,3,3)"),
  list(lambda = c(2, 3, 4), label = "Moderate (2,3,4)"),
  list(lambda = c(1, 3, 5), label = "Strong (1,3,5)")
)

sample_sizes <- c(10, 20, 30, 50, 100, 200, 500, 1000, 2000, 5000)
R <- 100000  # Monte Carlo replications

# --- Run simulations ---
cat(sprintf("Monte Carlo validation (R = %s per cell)...\n",
            format(R, big.mark = ",")))

all_results <- list()
for (cfg in configs) {
  lambda <- cfg$lambda
  rows <- vector("list", length(sample_sizes))

  for (si in seq_along(sample_sizes)) {
    n <- sample_sizes[si]
    cat(sprintf("  %s, n = %d ...", cfg$label, n))

    Sigma_theory <- theoretical_cov(lambda, n)
    mc <- mc_covariance(lambda, n, R)

    diff_mat <- mc$cov - Sigma_theory
    frob <- sqrt(sum(diff_mat^2))
    rel_frob <- frob / sqrt(sum(Sigma_theory^2))
    max_err <- max(abs(diff_mat))

    cat(sprintf(" reject %.2f%%, R_eff = %d\n",
                mc$reject_rate * 100, mc$R_eff))

    rows[[si]] <- data.frame(
      n = n, rel_frob = rel_frob, frob = frob, max_err = max_err,
      reject_pct = mc$reject_rate * 100, R_eff = mc$R_eff
    )
  }
  res <- do.call(rbind, rows)
  res$config <- cfg$label
  all_results[[cfg$label]] <- res
}

results_df <- do.call(rbind, all_results)

# --- Print summary ---
cat("\n=== Relative Frobenius Error (%) ===\n")
for (cfg in configs) {
  cat(sprintf("\n%s:\n", cfg$label))
  sub <- results_df[results_df$config == cfg$label, ]
  for (i in seq_len(nrow(sub))) {
    cat(sprintf("  n = %5d:  rel. Frob = %.2f%%,  max |err| = %.6f,  rejected = %.2f%%\n",
                sub$n[i], sub$rel_frob[i] * 100, sub$max_err[i], sub$reject_pct[i]))
  }
}

# --- Generate figure ---
script_dir <- tryCatch(
  dirname(sys.frame(1)$ofile),
  error = function(e) getwd()
)
figpath <- file.path(script_dir, "..", "paper", "fig_convergence.pdf")
if (!dir.exists(dirname(figpath))) figpath <- "fig_convergence.pdf"

cat(sprintf("\nWriting figure to %s\n", normalizePath(figpath, mustWork = FALSE)))

pdf(figpath, width = 5.5, height = 4)
par(mar = c(4.2, 4.8, 0.8, 0.8), cex.lab = 1.05, cex.axis = 0.9)

cols <- c("#2166AC", "#B2182B", "#4DAF4A")
pchs <- c(16, 17, 15)

plot(NULL, xlim = range(sample_sizes), ylim = c(0.001, 1.0),
     log = "xy", xlab = "Sample size (n)",
     ylab = "Relative Frobenius error",
     axes = FALSE)

axis(1, at = sample_sizes,
     labels = c("10", "20", "30", "50", "100", "200", "500", "1K", "2K", "5K"))
axis(2, at = c(0.002, 0.005, 0.01, 0.02, 0.05, 0.1, 0.2, 0.5),
     labels = c("0.2%", "0.5%", "1%", "2%", "5%", "10%", "20%", "50%"),
     las = 1)
box()

# Reference line: O(n^{-1/2})
ns_ref <- seq(8, 7000, length.out = 300)
lines(ns_ref, 0.55 / sqrt(ns_ref), col = "gray55", lty = 2, lwd = 1.5)
text(4000, 0.55 / sqrt(4000) * 1.55, expression(O(n^{-1/2})),
     col = "gray40", cex = 0.85)

for (i in seq_along(configs)) {
  sub <- all_results[[configs[[i]]$label]]
  lines(sub$n, sub$rel_frob, col = cols[i], lwd = 2)
  points(sub$n, sub$rel_frob, col = cols[i], pch = pchs[i], cex = 1.2)
}

legend("topright",
       legend = sapply(configs, `[[`, "label"),
       col = cols, pch = pchs, lwd = 2,
       cex = 0.8, bg = "white", inset = 0.02)

invisible(dev.off())
cat("Done.\n")
