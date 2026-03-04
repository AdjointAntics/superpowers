---
name: strict-linting
description: Functorial AST analysis, catamorphic code folding, and rule natural transformations using Strict
---

# Strict Linting

## Categorical Foundation

Julia code is an **initial algebra** for the expression functor Σ:
- **Expr** = constant + symbol + quote + ... | **let** | **if** | **for** | **function** | ...

Linting is a **functor** L: Expr → Violation from the expression category to the violation category.

A complete analysis is a **catamorphism** - folding over the AST tree, applying lint rules at each node.

## Core Concept: AST as Initial Algebra

```julia
using Strict

# Julia expressions form the initial algebra for the functor:
# 
# F(Expr) = const + symbol + call + if + for + function + ...
# 
# Expr ≅ F(Expr)
# 
# This is the fixed point - the least fixed point of F
```

## Analysis as Catamorphism

```julia
# Analysis folds over the AST - this is a catamorphism
# 
# cata(algebra) :: Expr → Violations
# 
# where algebra :: F(Violations) → Violations

result = Strict.analyze(code)
```

### The Algebra

```julia
# The folding algebra combines child violations:
# - Constant node: empty violations
# - Call node: violations from children + rule checks
# - Function: violations from children + signature checks
```

## Rules as Functors

Each lint rule is a **functor** from AST to violations:

```julia
# Rule R: Expr → Violation
# 
# R(const(x)) = []
# R(call(f, args)) = check_rule(f, args) ∪ R(args)
```

### Rule Categories

| Category | Functor Domain | Description |
|----------|---------------|-------------|
| Warning | AST → Warnings | Potential issues |
| Readability | AST → Readability | Style violations |
| Performance | AST → Performance | Efficiency issues |
| Correctness | AST → Correctness | Semantic errors |

### Built-in Rules

```julia
# Warning rules
:unused_assignment
:shadowed_variable  
:unreachable_code

# Performance rules
:allocation_in_loop
:constant_condition
:val_with_runtime_arg

# Readability rules
:complex_boolean
:no_single_letter_variables
:needless_else
```

## Running Linting

### CLI Usage

```sh
# Lint all packages
yon lint

# Lint specific package
yon lint Algebra

# Auto-fix issues
yon fix
```

### Programmatic Usage

```julia
using Strict

# Analyze single expression
violations = analyze(:(x + y))

# Analyze file
violations = analyze_file("src/MyModule.jl")

# Analyze module
violations = analyze_module(MyModule)
```

### Rule Configuration

```julia
# Enable/disable rules
config = StrictConfig()
config.rules[:unused_assignment] = true
config.rules[:complex_boolean] = false

# Run with config
result = analyze(code; config=config)
```

## The Violation Type

```julia
# Violation fields:
# - rule: Symbol - rule identifier
# - node: Expr - AST node causing violation
# - message: String - human-readable description
# - severity: :error/:warning/:info
# - line, column: location
```

## Rule Composition

### Composing Rules

Rules compose via **natural transformation**:

```julia
# η: R₁ → R₂ between rule functors
# Preserves composition: η(F ∘ G) = η(F) ∘ η(G)

# Combine rules as coproduct
all_rules = rule₁ ⊕ rule₂ ⊕ rule₃
```

### Custom Composition

```julia
# Product of rules - all must pass
strict_rules = warning_rules ⊗ performance_rules

# Sum of rules - any triggers
permissive_rules = warning_rules ⊕ performance_rules
```

## AST Analysis Details

### Node Types

```julia
# Julia AST node types:
:const   # Constants
:symbol  # Variables
:call    # Function calls
:do      # Do-blocks
:for     # For loops
:while   # While loops
:function # Function definitions
:macro   # Macro definitions
:if      # Conditionals
:let     # Let-blocks
:quote   # Quoted expressions
```

### Traversal

```julia
# Pre-order traversal (catamorphism)
pre_order(ast) do node
    # Visit each node
end

# Post-order traversal (anamorphism)  
post_order(ast) do node
    # Visit after children
end
```

## Functorial Analysis

### Expression Functor

The Julia AST follows the **expression functor**:

```julia
# F-Expression = 
#   | Const(c) 
#   | Sym(s) 
#   | Call(f, args) 
#   | If(cond, then, else) 
#   | For(var, iter, body) 
#   | Function(args, body)
#   | ...
```

### Analysis Functor

```julia
# Analysis A: F(Expr) → Violations
# 
# A(Const(c)) = []
# A(Sym(s)) = check_symbol(s)
# A(Call(f, args)) = A(args) ∪ check_call(f, args)
# ...
```

## Integration with HomTime

Lint performance is measurable:

```julia
# Measure linting time
h = hom(Strict.analyze, large_code)

# Benchmark rules
suite("lint_bench") do s
    s[:full] = hom(analyze, code)
    s[:fast] = hom(analyze_fast, code)
end
```

## Integration

Use with:
- **superpowers:compound-feedback-loop** - Full quality pipeline
- **superpowers:homtime-optimization** - Performance measurement

## Key Principles

1. **AST is initial algebra** - least fixed point of expression functor
2. **Analysis is catamorphism** - fold over the tree
3. **Rules are functors** - map AST to violations
4. **Composition is natural** - natural transformations between rules

## References

- Strict.jl: Strict.jl source
- AST analysis: functor/pattern.jl
- Rules: rules/ directory
