---
name: topos-testing
description: Use when writing or running tests in Topos -- law verification, property testing, test conventions, and yon test commands
---
# Topos Testing

## When
Invoke when writing new tests, verifying categorical laws, running test suites, or debugging test failures across Topos packages.

## Iron Laws
1. Every categorical abstraction MUST have its algebraic laws tested (functor, monad, comonad, adjunction).
2. Julia's `@test` does NOT accept string messages. Use `@testset "description" begin ... end` instead.
3. Test files must be named `test/test_*.jl` for auto-discovery.
4. Property-based tests should cover algebraic laws, not just example cases.

## Process
1. Run all tests: `yon test`.
2. Run a specific package: `yon test Algebra`.
3. Run a single test file: `yon test Theory::test_functor`.
4. Run verbose: `yon -v test`.
5. Name test files `test/test_*.jl` (auto-discovered by yon).
6. If `test/runtests.jl` exists and is non-empty, it is used as the entry point instead.
7. Setup files (`test/*.jl` not matching `test_*`) are included first.
8. Write functor law tests: `@test fmap(identity, x) == x` and `@test fmap(f . g, x) == fmap(f, fmap(g, x))`.
9. Write monad law tests: left identity, right identity, associativity.
10. Write applicative law tests: identity, composition, homomorphism, interchange.

## Law Testing Patterns

**Functor laws:**
```julia
@test fmap(identity, x) == identity(x)
@test fmap(f . g, x) == (fmap(f) . fmap(g))(x)
```

**Monad laws:**
```julia
@test (return_m >=> f)(x) == f(x)          # left identity
@test (m >=> return_m)(x) == m(x)          # right identity
@test ((f >=> g) >=> h)(x) == (f >=> (g >=> h))(x)  # associativity
```

**Applicative laws:**
```julia
@test pure(identity) |> app(v) == v         # identity
@test pure(f) |> app(pure(x)) == pure(f(x)) # homomorphism
```

## Auto-Discovery Rules
- Files matching `test/test_*.jl` are auto-discovered and run in supervised `@testset`.
- If `test/runtests.jl` exists and is non-empty, it overrides auto-discovery.
- Packages within a dependency tier run in parallel; tiers run sequentially.

## Assertion Notes
- `@test condition` -- basic assertion.
- `@test_throws ExceptionType expr` -- expect exception.
- `@test_nowarn expr` -- expect no warnings.
- `@testset "name" begin ... end` -- grouped assertions with description.
- NEVER write `@test "message"` -- this does not work in Julia.

## Composability
Expects packages with `test/` directories following naming conventions. Produces test reports consumed by CI and `yon test` output.
