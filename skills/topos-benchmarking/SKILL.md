---
name: topos-benchmarking
description: HomTime measurement, temporal composition, and benchmarking in Topos
---

# Topos Benchmarking

## Overview

HomTime provides the Hom-functor measurement foundation - benchmarking as categorical measurement.

## Core Concept

The Hom-functor measures morphism behavior:
- Input → Output time
- Memory allocation
- Cache behavior

## Running Benchmarks

```sh
# Run all benchmarks
yon bench

# Run specific package
yon bench Algebra

# Verbose output
yon -v bench
```

## Benchmark Structure

```julia
# bench/benchmarks/my_benchmark.jl

using BenchmarkTools
using MyPackage

SUITE = BenchmarkGroup()

SUITE["my_function"] = @benchmarkable my_function(input)
```

## Using HomTime

```julia
using HomTime

# Measure morphism
measure(f, x)

# Time composition
time_compose(f, g, x)

# Memory allocation
allocate(f, x)
```

## Temporal Composition

Measure composed functions:

```julia
# Sequential composition
t_seq = time_seq(f, g, x)

# Parallel (when independent)
t_par = time_par(f, g, x)
```

## Measurement Types

| Type | Measures |
|------|----------|
| Time | Execution time |
| Memory | Allocations |
| Cache | Hit/miss rates |
| Throughput | Items/second |

## Integration

Benchmarks auto-discovered:
- `bench/run_bench.jl` used if exists
- Otherwise `bench/benchmarks/*_benchmark.jl`

## Testing

```sh
yon bench
yon bench Poly
```

## Integration with superpowers

Use with:
- **superpowers:topos-yon-cli** - For running benchmarks
