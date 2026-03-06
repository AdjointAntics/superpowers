---
name: testy-property-testing
description: Use when writing property-based tests, generating random test data, verifying algebraic laws (functor, monad), or shrinking failing inputs -- uses Testy's @property macro and Gen types
---
# Testy Property Testing

## When
Invoke when you need to test universal properties across random inputs, generate structured test data, verify categorical laws, or find minimal counterexamples via shrinking.

## Iron Laws
1. Every categorical abstraction MUST have property tests for its laws.
2. Always enable shrinking for counterexample minimization unless performance prohibits it.
3. Use at least 100 samples (`check(prop; samples=100)`) for meaningful coverage.
4. Compose generators from primitives -- do not hand-roll random data.

## Process
1. Define a property with the `@property` macro:
   ```julia
   @property function sort_preserves_length(xs::Vector{Int})
       sorted = sort(xs)
       issorted(sorted) && length(sorted) == length(xs)
   end
   ```
2. Use generators for input:
   ```julia
   @property "sort preserves length" begin
       xs in generate(Vector{Int}, 100)
       sort(xs) |> length == xs |> length
   end
   ```
3. Create generators from built-in types:
   ```julia
   Gen(Int)              # Any Int
   Gen(1:1000)           # Range
   Gen(Vector{Int})      # Vectors
   Gen(Dict{String,Int}) # Dicts
   Gen((Int, String))    # Tuples
   ```
4. Compose generators: `Gen(Int) x Gen(String)` for products; nest for collections.
5. Enable shrinking: `generate(Gen(Int), 100; shrink=true)`. Define custom shrinking with `Testy.shrink(val)` returning smaller candidates.
6. Run properties: `check(my_property)`, `check(my_property; samples=1000)`, `check(my_property; size=100)`.
7. Use implication for conditional properties:
   ```julia
   @property begin
       xs in Gen(Vector{Int})
       length(xs) > 0 -> minimum(xs) <= maximum(xs)
   end
   ```
8. Test functor laws:
   ```julia
   @property "fmap identity" begin
       x in Gen(Int)
       fmap(identity, x) == x
   end
   ```
9. Test monad laws:
   ```julia
   @property "left identity" begin
       a in Gen(Int)
       (return . f)(a) == f(a)
   end
   ```

## Composability
Expects callable predicates and Gen-based generators. Produces test results (pass/fail with counterexamples). Pairs with homtime-optimization for benchmarking property check time, and testy-stateful-testing for state machine properties.
