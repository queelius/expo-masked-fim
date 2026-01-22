# Statistical Inference for Series Systems from Masked Failure Time Data

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![GitHub release](https://img.shields.io/github/v/release/queelius/expo-masked-fim)](https://github.com/queelius/expo-masked-fim/releases)

## Abstract

We consider the problem of estimating component failure rates in series systems when observations consist of system failure times paired with partial information about the failed component. For the case where component lifetimes follow exponential distributions, we derive closed-form expressions for the maximum likelihood estimator, the Fisher information matrix, and establish sufficient statistics. The asymptotic sampling distribution of the estimator is characterized and confidence intervals are provided. A detailed analysis of a three-component system demonstrates the theoretical results.

## Key Results

- **Theorem 5.1**: Closed-form MLE for $m$-component systems with masking cardinality $w = m-1$
- **Proposition 4.2**: Independence of failed component $K$ and system lifetime $S$ for exponential distributions
- **Explicit Fisher Information**: Direct computation without numerical differentiation
- **Sufficient Statistics**: Mean system lifetime and candidate set frequencies

## Paper

The full paper is available at [`paper/main.pdf`](paper/main.pdf) (29 pages).

### Building from Source

```bash
cd paper
latexmk -pdf main.tex
```

## Repository Structure

```
paper/              # LaTeX source and PDF
├── main.tex        # Paper source
├── main.pdf        # Compiled PDF
└── references.bib  # Bibliography
docs/               # Documentation site (MkDocs)
research/           # Numerical validation code (C++)
archive/            # Historical versions
```

## Citation

If you use this work, please cite:

```bibtex
@article{towell2026masked,
  title={Statistical Inference for Series Systems from Masked Failure Time Data: The Exponential Case},
  author={Towell, Alexander},
  year={2026},
  url={https://github.com/queelius/expo-masked-fim}
}
```

Or use the [CITATION.cff](CITATION.cff) file for automatic citation in GitHub.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Author

**Alexander Towell**
Southern Illinois University Edwardsville
[atowell@siue.edu](mailto:atowell@siue.edu)
[ORCID: 0000-0001-6443-0618](https://orcid.org/0000-0001-6443-0618)
