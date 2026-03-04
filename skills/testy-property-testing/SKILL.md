---
name: testy-property-testing
description: Property-based testing via universal quantification, generator functors, and shrinking coalgebras using Testy
---

# Testy Property Testing

## Categorical Foundation

A property in Testy captures a **universal property** - a statement of what a program must satisfy for **all** inputs. This is the categorical notion of **forall quantification**: ∀x: P(x), where P is a predicate (morphism to truth).

## Core Concept: Property as Universal Property

```julia
using Testy

# A property declares a universal morphism:
# property: Program → (∀x: Input) → Property(x)
# 
# This is Nat(Hom(Program, -), Forall(Input, Property))
```

## The Property Type

```julia
# A TestableProperty is a morphism to the property category
struct TestableProperty{I,O}
    gen::Gen           # Generator (distribution functor)
    check::Function    # Property predicate
    name::String
end
```

The **Generator** G is a functor G: Size → Set - it maps a size parameter to generated values.

## Defining Properties

### Basic Property

```julia
@property function sort_property(xs::Vector{Int})
    # Universal quantification over all vectors
    sorted = sort(xs)
    issorted(sorted) && length(sorted) == length(xs)
end
```

### With Generator

```julia
@property "sort preserves length" begin
    # Generator creates test data
    xs ∈ generate(Vector{Int}, 100)
    
    # Property: ∀xs: sort(xs).length = xs.length
    sort(xs).len == xs.len
end
```

## Generator Functors

### The Generator Category

A **Generator** is a functor G: Size → Set where:
- Size is the input size parameter
- Set is the category of Julia sets
- The functor maps sizes to generated values

### Built-in Generators

```julia
# Primitive generators
gen_int = Gen(Int)           # Any Int
gen_positive = Gen(1:1000)   # Range
gen_vector = Gen(Vector{Int})  # Vectors

# Composite generators
gen_dict = Gen(Dict{String, Int})
gen_tuple = Gen((Int, String))
gen_named = Gen(;x=Gen(Int), y=Gen(String))
```

### Generator Composition

```julia
# Functor composition: G₁ ○ G₂
# Generate a vector of positive integers
gen_positive_vec = Gen(Vector{generate(Gen, 1:100)})

# Product: G₁ × G₂
gen_pair = Gen(Int) × Gen(String)
```

## The Generator Adjunction

Generator creation uses an **adjunction**:

```julia
# L ⊣ R between Set and Generator category
# L: Set → Generator (free generator)
# R: Generator → Set (forget to underlying set)

# lift: Set → Generator (left adjoint)
# generate: Generator × Size → Set (right adjoint)
```

## Shrinking: The Coalgebra

Shrinking is a **coalgebra** on the generator:

```julia
# A shrinking coalgebra: A → Shrink(A)
# 
# Given a value, produce smaller values to test
# This is the costructure map of a cofree coalgebra

shrink(value)  # Returns generator of smaller values
```

### Using Shrinking

```julia
@property "addition is commutative" begin
    # With automatic shrinking
    a ∈ generate(Gen(Int), 100; shrink=true)
    b ∈ generate(Gen(Int), 100; shrink=true)
    
    a + b == b + a
end
```

### Custom Shrinking

```julia
# Define shrink method for custom type
function Testy.shrink(bt::BinaryTree)
    # Return smaller versions
    [bt.left, bt.right] |> filter(!isnothing)
end
```

## Property Composition

### Conjunction (And)

```julia
# P ∧ Q: property must satisfy both
@property begin
    a ∈ Gen(Int)
    b ∈ Gen(Int)
    
    # Both must hold
    a + b > a
    a + b > b
end
```

### Disjunction (Or)

```julia
# P ∨ Q: property must satisfy at least one
@property begin
    x ∈ Gen(Int)
    
    # Either condition
    x > 0 || x == 0 || x < 0  # Always true example
end
```

### Implication

```julia
# P → Q: when P holds, Q must hold
@property begin
    xs ∈ Gen(Vector{Int})
    length(xs) > 0 → minimum(xs) >= 0
end
```

## Running Properties

### Direct Execution

```julia
# Run property - generates samples and checks
result = check(my_property)

# Returns test result
```

### With Count

```julia
# Run with specific sample count
result = check(my_property; samples=1000)
```

### With Size

```julia
# Control generated size
result = check(property; size=100)
```

## The Forall Monad

Universal quantification forms a **monad** in the testing category:

```julia
# Return: wrap value in universal quantifier
forall(x) = (f -> f(x))

# Bind: chain quantified properties  
forall(x) >>= f = forall(y -> f(y)(x))

# Map: transform quantified values
map(forall(x), f) = forall(f(x))
```

## Categorical Law Testing

### Functor Laws

```julia
@property "fmap is functorial" begin
    f ∈ Gen(Function)  # Note: careful with function generation
    g ∈ Gen(Function)
    x ∈ Gen(Int)
    
    # Identity: fmap(id) = id
    fmap(identity, x) == x
    
    # Composition: fmap(f ∘ g) = fmap(f) ∘ fmap(g)
    fmap(f ∘ g, x) == fmap(f, fmap(g, x))
end
```

### Monad Laws

```julia
@property "monad laws" begin
    a ∈ Gen(Int)
    f ∈ Gen(Int → Int)
    g ∈ Gen(Int → Int)
    
    # Left identity: return >=> f = f
    (return ∘ f)(a) == f(a)
    
    # Right identity: m >=> return = m  
    m >>= return == m
    
    # Associativity: (f >=> g) >=> h = f >=> (g >=> h)
end
```

## Integration with HomTime

Properties can be benchmarked:

```julia
# Measure property checking time
h = hom(check, my_property)

# Use HomTime metrics
time_median(h)
```

## Integration

Use with:
- **superpowers:compound-feedback-loop** - Test → Benchmark cycle
- **superpowers:testy-stateful-testing** - Stateful property testing
- **superpowers:strict-linting** - Code quality

## Key Principles

1. **Properties are universal** - ∀x: P(x) captures the specification
2. **Generators are functors** - Size → Set
3. **Shrinking is coalgebraic** - cofree on the generator
4. **Evidence is monadic** - structured, composable judgment

## References

- Testy.jl: Property.jl, Gen.jl, Shrink.jl
- Property-based testing: Testy documentation
