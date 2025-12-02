# Code

## Simulation and Estimation Code

The simulation code for numerical validation and MLE computation is available in a separate repository:

[View on GitHub](https://github.com/queelius/series_system_estimation){ .md-button .md-button--primary }

## Features

- Data generation for masked system failure times
- MLE computation using the closed-form solution (Theorem 5.1)
- Monte Carlo simulation framework
- Comparison of empirical vs. theoretical covariance

## Usage Example

```python
import numpy as np

def generate_masked_data(lambdas, n, w=2):
    """Generate masked system failure data."""
    m = len(lambdas)
    total_rate = sum(lambdas)

    # System failure times (exponential with total rate)
    times = np.random.exponential(1/total_rate, n)

    # Failed component (proportional to rates)
    probs = np.array(lambdas) / total_rate
    failed = np.random.choice(m, n, p=probs)

    # Generate candidate sets containing failed component
    candidate_sets = []
    for i in range(n):
        # Include failed component + (w-1) random others
        others = [j for j in range(m) if j != failed[i]]
        additional = np.random.choice(others, w-1, replace=False)
        cset = tuple(sorted([failed[i]] + list(additional)))
        candidate_sets.append(cset)

    return times, candidate_sets

def mle_3comp_w2(times, candidate_sets):
    """Closed-form MLE for m=3, w=2."""
    n = len(times)
    t_bar = np.mean(times)

    # Count candidate set frequencies
    omega_12 = sum(1 for c in candidate_sets if set(c) == {0, 1})
    omega_13 = sum(1 for c in candidate_sets if set(c) == {0, 2})
    omega_23 = sum(1 for c in candidate_sets if set(c) == {1, 2})

    # Closed-form solution
    lambda_1 = (omega_12 + omega_13) / (2 * n * t_bar)
    lambda_2 = (omega_12 + omega_23) / (2 * n * t_bar)
    lambda_3 = (omega_13 + omega_23) / (2 * n * t_bar)

    return np.array([lambda_1, lambda_2, lambda_3])
```

## Requirements

- Python 3.8+
- NumPy
- (Optional) SciPy for numerical optimization comparison

## Citation

If you use this code, please cite the accompanying paper:

```bibtex
@article{towell2025masked,
  title={Statistical Inference for Series Systems from Masked Failure Time Data: The Exponential Case},
  author={Towell, Alexander},
  year={2025}
}
```
