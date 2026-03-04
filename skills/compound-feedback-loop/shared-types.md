# Compound Feedback Loop Types

## Overview

This module defines the shared types that flow between skills in the compound feedback loop. These types form the substrate upon which invocation chains and unified runners operate.

## Type Hierarchy

```
CompoundArtifact
├── Spec
├── Implementation
├── TestResult
├── BenchmarkResult
├── AnalysisResult
├── Visualization
├── Insight
└── Refinement
```

## Core Types

### Spec

```julia
"""
    Spec

The initial specification - defines what to build.
This is the starting object in the development category.
"""
struct Spec
    name::Symbol
    interface::Any  # Function signature or interface
    requirements::Vector{Requirement}
    invariants::Vector{Invariant}
    metadata::Dict{Symbol, Any}
end
```

### Implementation

```julia
"""
    Implementation

The code that satisfies the spec.
This is a morphism from spec to working code.
"""
struct Implementation
    spec::Spec
    code::Module
    tests::Vector{Test}
    benchmarks::Vector{Benchmark}
end
```

### TestResult

```julia
"""
    TestResult

The outcome of running tests.
This verifies the equalizer: implementation = specification.
"""
struct TestResult
    implementation::Implementation
    passed::Bool
    properties::Vector{PropertyResult}
    coverage::Float64
    duration::Float64
end
```

### BenchmarkResult

```julia
"""
    BenchmarkResult

The timing measurements from HomTime.
This is a collection of HomSets - timing morphisms.
"""
struct BenchmarkResult
    implementation::Implementation
    suite::HomTime.Suite
    complexity::Union{Nothing, ComplexityAnalysis}
    trust_score::TrustScore
end
```

### AnalysisResult

```julia
"""
    AnalysisResult

Statistical analysis of benchmarks.
This includes evidence, significance tests, and recommendations.
"""
struct BenchmarkResult
    benchmarks::BenchmarkResult
    comparison::Union{Nothing, Comparison}
    evidence::Union{Nothing, Evidence}
    regressions::Vector{Symbol}
end
```

### Visualization

```julia
"""
    Visualization

The visual representation of analysis results.
Composed via Poly widget monoidal structures.
"""
struct Visualization
    analysis::AnalysisResult
    widget::Poly.Widget
    layout::Layout  # ⊗, +, ▷ composition
end
```

### Insight

```julia
"""
    Insight

Extracted insights from visualization.
"""
struct Insight
    visualization::Visualization
    findings::Vector{Finding}
    recommendations::Vector{Recommendation}
    confidence::Float64
end
```

### Refinement

```julia
"""
    Refinement

Updated specification based on insights.
This is the unit η: Id → R∘L in the adjunction.
"""
struct Refinement
    original_spec::Spec
    insights::Vector{Insight}
    changes::Vector{Change}
    new_spec::Spec
end
```

## Type Flows

### L Functor (Development)

```
Spec → Implementation → TestResult → BenchmarkResult → AnalysisResult
```

Each arrow is a morphism in the development category.

### R Functor (Feedback)

```
AnalysisResult → Visualization → Insight → Refinement
```

Each arrow is a morphism in the feedback category.

### The Adjunction

```
L ⊣ R

η: Spec → R(L(Spec))  # Refinement
ε: L(R(Analysis)) → Analysis  # Deployed artifact
```

## Shared Functions

### Transformation

```julia
"""
    transform(from::T1, to::Type{T2}) where {T1, T2 <: CompoundArtifact}

Transform between artifact types.
This is a natural transformation in the category of artifacts.
"""
transform(impl::Implementation, ::Type{TestResult}) = ...
transform(bench::BenchmarkResult, ::Type{AnalysisResult}) = ...
```

### Composition

```julia
"""
    compose(::Type{L}, ::Type{R}) where {L, R}

Compose development and feedback functors.
"""
compose(Implementation, TestResult) = TestResult
```

## Integration Points

### Testy Integration

```julia
# TestResult from Testy properties
struct TestResult
    testable::Testy.TestableProperty
    result::Testy.Result
end
```

### HomTime Integration

```julia
# BenchmarkResult wraps HomSet
struct BenchmarkResult
    homset::HomTime.HomSet
    measurement::HomTime.Measurement
end
```

### Poly Integration

```julia
# Visualization uses Poly widgets
struct Visualization
    widget::Poly.Modes.Widget
    compose_vertically(w1, w2) = w1 ⊗ w2
    compose_horizontally(w1, w2) = w1 + w2
end
```

### Strict Integration

```julia
# Implementation validated by Strict
struct Implementation
    lint_result::Strict.Analysis
    violations::Vector{Strict.Violation}
end
```

## Category Structure

- **Objects**: CompoundArtifact subtypes
- **Morphisms**: transform() functions
- **Functors**: L (development), R (feedback)
- **Natural Transformations**: compose()
- **Adjunction**: L ⊣ R with unit η and counit ε

## Usage

These types flow through:
1. **Invocation Chains** - explicit next-skill calls use these types
2. **Unified Runner** - orchestrates using these types as the substrate
