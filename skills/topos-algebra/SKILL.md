---
name: topos-algebra
description: Use when working with free/cofree constructions, effects, or monad transformers in the Algebra package
---
# Topos Algebra

## When
Invoke when building or modifying free monads, cofree comonads, effect handlers, or monad transformer stacks in the Algebra package. Also use when testing algebraic laws for these constructions.

## Iron Laws
1. Every categorical construction (functor, monad, comonad) MUST have its algebraic laws tested.
2. Free constructions build syntax from signatures; cofree constructions observe behavior from data. Respect this duality.
3. Effect signatures use `@sig` to declare sum types; handlers pattern-match on those constructors.
4. Monad transformer stacks compose via `StateT`, `ErrorT`, `ReaderT`, `WriterT`, and `IO`.
5. Algebra depends on Theory, YonedaStyle, Testy, and FreeSchema only.

## Process
1. Define effect signatures with `@sig EffectF{X} = Constructor1{X} | Constructor2{X}`.
2. Build free monads over signatures with `Free{EffectF}(action)`.
3. Write handlers that pattern-match on effect constructors and return `(result, state)` tuples.
4. Run effects with `run_effect(free_expr, handler, initial_state)`.
5. For cofree comonads, build from an observation function: `cofree{State}(initial, observe_fn)`.
6. Use `extract` to get the current observation and `extend` to add new behavior.
7. Compose monad transformers: `Stack = StateT compose ErrorT compose IO`.
8. Test functor laws: `fmap(id, fx) == fx` and `fmap(f . g, fx) == fmap(f, fmap(g, fx))`.
9. Test monad laws: left identity, right identity, associativity.
10. Run tests with `yon test Algebra` and benchmarks with `yon bench Algebra`.

## Key Types

| Type | Purpose |
|------|---------|
| `Free{F, A}` | Free functor/monad over signature F |
| `Cofree{F, A}` | Cofree comonad over signature F |
| `Lift{F}` | Lifting into free |
| `Handle` | Effect handler |

## Monad Transformers

| Transformer | Effect |
|-------------|--------|
| StateT | State threading |
| ErrorT | Error handling |
| ReaderT | Environment |
| WriterT | Logging |
| IO | Side effects |

## Test Files
- `test/test_free.jl` - Free constructions
- `test/test_cofree.jl` - Cofree constructions
- `test/test_effects.jl` - Effect handlers
- `test/test_transformers.jl` - Monad transformers

## Composability
Expects Theory protocols to be available. Produces free/cofree constructions that Poly and other T1+ packages can consume.
