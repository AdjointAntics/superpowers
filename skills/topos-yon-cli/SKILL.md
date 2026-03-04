---
name: topos-yon-cli
description: Master the yon CLI for the Topos monorepo - test, bench, lint, check, and elaborate commands
---

# Topos Yon CLI

## Overview

`yon` is the Topos CLI that bridges shell to Julia for the monorepo. It provides introspection, testing, benchmarking, and linting via a Yoneda-style self-description system.

## Setup

```sh
# Install yon CLI
julia bin/yon install
```

This creates a symlink to `~/.local/bin/yon`. If PATH doesn't include it, the command prints the one-liner to add.

## Core Commands

### Running Tests

```sh
# Test all packages (tier-parallel)
yon test

# Test specific packages
yon test Theory Algebra

# Run a single test file
yon test Theory::test_functor

# Verbose output (show all, not just failures)
yon -v test
```

Tests run in dependency-tier parallelism: packages within a tier run in parallel, tiers run sequentially.

### Benchmarks

```sh
# Run all benchmarks
yon bench
```

### Linting

```sh
# Lint all packages with Strict
yon lint

# Auto-fix lint issues
yon fix
```

### Verification

```sh
# Verify all packages load (precompilation check)
yon check
```

### Inspecting Packages

```sh
# List all packages and tiers
yon packages

# Show dependency graph
yon deps Algebra

# List source, test, bench files
yon ls Theory
```

## Elaboration (yon eval)

The bridge from shell to Julia REPL. Auto-loads package, evaluates expression.

```sh
# Get package identity
yon eval Theory 'yon()'

# List all exports
yon eval Theory 'names(Theory)'

# Get method signatures
yon eval Theory 'methods(fmap)'

# Get documentation
yon eval Theory '@doc fmap'

# Inspect type hierarchy
yon eval Theory 'subtypes(AbstractType)'

# Get struct fields
yon eval Theory 'fieldnames(SomeStruct)'
```

### Evaluation Syntax

```
yon eval <Package> '<expression>'
```

- `<Package>` = Theory, Algebra, Poly, FreeSchema, Testy, YonedaStyle, HomTime, Strict
- Expression is raw Julia — no DSL, Julia IS the query language

## Self-Description (yon())

Every package exports `yon()` returning its identity: `(name, version, description, deps, exports)`.

```julia
yon eval Theory 'yon()'
# => (name="Theory", version=v"0.1.0", description="...",
#     deps=[], exports=[:yon])

yon eval Algebra 'yon()'
# => (name="Algebra", version=v"0.1.0", description="...",
#     deps=[(name="Theory", ...), (name="YonedaStyle", ...)],
#     exports=[:yon])
```

## How Auto-Discovery Works

### Tests
- Files matching `test/test_*.jl` are auto-discovered
- Run in supervised `@testset`
- If `test/runtests.jl` exists and non-empty, use it (escape hatch)
- Setup files (`test*.jl` not matching `test_*`) included first

### Benchmarks
- `bench/run_bench.jl` used if present
- Otherwise `bench/benchmarks/*_benchmark.jl` files auto-discovered

### Parallelism
- Packages grouped by dependency tiers
- All packages within a tier run in parallel (one process each)
- Tiers execute sequentially

## Exit Codes

| Code | Meaning |
|------|---------|
| 0 | All passed |
| 1 | Any failure or bad usage |

## Common Workflows

### Development Cycle
```sh
# After making changes
yon test              # Run tests
yon bench             # Check performance
yon lint              # Check style
yon check            # Verify compilation
```

### Exploration
```sh
# Understand a package
yon eval Algebra 'yon()'
yon eval Algebra 'names(Algebra)'
yon eval Algebra 'methods(fmap)'

# Look up a specific function
yon eval Algebra '@doc some_function'
yon eval Algebra 'fieldnames(SomeType)'
```

### Debugging
```sh
# If tests fail, run verbose
yon -v test Package

# Run single test file
yon test Package::test_specific_feature
```

## Options

```sh
yon -v test              # Verbose: show all output
yon help test            # Detailed help
yon help <command>       # Any command
```

## Integration with superpowers

Use with:
- **superpowers:topos-testing** - For test creation and execution
- **superpowers:topos-package-development** - For creating new packages

## Key Principles

1. **Elaboration Reflection**: Every package knows itself. `yon()` is the universal identity.
2. **Diagrammatic**: Use `yon eval <Pkg> '@doc yon'` to see package's place in the diagram
3. **Tiered**: Dependency tiers enforce strict architecture
4. **Self-describing**: The monorepo knows its own structure

## Red Flags

- Don't run tests without first understanding the tier structure
- Don't skip `yon check` before committing - precompilation issues waste CI
- Don't use `@test "message"` - Julia's `@test` doesn't accept strings (use `@testset "message"`)

## References

- CLAUDE.md in repo root
- Package-specific CLAUDE.md files
- docs/T0-Foundations and docs/T1-Adjunctions
