# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [3.0.0] - 2026-01-13

### Added
- Proposition 4.2: K⊥S independence proof for exponential series systems
- Theorem 5.1: Closed-form MLE for arbitrary m with w=m-1 masking
- Corollary 5.2: Three-component special case (m=3, w=2)
- Remark 4.5: Inverse-variance pooling for variable masking cardinality
- Remark 5.4: Boundary estimates and constrained MLE for negative values
- CHANGELOG.md for release tracking

### Changed
- Generalized main theorem from m=3 to arbitrary m with w=m-1
- Clarified sufficient statistics notation
- Updated conclusion to reflect general w=m-1 results
- Improved definition of masked system failure time (pair vs triple)

### Documentation
- Comprehensive CLAUDE.md with build commands and LaTeX macros
- MkDocs documentation site with paper overview and code examples
- GitHub Pages deployment via GitHub Actions

### Removed
- Unused diagram source files (*.dia, *.ora, *.mm)
- Stale HTML preview artifacts
