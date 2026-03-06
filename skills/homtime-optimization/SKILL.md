---
name: homtime-optimization
description: Use when measuring function performance, detecting algorithmic complexity, or predicting execution time at unseen input sizes -- uses HomTime's hom(), scaling(), and predict() API
---
# HomTime Optimization

## When
Invoke when you need to benchmark a function, detect its complexity class, predict performance at larger inputs, or compose timing measurements for sequential/parallel pipelines.

## Iron Laws
1. Always measure with `hom()` before drawing performance conclusions.
2. Use `scaling()` with at least 3 input sizes for complexity detection.
3. Check `trust_score()` before trusting any measurement -- low trust means re-run.
4. Never compare raw timings across different machines; use `effect_size()`.

## Process
1. Measure a single function: `result = hom(sort, rand(1000))`. Extract stats with `time_median(result)`, `time_mean(result)`, `time_min(result)`, `time_std(result)`.
2. Create a benchmark suite for related measurements:
   ```julia
   suite("my_benchmarks") do s
       @horzion s[:sort_100] = hom(sort, rand(100))
       @horzion s[:sort_1000] = hom(sort, rand(1000))
   end
   ```
3. Detect complexity: `result = scaling(my_function, [10, 100, 1000, 10000])` then `analysis = complexity(result)`. Returns `best` (complexity class), `candidates`, and `r_squared`.
4. Predict at unseen size: `prediction = predict(result, 1000000)`. Returns `predicted_ns`, `ci` (bootstrap confidence interval), and `model`.
5. Check measurement quality: `ts = trust_score(homset)` -- composite 0.0-1.0 from cv, outlier, sample, convergence, and compile components.
6. Compose sequentially: `composed = compose_temporal(h1, h2)` (time adds).
7. Compose in parallel: `parallel = tensor_temporal(h1, h2)` (time = max).
8. Compare implementations: `es = effect_size(baseline, current)` -- returns `cohens_d`, `cliffs_delta`, and classification (`:negligible`, `:small`, `:medium`, `:large`).
9. Compute confidence intervals: `ci = bootstrap_ci(homset, time_median; level=0.95)`.

### HomSet Fields
`name::Symbol`, `measurements::Vector{Measurement}`, `config::HomConfig`, `convergence::ConvergenceStatus`

### Measurement Fields
`time_ns`, `allocs`, `bytes`, `gc_time_ns`, `compile_ns`

### Complexity Classes

| Class | Detection |
|-------|-----------|
| O(1) | Constant |
| O(log n) | Logarithmic |
| O(n) | Linear |
| O(n log n) | Linearithmic |
| O(n^2) | Quadratic |
| O(n^3) | Cubic |
| O(2^n) | Exponential |

### Trust Score Components
`cv_component`, `outlier_component`, `sample_component`, `convergence_component`, `compile_component` -- composite as `ts.score`.

## Composability
Expects a callable function and representative input. Produces HomSet values that feed into `compare()` (see homtime-ci-integration), property tests, or suite-level aggregation.
