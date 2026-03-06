---
name: topos-poly
description: Use when working with polynomial functors, graphical calculus, profunctor optics, or monoidal structures in the Poly package
---
# Topos Poly

## When
Invoke when building polynomial functors, composing string diagrams, using profunctor optics (lens/prism/traversal), or working with any of Poly's four monoidal structures.

## Iron Laws
1. Polynomial functors are sums of representables: P(x) = sum of x^{n_i}.
2. Optics must satisfy their categorical laws (get-put, put-get for lenses; match-build for prisms).
3. The four monoidal structures have distinct units and tensor products. Do not conflate them.
4. All Poly abstractions must have algebraic law tests.

## Process
1. Define polynomial functors as `Poly{Position, Direction}` containers.
2. Compose morphisms with `f . g` (sequential) and `f (tensor) g` (parallel).
3. Build string diagrams using `Poly.Diagrams`: `diagram = f (tensor) g . alpha . id`, then `draw(diagram)`.
4. Create optics: `lens(get_fn, set_fn)`, `prism(build_fn, try_match_fn)`, `traversal(focus_fn)`.
5. Use optics: `view(lens, state)`, `set(lens, state, value)`, `over(lens, fn, state)`.
6. Run tests: `yon test Poly`.
7. Run benchmarks: `yon bench Poly`.

## Profunctor Optics

| Optic | Purpose |
|-------|---------|
| Lens | Get + set |
| Prism | Match + build |
| Traversal | Multiple focus |
| Fold | Read-only traversal |
| Affine | Optional + required |

## Four Monoidal Structures

| Structure | Tensor | Unit | Significance |
|-----------|--------|------|-------------|
| (Poly, compose, y) | poly_compose | Arena(1,1) | Comonoids = categories |
| (Poly, tensor, 1) | poly_mul | Arena(1,0) | Parallel machines |
| (Poly, +, 0) | poly_add | Arena(0,0) | Choice |
| (Poly, product, 1) | poly_product | Arena(1,0) | Cartesian |

## Subdirectories
- `Poly/Objects/` -- Polynomial objects
- `Poly/Morphisms/` -- Morphisms
- `Poly/Diagrams/` -- Graphical calculus
- `Poly/Dynamics/` -- State machines
- `Poly/Symmetry/` -- Symmetries
- `Poly/Duality/` -- Dualities
- `Poly/Modes/` -- Mode theory

## Composability
Expects Theory protocols and LawKit for law verification. Produces polynomial functor compositions and optics consumed by PolyModes (TUI) and other application-tier packages.
