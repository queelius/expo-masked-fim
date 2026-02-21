#!/usr/bin/env Rscript
# Validate the closed-form MLE (Theorem 5.1) for general m-component systems
# with masking cardinality w = m-1.
#
# Extends the m=3 validation to m=4, m=5, and m=10 to confirm that the
# general-m formula works correctly for arbitrary system dimension.
#
# Self-contained: no external packages required beyond base R.

set.seed(2026)

# --- Closed-form MLE for w = m-1 (Theorem 5.1) ---
# hat_lambda_j = (A_j - (m-2)*B_j) / (n * t_bar)
# where A_j = sum of candidate set counts containing j
#       B_j = count of the unique candidate set excluding j

# --- Theoretical asymptotic covariance for w = m-1 ---
# From Proposition 4.5, specialized to w = m-1:
# I^{-1}(lambda | w=m-1) has entries computed from the general formula.
theoretical_cov_wm1 <- function(lambda) {
  m <- length(lambda)
  Lambda <- sum(lambda)
  w <- m - 1

  # Generate all candidate sets of size w = m-1
  # Each is {1,...,m} \ {j} for j = 1,...,m
  # FIM element [j,k] = sum over c containing both j and k of
  #   1 / (sigma_c * C(m-1,w-1) * Lambda)
  # where sigma_c = sum of lambda_p for p in c

  binom_coeff <- choose(m - 1, w - 1)  # = m-1 for w=m-1

  FIM <- matrix(0, nrow = m, ncol = m)
  for (excluded in 1:m) {
    c <- setdiff(1:m, excluded)
    sigma_c <- sum(lambda[c])
    for (j in c) {
      for (k in c) {
        FIM[j, k] <- FIM[j, k] + 1 / sigma_c
      }
    }
  }
  FIM <- FIM / (binom_coeff * Lambda)

  # Invert for asymptotic covariance
  solve(FIM)
}

# --- Monte Carlo validation for general m ---
BATCH_SIZE <- 5000L

mc_validate_general_m <- function(lambda, n, R) {
  m <- length(lambda)
  w <- m - 1
  Lambda <- sum(lambda)
  probs <- lambda / Lambda

  # Precompute: candidate sets are complements of singletons
  # cand_sets[[j]] = {1,...,m} \ {j}
  cand_sets <- lapply(1:m, function(j) setdiff(1:m, j))

  # For each failed component k, it appears in all candidate sets except
  # the one that excludes k. We need to sample which set we observe.
  # Under uniform masking with w=m-1, each of the (m-1) sets containing k
  # is equally likely. The set containing k is everything except one of the
  # non-k components, chosen uniformly.

  mle_chunks <- vector("list", ceiling(R / BATCH_SIZE))
  n_rejected <- 0L
  chunk_idx <- 0L

  R_remaining <- R
  while (R_remaining > 0L) {
    B <- min(BATCH_SIZE, R_remaining)
    R_remaining <- R_remaining - B
    chunk_idx <- chunk_idx + 1L

    # Generate system lifetimes
    t_bars <- rowMeans(matrix(rexp(B * n, rate = Lambda), nrow = B))

    # For each of B*n observations, determine:
    # 1. Which component failed (K)
    # 2. Which component is excluded from the candidate set
    K_all <- sample.int(m, size = B * n, replace = TRUE, prob = probs)

    # Under uniform masking w=m-1, the excluded component is chosen uniformly
    # from the m-1 non-failed components
    non_failed_idx <- sample.int(m - 1, B * n, replace = TRUE)

    # Map non_failed_idx to actual component: the non_failed_idx-th component
    # among {1,...,m} \ {K}
    excluded <- integer(B * n)
    for (i in seq_len(B * n)) {
      others <- setdiff(1:m, K_all[i])
      excluded[i] <- others[non_failed_idx[i]]
    }

    # Count B_j (how many times the set excluding j was observed) per sample
    excluded_mat <- matrix(excluded, nrow = B)
    B_counts <- matrix(0L, nrow = B, ncol = m)
    for (j in 1:m) {
      B_counts[, j] <- rowSums(excluded_mat == j)
    }

    # A_j = n - B_j (every observation either contains j or excludes j)
    A_counts <- n - B_counts

    # MLE: hat_lambda_j = (A_j - (m-2)*B_j) / (n * t_bar)
    mle_mat <- (A_counts - (m - 2) * B_counts) / (n * t_bars)

    # Filter: keep only samples where all MLE components are positive
    keep <- apply(mle_mat > 0, 1, all)
    n_rejected <- n_rejected + sum(!keep)

    if (sum(keep) > 0) {
      mle_chunks[[chunk_idx]] <- mle_mat[keep, , drop = FALSE]
    }
  }

  mle_all <- do.call(rbind, mle_chunks)
  R_eff <- nrow(mle_all)

  # Empirical covariance
  emp_cov <- cov(mle_all)

  # Theoretical covariance
  theory_cov <- theoretical_cov_wm1(lambda) / n

  # Error metrics
  diff_mat <- emp_cov - theory_cov
  rel_frob <- sqrt(sum(diff_mat^2)) / sqrt(sum(theory_cov^2))

  # Bias check: mean of MLEs vs true parameters
  mle_means <- colMeans(mle_all)
  rel_bias <- (mle_means - lambda) / lambda

  list(
    rel_frob = rel_frob,
    reject_rate = n_rejected / R,
    R_eff = R_eff,
    mle_means = mle_means,
    rel_bias = rel_bias,
    emp_cov = emp_cov,
    theory_cov = theory_cov
  )
}

# --- Configuration ---
configs <- list(
  list(m = 4, lambda = c(1, 1, 1, 1), label = "m=4, equal (1,1,1,1)"),
  list(m = 4, lambda = c(1, 2, 3, 4), label = "m=4, asymmetric (1,2,3,4)"),
  list(m = 5, lambda = c(1, 1, 1, 1, 1), label = "m=5, equal (1,1,1,1,1)"),
  list(m = 5, lambda = c(1, 2, 3, 4, 5), label = "m=5, asymmetric (1,2,3,4,5)"),
  list(m = 10, lambda = rep(1, 10), label = "m=10, equal (1,...,1)"),
  list(m = 10, lambda = 1:10, label = "m=10, asymmetric (1,...,10)")
)

sample_sizes <- c(100, 500, 2000)
R <- 50000

cat(sprintf("General-m MLE validation (R = %s per cell)...\n\n",
            format(R, big.mark = ",")))

cat(sprintf("%-35s %6s %12s %10s %12s\n",
            "Configuration", "n", "Rel.Frob(%)", "Reject(%)", "Max|bias|"))
cat(strrep("-", 80), "\n")

for (cfg in configs) {
  for (n in sample_sizes) {
    cat(sprintf("  %-33s n=%-4d ... ", cfg$label, n))
    flush.console()

    res <- mc_validate_general_m(cfg$lambda, n, R)

    cat(sprintf("rel_frob=%.2f%%, reject=%.1f%%, max|bias|=%.4f\n",
                res$rel_frob * 100, res$reject_rate * 100, max(abs(res$rel_bias))))
  }
  cat("\n")
}

# --- Summary table ---
cat("\n=== Summary: Relative Frobenius Error (%) ===\n\n")
cat(sprintf("%-35s", "Configuration"))
for (n in sample_sizes) cat(sprintf(" %8d", n))
cat("\n")
cat(strrep("-", 35 + 9 * length(sample_sizes)), "\n")

for (cfg in configs) {
  cat(sprintf("%-35s", cfg$label))
  for (n in sample_sizes) {
    res <- mc_validate_general_m(cfg$lambda, n, R)
    cat(sprintf(" %7.2f%%", res$rel_frob * 100))
  }
  cat("\n")
}

cat("\nDone.\n")
