#!/usr/bin/env Rscript
# Verify mutual information derivations for series systems with masked failures
# Under uniform masking model with exponential component lifetimes

# Helper function to compute mutual information I(K;C)
compute_mutual_information <- function(m, lambda, w) {
  Lambda <- sum(lambda)

  # P(K=k) for each component k
  prob_k <- lambda / Lambda

  # Generate all candidate sets of cardinality w
  candidate_sets <- combn(1:m, w, simplify = FALSE)

  # P(C=c|K=k) = 1/C(m-1,w-1) if k in c, else 0
  prob_c_given_k <- 1 / choose(m-1, w-1)

  # Compute P(C=c) for each candidate set c
  prob_c <- sapply(candidate_sets, function(c) {
    sum(lambda[c]) / (Lambda * choose(m-1, w-1))
  })

  # Compute mutual information
  mi <- 0
  for (i in seq_along(candidate_sets)) {
    c <- candidate_sets[[i]]
    sigma_c <- sum(lambda[c])

    for (k in c) {
      # P(K=k, C=c) = P(C=c|K=k) * P(K=k)
      prob_k_and_c <- prob_c_given_k * prob_k[k]

      # I(K;C) += P(K=k,C=c) * log(P(K=k,C=c) / (P(K=k)*P(C=c)))
      mi <- mi + prob_k_and_c * log(prob_k_and_c / (prob_k[k] * prob_c[i]))
    }
  }

  return(mi)
}

# Alternative formula using sigma_c
compute_mutual_information_formula2 <- function(m, lambda, w) {
  Lambda <- sum(lambda)

  # Generate all candidate sets of cardinality w
  candidate_sets <- combn(1:m, w, simplify = FALSE)

  # Compute using alternative formula
  mi <- 0
  for (c in candidate_sets) {
    sigma_c <- sum(lambda[c])
    mi <- mi + (sigma_c / (Lambda * choose(m-1, w-1))) * log(Lambda / sigma_c)
  }

  return(mi)
}

# Compute entropy H(K)
compute_entropy_k <- function(lambda) {
  prob_k <- lambda / sum(lambda)
  -sum(prob_k * log(prob_k))
}

cat(paste(rep("=", 78), collapse=""), "\n")
cat("MUTUAL INFORMATION VERIFICATION FOR MASKED SERIES SYSTEMS\n")
cat(paste(rep("=", 78), collapse=""), "\n\n")

# ============================================================================
# Test Case 1: m=3, lambda=(1,3,5), w=2
# ============================================================================
cat("Test Case 1: m=3, lambda=(1,3,5), Lambda=9, w=2\n")
cat(paste(rep("-", 78), collapse=""), "\n")

m <- 3
lambda <- c(1, 3, 5)
Lambda <- sum(lambda)
w <- 2

cat("Parameters:\n")
cat(sprintf("  m = %d\n", m))
cat(sprintf("  lambda = (%s)\n", paste(lambda, collapse=", ")))
cat(sprintf("  Lambda = %g\n", Lambda))
cat(sprintf("  w = %d\n", w))
cat(sprintf("  C(m-1,w-1) = C(%d,%d) = %d\n\n", m-1, w-1, choose(m-1, w-1)))

# Verify probabilities
cat("Marginal probabilities P(K=k):\n")
for (k in 1:m) {
  cat(sprintf("  P(K=%d) = lambda_%d/Lambda = %g/%g = %g\n",
              k, k, lambda[k], Lambda, lambda[k]/Lambda))
}

cat("\nCandidate set probabilities P(C=c):\n")
candidate_sets <- combn(1:m, w, simplify = FALSE)
for (i in seq_along(candidate_sets)) {
  c <- candidate_sets[[i]]
  sigma_c <- sum(lambda[c])
  prob_c <- sigma_c / (Lambda * choose(m-1, w-1))
  cat(sprintf("  P(C={%s}) = sigma_{%s}/(Lambda*C(m-1,w-1)) = %g/(%g*%d) = %g\n",
              paste(c, collapse=","), paste(c, collapse=","),
              sigma_c, Lambda, choose(m-1, w-1), prob_c))
}

# Compute mutual information using both methods
mi_method1 <- compute_mutual_information(m, lambda, w)
mi_method2 <- compute_mutual_information_formula2(m, lambda, w)

cat("\nMutual Information I(K;C):\n")
cat(sprintf("  Method 1 (definition): I(K;C) = %g\n", mi_method1))
cat(sprintf("  Method 2 (formula):    I(K;C) = %g\n", mi_method2))
cat(sprintf("  Difference:            |I1 - I2| = %g\n", abs(mi_method1 - mi_method2)))
cat(sprintf("  ✓ Methods agree: %s\n\n",
            ifelse(abs(mi_method1 - mi_method2) < 1e-10, "YES", "NO")))

# ============================================================================
# Test Case 2: Compare w=1 and w=2 for same system
# ============================================================================
cat("Test Case 2: Verify I(K;C_w=1) = H(K) and I(K;C_w=1) > I(K;C_w=2)\n")
cat(paste(rep("-", 78), collapse=""), "\n")

mi_w1 <- compute_mutual_information(m, lambda, w=1)
mi_w2 <- compute_mutual_information(m, lambda, w=2)
h_k <- compute_entropy_k(lambda)

cat(sprintf("  H(K) = %g\n", h_k))
cat(sprintf("  I(K;C) with w=1: %g\n", mi_w1))
cat(sprintf("  I(K;C) with w=2: %g\n", mi_w2))
cat(sprintf("  |I(K;C_w=1) - H(K)| = %g\n", abs(mi_w1 - h_k)))
cat(sprintf("  ✓ I(K;C_w=1) = H(K): %s\n",
            ifelse(abs(mi_w1 - h_k) < 1e-10, "YES", "NO")))
cat(sprintf("  ✓ I(K;C_w=1) > I(K;C_w=2): %s\n\n",
            ifelse(mi_w1 > mi_w2, "YES", "NO")))

# ============================================================================
# Test Case 3: Symmetric case lambda=(3,3,3), w=2
# ============================================================================
cat("Test Case 3: Symmetric case lambda=(3,3,3), w=2\n")
cat(paste(rep("-", 78), collapse=""), "\n")

m_sym <- 3
lambda_sym <- c(3, 3, 3)
w_sym <- 2

mi_sym <- compute_mutual_information(m_sym, lambda_sym, w_sym)
theoretical_sym <- log(m_sym / w_sym)

cat(sprintf("  m = %d, lambda = (%s), w = %d\n",
            m_sym, paste(lambda_sym, collapse=", "), w_sym))
cat(sprintf("  I(K;C) computed: %g\n", mi_sym))
cat(sprintf("  I(K;C) = log(m/w) = log(%d/%d) = %g\n",
            m_sym, w_sym, theoretical_sym))
cat(sprintf("  Difference: %g\n", abs(mi_sym - theoretical_sym)))
cat(sprintf("  ✓ Formula verified: %s\n\n",
            ifelse(abs(mi_sym - theoretical_sym) < 1e-10, "YES", "NO")))

# ============================================================================
# Test Case 4: m=4, lambda=(1,2,3,4), w=1,2,3 - monotonicity
# ============================================================================
cat("Test Case 4: m=4, lambda=(1,2,3,4), monotonicity in w\n")
cat(paste(rep("-", 78), collapse=""), "\n")

m4 <- 4
lambda4 <- c(1, 2, 3, 4)

cat(sprintf("  m = %d, lambda = (%s)\n\n", m4, paste(lambda4, collapse=", ")))

mi_values <- numeric(3)
for (w_test in 1:3) {
  mi_values[w_test] <- compute_mutual_information(m4, lambda4, w_test)
  cat(sprintf("  I(K;C) with w=%d: %g\n", w_test, mi_values[w_test]))
}

cat("\n  Monotonicity check:\n")
for (i in 1:(length(mi_values)-1)) {
  decrease <- mi_values[i] > mi_values[i+1]
  cat(sprintf("    I(w=%d) > I(w=%d): %s (difference = %g)\n",
              i, i+1, ifelse(decrease, "YES", "NO"),
              mi_values[i] - mi_values[i+1]))
}

all_decreasing <- all(diff(mi_values) < 0)
cat(sprintf("  ✓ I(K;C) monotonically decreasing in w: %s\n\n",
            ifelse(all_decreasing, "YES", "NO")))

# ============================================================================
# Additional verification: Detailed computation for Test Case 1
# ============================================================================
cat("Detailed Computation for Test Case 1 (m=3, lambda=(1,3,5), w=2)\n")
cat(paste(rep("-", 78), collapse=""), "\n")

m <- 3
lambda <- c(1, 3, 5)
Lambda <- 9
w <- 2

cat("Computing I(K;C) term by term:\n\n")

candidate_sets <- combn(1:m, w, simplify = FALSE)
total_mi <- 0

for (i in seq_along(candidate_sets)) {
  c <- candidate_sets[[i]]
  sigma_c <- sum(lambda[c])
  prob_c <- sigma_c / (Lambda * choose(m-1, w-1))

  cat(sprintf("Candidate set C = {%s}, sigma_c = %g, P(C) = %g\n",
              paste(c, collapse=","), sigma_c, prob_c))

  set_contribution <- 0
  for (k in c) {
    prob_k <- lambda[k] / Lambda
    prob_c_given_k <- 1 / choose(m-1, w-1)
    prob_k_and_c <- prob_c_given_k * prob_k

    term <- prob_k_and_c * log(prob_k_and_c / (prob_k * prob_c))
    set_contribution <- set_contribution + term

    cat(sprintf("  k=%d: P(K=%d,C)=%g, log(P(K,C)/(P(K)P(C)))=%g, contribution=%g\n",
                k, k, prob_k_and_c, log(prob_k_and_c / (prob_k * prob_c)), term))
  }

  cat(sprintf("  Set contribution: %g\n\n", set_contribution))
  total_mi <- total_mi + set_contribution
}

cat(sprintf("Total I(K;C) = %g\n\n", total_mi))

# Alternative formula verification
cat("Verification using alternative formula:\n")
alt_mi <- 0
for (i in seq_along(candidate_sets)) {
  c <- candidate_sets[[i]]
  sigma_c <- sum(lambda[c])
  term <- (sigma_c / (Lambda * choose(m-1, w-1))) * log(Lambda / sigma_c)
  cat(sprintf("  C={%s}: (sigma_c/(Lambda*C(m-1,w-1))) * log(Lambda/sigma_c) = %g\n",
              paste(c, collapse=","), term))
  alt_mi <- alt_mi + term
}
cat(sprintf("Total: %g\n", alt_mi))

cat("\n", paste(rep("=", 78), collapse=""), "\n")
cat("ALL VERIFICATIONS COMPLETE\n")
cat(paste(rep("=", 78), collapse=""), "\n")
