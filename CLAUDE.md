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

1. **Uniform Masking**: Non-failed components are equally likely to be included in the candidate set. This is **not realistic in practice** (real diagnostics have systematic biases), but enables closed-form solutions.

2. **Exponential Lifetimes**: Components have constant hazard rates (memoryless property). Appropriate for random shocks but not wear-out or aging.

These assumptions are explicitly discussed in Definition 2.1, Remarks 2.2-2.3, and Section 6.1 (Limitations).

## Repository Structure

```
.
├── paper/                      # Main paper directory
│   ├── main.tex                # Main paper (~860 lines, revised version)
│   ├── references.bib          # Bibliography (15 references)
│   ├── main.pdf                # Generated PDF output (~25 pages)
│   └── html/                   # HTML output (LaTeXML)
│
├── img/                        # TikZ diagram source files
├── figures/                    # Generated plots and visualizations
├── research/                   # Research materials and simulations
├── archive/                    # Deprecated files from original version
├── README.md                   # Project overview
└── CLAUDE.md                   # This file
```

## Build Commands

**Working directory**: All commands below should be run from the `paper/` directory.

### Compile the document
```bash
cd paper/
pdflatex main.tex
```

For a complete build with bibliography:
```bash
cd paper/
pdflatex main.tex
bibtex main
pdflatex main.tex
pdflatex main.tex
```

### Clean auxiliary files
```bash
cd paper/
rm -f *.aux *.bbl *.blg *.log *.out *.toc
```

### View the PDF
```bash
evince paper/main.pdf &
```

## Document Architecture

### Main Structure
- **paper/main.tex**: ~860 lines with inline notation macros (lines 23-82)
- **paper/references.bib**: 15 references in reliability and statistics

### Paper Sections

**Section 1: Introduction**
- Motivation with practical examples (electronics, medical devices, aerospace)
- **Subsection 1.1: Related Work** - Comprehensive literature review (15 citations)
- **Subsection 1.2: Contributions** - Highlights closed-form MLE for m=3, w=2 as key result
- **Subsection 1.3: Paper organization**

**Section 2: Probabilistic Model**
- **2.1 Series System Lifetime** - Basic definitions, Assumptions 2.1-2.2
- **2.2 Masked Component Failures** - Definition 2.1 (Uniform Masking), **Remarks 2.2-2.3 (explicit discussion of assumption limitations and justification)**
- **2.3 Parametric Families** - General parametric framework

**Section 3: Likelihood and Fisher Information**
- **3.1 Likelihood Function** - Proposition 3.1 with complete proof deriving candidate set probability
- **3.2 Fisher Information Matrix** - General definition

**Section 4: Exponentially Distributed Component Lifetimes** *(Core contribution)*
- **4.1 Exponential Parametric Functions** - Standard exponential results, K⊥S independence
- **4.2 Maximum Likelihood Estimator** - Score equations, Theorem 4.1
- **4.3 Sufficient Statistics** - Theorem 4.2 with proof via factorization theorem
- **4.4 Fisher Information Matrix** - Complete derivation with full proof
- **4.5 Asymptotic Sampling Distribution** - Theorem 4.3, asymptotic normality
- **4.6 Confidence Intervals** - Wald-type intervals

**Section 5: Three-Component Systems**
- **5.1 Candidate Sets of Size Two** - **Theorem 5.1: Closed-form MLE with complete 60-line proof**
- **5.2 Candidate Sets of Size One** - Degenerate case (no masking)
- **5.3 Numerical Validation** - Multiple configurations, comparison metrics, finite-sample analysis

**Section 6: Conclusion**
- **6.1 Model Assumptions and Limitations** - Explicit discussion of uniform masking and exponential assumptions
- **6.2 Extensions** - Non-uniform masking, variable cardinality, non-exponential distributions

**Appendix: Numerical Solution Methods** - Newton-Raphson algorithm

### Key Mathematical Notation (from paper/main.tex lines 23-82)

**Random variables and probability:**
- `\RV{X}` - Random variable X
- `\Prob{...}` - Probability
- `\Expect{...}` - Expectation
- `\SetIndicator{...}` - Indicator function 𝟙

**System-specific notation:**
- `\sv` - System lifetime (S)
- `\cv` - Component lifetime (T)
- `\cand` - Candidate set (C)
- `\sysparam` - System parameter matrix (Θ)

**Statistics and estimation:**
- `\estimator{x}` - MLE estimator (hat notation)
- `\tparam{x}` - True parameter (star notation)
- `\expomle` - Exponential MLE estimator
- `\infomatrx` - Fisher information matrix
- `\mfs` - Minimal sufficient statistic
- `\cntsymb` - Count symbol for candidate set frequencies

**Theorem environments defined:**
- `theorem`, `corollary`, `proposition`, `definition`, `assumption`, `remark`

## Bibliography

15 key references organized chronologically:
- Cox (1959) - Foundational competing risks theory
- Barlow & Proschan (1975) - Statistical reliability theory
- Dinse (1982) - Nonparametric methods for partial data
- Miyakawa (1984) - First masked system failure data analysis
- Usher & Hodgson (1988) - ML for masked data
- Lin et al. (1993) - Exact MLE procedures
- Reiser et al. (1995), Guttman et al. (1995) - Bayesian approaches
- Flehinger et al. (1998, 2002) - Parametric modeling
- Sarhan (2001) - Reliability estimation
- Kuo & Yang (2007) - Bayesian modeling
- Agustin (2010) - Series systems overview
- Guo et al. (2013) - Incomplete failure data

## Revision History

**Major revision October-November 2025:**
- **Original**: 3,351 lines, ~100 pages, 13 chapters
- **First revision**: 567 lines, ~11 pages, 6 chapters
- **Current**: ~860 lines, ~25 pages (with complete proofs)

Key changes in latest revision:
- Replaced "α-masking" terminology with "uniform masking" (α was never used in equations)
- Added comprehensive Related Work subsection (15 citations, up from 6)
- Added complete proofs for: candidate set probability, Fisher information, m=3 w=2 MLE
- Fixed section hierarchy (14 misplaced \section commands → \subsection)
- Added explicit Model Assumptions and Limitations section
- Enhanced numerical validation with multiple configurations and metrics
- Added remark environment to theorem definitions

## Notes for Editing

1. **Working directory**: LaTeX compilation should be done from the `paper/` directory
2. **Model assumptions**: The uniform masking assumption is explicitly acknowledged as unrealistic but analytically tractable
3. **Core contribution**: Closed-form MLE for m=3, w=2 (Theorem 5.1) is the key novel result
4. **Complete proofs**: All major theorems now have full proofs; don't abbreviate them
5. **Use defined macros**: Always use macros from lines 23-82 rather than ad-hoc LaTeX
6. **Remark environment**: Use `\begin{remark}...\end{remark}` for extended discussions (defined line 80-81)
7. **Graphics path**: Document searches `images/`, `../images/`, `../../images/`
