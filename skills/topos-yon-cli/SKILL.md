---
name: topos-yon-cli
description: Use when running yon CLI commands -- test, bench, lint, check, eval, packages, deps, ls, and fix
---
# Topos Yon CLI

## When
Invoke when running tests, benchmarks, linting, compilation checks, or evaluating Julia expressions via the `yon` CLI in the Topos monorepo.

## Iron Laws
1. `yon eval <Pkg> '<expr>'` is the bridge from shell to Julia. The expression is raw Julia -- no DSL.
2. Every package exports `yon()` returning `(name, version, description, deps, exports)`.
3. Tests run in dependency-tier parallelism: packages within a tier run in parallel, tiers run sequentially.
4. Exit code 0 means all passed. Exit code 1 means any failure or bad usage.

## Process
1. Install: `julia bin/yon install` (creates symlink to `~/.local/bin/yon`).
2. Run all tests: `yon test`. Run specific packages: `yon test Theory Algebra`.
3. Run a single test file: `yon test Theory::test_functor`.
4. Run benchmarks: `yon bench`. Run for a package: `yon bench Poly`.
5. Lint all packages: `yon lint`. Auto-fix: `yon fix`.
6. Verify compilation: `yon check`.
7. Inspect a package: `yon eval Theory 'yon()'`.
8. List packages: `yon packages`. Show deps: `yon deps Algebra`. List files: `yon ls Theory`.
9. Add `-v` for verbose output: `yon -v test`.

## All Commands

| Command | Purpose |
|---------|---------|
| `yon test [Pkg...]` | Run tests (all or specific) |
| `yon test Pkg::file` | Run single test file |
| `yon bench [Pkg]` | Run benchmarks |
| `yon lint [Pkg]` | Lint with Strict |
| `yon fix` | Auto-fix lint issues |
| `yon check` | Verify precompilation |
| `yon eval Pkg 'expr'` | Evaluate Julia expression |
| `yon packages` | List all packages and tiers |
| `yon deps Pkg` | Show dependency graph |
| `yon ls Pkg` | List source, test, bench files |
| `yon -v <cmd>` | Verbose output |
| `yon help <cmd>` | Detailed help |

## Eval Syntax Examples
```sh
yon eval Theory 'yon()'              # Package identity
yon eval Theory 'names(Theory)'      # List exports
yon eval Theory 'methods(fmap)'      # Method signatures
yon eval Theory '@doc fmap'          # Documentation
yon eval Theory 'subtypes(AbstractType)'  # Type hierarchy
yon eval Theory 'fieldnames(SomeStruct)'  # Struct fields
```

## Auto-Discovery Rules
- **Tests**: `test/test_*.jl` auto-discovered. `test/runtests.jl` overrides if non-empty. Setup files included first.
- **Benchmarks**: `bench/run_bench.jl` if present, otherwise `bench/benchmarks/*_benchmark.jl`.
- **Parallelism**: Packages grouped by tier, parallel within tier, sequential across tiers.

## Exit Codes

| Code | Meaning |
|------|---------|
| 0 | All passed |
| 1 | Any failure or bad usage |

## Common Workflows

**Development cycle:**
```sh
yon test       # Run tests
yon bench      # Check performance
yon lint       # Check style
yon check      # Verify compilation
```

**Exploration:**
```sh
yon eval Algebra 'yon()'
yon eval Algebra 'names(Algebra)'
yon eval Algebra 'methods(fmap)'
yon eval Algebra '@doc some_function'
```

**Debugging:**
```sh
yon -v test Package                    # Verbose output
yon test Package::test_specific_feature # Single file
```

## Composability
Expects the Topos monorepo with `packages/` directory and `bin/yon` entry point. Produces test/bench/lint reports consumed by CI and all other topos-* skills.
