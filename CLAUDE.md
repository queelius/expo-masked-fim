# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is an academic research paper on **statistical inference for series systems with masked failure times**. The paper derives closed-form expressions for maximum likelihood estimators when component lifetimes follow exponential distributions.

Key concepts:
- **Series system**: An m-out-of-m system where all components must function for the system to work
- **Masked system failure times**: Observations where we know the system failed at time t and have a candidate set C ⊆ {1,...,m} of components that may have caused the failure
- **α-masked candidate set model**: A probabilistic model where candidate sets include the failed component with probability α

## Repository Structure

```
.
├── main.tex                    # Main paper (546 lines, revised version)
├── custom_simplified.sty       # Custom LaTeX notation macros
├── references.bib              # Bibliography (6 references)
├── README.md                   # Project overview
├── CLAUDE.md                   # This file
│
├── img/                        # TikZ diagram source files
│   ├── graph_model.tex
│   ├── graph_model_alpha.tex
│   └── graph_model_simplified.tex
│
├── figures/                    # Generated plots and visualizations
│   ├── 3-out-of-3.png
│   ├── actual.png
│   ├── superimposed.png
│   ├── fig_mse_expo_error.tex
│   └── fig_frob_error_3_expo.tex
│
├── research/                   # Research materials and simulations
│   ├── matrix_errors/          # Numerical validation code/data
│   ├── *.dia                   # Diagram source files
│   └── *.mm                    # Mind maps
│
└── archive/                    # Deprecated files from original version
    ├── main_original.tex       # Original 3,351-line version
    └── deprecated/             # Old auxiliary files

```

## Build Commands

### Compile the document
```bash
pdflatex main.tex
```

For a complete build with bibliography:
```bash
pdflatex main.tex
bibtex main
pdflatex main.tex
pdflatex main.tex
```

### Clean auxiliary files
```bash
rm -f *.aux *.bbl *.blg *.log *.out *.toc
```

### View the PDF
```bash
evince main.pdf &
# or
xdg-open main.pdf
```

## Document Architecture

### Main Structure
- **main.tex**: Focused 546-line paper on exponential distribution results
- **custom_simplified.sty**: Streamlined notation macros (260 lines)
- **references.bib**: 6 key references in reliability and statistics

### Paper Sections

**Chapter 1: Introduction**
- Motivation and literature review
- 6 cited works from Usher & Hodgson (1988) to present
- Clear statement of contributions

**Chapter 2: Probabilistic Model**
- Series system definition
- Masked failure model
- α-masked candidate sets

**Chapter 3: Likelihood and Fisher Information**
- General framework for parametric families
- Fisher information matrix formulation

**Chapter 4: Exponentially Distributed Component Lifetimes** *(Core contribution)*
- Closed-form MLE expressions
- Explicit Fisher information matrix
- Minimal sufficient statistics theorem
- Asymptotic sampling distribution

**Chapter 5: Three-Component Systems**
- Detailed analysis with w=1 and w=2
- Closed-form solutions for w=2 case
- Numerical validation results

**Chapter 6: Conclusion**
- Summary of contributions
- Extensions and future work

**Appendix: Numerical Solution Methods**
- Newton-Raphson algorithm

### Key Mathematical Notation (from custom_simplified.sty)

**Probability and distributions:**
- `\RV{X}` - Random variable X
- `\Prob{...}` - Probability
- `\Expect{...}` - Expectation
- `\PDF{...}`, `\CDF{...}`, `\RDF{...}` - Probability/cumulative/reliability distribution functions
- Distribution notation: `\expdist`, `\mvn`, `\normdist`

**System-specific notation:**
- `\sv` - System lifetime random variable (S)
- `\cv` - Component lifetime random variable (T)
- `\rvcand` - Candidate set random variable (C)
- `\sysparam` - System parameter matrix (Θ)
- `\sysparamvec` - System parameter vector (θ)
- `\expomle` - Exponential MLE estimator
- `\infomatrx` - Fisher information matrix
- `\cov` - Covariance matrix

**Statistics and estimation:**
- `\estimator{x}` - MLE estimator (hat notation)
- `\tparam{x}` - True parameter (star notation)
- `\likelihood`, `\score`, `\hessian` - Statistical operators

### Figures and Graphics

**TikZ diagrams** (in `img/`):
- `graph_model.tex` - Basic probabilistic model
- `graph_model_alpha.tex` - Model with α-masking
- `graph_model_simplified.tex` - Simplified diagram

**Data plots** (in `figures/`):
- `fig_mse_expo_error.tex` - MSE error analysis
- `fig_frob_error_3_expo.tex` - Frobenius norm error
- PNG visualizations of numerical results

## Revision History

The paper underwent major revision in October 2025:
- **Original**: 3,351 lines, ~100 pages, 13 chapters
- **Revised**: 546 lines, 11 pages, 6 chapters
- **Reduction**: 84% line count reduction, 89% page reduction

Key changes:
- Removed Weibull and Lomax case studies (no closed-form results)
- Eliminated entropy digressions and incomplete sections
- Condensed probability theory preliminaries by 70%
- Added proper literature review with 6 key citations
- Fixed all broken cross-references and TODOs
- Focused exclusively on exponential distribution closed-form results

## Git Structure

- **Main branch**: `candidates`
- **Submodule**: Reference to code at `https://github.com/queelius/series_system_estimation_from_masked_system_failure_time_samples_code.git`

## Notes for Editing

1. **Core contributions preserved**: All closed-form exponential results (MLE, Fisher information, sufficient statistics) are in Chapter 4
2. **Mathematical rigor maintained**: This is a formal mathematical statistics paper
3. **Use defined macros**: Always use custom_simplified.sty macros rather than ad-hoc LaTeX
4. **Figures via input**: TikZ figures use `\input{img/...}`, data plots use PGFPlots
5. **Archive for reference**: Original version in `archive/main_original.tex`

## Bibliography

Six key references:
1. Usher & Hodgson (1988) - Foundational ML for masked data
2. Lin et al. (1993) - Exact MLE procedures
3. Agustin (2010) - Series systems overview
4. Kuo & Yang (2007) - Bayesian approaches
5. Guo et al. (2013) - Incomplete failure data
6. Bickel & Doksum (2000) - MLE theory

## Research Materials

The `research/` directory contains:
- **matrix_errors/**: C++ code and data for numerical validation
- Diagram source files (`.dia` format)
- Mind maps of conceptual development (`.mm` format)
- Large image file (`series_system_latent.ora`)

These are supplementary materials not included in the main paper.
