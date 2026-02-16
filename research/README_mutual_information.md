# Mutual Information Verification for Masked Series Systems

## Overview

This directory contains R scripts for numerical verification of mutual information derivations under the uniform masking model for series systems with exponential component lifetimes.

## Files

### Main Scripts

1. **verify_mutual_information.R** - Comprehensive verification with detailed output
   - Implements two computation methods and verifies equivalence
   - Tests all four cases requested
   - Provides detailed term-by-term breakdown

2. **test_mutual_information.R** - Unit test suite using testthat
   - 9 unit tests covering key properties
   - Can be integrated into automated testing workflows
   - All tests pass

3. **mutual_information_verification_results.md** - Summary of findings
   - Numerical results
   - Statistical interpretation
   - Implications for inference

## Quick Start

```bash
# Run comprehensive verification
cd research
Rscript verify_mutual_information.R

# Run unit tests
Rscript test_mutual_information.R
```

## Mathematical Background

### Model Setup

For a series system with m components:
- Component k has exponential lifetime with rate λ_k
- System rate: Λ = Σ λ_k
- Masked failure: observe (S, C) where S is system lifetime and C ⊆ {1,...,m} is candidate set
- Uniform masking: |C| = w (constant), P(C=c|K=k) = 1/C(m-1,w-1) for k ∈ c

### Mutual Information

The mutual information I(K;C) quantifies how much information the candidate set C provides about the failed component K:

**Definition:**
```
I(K;C) = Σ_{k,c} P(K=k,C=c) log[P(K=k,C=c) / (P(K=k)P(C=c))]
```

**Simplified formula (derived in paper):**
```
I(K;C) = (1/Λ) Σ_c [σ_c / C(m-1,w-1)] log(Λ/σ_c)
where σ_c = Σ_{j∈c} λ_j
```

## Verified Properties

### 1. Formula Equivalence

**Property:** Both computation methods yield identical results

**Verification:** For m=3, λ=(1,3,5), w=2:
- Method 1 (definition): 0.36771
- Method 2 (formula): 0.36771
- Difference: < 10⁻¹⁶

### 2. Perfect Masking (w=1)

**Property:** I(K;C) = H(K) when candidate set contains only failed component

**Verification:** For m=3, λ=(1,3,5):
- H(K) = 0.936888
- I(K;C_{w=1}) = 0.936888
- Difference: < 10⁻¹⁶

**Interpretation:** Perfect diagnosis preserves all entropy of K

### 3. Monotonicity in w

**Property:** I(K;C) decreases as candidate set size increases

**Verification:** For m=4, λ=(1,2,3,4):

| w | I(K;C) | % retained from w=1 |
|---|--------|---------------------|
| 1 | 1.27985 | 100% |
| 2 | 0.659008 | 51.5% |
| 3 | 0.276502 | 21.6% |

**Interpretation:** Larger candidate sets provide less information about which component failed

### 4. Symmetric System Formula

**Property:** For symmetric systems (all λ_k equal), I(K;C) = log(m/w)

**Verification:** For m=3, λ=(3,3,3), w=2:
- Computed: 0.405465
- Theoretical: log(3/2) = 0.405465
- Difference: < 10⁻¹⁶

### 5. Information Bounds

**Properties:**
- 0 ≤ I(K;C) ≤ H(K)
- I(K;C) = 0 when w=m (all components in candidate set)
- I(K;C) = H(K) when w=1 (perfect diagnosis)

**All verified numerically**

## Key Results Summary

### Information Loss Quantification

For a 3-component system with λ=(1,3,5):

```
Information retained with w=2: 0.36771 / 0.936888 ≈ 39.2%
Information lost due to masking: ≈ 60.8%
```

### Asymmetry Effects

In asymmetric systems:
- High-rate components (more likely to fail) contribute more to I(K;C)
- Candidate sets containing high-rate components are more informative
- For λ=(1,3,5), w=2:
  - P(C={2,3}) = 0.444 (highest, contains λ_3=5)
  - P(C={1,2}) = 0.222 (lowest, misses λ_3=5)

### Detailed Computation Example

For C={1,2} with λ=(1,3,5):
- σ_c = 4, P(C) = 4/18 ≈ 0.222
- Contribution from k=1: 0.0451 bits
- Contribution from k=2: 0.1352 bits
- Total contribution: 0.1802 bits

This represents the **partial information gained** when observing C={1,2}.

## Statistical Implications

### For Maximum Likelihood Estimation

1. **Efficiency**: Lower I(K;C) implies higher variance in MLEs
   - MLE variance inversely related to Fisher information
   - Fisher information related to I(K;C) through likelihood structure

2. **Convergence Rate**:
   - Systems with high I(K;C) achieve better estimation accuracy with fewer observations
   - Masking slows convergence by factor related to information loss

3. **Confidence Intervals**:
   - Wider intervals expected when w is large (low I(K;C))
   - For fixed sample size n, interval width scales roughly as √(1/I(K;C))

### For System Design

1. **Diagnostic Value**: I(K;C) quantifies benefit of improved diagnostics
   - Moving from w=2 to w=1 increases information by ~2.5x for m=3
   - Diminishing returns: w=3 to w=2 less impactful than w=2 to w=1

2. **Cost-Benefit Analysis**:
   - If diagnostic improvement from w=2 to w=1 costs C dollars
   - Information gain is 0.936888 - 0.36771 = 0.569 bits
   - Willingness to pay: ~C per 0.569 bits of diagnostic information

## Implementation Notes

### Computational Complexity

For m components with candidate set size w:
- Number of candidate sets: C(m, w)
- Computation time: O(m × C(m, w))
- Memory: O(C(m, w))

Example complexities:
- m=3, w=2: 3 candidate sets, ~instant
- m=4, w=2: 6 candidate sets, ~instant
- m=10, w=5: 252 candidate sets, ~milliseconds

### Numerical Stability

All logarithms are natural logs. For very small probabilities:
- Use log-space arithmetic where possible
- All results accurate to machine precision (< 10⁻¹⁵)
- No numerical issues observed for tested parameter ranges

### Extension to Non-Uniform Masking

Current implementation assumes **uniform masking**: all non-failed components equally likely in candidate set.

For non-uniform masking:
- Replace P(C=c|K=k) with empirical masking probabilities
- Same definition of I(K;C) applies
- Expect higher I(K;C) if diagnostics systematically exclude certain components

## Future Work

Potential extensions:

1. **Non-exponential lifetimes**: Weibull, log-normal distributions
2. **Variable candidate set size**: w not constant
3. **Partial information**: Pr obability weights on candidate set members
4. **Sequential diagnosis**: Conditional mutual information I(K;C_2|C_1)
5. **Multi-system data**: Information aggregation across systems

## References

See main paper `paper/main.tex`:
- Section 2: Uniform masking model definition
- Section 3: Likelihood construction
- Section 6.1: Discussion of information loss

## Testing

Run all tests:
```bash
Rscript test_mutual_information.R
```

Expected output: "✓ All tests passed!" with 9 successful tests.

## License

Part of the masked-fim research project. See repository root for license information.
