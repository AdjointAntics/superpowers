---
name: topos-benchmarking
description: Use when benchmarking packages with HomTime or BenchmarkTools -- measures morphism timing, allocation, and composition
---
# Topos Benchmarking

## When
Invoke when measuring performance of any Topos package, writing new benchmarks, or investigating performance regressions.

## Iron Laws
1. Every benchmark file lives in `bench/` and follows auto-discovery naming conventions.
2. Use BenchmarkTools `@benchmarkable` for suite entries; use HomTime for categorical measurement.
3. Never commit performance regressions without justification.

## Process
1. Run all benchmarks: `yon bench`.
2. Run a specific package: `yon bench Algebra`.
3. Run verbose: `yon -v bench`.
4. Write benchmark files at `bench/benchmarks/*_benchmark.jl` using BenchmarkTools:
   ```julia
   using BenchmarkTools, MyPackage
   SUITE = BenchmarkGroup()
   SUITE["my_function"] = @benchmarkable my_function(input)
   ```
5. Use HomTime API for categorical measurement: `measure(f, x)`, `time_compose(f, g, x)`, `allocate(f, x)`.
6. For sequential composition timing use `time_seq(f, g, x)`. For parallel use `time_par(f, g, x)`.

## Auto-Discovery Rules
- If `bench/run_bench.jl` exists, it is used as the entry point.
- Otherwise, all files matching `bench/benchmarks/*_benchmark.jl` are auto-discovered.

## Measurement Types

| Type | Measures |
|------|----------|
| Time | Execution time |
| Memory | Allocations |
| Cache | Hit/miss rates |
| Throughput | Items/second |

## Composability
Expects a package with `bench/` directory. Produces timing and allocation reports consumed by CI and development workflows.
