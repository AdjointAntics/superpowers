---
name: poly-ui-representation
description: Use when representing data as polynomial functors, using optics (lens/prism/traversal) for state access, or bridging data to UI widgets via Yoneda embedding -- uses Poly
---
# Poly UI Representation

## When
Invoke when you need to model data structures as polynomial functors, use optics for composable get/set access, or convert data into widget-ready representations.

## Iron Laws
1. Represent every data type as a polynomial functor before building UI.
2. Use optics (Lens/Prism/Traversal) for all state access -- never raw field mutation.
3. Bridge data to UI via the pipeline: Data -> Representable -> Polynomial -> Widget.

## Process
1. Create polynomial functors:
   ```julia
   using Poly
   p1 = poly{1}()            # constant (x^0)
   p2 = poly{i -> i}()       # identity (x)
   p3 = poly{i -> i + 1}()   # non-empty vector
   p4 = poly{i -> 2}()       # choice of two
   ```
2. Embed data via Yoneda:
   ```julia
   using Poly.Representable
   repr = Yoneda(Hom, my_data)
   emb = YonedaEmbedding(DataType)
   ```
3. Create and use a Lens:
   ```julia
   using Poly.Optics
   lens = Lens(get, set)
   view(lens, state)             # get value
   set(lens, state, new_value)   # set value
   over(lens, f, state)          # modify value
   ```
4. Create and use a Prism:
   ```julia
   prism = Prism(build, match)
   build(prism, value)           # construct
   match(prism, state)           # extract (returns Option)
   ```
5. Create and use a Traversal:
   ```julia
   traversal = Traversal(get_many, over_many)
   over(traversal, f, collection)  # apply to all elements
   ```
6. Build a widget from polynomial representation:
   ```julia
   widget = Widget(get_state, render_view, handle_event)
   ```

### Data as Polynomials

| Type | Polynomial |
|------|-----------|
| Int | x (identity) |
| Bool | 1 + 1 (two constants) |
| Vector | x + x^2 + x^3 + ... |
| Dict | product of (1 + x) |
| Tree | fixed point of 1 + x*P*P |

### Interface Bridging Pipeline
Data -> Representable Functor (`Yoneda`) -> Polynomial Functor (`poly{}`) -> Widget

## Composability
Expects Julia data types. Produces polynomial functor representations and optic accessors. Feeds into poly-widget-composition for layout and interaction composition.
