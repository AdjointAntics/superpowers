---
name: topos-categorical-reframing
description: Apply category theory concepts specifically to the Topos codebase - Yoneda, adjunctions, free/cofree
---

# Topos Categorical Reframing

## Overview

This skill maps Topos-specific concepts to their categorical foundations, enabling deeper understanding of the codebase.

## Core Mappings

### Topos Concept → Category Theory

| Topos Concept | Category Theory | Description |
|--------------|-----------------|-------------|
| `yon()` | Yoneda lemma | Identity through relationships |
| `yon eval` | Elaboration | Self-description/reflection |
| Algebra/Free | Free functor | Build syntax from signature |
| Algebra/Cofree | Cofree comonad | Observe from data |
| Poly/Optics | Profunctor | Bidirectional access |
| StateT | State monad | State threading |
| `cata` | Catamorphism | Fold/consume |
| `ana` | Anamorphism | Unfold/produce |
| Adjunction L ⊣ R | Adjunction | Free/ forgetful |

### Package Relationships

```
Theory (T0) ──────► Algebra (T1)
    │                    │
    ▼                    ▼
 YonedaStyle ◄──────► Poly
    │
    ▼
 HomTime
```

### Key Duality

```
Algebra/Free  <->  Algebra/Cofree
   (syntax)       (observation)
   
cata (fold)  <->  ana (unfold)
```

## Yoneda in Topos

Every `yon()` call is the Yoneda lemma in action:

```julia
yon eval Theory 'yon()'
# Returns: (name, version, deps, exports)
# This is Nat(Hom(Package, -), Id) ≅ Package
```

## Adjunctions in Topos

### Free-Forgetful

```julia
L = Free{Signature}     # Left adjoint - creates free structure
R = Forget{Signature}  # Right adjoint - forgets to underlying

# L ⊣ R
# Unit: η: Id → R∘L (wrap in free)
# Counit: ε: L∘R → Id (evaluate)
```

### State

```julia
Get ⊣ Store
# Get extracts, Store provides
```

## Recursion Schemes

| Scheme | Topos | Category Theory |
|--------|-------|-----------------|
| fold | `cata` | Catamorphism |
| unfold | `ana` | Anamorphism |
| refold | `hylo` | Hylomorphism |
| histo | `histo` | Histomorphism |

## Optics as Profunctors

```julia
# Lens = Get ⊗ Put
# Prism = Build ⊗ Match
# Traversal = Traverse ⊗ Extract
```

## Using This Skill

When working on Topos:

1. Identify the categorical pattern
2. Map to CT concept
3. Apply categorical reasoning
4. Translate back

## Integration

Use with:
- **superpowers:topos-yon-cli** - Yoneda reflection
- **superpowers:topos-algebra** - Free/cofree
- **superpowers:topos-theory-foundations** - Core CT
- **superpowers:topos-poly** - Optics

## References

- docs/T0-Foundations/
- docs/T1-Adjunctions/
- CLAUDE.md root
