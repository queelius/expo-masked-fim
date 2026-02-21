#!/usr/bin/env Rscript
# Validate asymptotic normality of the MLE for exponential series systems
# with masked failure data (m=3, w=2, uniform masking).
#
# Tests whether the standardized MLE components follow a standard normal
# distribution using Shapiro-Wilk tests and Q-Q plots.
#
# Self-contained: no external packages required beyond base R.

set.seed(2026)

# --- Generate MLE samples ---
BATCH_SIZE <- 10000L

generate_mle_samples <- function(lambda, n, R) {
  Lambda <- sum(lambda)
  probs <- lambda / Lambda
  others <- matrix(c(2L, 3L, 1L, 3L, 1L, 2L), nrow = 3, byrow = TRUE)

  mle_chunks <- vector("list", ceiling(R / BATCH_SIZE))
  n_rejected <- 0L
  chunk_idx <- 0L

  R_remaining <- R
  while (R_remaining > 0L) {
    B <- min(BATCH_SIZE, R_remaining)
    R_remaining <- R_remaining - B
    chunk_idx <- chunk_idx + 1L

    t_bars <- rowMeans(matrix(rexp(B * n, rate = Lambda), nrow = B))
    K_all <- sample.int(3, size = B * n, replace = TRUE, prob = probs)
    extra_idx <- sample.int(2, B * n, replace = TRUE)
    extra_all <- others[cbind(K_all, extra_idx)]
    lo <- pmin(K_all, extra_all)
    hi <- pmax(K_all, extra_all)
    cand_code <- lo * 10L + hi

    cand_mat <- matrix(cand_code, nrow = B)
    n12 <- rowSums(cand_mat == 12L)
    n13 <- rowSums(cand_mat == 13L)
    n23 <- rowSums(cand_mat == 23L)

    keep <- (n12 + n13 > n23) & (n12 + n23 > n13) & (n13 + n23 > n12)
    n_rejected <- n_rejected + sum(!keep)

    n12 <- n12[keep]; n13 <- n13[keep]; n23 <- n23[keep]
    t_bars <- t_bars[keep]

    mle_chunks[[chunk_idx]] <- cbind(
      (n12 + n13 - n23) / (n * t_bars),
      (n12 - n13 + n23) / (n * t_bars),
      (-n12 + n13 + n23) / (n * t_bars)
    )
  }

  mle_mat <- do.call(rbind, mle_chunks)
  list(mle = mle_mat, reject_rate = n_rejected / R)
}

# --- Theoretical asymptotic covariance ---
theoretical_cov <- function(lambda, n) {
  L <- sum(lambda)
  (L / n) * matrix(c(
     L,          -lambda[3], -lambda[2],
    -lambda[3],   L,         -lambda[1],
    -lambda[2],  -lambda[1],  L
  ), nrow = 3, byrow = TRUE)
}

# --- Configuration ---
configs <- list(
  list(lambda = c(3, 3, 3), label = "Symmetric (3,3,3)"),
  list(lambda = c(2, 3, 4), label = "Moderate (2,3,4)"),
  list(lambda = c(1, 3, 5), label = "Strong (1,3,5)")
)

# Use large n to be well into asymptotic regime
n_values <- c(100, 500, 1000)
R <- 100000

cat("Asymptotic normality validation...\n\n")

# --- Shapiro-Wilk tests ---
cat("=== Shapiro-Wilk Test (p-values for normality of standardized MLE) ===\n\n")
cat(sprintf("%-25s %6s %12s %12s %12s\n",
            "Configuration", "n", "lambda_1", "lambda_2", "lambda_3"))
cat(strrep("-", 70), "\n")

for (cfg in configs) {
  for (n in n_values) {
    res <- generate_mle_samples(cfg$lambda, n, R)
    Sigma <- theoretical_cov(cfg$lambda, n)
    se <- sqrt(diag(Sigma))

    # Standardize
    z <- sweep(res$mle, 2, cfg$lambda) / matrix(se, nrow = nrow(res$mle),
                                                  ncol = 3, byrow = TRUE)

    # Shapiro-Wilk on subsample (limited to 5000 by R)
    sub_idx <- sample.int(nrow(z), min(5000, nrow(z)))
    sw <- sapply(1:3, function(j) shapiro.test(z[sub_idx, j])$p.value)

    cat(sprintf("%-25s %6d %12.4f %12.4f %12.4f\n",
                cfg$label, n, sw[1], sw[2], sw[3]))
  }
  cat("\n")
}

# --- Q-Q plots ---
figpath <- tryCatch(
  file.path(dirname(sys.frame(1)$ofile), "..", "paper", "fig_qq.pdf"),
  error = function(e) NULL
)
if (is.null(figpath) || !dir.exists(dirname(figpath))) {
  # Fallback: try relative path from working directory
  if (dir.exists("paper")) {
    figpath <- "paper/fig_qq.pdf"
  } else if (dir.exists("../paper")) {
    figpath <- "../paper/fig_qq.pdf"
  } else {
    figpath <- "fig_qq.pdf"
  }
}
cat(sprintf("\nWriting Q-Q plot to %s\n", normalizePath(figpath, mustWork = FALSE)))

pdf(figpath, width = 8, height = 6)
par(mfrow = c(3, 3), mar = c(3.5, 3.5, 2.5, 0.8), mgp = c(2.2, 0.7, 0))

for (cfg in configs) {
  n <- 1000  # Well into asymptotic regime
  res <- generate_mle_samples(cfg$lambda, n, R)
  Sigma <- theoretical_cov(cfg$lambda, n)
  se <- sqrt(diag(Sigma))

  z <- sweep(res$mle, 2, cfg$lambda) / matrix(se, nrow = nrow(res$mle),
                                                ncol = 3, byrow = TRUE)

  for (j in 1:3) {
    qqnorm(z[sample.int(nrow(z), 5000), j],
           main = sprintf("%s, j=%d", cfg$label, j),
           cex.main = 0.85, cex = 0.3, col = rgb(0, 0, 0.7, 0.3),
           xlab = "Theoretical quantiles", ylab = "Sample quantiles")
    abline(0, 1, col = "red", lwd = 1.5)
  }
}

invisible(dev.off())

# --- Anderson-Darling-like tail check ---
cat("\n=== Tail Behavior: Fraction outside 2 and 3 standard deviations ===\n")
cat(sprintf("Expected: 2 SD -> %.2f%%, 3 SD -> %.2f%%\n\n",
            (1 - pnorm(2) + pnorm(-2)) * 100,
            (1 - pnorm(3) + pnorm(-3)) * 100))

for (cfg in configs) {
  n <- 1000
  res <- generate_mle_samples(cfg$lambda, n, R)
  Sigma <- theoretical_cov(cfg$lambda, n)
  se <- sqrt(diag(Sigma))

  z <- sweep(res$mle, 2, cfg$lambda) / matrix(se, nrow = nrow(res$mle),
                                                ncol = 3, byrow = TRUE)

  cat(sprintf("%s (n=%d):\n", cfg$label, n))
  for (j in 1:3) {
    outside_2 <- mean(abs(z[, j]) > 2) * 100
    outside_3 <- mean(abs(z[, j]) > 3) * 100
    cat(sprintf("  lambda_%d: >2 SD = %.2f%%, >3 SD = %.2f%%\n",
                j, outside_2, outside_3))
  }
  cat("\n")
}

cat("Done.\n")
