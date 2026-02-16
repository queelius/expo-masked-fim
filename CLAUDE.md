# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is an academic research paper on **statistical inference for series systems with masked failure times**. The paper derives closed-form expressions for maximum likelihood estimators when component lifetimes follow exponential distributions.

Key concepts:
- **Series system**: An m-out-of-m system where all components must function for the system to work
- **Masked system failure times**: Observations where we know the system failed at time t and have a candidate set C ⊆ {1,...,m} of components that may have caused the failure
- **Uniform masking model**: A probabilistic model where the failed component is always in the candidate set, and non-failed components are equally likely to be included. **This is a strong assumption made for analytical tractability, not realism.**

## Key Model Assumptions

The paper makes two key assumptions that enable analytical results but limit direct applicability:

1. **Uniform Masking**: Non-failed components are equally likely to be included in the candidate set. Not realistic in practice (real diagnostics have systematic biases), but enables closed-form solutions.

2. **Exponential Lifetimes**: Components have constant hazard rates (memoryless property). Appropriate for random shocks but not wear-out or aging.

These assumptions are explicitly discussed in Definition 2.1, Remarks 2.2-2.3, and Section 6.1 (Limitations).

## Repository Structure

```
paper/              # Main paper directory
├── main.tex        # Main paper (~860 lines, macros at lines 23-82)
├── references.bib  # Bibliography (15 references)
├── main.pdf        # Generated PDF output
└── html/           # HTML output (LaTeXML)
docs/               # MkDocs documentation site
research/           # Simulation and validation code (R)
├── validate_asymptotic_covariance.R  # Monte Carlo validation of asymptotic theory
├── verify_mutual_information.R       # Mutual information verification
img/                # TikZ diagram sources
figures/            # Generated plots
archive/            # Deprecated files (read-only)
```

## Build Commands

### Paper (working directory: `paper/`)

```bash
# Full build with automatic bibliography handling (preferred)
cd paper && latexmk -pdf main.tex

# Clean auxiliary files
cd paper && latexmk -c

# Manual build if latexmk unavailable
cd paper && pdflatex main.tex && bibtex main && pdflatex main.tex && pdflatex main.tex
```

### HTML Preview

```bash
cd paper/html && latexmlc ../main.tex --dest=index.html
```

### Documentation Site

```bash
# Serve locally
mkdocs serve

# Build for GitHub Pages
mkdocs build
```

### Numerical Validation (R)

```bash
# Monte Carlo validation of asymptotic covariance (generates paper/fig_convergence.pdf)
Rscript research/validate_asymptotic_covariance.R

# Mutual information verification
Rscript research/verify_mutual_information.R
```

## Key LaTeX Macros (paper/main.tex lines 23-82)

**Random variables and probability:**
- `\RV{X}` - Random variable X
- `\Prob{...}`, `\Expect{...}` - Probability, Expectation
- `\SetIndicator{...}` - Indicator function 𝟙

**System-specific:**
- `\sv` - System lifetime (S)
- `\cv` - Component lifetime (T)
- `\cand` - Candidate set (C)
- `\sysparam` - System parameter matrix (Θ)

**Statistics:**
- `\estimator{x}` - MLE estimator (hat notation)
- `\tparam{x}` - True parameter (star notation)
- `\expomle` - Exponential MLE estimator
- `\infomatrx` - Fisher information matrix
- `\mfs` - Minimal sufficient statistic
- `\cntsymb` - Count symbol for candidate set frequencies

**Theorem environments:** `theorem`, `corollary`, `proposition`, `definition`, `assumption`, `remark`

## Notes for Editing

1. **Working directory**: LaTeX compilation should be done from `paper/`
2. **Use defined macros**: Always use macros from lines 23-82 rather than ad-hoc LaTeX
3. **Core contribution**: Closed-form MLE for w=m-1 with arbitrary m (Theorem 5.1); three-component case (Corollary 5.2) as illustration
4. **Complete proofs**: All major theorems have full proofs; don't abbreviate them
5. **Model assumptions**: The uniform masking assumption is explicitly acknowledged as unrealistic but analytically tractable
6. **Graphics path**: Document searches `images/`, `../images/`, `../../images/`
7. **Regenerate artifacts**: After data/plot changes, regenerate `paper/main.pdf` and `paper/html/index.html`
8. **Bibliography**: Add entries to `paper/references.bib` with `\cite{key}`; avoid inline URLs
