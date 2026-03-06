---
name: topos-theory-foundations
description: Theory package - Yoneda, adjunctions, recursion schemes, and core categorical abstractions in Topos
---

# Topos Theory Foundations

## Overview

Theory is the equivariant kernel - the zero-dependency foundation of Topos. It provides algebraic theory protocols, the Yoneda lemma, adjunctions, and recursion schemes.

## Purpose

Theory is T0 - zero external dependencies. It defines the categorical protocols that all other packages build upon.

## Core Components

### 1. Algebraic Theory Protocols

```julia
using Theory

# Define theory signature
@theory ThMonoid{+, *, 1} begin
    # Objects
    (a, b, c)::Ob
    
    # Morphisms
    +(a::Ob, b::Ob)::Ob
    *(a::Ob, b::Ob)::Ob
    one()::Ob
    
    # Laws
    (a + b) * c == a + (b * c)  ⊣ [a::Ob, b::Ob, c::Ob]
    one() * a == a                ⊣ [a::Ob]
    a * one() == a                ⊣ [a::Ob]
end
```

### 2. Yoneda Lemma

The Yoneda lemma states: for any category C, functor F: C → Set:

```
Nat(Hom(A, -), F) ≅ F(A)
```

In Topos:

```julia
using Theory

# Representable functor
HomA = Yoneda(Hom, A)

# Natural transformation to F
η = to_yoneda(F, A)

# Contravariant version
HomA_op = Yoneda(Hom, A, contravariant=true)
```

### 3. Adjunctions

An adjunction L ⊣ R is when L is left adjoint to R:

```julia
using Theory

# L ⊣ R
adjunction = Adjunction(L, R, unitit)

# Unit, coun: η: Id → R∘L
# Counit: ε: L∘R → Id

# Triangle laws
@test L(η) == ε ∘ L(η)
@test R(ε) == η ∘ R(ε)
```

### 4. Recursion Schemes

#### Catamorphism (fold)

```julia
using Theory

# Fold: cata(algebra)
# algebra: F(A) → A
# unfolds: A → F(A)

result = cata(algebra, data)
```

#### Anamorphism (unfold)

```julia
# Unfold: ana(coalgebra)
# coalgebra: A → F(A)
# unfolds: A

result = ana(coalgebra, seed)
```

#### Histomorphism (refold with accumulation)

```julia
# histo: (F(A) → A) with history
result = histo(algebra, data)
```

#### Futumorphism (cohistorphism)

```julia
# futu: (A → F(A)) with future
result = futu(coalgebra, seed)
```

#### Chronomorphism

```julia
# chrono: combines cata and ana
result = chrono(alg, coalg, data)
```

#### Zygo morphism

```julia
# zygo: with auxiliary accumulation
result = zygo(witness, algebra, data)
```

## Key Abstractions

### Functors

```julia
# Functor F: C → D
struct MyFunctor <: Functor
    # Mapping data
end

# fmap: F(A) → F(B)
fmap(f, fa) = # implement
```

### Monads

```julia
# Monad T: C → C with:
# - return: A → T(A) (unit)
# - join: T(T(A)) → T(A) (multiplication)

struct MyMonad <: Monad
    # data
end

return(m::MyMonad, a) = # lift into monad
join(m::MyMonad, tta) = # flatten
```

### Comonads

```julia
# Comonad W: C → C with:
# - extract: W(A) → A (counit)
# - extend: W(A) → W(W(A))

struct MyComonad <: Comonad
    # data
end

extract(w::MyComonad, wa) = # project
extend(w::MyComonad, f, wa) = # duplicate and map
```

## Testing

```sh
yon test Theory
yon bench Theory
```

## Common Patterns

### Implementing a New Theory

```julia
@theory ThMyTheory{Op} begin
    # Signature
    op(a::Ob, b::Ob)::Ob
    
    # Laws
    op(a, a) == a ⊣ [a::Ob]  # idempotent
    op(a, b) == op(b, a) ⊣ [a::Ob, b::Ob]  # commutative
end
```

### Using Yoneda

```julia
# Create representable
R = Yoneda(Hom, A)

# Natural to any F
η = to_yoneda(F, A)

# Evaluate
value = η(id)
```

### Building Adjunctions

```julia
# Free-forgetful adjunction
L = Free(T)
R = Forget(T)

# Unit
η = unit(L, R)

# Counit  
ε = counit(L, R)

# Verify triangle laws
L(η) == ε ∘ L(η)
R(ε) == η ∘ R(ε)
```

## Integration with superpowers

Use with:
- **superpowers:topos-yon-cli** - For running tests
- **superpowers:topos-testing** - For law verification
- **superpowers:topos-algebra** - For free/cofree
- **superpowers:topos-poly** - For polynomial functors

## References

- Theory/src/Yoneda/
- Theory/src/Schemes/ (recursion)
- docs/T0-Foundations/
