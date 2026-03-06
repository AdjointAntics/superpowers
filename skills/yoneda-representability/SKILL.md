---
name: yoneda-representability
description: Use when making data representable via the Yoneda lemma, computing coends, bridging interfaces with natural transformations, or using @representable macro -- uses Yoneda.jl
---
# Yoneda Representability

## When
Invoke when you need to make data representable as `Hom(A, -)`, bridge between different functor interfaces, compute coends, or use the `@representable` macro for automatic Yoneda embedding.

## Iron Laws
1. Every data type that participates in the polynomial pipeline must be made representable.
2. Verify the round-trip: `to_yoneda(from_yoneda(r)) == r`.
3. Use `@representable` for standard types; implement `to_yoneda`/`from_yoneda` manually only when needed.

## Process
1. Understand the Yoneda lemma: `Nat(Hom(A, -), F) = F(A)`. Natural transformations from a representable functor to any functor F correspond uniquely to elements of F(A).
2. Create the Yoneda embedding:
   ```julia
   using Yoneda
   Y = YonedaEmbedding(Category)
   ```
3. Convert to/from Yoneda form:
   ```julia
   to_yoneda(F, A)    # Nat(Hom(A, -), F) -> F(A)
   from_yoneda(F, A)  # F(A) -> Nat(Hom(A, -), F)
   ```
4. Compute coends:
   ```julia
   c = coend(data)    # universal representation
   ```
5. Use the `@representable` macro:
   ```julia
   @representable MyType
   # Creates: Yoneda embedding, to_yoneda, from_yoneda
   ```
6. Implement manually when needed:
   ```julia
   function Theory.to_yoneda(F::Type, A)
       # Return the transformation
   end
   function Theory.from_yoneda(F::Type, A, value)
       # Build the element
   end
   ```
7. Bridge interfaces via the pipeline:
   ```julia
   # Data -> Representable -> Polynomial -> UI
   data_repr = make_representable(my_data)
   poly_form = to_polynomial(data_repr)
   widget = to_widget(poly_form)
   ```
8. Use the co-Yoneda dual: `co_yoneda = CoYonedaEmbedding()` for representability in the opposite category.

## Composability
Expects Julia data types. Produces representable functor forms that feed into poly-ui-representation for polynomial encoding and poly-widget-composition for UI rendering. Verify with testy-property-testing using round-trip properties.
