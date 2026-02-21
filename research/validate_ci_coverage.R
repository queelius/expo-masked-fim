#!/usr/bin/env Rscript
# Confidence interval coverage validation for exponential series systems
# with masked failure data (m=3, w=2, uniform masking).
#
# Validates the Wald-type confidence interval (Eq. 24) by checking that
# the empirical coverage rate matches the nominal level as n grows.
#
# Self-contained: no external packages required beyond base R.

set.seed(2026)

# --- Theoretical asymptotic covariance (equation 30) ---
theoretical_cov <- function(lambda, n) {
  L <- sum(lambda)
  (L / n) * matrix(c(
     L,          -lambda[3], -lambda[2],
    -lambda[3],   L,         -lambda[1],
    -lambda[2],  -lambda[1],  L
  ), nrow = 3, byrow = TRUE)
}

# --- Identifiability check ---
is_identifiable <- function(n12, n13, n23) {
  (n12 + n13 > n23) & (n12 + n23 > n13) & (n13 + n23 > n12)
}

# --- Coverage simulation ---
# For each replicate: generate data, compute MLE, compute CI, check coverage.
BATCH_SIZE <- 10000L

ci_coverage <- function(lambda, n, R, alpha_levels = c(0.10, 0.05, 0.01)) {
  Lambda <- sum(lambda)
  probs <- lambda / Lambda
  others <- matrix(c(2L, 3L, 1L, 3L, 1L, 2L), nrow = 3, byrow = TRUE)

  # Storage for coverage counts: [alpha_level, component]
  n_covered <- matrix(0L, nrow = length(alpha_levels), ncol = 3)
  n_valid <- 0L
  n_rejected <- 0L

  R_remaining <- R
  while (R_remaining > 0L) {
    B <- min(BATCH_SIZE, R_remaining)
    R_remaining <- R_remaining - B

    # Generate data
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

    keep <- is_identifiable(n12, n13, n23)
    n_rejected <- n_rejected + sum(!keep)

    n12 <- n12[keep]; n13 <- n13[keep]; n23 <- n23[keep]
    t_bars_k <- t_bars[keep]
    B_kept <- sum(keep)
    if (B_kept == 0L) next
    n_valid <- n_valid + B_kept

    # Closed-form MLE
    mle1 <- (n12 + n13 - n23) / (n * t_bars_k)
    mle2 <- (n12 - n13 + n23) / (n * t_bars_k)
    mle3 <- (-n12 + n13 + n23) / (n * t_bars_k)

    # For each replicate, compute the plug-in asymptotic variance
    # I^{-1}(hat_lambda | w=2) / n, diagonal elements
    # From eq. 30: [I^{-1}]_{jj} = Lambda^2 / n where Lambda = sum(lambda)
    # More precisely: diagonal of I^{-1}/n = Lambda * Lambda / n
    # Actually, from the covariance matrix:
    #   Var(hat_lambda_j) = Lambda^2 / n
    # where Lambda = hat_lambda_1 + hat_lambda_2 + hat_lambda_3 (plug-in)
    Lambda_hat <- mle1 + mle2 + mle3  # = 1/t_bar
    var1 <- Lambda_hat^2 / n
    var2 <- Lambda_hat^2 / n
    var3 <- Lambda_hat^2 / n

    se1 <- sqrt(var1)
    se2 <- sqrt(var2)
    se3 <- sqrt(var3)

    # Check coverage for each alpha level
    for (ai in seq_along(alpha_levels)) {
      z <- qnorm(1 - alpha_levels[ai] / 2)

      covered1 <- (lambda[1] >= mle1 - z * se1) & (lambda[1] <= mle1 + z * se1)
      covered2 <- (lambda[2] >= mle2 - z * se2) & (lambda[2] <= mle2 + z * se2)
      covered3 <- (lambda[3] >= mle3 - z * se3) & (lambda[3] <= mle3 + z * se3)

      n_covered[ai, 1] <- n_covered[ai, 1] + sum(covered1)
      n_covered[ai, 2] <- n_covered[ai, 2] + sum(covered2)
      n_covered[ai, 3] <- n_covered[ai, 3] + sum(covered3)
    }
  }

  coverage_rates <- n_covered / n_valid
  list(
    coverage = coverage_rates,
    alpha_levels = alpha_levels,
    n_valid = n_valid,
    reject_rate = n_rejected / R
  )
}

# --- Configuration ---
configs <- list(
  list(lambda = c(3, 3, 3), label = "Symmetric (3,3,3)"),
  list(lambda = c(2, 3, 4), label = "Moderate (2,3,4)"),
  list(lambda = c(1, 3, 5), label = "Strong (1,3,5)")
)

sample_sizes <- c(50, 100, 200, 500, 1000)
alpha_levels <- c(0.10, 0.05, 0.01)
R <- 100000

# --- Run ---
cat(sprintf("Confidence interval coverage validation (R = %s per cell)...\n\n",
            format(R, big.mark = ",")))

all_results <- list()

for (cfg in configs) {
  cat(sprintf("=== %s ===\n", cfg$label))
  cat(sprintf("  %-6s", "n"))
  for (a in alpha_levels) {
    nominal <- (1 - a) * 100
    cat(sprintf("  %4.0f%% CI (l1,l2,l3)       ", nominal))
  }
  cat("  reject%%\n")

  for (n in sample_sizes) {
    res <- ci_coverage(cfg$lambda, n, R, alpha_levels)

    cat(sprintf("  %-6d", n))
    for (ai in seq_along(alpha_levels)) {
      cat(sprintf("  (%5.1f,%5.1f,%5.1f)%%",
                  res$coverage[ai, 1] * 100,
                  res$coverage[ai, 2] * 100,
                  res$coverage[ai, 3] * 100))
    }
    cat(sprintf("  %5.1f%%\n", res$reject_rate * 100))

    all_results[[paste(cfg$label, n)]] <- list(
      config = cfg$label, n = n,
      coverage = res$coverage, reject = res$reject_rate
    )
  }
  cat("\n")
}

# --- Generate LaTeX table for paper ---
cat("\n=== LaTeX Table (95% CI coverage) ===\n\n")
cat("\\begin{table}[t]\n")
cat("\\centering\n")
cat("\\caption{Empirical coverage rates (\\%) for 95\\% Wald confidence intervals")
cat(" (Eq.~\\ref{eq:confidence_interval}), based on $R = 10^5$ replications.\n")
cat("Non-identifiable samples filtered via triangle inequality~\\eqref{eq:triangle_ineq}.")
cat(" Nominal coverage is 95\\%.}\n")
cat("\\label{tab:coverage}\n")
cat("\\begin{tabular}{llrrr}\n")
cat("\\hline\n")
cat("Configuration & $n$ & $\\hat{\\lambda}_1$ & $\\hat{\\lambda}_2$ & $\\hat{\\lambda}_3$ \\\\\n")
cat("\\hline\n")

for (cfg in configs) {
  first <- TRUE
  for (n in sample_sizes) {
    key <- paste(cfg$label, n)
    res <- all_results[[key]]
    ai <- 2  # 95% CI index

    label <- if (first) cfg$label else ""
    first <- FALSE

    cat(sprintf("%s & %d & %.1f & %.1f & %.1f \\\\\n",
                label, n,
                res$coverage[ai, 1] * 100,
                res$coverage[ai, 2] * 100,
                res$coverage[ai, 3] * 100))
  }
  cat("\\hline\n")
}

cat("\\end{tabular}\n")
cat("\\end{table}\n")

cat("\nDone.\n")
