---
name: topos-poly
description: Polynomial functors, graphical calculus, profunctor optics, and the Poly package in Topos
---

# Topos Poly

## Overview

Poly implements polynomial functors, graphical calculus, profunctor optics, and TUI as Moore machines.

## Core Concepts

### Polynomial Functor

A polynomial functor P(x) = Σ_i x^{n_i} is:
- Sum of containers
- Each with positions

```julia
using Poly

# Define polynomial
p = poly{i -> i + 1}()  # x + x² + ...

# Evaluate
p(3)  # positions at 3
```

### Graphical Calculus

String diagrams for monoidal categories:

```julia
using Poly.Diagrams

# Compose morphisms
diagram = f ⊗ g ∘ α ∘ id

# Draw
draw(diagram)
```

## Objects and Morphisms

### Poly Objects

```julia
# Container types
Poly{Position, Direction}

# Direction: input/output
dir = Input()  # consuming
dir = Output()  # producing
```

### Morphisms

```julia
# Polynomial morphism
morphism = PolyMorphism(f, g, η)

# Compose
f ∘ g
f ⊗ g
```

## Profunctor Optics

### Optic Types

| Optic | Purpose |
|-------|---------|
| Lens | Get + set |
| Prism | Match + build |
| Traversal | Multiple focus |
| Fold | Read-only traversal |
| Affine | Optional + required |

### Creating Optics

```julia
using Poly.Optics

# Lens: get + set
lens = lens(get_fn, set_fn)

# Prism: match + build
prism = prism(build_fn, try_match_fn)

# Traversal
traversal = traversal(focus_fn)
```

### Using Optics

```julia
# Get (view)
view(lens, state)

# Set (over)
set(lens, state, new_value)

# Modify (over)
over(lens, fn, state)
```

## Four Monoidal Structures

Poly has four monoidal structures:

| Structure | Tensor | Unit | Significance |
|-----------|--------|------|-------------|
| (Poly, ◁, y) | poly_compose | Arena(1,1) | Comonoids = categories |
| (Poly, ⊗, 1) | poly_mul | Arena(1,0) | Parallel machines |
| (Poly, +, 0) | poly_add | Arena(0,0) | Choice |
| (Poly, ×, 1) | poly_product | Arena(1,0) | Cartesian |

## Testing

```sh
yon test Poly
yon bench Poly
```

## Subdirectories

- Poly/Objects/ - Polynomial objects
- Poly/Morphisms/ - Morphisms
- Poly/Diagrams/ - Graphical calculus
- Poly/Dynamics/ - State machines
- Poly/Symmetry/ - Symmetries
- Poly/Duality/ - Dualities
- Poly/Modes/ - Mode theory

## Integration with superpowers

Use with:
- **superpowers:topos-yon-cli** - For running tests
- **superpowers:topos-testing** - For law verification
- **superpowers:topos-theory-foundations** - For category theory
