#!/usr/bin/env Rscript
# Plot mutual information as a function of candidate set size w

# Helper function
compute_mi <- function(m, lambda, w) {
  Lambda <- sum(lambda)
  candidates <- combn(1:m, w, simplify = FALSE)
  mi <- 0
  for (c in candidates) {
    sigma_c <- sum(lambda[c])
    mi <- mi + (sigma_c / (Lambda * choose(m-1, w-1))) * log(Lambda / sigma_c)
  }
  return(mi)
}

# Test systems
systems <- list(
  "Asymmetric (1,3,5)" = c(1, 3, 5),
  "Symmetric (3,3,3)" = c(3, 3, 3),
  "Strongly asymmetric (1,2,8)" = c(1, 2, 8)
)

# Output file
pdf("/home/spinoza/github/papers/expo-masked-fim/research/mutual_information_vs_w.pdf",
    width = 10, height = 6)

par(mfrow = c(1, 2), mar = c(4.5, 4.5, 3, 1))

# Panel 1: m=3 systems
plot(1, type = "n", xlim = c(1, 3), ylim = c(0, 1.2),
     xlab = "Candidate set size w", ylab = "Mutual information I(K;C) [nats]",
     main = "Information vs. Masking Level (m=3)", xaxt = "n")
axis(1, at = 1:3)
grid()

colors <- c("blue", "red", "darkgreen")
ltys <- c(1, 2, 3)
pchs <- c(16, 17, 15)

for (i in seq_along(systems)) {
  lambda <- systems[[i]]
  m <- length(lambda)
  w_values <- 1:m
  mi_values <- sapply(w_values, function(w) compute_mi(m, lambda, w))

  lines(w_values, mi_values, col = colors[i], lwd = 2, lty = ltys[i])
  points(w_values, mi_values, col = colors[i], pch = pchs[i], cex = 1.5)
}

legend("topright", legend = names(systems), col = colors, lwd = 2,
       lty = ltys, pch = pchs, bty = "n", cex = 0.9)

# Panel 2: m=4 system
m4 <- 4
lambda4 <- c(1, 2, 3, 4)
w_values4 <- 1:m4
mi_values4 <- sapply(w_values4, function(w) compute_mi(m4, lambda4, w))

plot(w_values4, mi_values4, type = "b", col = "purple", lwd = 2, pch = 16, cex = 1.5,
     xlim = c(1, 4), ylim = c(0, 1.4), xlab = "Candidate set size w",
     ylab = "Mutual information I(K;C) [nats]",
     main = "Information vs. Masking Level (m=4)", xaxt = "n")
axis(1, at = 1:4)
grid()

# Add text labels for values
for (i in 1:m4) {
  text(w_values4[i], mi_values4[i] + 0.08,
       sprintf("%.3f", mi_values4[i]), cex = 0.8)
}

# Add annotation
text(2.5, 1.2, expression(lambda == "(1,2,3,4)"), cex = 1.1)

dev.off()

cat("Plot saved to: /home/spinoza/github/papers/expo-masked-fim/research/mutual_information_vs_w.pdf\n")

# Create a table summary
cat("\n=== Summary Table ===\n\n")
cat("System: m=3, lambda=(1,3,5)\n")
cat(sprintf("%-5s %10s %10s\n", "w", "I(K;C)", "% of H(K)"))
cat(strrep("-", 27), "\n")
lambda_test <- c(1, 3, 5)
H_K <- -sum(lambda_test / sum(lambda_test) * log(lambda_test / sum(lambda_test)))
for (w in 1:3) {
  mi <- compute_mi(3, lambda_test, w)
  cat(sprintf("%-5d %10.6f %9.1f%%\n", w, mi, 100 * mi / H_K))
}

cat("\n\nSystem: m=4, lambda=(1,2,3,4)\n")
cat(sprintf("%-5s %10s\n", "w", "I(K;C)"))
cat(strrep("-", 17), "\n")
for (w in 1:4) {
  mi <- compute_mi(4, c(1, 2, 3, 4), w)
  cat(sprintf("%-5d %10.6f\n", w, mi))
}
cat("\n")
