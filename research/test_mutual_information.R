#!/usr/bin/env Rscript
# Unit tests for mutual information computations

library(testthat)

# Helper function to compute mutual information I(K;C)
compute_mutual_information <- function(m, lambda, w) {
  Lambda <- sum(lambda)
  prob_k <- lambda / Lambda
  candidate_sets <- combn(1:m, w, simplify = FALSE)
  prob_c_given_k <- 1 / choose(m-1, w-1)
  prob_c <- sapply(candidate_sets, function(c) {
    sum(lambda[c]) / (Lambda * choose(m-1, w-1))
  })

  mi <- 0
  for (i in seq_along(candidate_sets)) {
    c <- candidate_sets[[i]]
    for (k in c) {
      prob_k_and_c <- prob_c_given_k * prob_k[k]
      mi <- mi + prob_k_and_c * log(prob_k_and_c / (prob_k[k] * prob_c[i]))
    }
  }
  return(mi)
}

# Alternative formula
compute_mutual_information_formula2 <- function(m, lambda, w) {
  Lambda <- sum(lambda)
  candidate_sets <- combn(1:m, w, simplify = FALSE)
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

cat("Running mutual information unit tests...\n\n")

# Test 1: Formula equivalence
cat("Test 1: Formula equivalence for m=3, lambda=(1,3,5), w=2\n")
m <- 3
lambda <- c(1, 3, 5)
w <- 2
mi1 <- compute_mutual_information(m, lambda, w)
mi2 <- compute_mutual_information_formula2(m, lambda, w)
test_that("Formula equivalence", expect_equal(mi1, mi2, tolerance = 1e-10))

# Test 2: Perfect masking
cat("Test 2: I(K;C) with w=1 equals H(K)\n")
mi_w1 <- compute_mutual_information(m, lambda, w=1)
h_k <- compute_entropy_k(lambda)
test_that("Perfect masking", expect_equal(mi_w1, h_k, tolerance = 1e-10))

# Test 3: Information decreases with larger w
cat("Test 3: I(K;C) decreases as w increases\n")
mi_w2 <- compute_mutual_information(m, lambda, w=2)
test_that("Monotonicity", expect_true(mi_w1 > mi_w2))

# Test 4: Symmetric case
cat("Test 4: Symmetric case I(K;C) = log(m/w)\n")
lambda_sym <- c(3, 3, 3)
w_sym <- 2
mi_sym <- compute_mutual_information(m, lambda_sym, w_sym)
theoretical <- log(m / w_sym)
test_that("Symmetric case", expect_equal(mi_sym, theoretical, tolerance = 1e-10))

# Test 5: Monotonicity for m=4
cat("Test 5: Monotonicity in w for m=4\n")
m4 <- 4
lambda4 <- c(1, 2, 3, 4)
mi_values <- sapply(1:3, function(w) compute_mutual_information(m4, lambda4, w))
test_that("m=4 monotonicity", expect_true(all(diff(mi_values) < 0)))

# Test 6: Non-negativity
cat("Test 6: I(K;C) is non-negative\n")
test_that("Non-negativity", expect_true(mi2 >= 0))

# Test 7: Upper bound
cat("Test 7: I(K;C) is bounded by H(K)\n")
test_that("Upper bound", expect_true(mi2 <= h_k))

# Test 8: Edge case m=2
cat("Test 8: Edge case m=2, w=1\n")
m2 <- 2
lambda2 <- c(1, 2)
mi2_w1 <- compute_mutual_information(m2, lambda2, w=1)
h_k2 <- compute_entropy_k(lambda2)
test_that("Edge case m=2", expect_equal(mi2_w1, h_k2, tolerance = 1e-10))

# Test 9: Larger candidate sets
cat("Test 9: Edge case m=4, w=3 vs w=2\n")
mi_w3 <- compute_mutual_information(m4, lambda4, w=3)
mi_w2_m4 <- compute_mutual_information(m4, lambda4, w=2)
test_that("Large w", {
  expect_true(mi_w3 < mi_w2_m4)
  expect_true(mi_w3 > 0)
})

cat("\n✓ All tests passed!\n")
