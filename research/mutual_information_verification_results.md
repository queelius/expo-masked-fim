# Mutual Information Verification Results

## Summary

All mathematical derivations for mutual information I(K;C) under uniform masking have been **numerically verified** using R.

## Key Results

### 1. Formula Equivalence (m=3, λ=(1,3,5), w=2)

Two formulas for computing I(K;C) produce **identical results** (within machine precision):

**Method 1** (Definition):
```
I(K;C) = Σ_{k,c: k∈c} P(K=k,C=c) log[P(K=k,C=c) / (P(K=k)P(C=c))]
```

**Method 2** (Simplified formula):
```
I(K;C) = (1/Λ) Σ_c [σ_c / C(m-1,w-1)] log(Λ/σ_c)
where σ_c = Σ_{j∈c} λ_j
```

**Result**: Both methods yield **I(K;C) = 0.36771** with difference < 10⁻¹⁶

### 2. Perfect Masking Property (w=1)

When w=1 (candidate set contains only the failed component), mutual information equals entropy:

```
I(K;C_{w=1}) = H(K) = 0.936888
```

This confirms that **perfect diagnosis yields maximum information**.

### 3. Information Loss from Masking

For the same system (m=3, λ=(1,3,5)):
- I(K;C_{w=1}) = 0.936888 (perfect diagnosis)
- I(K;C_{w=2}) = 0.36771 (masking with |C|=2)

**Information retained**: 0.36771 / 0.936888 ≈ **39.2%**

This quantifies the information loss due to masking.

### 4. Symmetric Case Formula (λ=(3,3,3), w=2)

For symmetric component rates:

**Computed**: I(K;C) = 0.405465
**Theoretical**: log(m/w) = log(3/2) = 0.405465

**Difference**: < 10⁻¹⁶

This verifies the closed-form expression for symmetric systems.

### 5. Monotonicity in w (m=4, λ=(1,2,3,4))

Mutual information **decreases monotonically** as candidate set size increases:

| w | I(K;C) | Decrease from previous |
|---|--------|------------------------|
| 1 | 1.27985 | — |
| 2 | 0.659008 | 0.620847 |
| 3 | 0.276502 | 0.382505 |

This confirms that **larger candidate sets provide less information** about the failed component.

## Implications for Statistical Inference

1. **Efficiency Loss**: Masking causes substantial information loss. For w=2 with m=3, we retain only ~39% of the information compared to perfect diagnosis.

2. **Trade-off**: The uniform masking model allows analytical tractability but at the cost of information. The mutual information I(K;C) quantifies this cost.

3. **Asymptotic Properties**: Lower I(K;C) suggests slower convergence of MLEs and wider confidence intervals (related to Fisher information).

4. **Design Implications**: For reliability systems with diagnostic capabilities, investing in better diagnostics (smaller w) yields exponentially more information about component failure rates.

## Technical Details

### Test System Parameters

**System 1** (m=3, asymmetric):
- λ = (1, 3, 5)
- Λ = 9
- P(K=1) = 1/9, P(K=2) = 3/9, P(K=3) = 5/9

**Candidate set probabilities** (w=2):
- P(C={1,2}) = 4/18 ≈ 0.222
- P(C={1,3}) = 6/18 ≈ 0.333
- P(C={2,3}) = 8/18 ≈ 0.444

**System 2** (m=3, symmetric):
- λ = (3, 3, 3)
- All components equally likely to fail

**System 3** (m=4, monotonicity test):
- λ = (1, 2, 3, 4)
- Tests w ∈ {1, 2, 3}

### Computational Notes

- All computations performed in R with double precision
- Numerical accuracy: differences < 10⁻¹⁶ (machine epsilon)
- Script: `/home/spinoza/github/papers/expo-masked-fim/research/verify_mutual_information.R`

## References

These results support the theoretical derivations in:
- Section 2 (Uniform masking model)
- Section 3 (Likelihood construction)
- Section 6.1 (Information loss due to masking)

The mutual information I(K;C) provides a **model-independent measure** of diagnostic quality under the uniform masking assumption.
