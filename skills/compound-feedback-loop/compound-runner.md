---
name: compound-runner
description: Unified runner that orchestrates the complete compound feedback loop - Test → Benchmark → Visualize → Repeat
---

# Compound Runner

## Overview

The unified runner orchestrates the entire compound feedback loop in a single command. It is the **counit** ε: L∘R → Id in the adjunction - the deployed artifact.

## Usage

```sh
# Run the full compound loop
yon compound

# Run specific phases
yon compound --phases test,bench,visualize
yon compound --spec myspec.jl

# Interactive mode
yon compound --interactive
```

## CLI Interface

```sh
yon compound [OPTIONS]

Options:
  --spec FILE           Specification file (default: spec.jl)
  --phases PHASES      Comma-separated: test,bench,analyze,visualize (default: all)
  --baseline FILE      Baseline for regression detection
  --output DIR         Output directory (default: ./compound_output)
  --interactive        Interactive mode
  --watch              Watch mode - re-run on file changes
  --verbose, -v       Verbose output
  --help, -h          Show this help
```

## The Runner

### Main Entry Point

```julia
"""
    compound_runner(spec::Spec; config::RunnerConfig)

The unified runner - orchestrates the complete adjunction.

This is the counit ε: L∘R → Id in the adjunction.
"""
function compound_runner(spec::Spec; config::RunnerConfig=default_config())
    # Phase 1: Implementation (L¹)
    impl = run_implementation_phase(spec)
    
    # Phase 2: Testing (L²)
    test_result = run_test_phase(impl, spec)
    
    # Phase 3: Benchmarking (L³)
    benchmark_result = run_benchmark_phase(test_result)
    
    # Phase 4: Analysis (L⁴)
    analysis_result = run_analysis_phase(benchmark_result)
    
    # Phase 5: Visualization (R¹)
    visualization = run_visualization_phase(analysis_result)
    
    # Phase 6: Insights (R²)
    insight = run_insight_phase(visualization)
    
    # Phase 7: Refinement (R³) - This is the unit η
    refinement = run_refinement_phase(spec, insight)
    
    return CompoundResult(
        spec=spec,
        impl=impl,
        test_result=test_result,
        benchmark_result=benchmark_result,
        analysis_result=analysis_result,
        visualization=visualization,
        insight=insight,
        refinement=refinement
    )
end
```

### Phase Implementations

```julia
"""
    run_implementation_phase

Uses: superpowers:topos-package-development
"""
function run_implementation_phase(spec::Spec)
    impl = invoke(skill(:topos-package-development), spec)
    return Implementation(spec=spec, code=impl)
end

"""
    run_test_phase

Uses: superpowers:testy-property-testing
"""
function run_test_phase(impl::Implementation, spec::Spec)
    test_result = invoke(skill(:testy-property-testing), impl; spec=spec)
    return TestResult(
        implementation=impl,
        passed=all_passed(test_result),
        properties=test_result.properties,
        coverage=test_result.coverage,
        duration=test_result.duration
    )
end

"""
    run_benchmark_phase

Uses: superpowers:homtime-optimization
"""
function run_benchmark_phase(test_result::TestResult)
    benchmark_result = invoke(
        skill(:homtime-optimization),
        test_result.implementation;
        targets=extract_benchmarks(test_result)
    )
    return BenchmarkResult(
        implementation=test_result.implementation,
        suite=benchmark_result.suite,
        complexity=benchmark_result.complexity,
        trust_score=benchmark_result.trust_score
    )
end

"""
    run_analysis_phase

Uses: superpowers:homtime-ci-integration
"""
function run_analysis_phase(benchmark_result::BenchmarkResult; baseline=nothing)
    analysis_result = invoke(
        skill(:homtime-ci-integration),
        benchmark_result;
        baseline=baseline
    )
    return AnalysisResult(
        benchmarks=benchmark_result,
        comparison=analysis_result.comparison,
        evidence=analysis_result.evidence,
        regressions=analysis_result.regressions
    )
end

"""
    run_visualization_phase

Uses: superpowers:poly-ui-representation, poly-widget-composition
"""
function run_visualization_phase(analysis_result::AnalysisResult)
    # Convert to representable
    repr = invoke(skill(:yoneda-representability), analysis_result)
    
    # Create widgets
    widget = invoke(skill(:poly-ui-representation), repr)
    
    # Compose layout
    layout = invoke(skill(:poly-widget-composition), widget)
    
    return Visualization(
        analysis=analysis_result,
        widget=widget,
        layout=layout
    )
end

"""
    run_insight_phase

Extract insights from visualization
"""
function run_insight_phase(visualization::Visualization)
    insights = extract_insights(visualization)
    return Insight(
        visualization=visualization,
        findings=insights.findings,
        recommendations=insights.recommendations,
        confidence=insights.confidence
    )
end

"""
    run_refinement_phase

This is the unit η: Id → R∘L
"""
function run_refinement_phase(spec::Spec, insight::Insight)
    refinement = refine(spec, insight)
    return Refinement(
        original_spec=spec,
        insights=[insight],
        changes=refinement.changes,
        new_spec=refinement.new_spec
    )
end
```

## Configuration

```julia
"""
    RunnerConfig

Configuration for the compound runner.
"""
struct RunnerConfig
    phases::Vector{Symbol}
    output_dir::String
    baseline_path::Union{Nothing, String}
    watch::Bool
    interactive::Bool
    verbose::Bool
    
    # Phase-specific configs
    test_config::TestConfig
    benchmark_config::BenchmarkConfig
    lint_config::LintConfig
end
```

### Default Configuration

```julia
default_config() = RunnerConfig(
    phases=[:implement, :test, :benchmark, :analyze, :visualize, :insight, :refine],
    output_dir="./compound_output",
    baseline_path=nothing,
    watch=false,
    interactive=false,
    verbose=false,
    test_config=TestConfig(samples=1000),
    benchmark_config=BenchmarkConfig(samples=100, evals=1),
    lint_config=LintConfig(enabled=true)
)
```

## Output

### Directory Structure

```
compound_output/
├── spec.json                    # Original specification
├── implementation/             # Generated code
│   ├── src/
│   └── test/
├── test_results.json            # Test outcomes
├── benchmark_results.json       # HomTime results
├── analysis_results.json        # Statistical analysis
├── visualizations/              # Generated UI
│   ├── dashboard.html
│   ├── charts/
│   └── reports/
├── insights.json                # Extracted insights
└── refinement/                  # Updated specification
    ├── new_spec.json
    └── diff.json
```

### JSON Artifacts

Each phase produces JSON that can be used as baseline for future runs:

```json
{
  "phase": "benchmark",
  "timestamp": "2026-03-04T12:00:00Z",
  "suite": {
    "sort_1000": {
      "median_ns": 15000,
      "allocs": 42,
      "trust_score": 0.95
    }
  }
}
```

## Modes

### Batch Mode

Default - runs all phases and exits:

```sh
yon compound --spec myspec.jl
```

### Interactive Mode

Interactive refinement after visualization:

```sh
yon compound --interactive
# User sees visualization, can:
# - Accept refinement
# - Modify spec
# - Re-run specific phases
```

### Watch Mode

Re-run on file changes:

```sh
yon compound --watch --spec myspec.jl
# Monitors: spec.jl, src/, test/
# Re-runs affected phases on changes
```

## Regression Detection

### Baseline Comparison

```julia
# Compare against previous run
yon compound --baseline compound_output/benchmark_results.json

# Or use Git baseline
yon compound --baseline git:HEAD~1
```

### Exit Codes

| Code | Meaning |
|------|---------|
| 0 | All phases passed |
| 1 | Test failures |
| 2 | Benchmark regressions |
| 3 | Analysis errors |
| 4 | Visualization errors |

## Integration with superpowers

This runner uses:
- **superpowers:compound-feedback-loop** - Adjunction structure
- **superpowers:topos-package-development** - L¹
- **superpowers:testy-property-testing** - L²
- **superpowers:homtime-optimization** - L³
- **superpowers:homtime-ci-integration** - L⁴
- **superpowers:poly-ui-representation** - R¹
- **superpowers:poly-widget-composition** - R¹
- **superpowers:yoneda-representability** - Bridge

## Key Principles

1. **Counit of adjunction** - ε: L∘R → Id
2. **Composable phases** - Each phase is independently runnable
3. **JSON artifacts** - Enable baseline comparison
4. **Multiple modes** - Batch, interactive, watch

## References

- Compound feedback loop: superpowers:compound-feedback-loop
- Shared types: shared-types.md
