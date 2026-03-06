---
name: topos-theory-foundations
description: Use when working with Theory package foundations -- algebraic theory protocols, recursion schemes, functors, monads, and comonads
---
# Topos Theory Foundations

## When
Invoke when defining algebraic theory protocols, using recursion schemes (cata, ana, histo, futu, chrono, zygo), or implementing functors, monads, and comonads in Theory.

## Iron Laws
1. Theory is T0 -- zero external dependencies. Never add external deps.
2. Every theory protocol defines objects, morphisms, and algebraic laws via `@theory`.
3. Recursion schemes must use the correct algebra/coalgebra: cata folds with `F(A) -> A`, ana unfolds with `A -> F(A)`.
4. All new abstractions must have algebraic law tests.

## Process
1. Define theory protocols with `@theory ThName{Ops} begin ... end`, specifying objects, morphisms, and laws.
2. Use `cata(algebra, data)` to fold (catamorphism): algebra has type `F(A) -> A`.
3. Use `ana(coalgebra, seed)` to unfold (anamorphism): coalgebra has type `A -> F(A)`.
4. Use `histo(algebra, data)` for histomorphism (fold with history).
5. Use `futu(coalgebra, seed)` for futumorphism (unfold with future).
6. Use `chrono(alg, coalg, data)` for chronomorphism (combines cata and ana).
7. Use `zygo(witness, algebra, data)` for zygomorphism (fold with auxiliary accumulation).
8. Implement functors by defining `fmap(f, fa)`.
9. Implement monads by defining `return_m(a)` and `join(tta)`.
10. Run tests: `yon test Theory`. Run benchmarks: `yon bench Theory`.

## Recursion Schemes

| Scheme | Function | Type | Direction |
|--------|----------|------|-----------|
| Catamorphism | `cata` | F(A) -> A | Fold |
| Anamorphism | `ana` | A -> F(A) | Unfold |
| Hylomorphism | `hylo` | Both | Refold |
| Histomorphism | `histo` | F(A) -> A + history | Fold with memory |
| Futumorphism | `futu` | A -> F(A) + future | Unfold with lookahead |
| Chronomorphism | `chrono` | Both + history/future | Combined |
| Zygomorphism | `zygo` | F(A) -> A + witness | Fold with auxiliary |

## Key Abstractions
- **Functor**: `fmap(f, fa)` preserving identity and composition.
- **Monad**: `return_m(a)` (unit) + `join(tta)` (multiplication), satisfying left/right identity and associativity.
- **Comonad**: `extract(wa)` (counit) + `extend(f, wa)` (comultiplication), satisfying dual laws.

## Composability
Expects LawKit for law verification. Produces algebraic theory protocols and recursion scheme functions consumed by all higher-tier packages (ExprFunctor, Initial, Terminal, Free, Cofree, Poly).
