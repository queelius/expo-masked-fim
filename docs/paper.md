# Paper

## Statistical Inference for Series Systems from Masked Failure Time Data: The Exponential Case

**Author:** Alexander Towell
**Email:** atowell@siue.edu

[Download PDF](paper/main.pdf){ .md-button .md-button--primary }

## Abstract

We consider the problem of estimating component failure rates in series systems when observations consist of system failure times paired with partial information about the failed component. For the case where component lifetimes follow exponential distributions, we derive closed-form expressions for the maximum likelihood estimator, the Fisher information matrix, and establish sufficient statistics. The asymptotic sampling distribution of the estimator is characterized and confidence intervals are provided. A detailed analysis of a three-component system demonstrates the theoretical results.

## Main Contributions

### 1. Explicit Fisher Information Matrix

We derive a closed-form expression for the Fisher information matrix under arbitrary masking patterns, enabling direct computation of asymptotic variances without numerical differentiation or Monte Carlo simulation.

### 2. Sufficient Statistics

The mean system lifetime and candidate set frequency vector constitute sufficient statistics, reducing the data to $1 + \binom{m}{w}$ real numbers.

### 3. Closed-Form MLE for Three-Component Systems

For the important special case of $m=3$ components with candidate sets of size $w=2$, we derive an explicit closed-form solution. This represents the first known closed-form MLE for non-trivial masking scenarios.

### 4. Asymptotic Distribution Theory

We characterize the asymptotic sampling distribution of the MLE and provide Wald-type confidence intervals with explicit formulas.

## Paper Structure

1. **Introduction** - Motivation and literature review
2. **Probabilistic Model** - Series system and uniform masking model
3. **Likelihood and Fisher Information** - General framework
4. **Exponential Case** - Main theoretical results
5. **Three-Component Systems** - Detailed analysis with closed-form solutions
6. **Conclusion** - Summary and future directions

## Related Work

Key references:

- Cox (1959) - Competing risks with exponential lifetimes
- Miyakawa (1984) - Incomplete data in competing risks
- Usher & Hodgson (1988) - ML for masked data
- Lin et al. (1993) - Exact MLE procedures
- Barlow & Proschan (1975) - Reliability theory foundations
