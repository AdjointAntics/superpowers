---
name: homtime-ci-integration
description: Automated regression detection, bisection, and CI pipeline integration using HomTime
---

# HomTime CI Integration

## Categorical Foundation

Regression detection is testing whether the **equalizer** between baseline and current performance holds. A regression is a **pullback failure** - the observed performance fails to pull back to the expected performance in the timing category.

## Core Concept: Regression as Equalizer Failure

```julia
using HomTime

# The baseline is an equalizer: expected_performance ⊆ actual_performance
# Regression = equalizer fails to hold

baseline = load_results("baseline.json")
current = hom(sort, rand(1000))  # New measurement

comparison = compare(baseline, current)
```

## Comparison Types

### Pairwise Comparison

```julia
# Compare two HomSets - tests the coequalizer
comparison = compare(baseline_homset, current_homset)

# Returns Comparison containing:
# - baseline_name, current_name
# - threshold: classification threshold
# - deltas: Vector of BenchmarkDelta
```

### BenchmarkDelta

Each delta classifies the change:

```julia
delta = comparison.deltas[1]

# Fields:
# - name: benchmark identifier
# - baseline_ns, current_ns: median times
# - ratio: current / baseline
# - status: :regression, :improvement, or :unchanged
# - ci: ConfidenceInterval (optional)
# - test: SignificanceTest (optional)
# - evidence: Evidence (optional)
```

## Statistical Significance

### The Coequalizer Test

Testing if two distributions are equal:

```julia
# Mann-Whitney U test - non-parametric
test = mann_whitney(baseline_homset, current_homset)

# Returns SignificanceTest:
# - test: :mann_whitney
# - p_value: probability of no difference
# - effect_size: ratio of medians
# - reject: whether to reject null hypothesis
# - alpha: significance level
```

### Effect Size Classification

```julia
es = effect_size(baseline_homset, current_homset)

# Cohen's d: (mean_current - mean_baseline) / pooled_std
# Cliff's delta: P(X > Y) - P(X < Y), range [-1, 1]

es.classification  # :negligible, :small, :medium, :large
```

## Evidence Construction: The Judgment Monad

Evidence builds a **monad** for structured judgment:

```julia
evidence = build_evidence(
    baseline_homset,
    current_homset;
    threshold=1.2
)

# Returns Evidence:
# - status: :regression, :improvement, :unchanged
# - significance: SignificanceTest
# - effect: EffectSize
# - ci: ConfidenceInterval
# - trust_baseline: TrustScore
# - trust_current: TrustScore
# - practical_significance: :negligible/:small/:medium/:large
# - recommendation: Human-readable guidance
```

The **monad** structure:
- **Return**: Wrap a judgment as evidence
- **Bind**: Chain evidence to recommendations
- **Map**: Transform evidence components

## Regression Detection

### Threshold-Based Classification

```julia
# Classify using threshold
comparison = compare(baseline, current; threshold=1.2)

# Ratio > 1.2 = :regression
# Ratio < 0.83 = :improvement  
# Otherwise = :unchanged
```

### Evidence-Based Classification

```julia
# Use full evidence chain
comparison = compare(baseline, current; evidence=true)

# Now each delta has evidence built from:
# - Statistical significance (p-value)
# - Effect size (practical significance)
# - Confidence interval
# - Trust scores (measurement quality)
```

## CI Integration

### Saving Baselines

```julia
# Save current run as baseline
suite = suite("my_bench") do s
    s[:test] = hom(f, x)
end

# Save to file
save_results("results.json", suite)

# Or to CI-specific location
ci_save(suite)
```

### Loading Baselines

```julia
# Load from file
baseline = load_results("baseline.json")

# Or from CI baseline path
baseline = ci_baseline_path() |> load_results
```

### CI Comparison

```julia
# In CI, compare against baseline
result = ci_compare(baseline_suite, current_suite)

# Returns Comparison with evidence
# Can also generate report
ci_report(result; format=:terminal)
```

### CI Exit Codes

```julia
# Exit with appropriate code
ci_exit(comparison)

# Returns:
# - 0: No regressions detected
# - 1: Regression detected
```

## Bisection: Finding the Kernel

When a regression is detected, **bisect** to find the exact commit:

```julia
# Bisect for regression
result = bisect_regression(
    benchmark=:sort_1000,
    good_commit="abc123",  # Known good
    bad_commit="def456",   # Known bad
    bisect_script="run_bench.sh"
)

# Returns BisectResult:
# - bad_commit: First commit with regression
# - good_commit: Last commit without regression
# - commits_tested: All tested
# - ratios: Performance at each step
# - steps: Number of bisection steps
```

The bisection finds the **kernel** of the performance morphism - the exact point where performance diverged from expected.

## Aggregate Runs

### Across Multiple Runs

```julia
# Aggregate multiple benchmark runs
combined = aggregate("bench_results/")

# Or aggregate directory
combined = aggregate_dir("results/")
```

### Time Series Analysis

```julia
# Collect time series
series = hom_series(f, x; samples=100)

# Returns TimeIndexed{Measurement}

# Detect trend
trend = detect_trend(series)

# Returns:
# - :stable, :improving, :degrading
# - slope
# - confidence
```

## Evidence as Monad

The evidence system forms a **monad** for composing judgments:

```julia
# Return - wrap judgment
evidence = return(judgment)

# Bind - chain to recommendation  
recommendation = evidence >>= next_judgment

# Map - transform evidence
classified = map(evidence) do e
    categorize(e.effect)
end
```

## The Judgment Category

- **Objects**: Benchmark suites
- **Morphisms**: Comparisons between suites
- **Equalizers**: Expected vs observed performance
- **Coequalizers**: Statistical tests for difference
- **Kernels**: Regression locations (bisection)

## Integration

Use with:
- **superpowers:homtime-optimization** - Generate measurements
- **superpowers:compound-feedback-loop** - Full CI pipeline

## Key Principles

1. **Regression is equalizer failure** - expected ≠ observed
2. **Significance is coequalizer** - statistical test for equality
3. **Evidence is monadic** - structured, composable judgment
4. **Bisection finds kernel** - exact commit of divergence

## References

- HomTime CI integration: Persist.jl
- Bisection: HomTime.jl
- Evidence: Rigor.jl
