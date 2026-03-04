---
name: topos-testing
description: Property-based testing and categorical law verification in Topos using Testy
---

# Topos Testing

## Overview

Testing in Topos follows categorical principles: every abstraction MUST have its algebraic laws tested. Testy provides the shared testing foundation with property-based testing, shrinking, and categorical law suites.

## Core Principles

1. **Every categorical abstraction requires law tests** - functors, monads, comonads, adjunctions, etc.
2. **Property-based testing** - test properties, not just examples
3. **Law suites** - categorical laws are first-class test targets

## Running Tests

```sh
# Test all packages (tier-parallel)
yon test

# Test specific package
yon test Algebra

# Single test file
yon test Theory::test_functor

# Verbose
yon -v test Algebra
```

## Test File Structure

```julia
# test/test_my_feature.jl

# Setup - runs before test files
using Test
using Theory  # or other package

# Test functions - use test_ prefix
function test_functor_identity()
    @test fmap(id, x) == x
end

function test_functor_composition()
    @test fmap(f ∘ g, x) == fmap(f, fmap(g, x))
end

# Run tests
@testset "Functor laws" begin
    test_functor_identity()
    test_functor_composition()
end
```

## Test Naming Convention

- File: `test/test_*.jl` (auto-discovered)
- Alternative: `test/runtests.jl` (if exists and non-empty)
- Setup files: `test/setup_*.jl` or `test/*.jl` not matching `test_*`

## Categorical Law Testing

### Functor Laws

```julia
function test_functor_laws(f, x)
    # Identity: fmap(id) = id
    @test fmap(identity, x) == identity(x)
    
    # Composition: fmap(f ∘ g) = fmap(f) ∘ fmap(g)
    @test fmap(f ∘ g, x) == (fmap(f) ∘ fmap(g))(x)
end
```

### Monad Laws

```julia
function test_monad_laws(m)
    # Left identity: return >=> f = f
    @test (return ∘ f)(x) == f(x)
    
    # Right identity: m >=> return = m
    @test (m >=> return)(x) == m(x)
    
    # Associativity: (f >=> g) >=> h = f >=> (g >=> h)
    @test ((f >=> g) >=> h)(x) == (f >=> (g >=> h))(x)
end
```

### Applicative Laws

```julia
function test_applicative_laws(app)
    # Identity
    @test pure(identity) ⊛ v == v
    
    # Composition
    @test pure(∘) ⊛ u ⊛ v ⊛ w == u ⊛ (v ⊛ w)
    
    # Homomorphism
    @test pure(f) ⊛ pure(x) == pure(f(x))
    
    # Interchange
    @test u ⊛ pure(y) == pure(f -> f(y)) ⊛ u
end
```

## Property-Based Testing

### Basic Structure

```julia
using Test

function test_property_name()
    # Generate random data
    x = rand(Int)
    y = rand(Int)
    
    # Test property
    @test property_holds(x, y)
    
    # Test with multiple cases
    @testset for _ in 1:100
        x = rand(1:1000)
        @test property(x)
    end
end
```

### Using Testy's Generators

```julia
# Testy provides generators for categorical types
using Testy

function test_generator()
    @testset "Generator tests" begin
        # Use Testy's shrinking generators
    end
end
```

## Stateful Testing

Testy supports stateful property-based testing for stateful systems:

```julia
function test_stateful_system()
    # Define state transitions
    # Test state invariants
end
```

## Law Suites

Testy provides categorical law suites as reusable test modules:

```julia
using Testy

# Run predefined law suite
@testset "Functor laws" begin
    test_functor_laws(my_functor, test_data)
end

# Use Testy's suite
@testset "Categorical laws" begin
    @testset "Functor" begin
        check_functor(my_functor)
    end
    @testset "Monad" begin
        check_monad(my_monad)
    end
end
```

## Test Execution

### Via yon CLI
```sh
yon test                 # All packages
yon test Algebra         # Single package
yon test Algebra::test_functor  # Single file
```

### Direct Julia
```sh
julia -e 'using Pkg; Pkg.test("PackageName")'
```

## Assertions

### Standard Julia Tests

```julia
# Basic
@test condition
@test_throws ExceptionType expression
@test_nowarn expression
@test_logs :info expression

# With message - use testset
@testset "description" begin
    @test condition
end
```

**Note**: Julia's `@test` does NOT accept string messages. Use `@testset "name"`.

### Custom Assertions

```julia
macro my_assert(condition, message)
    quote
        if !($condition)
            error($message)
        end
    end
end
```

## Debugging Failed Tests

```sh
# Run verbose to see all output
yon -v test Package

# Run single test file
yon test Package::test_specific_file
```

## Integration with superpowers

Use with:
- **superpowers:topos-yon-cli** - For running tests
- **superpowers:topos-theory-foundations** - For understanding categorical laws
- **superpowers:topos-algebra** - For testing free/cofree constructions

## Common Patterns

### Testing Morphisms

```julia
@testset "Morphism properties" begin
    # Closure
    @test is_well_defined(f, domain)
    
    # Preservation
    @test preserves_structure(f, x, y)
end
```

### Testing Adjunctions

```julia
function test_adjunction(L, R, x)
    # Unit
    @test unit(x) == R(L(x))
    
    # Counit  
    @test counit(L(x)) == x
    
    # Triangle laws
    @test L(unit(x)) == unit(L(x)) ∘ counit(L(x))
end
```

### Testing Universal Properties

```julia
function test_universal_property(obj, morphism)
    # Check universal mapping property
    @test all(conditions) do other
        unique_mapping = unique_morphism(other)
        @test factor_through(unique_mapping, morphism)
    end
end
```

## Red Flags

- Don't add `@test "message"` - Julia doesn't support it
- Don't skip law tests for new categorical abstractions
- Don't test implementation details - test observable properties
- Don't forget shrinking for property-based tests

## References

- Testy package source
- test/test_*.jl files in packages
- Categorical law definitions in Theory
