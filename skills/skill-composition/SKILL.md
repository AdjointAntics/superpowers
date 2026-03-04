---
name: skill-composition
description: How skills compose into workflows - the monoidal category of skills with tensor products and sequential composition
---

# Skill Composition

## Categorical Foundation

Skills form a **monoidal category** with multiple composition structures:

```
(Skills, ⊗, Unit)  - Parallel composition (side by side)
(Skills, ▷, Id)     - Sequential composition (pipelined)
(Skills, +, Zero)   - Alternative composition (choice)
(Skills, ×, Terminal) - Product composition (both/all)
```

## The Skill Monoidal Category

### Objects

```julia
"""
    Skill - a reusable capability.
"""
struct Skill
    name::Symbol
    domain::Domain
    inputs::Type
    outputs::Type
    preconditions::Vector{Constraint}
    postconditions::Vector{Constraint}
    quality_profile::Quality
end
```

### Morphisms

```julia
"""
    SkillMorphism - how skills connect.
"""
struct SkillMorphism
    source::Skill
    target::Skill
    connector::Connector      # How to pass data
    transformation::Function # Optional transformation
    guarantees::Vector{Guarantee}
end
```

## Composition Operators

### 1. Tensor (Parallel) ⊗

```julia
"""
    Parallel composition: run both skills.

A ⊗ B means: Run A and B, combine results.

This is the tensor in the monoidal category.
"""
struct ParallelComposition
    left::Skill
    right::Skill
    combiner::Function  # How to combine results
end

# Laws:
# Associativity: (A ⊗ B) ⊗ C = A ⊗ (B ⊗ C)
# Unit: A ⊗ Unit = A

# Example: Compile and test in parallel
compile ⊗ test
```

### 2. Sequential (Pipeline) ▷

```julia
"""
    Sequential composition: output of A feeds into B.

A ▷ B means: Run A, then feed result into B.

This is the ordinary function composition.
"""
struct SequentialComposition
    first::Skill
    second::Skill
    adapter::Function  # Adapt output to input if needed
end

# Laws:
# Associativity: (A ▷ B) ▷ C = A ▷ (B ▷ C)
# Identity: Id ▷ A = A

# Example: analyze ▷ visualize
```

### 3. Alternative (+) 

```julia
"""
    Alternative composition: choose one.

A + B means: Either A or B (choice/branching).

This is the coproduct.
"""
struct AlternativeComposition
    options::Vector{Skill}
    selector::Function  # How to choose
    default::Union{Skill, Nothing}
end

# Laws:
# Associativity: (A + B) + C = A + (B + C)
# Zero: Zero + A = A

# Example: try_fast + try_thorough
```

### 4. Product (×)

```julia
"""
    Product composition: both, all results.

A × B means: Run both, keep all results.

This is the categorical product.
"""
struct ProductComposition
    components::Vector{Skill}
    merger::Function
end

# Laws:
# Projections: π₁(A × B) = A, π₂(A × B) = B
# Universal: any A → B × C factors uniquely

# Example: analyze_metrics × analyze_logs × analyze_traces
```

## The Braiding

```julia
"""
    Braiding: swap parallel skills.

σ: A ⊗ B → B ⊗ A
"""
function braid(composition::ParallelComposition)
    return ParallelComposition(
        left = composition.right,
        right = composition.left,
        combiner = swap_results(composition.combiner)
    )
end
```

## Composition Patterns

### Pattern 1: Pipeline

```julia
"""
    Classic pipeline: a ▷ b ▷ c ▷ d
"""
function pipeline(skills::Vector{Skill})
    return foldr(▷, skills)
end
```

### Pattern 2: Fan-out

```julia
"""
    One input, multiple parallel outputs.
    a ⊗ (b ⊗ c)
"""
function fanout(input::Skill, outputs::Vector{Skill})
    return input ⊗ foldr(⊗, outputs)
end
```

### Pattern 3: Fan-in

```julia
"""
    Multiple inputs, one combined output.
    (a ⊗ b) ⊗ c ▷ combine
"""
function fanin(inputs::Vector{Skill}, combine::Skill)
    return foldr(⊗, inputs) ▷ combine
end
```

### Pattern 4: Conditional

```julia
"""
    Branch based on output.
    a ▷ (b + c)
"""
function conditional(input::Skill, branches::Dict{Condition, Skill})
    return input ▷ AlternativeComposition(
        options = values(branches),
        selector = condition -> branches[condition],
        default = nothing
    )
end
```

### Pattern 5: Retry

```julia
"""
    Retry on failure.
    retry(a) = a + a + a + fallback
"""
function retry(skill::Skill, max_attempts::Int=3, fallback::Skill)
    attempts = [skill for _ in 1:max_attempts]
    return AlternativeComposition(
        options = [attempts..., fallback],
        selector = first_success,
        default = fallback
    )
end
```

### Pattern 6: Timeout

```julia
"""
    Time-bounded execution.
"""
function timeout(skill::Skill, limit::Float64, fallback::Skill)
    return AlternativeComposition(
        options = [timed_skill(skill, limit), fallback],
        selector = first_complete,
        default = fallback
    )
end
```

## Type Preservation

```julia
"""
    Composition must preserve type safety.

This is the functorality condition.
"""
function verify_composable(a::Skill, b::Skill)
    # Output of A must be input of B
    if a.outputs == b.inputs
        return valid()
    elseif can_adapt(a.outputs, b.inputs)
        return valid(adapter = create_adapter(a.outputs, b.inputs))
    else
        return invalid("Type mismatch: $(a.outputs) → $(b.inputs)")
    end
end
```

## Quality Aggregation

```julia
"""
    Composition affects quality.

The quality of A ⊗ B is a function of both qualities.
"""
function compose_quality(qa::Quality, qb::Quality, op::CompositionOperator)
    match op begin
        :⊗ => min(qa, qb)           # Parallel: limited by weakest
        :▷ => min(qa, qb)           # Sequential: limited by worst
        :+ => weighted_mean(qa, qb)  # Alternative: expected value
        :× => product(qa, qb)        # Product: combined quality
    end
end
```

## The Composition Category

### Identity

```julia
"""
    Identity skill: passes through unchanged.
"""
identity_skill = Skill(
    name = :identity,
    domain = :universal,
    inputs = :any,
    outputs = :any,
    preconditions = [],
    postconditions = [],
    quality = Quality(1.0)
)
```

### Zero Object

```julia
"""
    Zero skill: always fails immediately.
"""
zero_skill = Skill(
    name = :zero,
    domain = :nothing,
    inputs = :nothing,
    outputs = :nothing,
    preconditions = [],
    postconditions = [],
    quality = Quality(0.0)
)
```

## Integration with Meta-Reasoning

```julia
# Meta-reasoning chooses composition
function choose_composition(problem, available_skills)
    if problem.can_parallelize
        return parallel_composition(problem.skills)
    elseif problem.has_dependencies
        return sequential_composition(problem.skills)
    elseif problem.has_alternatives
        return alternative_composition(problem.skills)
    else
        return single_skill(problem.skill)
    end
end
```

## Integration with Topos

### With Poly

```julia
# Skill composition visualized as string diagram
using Poly.Diagrams

diagram = (skill_a ⊗ skill_b) ▷ skill_c
draw(diagram)
```

## Key Principles

1. **Multiple compositions** - ⊗, ▷, +, × for different needs
2. **Type safety** - Verify composability
3. **Quality aggregation** - Track quality through composition
4. **Patterns are composable** - Combine patterns
5. **Monoidal laws** - Associativity, identity preserved

## Integration

This skill integrates with:
- **superpowers:skill-orchestration** - Uses composition for pipelines
- **superpowers:skill-meta-reasoning** - Chooses composition strategy
- **superpowers:compound-feedback-loop** - Composition is the workflow
- **superpowers:poly-widget-composition** - Similar monoidal structure

## References

- Monoidal categories: Category theory
- String diagrams: Physics/comp science
- Pipeline patterns: Software engineering
