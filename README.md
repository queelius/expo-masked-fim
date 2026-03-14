# Statistical Inference for Series Systems from Masked Failure Time Data

> **Status: Archived.** This research project has been discontinued. The paper is mathematically correct but addresses a niche problem (closed-form MLE under exponential lifetimes with uniform masking) that lacks a natural audience — the masked failure data community has largely moved to Bayesian, nonparametric, and machine learning methods under weaker assumptions. The most interesting insight from this work — the distinction between diagnostic information I(K;C) and Fisher information about parameters — was developed into a separate paper on [deterministic masking](https://github.com/queelius/deterministic-masking). The preprint is preserved on [Zenodo (doi:10.5281/zenodo.15151227)](https://doi.org/10.5281/zenodo.15151227) for archival purposes.

## Abstract

We consider the problem of estimating component failure rates in series systems when observations consist of system failure times paired with partial information about the failed component. For the case where component lifetimes follow exponential distributions, we derive closed-form expressions for the maximum likelihood estimator, the Fisher information matrix, and establish sufficient statistics. The asymptotic sampling distribution of the estimator is characterized and confidence intervals are provided. A detailed analysis of a three-component system demonstrates the theoretical results.

## Key Results

- **Theorem 5.1**: Closed-form MLE for $m$-component systems with masking cardinality $w = m-1$
- **Proposition 4.2**: Independence of failed component $K$ and system lifetime $S$ for exponential distributions
- **Explicit Fisher Information**: Direct computation without numerical differentiation
- **Sufficient Statistics**: Mean system lifetime and candidate set frequencies

## Paper

The full paper is available at [`paper/main.pdf`](paper/main.pdf). The preprint is on [Zenodo](https://doi.org/10.5281/zenodo.15151227).

### Building from Source

```bash
cd paper
latexmk -pdf main.tex
```

## Citation

```bibtex
@misc{towell2026masked,
  title={Statistical Inference for Series Systems from Masked Failure Time Data: The Exponential Case},
  author={Towell, Alexander},
  year={2026},
  doi={10.5281/zenodo.15151227}
}
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Author

**Alexander Towell**
[lex@metafunctor.com](mailto:lex@metafunctor.com)
[ORCID: 0000-0001-6443-9897](https://orcid.org/0000-0001-6443-9897)
