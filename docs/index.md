# Statistical Inference for Exponential Series Systems with Masked Failure Data

This repository contains the research paper and supporting materials for closed-form statistical inference in series systems when component lifetimes follow exponential distributions and failure data is masked.

## Overview

In reliability engineering, **series systems** fail when any single component fails. Often, the exact cause of failure cannot be determined with certainty, but can be narrowed to a subset of components. This partial information is known as **masked failure data**.

This work provides the first complete analytical treatment of maximum likelihood estimation for such systems, including:

- **Closed-form MLE** for three-component systems with pairwise masking
- **Explicit Fisher information matrix** for arbitrary masking patterns
- **Sufficient statistics** characterization
- **Asymptotic distribution theory** with confidence intervals

## Key Results

For a system with $m$ components where each observation identifies a candidate set of size $w$:

1. The **minimal sufficient statistics** are the mean system lifetime $\bar{t}$ and the candidate set frequency vector $\mathbf{\omega}$

2. The **Fisher information matrix** has closed-form expression depending only on $w$, not on the specific masking pattern

3. For $m=3$, $w=2$, the **MLE has explicit closed-form solution**:

$$\hat{\lambda}_j = \frac{\omega_{jk} + \omega_{j\ell}}{2n\bar{t}}$$

where $\{j,k,\ell\} = \{1,2,3\}$

## Resources

- **Paper (PDF)**: [Download PDF](paper/main.pdf) - Full paper with proofs and numerical validation
- **Source Code**: [GitHub Repository](https://github.com/queelius/series_system_estimation) - Simulation code and numerical experiments

## Citation

If you use this work, please cite:

```bibtex
@article{towell2025masked,
  title={Statistical Inference for Series Systems from Masked Failure Time Data: The Exponential Case},
  author={Towell, Alexander},
  year={2025},
  note={Working paper}
}
```

## License

This work is available under the MIT License.
