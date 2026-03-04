
---
name: compound-feedback-loop
description: The complete development adjunction L ⊣ R - Test → Verify → Benchmark → Visualize → Optimize → Repeat
---

# Compound Feedback Loop

## Categorical Foundation

The compound feedback loop is an **adjunction** L ⊣ R:

```
Development (L) ⊣ Feedback (R)

L: Specification → Implementation → Tests → Benchmarks → Metrics
R: Metrics → Visualization → Insights → Refinements → Specification
```

The **unit** η: Id → R∘L is the feedback from metrics to new specifications. The **counit** ε: L∘R → Id is the deployed artifact.

## The Adjunction Diagram

```
     η                    ε
  Spec ──────► R(L(Spec)) ──────►
      ◄──────── L(R(Metrics)) ◄────
              Feedback
```

Where:
- **L**: Development functor (builds, tests, measures)
- **R**: Feedback functor (visualizes, extracts insights)
- **η**: Unit (feedback from measurements to specs)
- **ε**: Counit (deployed artifact)

## The Cycle

---

## Invocation Chains

Each phase explicitly invokes the next skill. These chains form morphisms in the skill category.

### L Functor Chain (Development)

```julia
# Phase 1 → Phase 2: Spec → Implementation
invoke(
    superpowers:topos-package-development,
    spec::Spec
) → impl::Implementation

# Phase 2 → Phase 3: Implementation → TestResult
invoke(
    superpowers:testy-property-testing,
    impl::Implementation;
    spec=spec
) → test_result::TestResult

# Phase 3 → Phase 4: TestResult → BenchmarkResult
invoke(
    superpowers:homtime-optimization,
    test_result::TestResult;
    targets=benchmarks_to_run
) → benchmark_result::BenchmarkResult

# Phase 4 → Phase 5: BenchmarkResult → AnalysisResult
invoke(
    superpowers:homtime-ci-integration,
    benchmark_result::BenchmarkResult;
    baseline=previous_benchmarks
) → analysis_result::AnalysisResult
```

### R Functor Chain (Feedback)

```julia
# Phase 5 → Phase 6: AnalysisResult → Visualization
invoke(
    superpowers:poly-ui-representation,
    analysis_result::AnalysisResult
) → visualization::Visualization

# Phase 6 → Phase 7: Visualization → Insight
invoke(
    superpowers:poly-widget-composition,
    visualization::Visualization
) → insight::Insight

# Phase 7 → Phase 8: Insight → Refinement
# (This is the unit η: Id → R∘L)
refine(spec::Spec, insight::Insight) → refinement::Refinement
```

### Full Cycle Composition

```julia
# Compose the full L functor: Spec → AnalysisResult
L = compose(
    topos-package-development,     # Spec → Impl
    testy-property-testing,       # Impl → TestResult  
    homtime-optimization,         # TestResult → BenchmarkResult
    homtime-ci-integration        # BenchmarkResult → AnalysisResult
)

# Compose the full R functor: AnalysisResult → Refinement
R = compose(
    poly-ui-representation,       # AnalysisResult → Visualization
    poly-widget-composition,      # Visualization → Insight
    # Insight → Refinement is the unit η
)
```

### The Adjunction

```julia
# Full L∘R composition (development after feedback)
deployed_artifact = L(R(analysis_result))

# Full R∘L composition (feedback after development)  
new_spec = R(L(spec))

# The unit η: Spec → R(L(Spec))
η(spec) = refine(spec, insight(L(spec)))

# The counit ε: L(R(Analysis)) → Analysis
ε(analysis) = L(R(analysis))  # deployed artifact
```

---

### Phase 1: Specification (L⁰)

```julia
# Define what to build
spec = Specification(
    interface,
    requirements,
    invariants
)
```

### Phase 2: Implementation (L¹)

```julia
# Implement to specification
# Uses: superpowers:topos-package-development
impl = implement(spec)
```

### Phase 3: Testing (L²)

```julia
# Verify implementation satisfies spec
# Uses: superpowers:testy-property-testing, testy-stateful-testing
test_results = test(impl, spec)

# This is the equalizer: implementation = specification
```

### Phase 4: Benchmarking (L³)

```julia
# Measure performance
# Uses: superpowers:homtime-optimization
benchmarks = benchmark(impl)

# Results are HomSets - timing morphisms
```

### Phase 5: Analysis (L⁴)

```julia
# Statistical analysis
# Uses: superpowers:homtime-ci-integration
analysis = analyze(benchmarks)

# Evidence construction - the judgment monad
evidence = build_evidence(baseline, benchmarks)
```

### Phase 6: Visualization (R¹)

```julia
# Visualize results
# Uses: superpowers:poly-ui-representation, poly-widget-composition
visualization = visualize(analysis)

# Data becomes representable via Yoneda
# Widgets compose monoidally
```

### Phase 7: Insights (R²)

```julia
# Extract insights from visualization
insights = extract_insights(visualization)

# Performance regressions?
# Optimization opportunities?
# New requirements?
```

### Phase 8: Refinements (R³)

```julia
# Update specification based on insights
new_spec = refine(spec, insights)

# New η: Spec → Spec'
# Feedback to the beginning!
```

### Repeat: Compose Functors

```julia
# Full cycle as functor composition:
# 
# Cycle = L⁴ ∘ R³ ∘ L³ ∘ R² ∘ L² ∘ R¹ ∘ L¹ ∘ L⁰
#
# Each iteration compounds the improvement!
```

## The Compounds

### Each Iteration Compounds

| Iteration | Functor | Result |
|-----------|---------|--------|
| 1 | L¹ | Working code |
| 2 | L² ∘ L¹ | Verified code |
| 3 | L³ ∘ L² ∘ L¹ | Measured code |
| 4 | R¹ ∘ L³ ∘ L² ∘ L¹ | Visualized metrics |
| 5 | L¹ ∘ R¹ ∘ L³ ∘ L² ∘ L¹ | Refined spec |

Each cycle is **natural** - the structure is preserved!

## Integration Points

### With Testy (L²)

```julia
# Property-based verification
@property "sort invariant" begin
    xs ∈ Gen(Vector{Int})
    sorted = sort(xs)
    issorted(sorted)
end
```

### With HomTime (L³)

```julia
# Benchmark the sorted implementation
result = scaling(sort, [100, 1000, 10000])

# Detect complexity
complexity(result)
```

### With Strict (L¹)

```julia
# Ensure code quality
yon lint
```

### With Poly (R¹)

```julia
# Visualize benchmark results
chart = bar_chart(benchmark_results)

# Compose dashboard
dashboard = header ⊗ chart ⊗ details
```

## The Natural Transformation

Each phase connects via **natural transformations**:

```julia
# η_tests: Benchmarks → Tests
# "When benchmarks regress, add more tests"

# η_specs: Metrics → Specifications  
# "When performance degrades, refine requirements"

# These preserve the adjunction structure!
```

## Evidence as Monad

The evidence built throughout forms a **monad**:

```julia
# Return: wrap judgment as evidence
evidence = return(judgment)

# Bind: chain to next phase
insights = evidence >>= extract_insights

# Map: transform evidence
recommendations = map(evidence) do e
    categorize(e.status)
end
```

## CI Integration

The full loop runs in CI:

```yaml
# .github/workflows/compound.yml
name: Compound Feedback

on: [push]

jobs:
  test:
    runs-on: julia
    steps:
      - uses: actions/checkout
      - run: yon test
      
  benchmark:
    needs: test
    runs-on: julia
    steps:
      - run: yon bench
      
  visualize:
    needs: benchmark
    runs-on: julia
    steps:
      - run: yon visualize
      
  report:
    needs: visualize
    runs-on: julia  
    steps:
      - run: yon report
```

## The Compound Category

- **Objects**: Development states (Spec, Impl, Tests, Benchmarks...)
- **Morphisms**: Transformations between states
- **Functors**: L (development), R (feedback)
- **Adjunction**: L ⊣ R
- **Composition**: The full cycle

## Key Principles

1. **Adjunction structures** - L builds, R feedback
2. **Unit feedback** - η: Id → R∘L
3. **Counsel deployed** - ε: L∘R → Id
4. **Compounds naturally** - Each iteration preserves structure

## Integration

This skill integrates ALL other skills:
- **superpowers:testy-property-testing** - L²
- **superpowers:homtime-optimization** - L³
- **superpowers:homtime-ci-integration** - L⁴
- **superpowers:strict-linting** - L¹
- **superpowers:poly-ui-representation** - R¹
- **superpowers:poly-widget-composition** - R¹
- **superpowers:yoneda-representability** - Bridge
- **superpowers:testy-stateful-testing** - L²

---

## Shared Types (Substrate)

The compound feedback loop uses shared types that flow between skills. See `shared-types.md` for the type hierarchy:

```
CompoundArtifact
├── Spec                    # Starting specification
├── Implementation          # Code satisfying spec
├── TestResult              # Test outcomes (equalizer)
├── BenchmarkResult         # HomTime HomSets
├── AnalysisResult          # Statistical evidence
├── Visualization           # Poly widgets
├── Insight                 # Extracted findings
└── Refinement             # Updated spec (unit η)
```

These types form the **substrate** for:
1. **Invocation Chains** - explicit next-skill calls
2. **Unified Runner** - orchestrates using these types

---

## Unified Runner

For single-command execution, use the unified runner. See `compound-runner.md`.

## References

- Adjunction theory: Theory/Yoneda
- Evidence monad: HomTime/Rigor
- UI composition: Poly/Modes
