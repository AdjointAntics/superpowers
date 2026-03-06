---
name: poly-ui-representation
description: Data as representable polynomial functors, Yoneda embedding for UI, and optics as profunctors using Poly
---

# Poly UI Representation

## Categorical Foundation

Every data structure is representable via polynomial functors. A polynomial functor P = Σᵢxⁿⁱ maps input (container positions) to output (element dependencies). The **Yoneda embedding** embeds any data as a representable functor: Hom(Data, -) ≅ P(-).

## Core Concept: Data as Polynomial Functor

```julia
using Poly

# A polynomial functor: P(x) = Σᵢ xⁿⁱ
# 
# Each summand xⁿⁱ represents:
# - n: number of positions (input)
# - i: number of directions (output)

# Example: Vector{Int}
# P(x) = x + x² + x³ + ... (any length)
vec_poly = poly{i -> i + 1}()
```

## Polynomial Functors

### Definition

A polynomial functor P has the form:
```
P(x) = a₀ + a₁x + a₂x² + ...
     = Σᵢ nᵢxⁱ
```

Where:
- **aᵢ**: Number of summands with exponent i
- **i**: Number of positions (input directions)
- **n**: Number of options (output directions)

### Creating Polynomials

```julia
# Using macro syntax
p1 = poly{1}()          # x⁰ = 1 (constant)
p2 = poly{i -> i}()     # x¹ = x (identity)
p3 = poly{i -> i + 1}() # x + x² + x³ + ... (non-empty vector)
p4 = poly{i -> 2}()     # 2x (choice of two)
```

## Representability via Yoneda

### The Yoneda Lemma

The Yoneda lemma states:
```
Nat(Hom(A, -), F) ≅ F(A)
```

In our context:
- Hom(A, -) is the representable functor
- F is any data structure
- The isomorphism means any data can be represented as Hom(Data, -)

### Embedding Data

```julia
# Make data representable via Yoneda
using Poly.Representable

# Create representable functor from data
repr = Yoneda(Hom, my_data)

# Now repr ≅ Hom(Representation, -)
```

### Universal Representation

```julia
# The universal property: any morphism from Hom(A, -) 
# factors uniquely through the Yoneda embedding

# Create the embedding
emb = YonedaEmbedding(DataType)

# Now any Hom(A, x) can be computed as P(x)
```

## Optics as Profunctors

### Lenses

A **lens** is a profunctor morphism:

```julia
using Poly.Optics

# Lens: Get ⊗ Put
# 
# view: S → A (getter)
# set: S → B → S (setter)

lens = Lens(get, set)

# Using the optic
view(lens, state)           # Get value
set(lens, state, new_value)  # Set value
over(lens, f, state)        # Modify value
```

### Prisms

A **prism** is the dual:

```julia
# Prism: Build ⊗ Match
#
# build: B → S (constructor)
# match: S → Option[B] (destructor)

prism = Prism(build, match)

# Using
build(prism, value)         # Create
match(prism, state)         # Extract optionally
```

### Traversals

```julia
# Traversal: multiple focus points
#
# Used for collections

traversal = Traversal(get_many, over_many)

# function to all Apply elements
over(traversal, f, collection)
```

## Widget as Polynomial

### UI Widget Functor

A widget maps **state** to **view**:

```julia
# Widget W: State → View
# 
# This is a polynomial functor!
# W(s) = Σᵢ sⁿⁱ → vᵢ
#
# Where:
# - s: state positions
# - n: input dependencies  
# - v: view outputs

widget = Widget(
    get_state,    # How to extract relevant state
    render_view, # How to render given state
    handle_event # How events modify state
)
```

### State Functor

```julia
# Application state as functor:
# State: Events → (View × State)
# 
# This is the cofree comonad of the widget!
```

## Representing Common Data

### Primitives

```julia
# Int: P(x) = x (identity functor)
# Bool: P(x) = 1 + 1 (two constants)
# Char: P(x) = c (constant for each char)
```

### Collections

```julia
# Vector: P(x) = x + x² + x³ + ...
# Dict: P(x) = Πₖ (1 + x)^vₖ
# Set: P(x) = Σₙ Cₙxⁿ
```

### Nested Structures

```julia
# Tree: P(x) = 1 + x·P(x)·P(x)
# This is the least fixed point of the functor
```

## Integration with Yoneda

### Universal Properties

Making data "representable" means:

```julia
# Find A such that Hom(A, -) ≅ Data
# This is solving the Yoneda embedding

representation = solve_yoneda(Data)

# Now can use Hom(representation, state) as the widget
```

### Interface Bridging

Via the Yoneda embedding:
- **Data** → Representable Functor → **UI**
- Any data becomes a polynomial functor
- Any polynomial functor becomes a widget

## Integration

Use with:
- **superpowers:poly-widget-composition** - Compose widgets
- **superpowers:yoneda-representability** - Deep representability
- **superpowers:compound-feedback-loop** - Visualize results

## Key Principles

1. **Data is polynomial** - Every data structure is P(x) = Σᵢxⁿⁱ
2. **Yoneda embeds** - Any data as Hom(A, -)
3. **Widgets are optics** - Profunctor morphisms for get/set
4. **Universal representation** - Solves for the representable

## References

- Poly.jl: Objects/, Optics/
- Polynomial functors: Poly/src/Objects/
