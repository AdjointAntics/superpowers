---
name: topos-categorical-reframing
description: Use when mapping Topos concepts to category theory -- Yoneda, adjunctions, free/cofree, recursion schemes
---
# Topos Categorical Reframing

## When
Invoke when you need to understand a Topos concept through its categorical foundation, or when designing new abstractions that must fit the existing categorical architecture.

## Iron Laws
1. Every Topos abstraction maps to a specific categorical concept. Identify the mapping before implementing.
2. Dualities must be respected: Free/Cofree (syntax/observation), cata/ana (fold/unfold).
3. Use `yon eval` to inspect categorical structure at runtime.

## Process
1. Identify the Topos concept you are working with.
2. Find its categorical mapping in the table below.
3. Apply categorical reasoning (laws, universal properties, adjunctions).
4. Translate the result back to Topos code.
5. Verify with `yon eval <Pkg> 'yon()'` to inspect package relationships.

## Concept Mapping

| Topos Concept | Category Theory | Description |
|--------------|-----------------|-------------|
| `yon()` | Yoneda lemma | Identity through relationships |
| `yon eval` | Elaboration | Self-description/reflection |
| Free.jl | Free functor | Build syntax from signature |
| Cofree.jl | Cofree comonad | Observe from data |
| Poly/Optics | Profunctor | Bidirectional access |
| StateT | State monad | State threading |
| `cata` | Catamorphism | Fold/consume |
| `ana` | Anamorphism | Unfold/produce |
| Adjunction L -| R | Adjunction | Free/forgetful |

## Package Relationships

```
Theory (T0) ------> Initial/Terminal (T2)
    |                    |
    v                    v
 Yoneda/HomTime   Free/Cofree (T3)
    |
    v
  Poly (T3) -----> PolyModes (T4)
```

## Recursion Scheme Mapping

| Scheme | Function | Category Theory |
|--------|----------|-----------------|
| fold | `cata` | Catamorphism |
| unfold | `ana` | Anamorphism |
| refold | `hylo` | Hylomorphism |
| history fold | `histo` | Histomorphism |

## Composability
Expects familiarity with the Topos package tier system. Produces categorical understanding that informs design decisions across all packages.
