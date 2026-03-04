---
name: homtime-optimization
description: Measure morphisms, detect complexity via natural transformations, predict performance via Kan extensions using HomTime
---

# HomTime Optimization

## Categorical Foundation

HomTime implements the **Hom-functor** at the level of program execution: Hom(A, B) counts morphisms from A to B. HomTime counts nanoseconds. Every function becomes a **HomSet** - a collection of timing morphisms parameterized by input.

## Core Concept: HomSet as Morphism Collection

```julia
using HomTime

# Measure a single morphism: f: Input → Time
result = hom(my_function, argument)

# Returns a HomSet - the timing profile of f
# This is Nat(Hom(Time, -), HomSet) in the measurement category
```

## The HomSet Type

A **HomSet** is the collection of all timing observations for a morphism:

```julia
# HomSet fields:
# - name: Symbol - identity of the morphism
# - measurements: Vector{Measurement} - timing observations
# - config: HomConfig - measurement configuration
# - convergence: ConvergenceStatus - statistical convergence
```

Each **Measurement** captures:
- `time_ns`: Execution time in nanoseconds
- `allocs`: Number of heap allocations
- `bytes`: Total bytes allocated
- `gc_time_ns`: Garbage collection time
- `compile_ns`: JIT compilation time (TTFX analysis)

## Measuring Morphisms

### Single Measurement

```julia
using HomTime

# The morphism f: A → Time
h = hom(sort, rand(1000))

# Extract statistics - these are natural transformations
time_median(h)    # Median time
time_mean(h)      # Mean time  
time_min(h)       # Minimum time
time_std(h)       # Standard deviation
```

### Benchmark Suites

```julia
# A Suite is a named collection of HomSets - the product in the category of benchmarks
suite("my_benchmarks") do s
    @horzion s[:sort_100] = hom(sort, rand(100))
    @horzion s[:sort_1000] = hom(sort, rand(1000))
    @horzion s[:sort_10000] = hom(sort, rand(10000))
end
```

## Complexity Detection via Natural Transformation

### Scaling Analysis

The scaling morphism maps input sizes to time - a **natural transformation** between functors:

```julia
# Scale morphism: Size → Time
# This detects the complexity functor C: Size → Complexity

result = scaling(sort, [100, 1000, 10000, 100000])

# Returns ScalingResult containing HomSets at each size
# The complexity is determined by the best-fit natural transformation
```

### Complexity Classes

HomTime detects these complexity **functors**:

| Complexity | Functor | Detection |
|------------|---------|-----------|
| O(1) | Constant functor | Nat(Id, Time) |
| O(log n) | Logarithmic | Nat(Log, Time) |
| O(n) | Linear | Nat(Id, Time) |
| O(n log n) | Linearithmic | Nat(n log n, Time) |
| O(n²) | Quadratic | Nat(Id², Time) |
| O(n³) | Cubic | Nat(Id³, Time) |
| O(2^n) | Exponential | Nat(Exp, Time) |

### Complexity Analysis

```julia
using HomTime

# Benchmark across sizes
result = scaling(my_function, [10, 100, 1000, 10000])

# Extract complexity - this is finding the best natural transformation
analysis = complexity(result)

# Returns ComplexityAnalysis with:
# - best: best-fit ComplexityFunctor
# - candidates: all candidates ranked
# - r_squared: goodness of fit
```

## Kan Extensions for Prediction

### Performance Prediction via Kan Extension

The **Kan extension** extends the performance functor along the size functor - predicting performance at unseen sizes:

```julia
# Train on known sizes
result = scaling(my_function, [100, 1000, 10000])

# Predict at unseen size via Kan extension
prediction = predict(result, 1000000)

# Returns PredictionResult with:
# - predicted_ns: median time prediction
# - ci: confidence interval (bootstrap)
# - model: complexity model used
```

The Kan extension formula:
```
(Predict)ⁿ(A) = Colim(F ↓ A) P(F(A))
```

### Trust Score: Measurement Quality

Each measurement has a **TrustScore** - a 5-component quality metric:

```julia
ts = trust_score(homset)

# Components:
# - cv_component: Coefficient of variation (lower = higher trust)
# - outlier_component: Outlier fraction (fewer = higher)
# - sample_component: Sample adequacy toward target
# - convergence_component: Convergence quality (converged = 1.0)
# - compile_component: JIT compilation fraction (less = higher)

ts.score  # Composite 0.0-1.0
```

## Temporal Composition

### Sequential Composition

The **tensor** of two HomSets measures sequential composition:

```julia
# f then g: A → B → C
# Time(f ∘ g) = Time(f) + Time(g) in the timing category

h1 = hom(f, x)
h2 = hom(g, f(x))

# Sequential composition via tensor
composed = compose_temporal(h1, h2)
```

### Parallel Composition

The **product** measures parallel execution:

```julia
# f and g in parallel: A → B ⊗ C
# Time(f ⊗ g) = max(Time(f), Time(g))

parallel = tensor_temporal(h1, h2)
```

## Statistical Analysis

### Confidence Intervals

```julia
ci = bootstrap_ci(homset, time_median; level=0.95)

# Returns ConfidenceInterval:
# - estimate: point estimate
# - lower, upper: bounds
# - level: confidence level
```

### Effect Size

For comparing two implementations:

```julia
es = effect_size(baseline_homset, current_homset)

# Returns EffectSize:
# - cohens_d: parametric effect size
# - cliffs_delta: non-parametric (-1 to 1)
# - classification: :negligible, :small, :medium, :large
```

## The Measurement Category

The categorical structure of HomTime:

- **Objects**: Input types (Int, Vector, etc.)
- **Morphisms**: Timed functions f: A → Time
- **HomSets**: Collections of timing observations
- **Composition**: Sequential (tensor) and parallel (product)
- **Functors**: Complexity classes, scaling
- **Natural Transformations**: Complexity detection

## Integration

Use with:
- **superpowers:compound-feedback-loop** - The complete optimization cycle
- **superpowers:testy-property-testing** - Verify before benchmarking
- **superpowers:strict-linting** - Ensure code quality before measurement

## Key Principles

1. **Everything is a HomSet** - every function is measurable as timing morphisms
2. **Complexity is natural** - complexity detection finds the natural transformation
3. **Prediction is Kan** - Kan extensions extend performance along size
4. **Trust is composed** - measurement quality is a composite functor

## References

- HomTime.jl source: packages/HomTime/src/
- Complexity detection: Complexity.jl
- Statistical rigor: Rigor.jl
