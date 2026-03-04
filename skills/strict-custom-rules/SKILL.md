---
name: strict-custom-rules
description: Domain-specific lint rules via Grothendieck construction, morphism sections, and composite functors using Strict
---

# Strict Custom Rules

## Categorical Foundation

A custom lint rule is a **section** of the linting functor - a morphism that picks out a specific subclass of violations. Rules compose via the **Grothendieck construction** - building product rules from simpler components.

## Core Concept: Rule as Section

```julia
using Strict

# A rule R is a section of the linting functor L
# R: Violation → Code such that L ∘ R = Id
# 
# i.e., R picks out a specific type of violation

struct MyRule <: Strict.Rule
    # Rule configuration
end
```

## Creating Custom Rules

### Basic Rule Structure

```julia
using Strict

# Define a custom rule
struct NoGlobals <: Strict.Rule
    allow_readonly::Bool
end

# Check the rule
function Strict.check(rule::NoGlobals, node::Expr)
    violations = Violation[]
    
    # Find global references
    for node in traverse(node)
        if is_global(node)
            push!(violations, Violation(
                rule=:no_globals,
                node=node,
                message="Global variable reference: $(node)",
                severity=:warning
            ))
        end
    end
    
    return violations
end
```

### Rule Metadata

```julia
# Register rule metadata
function Strict.rule_name(::Type{NoGlobals})
    :no_globals
end

function Strict.category(::Type{NoGlobals})
    :warning
end

function Strict.description(::Type{NoGlobals})
    "Disallow global variable references"
end
```

## The Grothendieck Construction

### Product Rules

Rules compose via the Grothendieck construction:

```julia
# Given rules R₁ and R₂, the product rule:
# R = R₁ × R₂
# 
# Checks both rules and combines violations

combined = @rule NoGlobals × NoType piracy × NoShadowing
```

### Sum Rules

```julia
# Sum: either rule triggers
permissive = @rule NoGlobals + NoType piracy

# Strict: all must pass  
strict = @rule NoGlobals × NoShadowing
```

## Rule Morphisms

### Sections

A rule is a **section** of the lint functor:

```julia
# R: Violation → Code
# L ∘ R = Id(Violation)
#
# R is a right inverse to L

my_section = MyRule(config)
```

### Natural Transformations

Transform between rules:

```julia
# η: R₁ → R₂
# A natural transformation between rule functors
# 
# L(η) = Id (preserves the linting structure)

strict_to_permissive = convert_rule(MyStrictRule, MyPermissiveRule)
```

## Composing Rules

### Rule Products

```julia
# Create a rule product
strict_config = @rule no_globals × no_piracy × no_shadowing
```

### Rule Precedence

```julia
# Precedence: earlier rules can suppress later ones
config = @rule precedence(
    critical_rule,   # Runs first, can suppress
    warning_rule,   # Runs second
    style_rule      # Runs last
)
```

## Advanced Patterns

### Dependent Rules

```julia
# Rules can depend on configuration
struct DependedRule <: Strict.Rule
    config::DependentConfig
end

# Check can use configuration
function Strict.check(rule::DependedRule, node::Expr)
    if rule.config.enabled
        # Check rule
    else
        # No violations
    end
end
```

### State Rules

```julia
# Rules can maintain state across nodes
struct StatefulRule <: Strict.Rule
    seen::Set{Symbol}
end

function Strict.check!(rule::StatefulRule, node::Expr)
    # Update state
    push!(rule.seen, get_symbol(node))
    
    # Check using state
    check_with_state(rule, node)
end
```

## Rule Registration

### Global Registration

```julia
# Register globally
Strict.register_rule!(NoGlobals)
```

### Project Registration

```julia
# Register for project
Strict.register_rule!(NoGlobals; scope=:project)
```

## Integration

Use with:
- **superpowers:strict-linting** - Base linting
- **superpowers:compound-feedback-loop** - Quality pipeline

## Key Principles

1. **Rules are sections** - Right inverse of linting functor
2. **Composition is Grothendieck** - Products and sums
3. **Natural transformations** convert between rule styles

## References

- Strict.jl: rules/ directory
- Rule types: Strict/types.jl
