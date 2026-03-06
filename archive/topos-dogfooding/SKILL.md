---
name: topos-dogfooding
description: Complete self-referential feedback loop - skills benchmark, test, lint, and visualize themselves using Topos tools
---

# Topos Dogfooding

## Categorical Foundation

This skill implements the **meta-adjunction** - the compound feedback loop applied to itself:

```
Skills ⊣ Topos

Skills: Specification → Code → Tests → Benchmarks
Topos: Benchmarks → Visualization → Insights → Specification

η: Id → Topos∘Skills (self-feedback)
ε: Skills∘Topos → Id (improved skills)
```

Every skill is itself tested, benchmarked, and verified using the same categorical infrastructure it describes. This is **total self-reference** - the Yoneda lemma at work.

## Core Concept: Self-Reference as Fixed Point

```julia
# The dogfooding fixed point:
#
# Skills = Fix(Skills → Topos → Skills)
# 
# Where the functor maps skills through Topos back to improved skills
# This is the least fixed point of the development functor

dogfood(fixpoint) = iterate(
    skill → test(skill) → bench(skill) → visualize(skill) → improve(skill)
)
```

## The Five Pillars

### 1. Self-Benchmarking (HomTime)

Every skill invocation is measurable as a HomSet:

```julia
using HomTime

# Benchmark skill invocation
h = hom(invoke, skill(:testy-property-testing), spec)
# Returns: HomSet of timing morphisms

# Benchmark skill composition
h = hom(compose, L, R)

# Benchmark transformation
h = hom(transform, from::Spec, to::Implementation)
```

#### Skill Benchmark Suite

```julia
# Create benchmark suite for all skills
suite("skills") do s
    for skill_name in all_skills()
        s[skill_name] = hom(invoke, skill(skill_name), test_input)
    end
end

# Detect complexity of skill chains
result = scaling(compose_skill_chain, [1, 5, 10, 50])

# Complexity detection
analysis = complexity(result)
# Returns: O(n), O(log n), etc. for skill composition
```

#### Performance Regression

```julia
# Compare against baseline
comparison = compare(baseline, current)

# Build evidence
evidence = build_evidence(baseline, current)

# Evidence shows:
# - Status: :regression, :improvement, :unchanged
# - Significance: p-value
# - Effect size: practical impact
```

### 2. Self-Testing (Testy)

Every skill is property-tested:

```julia
using Testy

# Property: skill returns valid result
@property "skill_returns_valid_result" begin
    skill ∈ generate(Skill, 10)
    input ∈ generate(Any, 10)
    
    result = invoke(skill, input)
    is_valid(result)
end

# Property: skill composition is associative
@property "skill_composition_associative" begin
    L ∈ generate(Skill, 10)
    R ∈ generate(Skill, 10)
    S ∈ generate(Skill, 10)
    
    # (L ∘ R) ∘ S = L ∘ (R ∘ S)
    compose(compose(L, R), S) == compose(L, compose(R, S))
end

# Property: unit identity
@property "skill_unit_identity" begin
    skill ∈ generate(Skill, 10)
    
    compose(unit, skill) == skill
    compose(skill, unit) == skill
end
```

#### Skill Law Verification

```julia
# Test categorical laws of skill compositions
@property "functor_laws" begin
    F ∈ generate(Skill, 10)
    x ∈ generate(Any, 10)
    
    # Identity
    fmap(id, x) == x
    
    # Composition  
    fmap(f ∘ g, x) == fmap(f, fmap(g, x))
end

@property "monad_laws" begin
    m ∈ generate(Skill, 10)
    f ∈ generate(Skill, 10)
    
    # Left identity
    (return >=> f)(x) == f(x)
    
    # Right identity
    (m >=> return)(x) == m(x)
end
```

#### Property Generation for Skills

```julia
# Generator for skill invocations
@generator function generate_skill_input(skill::Skill)
    # Generate valid inputs for each skill type
    match skill.type begin
        :testy => generate(TestyInput, 10)
        :homtime => generate(HomTimeInput, 10)
        :strict => generate(StrictInput, 10)
        :poly => generate(PolyInput, 10)
    end
end
```

### 3. Self-Linting (Strict)

Every skill is linted for correctness:

```julia
# Lint all skills
violations = Strict.analyze(skills_module)

# Check for:
# - Correct category theory terminology
# - Proper skill structure
# - Convention compliance
```

#### Skill-Specific Lint Rules

```julia
# Rule: Must have categorical framing section
struct HasCategoricalFraming <: Strict.Rule end

function Strict.check(rule::HasCategoricalFraming, node::Expr)
    # Must have "Categorical Framing" section
    has_section(node, "Categorical Framing") || Violation(...)
end

# Rule: Must reference other skills
struct ReferencesOtherSkills <: Strict.Rule end

# Rule: Must use proper terminology
struct CorrectTerminology <: Strict.Rule end
```

#### Terminology Validation

```julia
# Validate categorical terms are correct
valid_terms = [
    "morphism", "functor", "natural transformation",
    "adjunction", "Yoneda", "kernel", "equalizer",
    "coequalizer", "pullback", "pushout",
    "monad", "comonad", "isomorphism"
]

@property "correct_terminology" begin
    skill_doc ∈ generate(SkillDoc, 10)
    
    # All CT terms in doc are valid
    all(term in valid_terms for term in extract_ct_terms(skill_doc))
end
```

### 4. Self-Visualization (Poly)

Every skill result is representable as a polynomial functor and visualizable:

```julia
using Poly

# Skill invocation as polynomial functor
skill_poly = polynomial(invoke_skill)

# Widget for skill performance
performance_widget = Widget(
    get_state = benchmark_results,
    render_view = bar_chart,
    handle_event = drill_down
)

# Compose skill dashboard
dashboard = (
    header("Skill Performance") ⊗
    benchmark_chart ⊗
    regression_alerts ⊗
    improvement_suggestions
)
```

#### Skill Graph Visualization

```julia
# Visualize skill dependencies
skill_graph = invoke_skill_graph()

# Render as string diagram
using Poly.Diagrams
draw(skill_graph)

# Show:
# - Skill invocation chains
# - Composition structure
# - Bottleneck skills
```

### 5. Self-Representability (Yoneda)

Every skill is a representable functor:

```julia
using Theory

# Make skills representable
SkillRep = Yoneda(Hom, Skill)

# Any skill query becomes Hom(Skill, Query) ≅ Result
# This enables universal skill interfaces
```

#### Skill Interface as Natural Transformation

```julia
# Skills as natural transformations between functors
# 
# Input: Query → Skill
# Output: Skill → Result
#
# η: Query → Result is a natural transformation

skill_as_natural_transformation = to_yoneda(Skill, Query)
```

## The Dogfooding Cycle

### Iteration

```julia
function dogfood_iteration(skills::Vector{Skill})
    # L: Build
    improved = improve(skills)
    
    # Test
    test_results = test(improved)
    
    # Benchmark  
    bench_results = bench(improved)
    
    # Analyze
    analysis = analyze(bench_results)
    
    # Visualize
    viz = visualize(analysis)
    
    # R: Feedback
    insights = extract_insights(viz)
    
    # η: Refine
    refined = refine(improved, insights)
    
    return refined
end

# Iterate to fixed point
skills = fixed_point(dogfood_iteration, initial_skills)
```

### Convergence

The iteration converges when:
- No performance regressions
- All categorical laws hold
- No lint violations
- Insights stabilize

## Integration

### With compound-feedback-loop

This skill IS the compound-feedback-loop applied to itself:

```julia
# The meta-adjunction
L = SkillDevelopment  # Build → Test → Benchmark
R = SkillFeedback     # Benchmark → Visualize → Refine

L ⊣ R  # The dogfooding adjunction
```

### With Shared Types

Uses the compound artifact types:

```julia
struct SkillArtifact <: CompoundArtifact
    skill::Skill
    invocation_time::HomSet
    test_results::Vector{PropertyResult}
    lint_violations::Vector{Violation}
    visualization::Widget
end
```

## Self-Benchmarking Templates

### Skill Invocation Benchmark

```julia
# Template for benchmarking a skill
template_skill_benchmark = """
# Skill: {{skill_name}}

## Invocation Benchmark
{{benchmark_results}}

## Composition Benchmark  
{{composition_results}}

## Regression Analysis
{{regression_analysis}}
"""
```

### Performance Metrics

| Metric | Description | Target |
|--------|-------------|--------|
| cold_start | Time to first invocation | < 100ms |
| warm_invoke | Subsequent invocations | < 10ms |
| composition | Skill chain composition | < 50ms |
| memory | Allocation per invocation | < 1MB |

## Self-Testing Templates

### Property Templates

```julia
# Template for skill properties
template_skill_property = """
@property "{{property_name}}" begin
    skill ∈ generate({{SkillType}}, {{size}})
    input ∈ generate({{InputType}}, {{size}})
    
    {{property_body}}
end
"""
```

### Law Verification Templates

```julia
# Template for categorical law verification
template_law_tests = """
# {{LawName}} for {{SkillName}}

@property "{{law_name}}_left_identity" begin
    # Law: id *> f = f
end

@property "{{law_name}}_right_identity" begin
    # Law: f *> id = f
end

@property "{{law_name}}_associativity" begin
    # Law: (f *> g) *> h = f *> (g *> h)
end
"""
```

## Self-Linting Templates

### Skill Lint Rules

```julia
# Required sections in a skill
required_sections = [
    "Overview",
    "Integration", 
    "Categorical Framing"
]

# Required CT terminology
required_terms = [
    "morphism", "functor", "natural transformation"
]
```

## Self-Visualization Templates

### Dashboard Widgets

```julia
# Performance dashboard
performance_dashboard = header("Skills") ⊗
    benchmark_chart ⊗
    regression_list ⊗
    improvement_tips

# Quality dashboard
quality_dashboard = header("Quality") ⊗
    test_coverage ⊗
    law_passes ⊗
    lint_violations
```

## Usage

### Full Dogfooding

```sh
# Run complete dogfooding cycle
yon dogfood

# Run specific pillars
yon dogfood --benchmark
yon dogfood --test
yon dogfood --lint
yon dogfood --visualize
```

### CI Integration

```yaml
# .github/workflows/dogfood.yml
name: Dogfood

on: [push, pull_request]

jobs:
  benchmark:
    runs-on: julia
    steps:
      - uses: actions/checkout
      - run: yon dogfood --benchmark
      
  test:
    needs: benchmark
    runs-on: julia
    steps:
      - run: yon dogfood --test
      
  lint:
    needs: test
    runs-on: julia
    steps:
      - run: yon dogfood --lint
      
  visualize:
    needs: lint
    runs-on: julia
    steps:
      - run: yon dogfood --visualize
```

## The Meta-Adjunction

```
Skills ──► Tests ──► Benchmarks ──► Visualization ──► Insights ──► Skills
   │                                                      │
   └──────────────────── η (self-reference) ──────────────┘

Each cycle improves skills via their own medicine:
- Tests: Property-based verification  
- Benchmarks: Performance measurement
- Lints: Code quality
- Visualization: Insight extraction

This is Yoneda at work: Skills know themselves through their representations.
```

## Key Principles

1. **Self-reference is fixed point** - Skills improve through their own tools
2. **Everything is measurable** - As HomSets via HomTime
3. **Everything is testable** - As properties via Testy
4. **Everything is lintable** - As AST via Strict
5. **Everything is visualizable** - As polynomial functors via Poly
6. **Everything is representable** - Via Yoneda embedding

## Integration with Other Skills

This skill integrates ALL other skills:
- **superpowers:homtime-optimization** - For self-benchmarking
- **superpowers:testy-property-testing** - For self-testing
- **superpowers:strict-linting** - For self-linting
- **superpowers:poly-ui-representation** - For self-visualization
- **superpowers:yoneda-representability** - For self-representability
- **superpowers:compound-feedback-loop** - The meta-adjunction

## References

- Topos dogfooding docs: docs/@TRANSIENT/
- Property testing: Testy.jl
- Benchmarking: HomTime.jl
- Linting: Strict.jl
- Visualization: Poly.jl
