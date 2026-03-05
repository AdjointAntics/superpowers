---
name: skill-bundling
description: Bundle, version, and distribute collections of skills as cohesive units with dependency resolution
---

# Skill Bundling

## Categorical Foundation

Skill bundling forms a **monoidal category** where:
- **Objects**: Skill bundles (collections of skills)
- **Morphisms**: Bundle transformations (add, remove, modify skills)
- **Monoidal product** ⊗: Combining bundles (union)
- **Monoidal sum** +: Alternative bundles (choice)
- **Tensor** ▷: Sequencing bundles (pipeline)

```
Bundle ⊗ Bundle → Bundle    # Union
Bundle + Bundle → Bundle    # Choice  
Bundle ▷ Bundle → Bundle    # Sequence
```

## Bundle Structure

### Bundle
# bundle.yaml Manifest

```yaml
name: topos-development
version: 1.0.0
description: Complete Topos monorepo development workflow

skills:
  - topos-package-development
  - topos-testing
  - topos-benchmarking
  - topos-linting
  - topos-poly

dependencies:
  topos-development: ^1.0.0

composition:
  default: [topos-package-development, topos-testing, topos-benchmarking]
  full: [topos-package-development, topos-testing, topos-benchmarking, topos-linting, topos-poly]
  minimal: [topos-package-development]
```

### Bundle Types

```julia
"""
    SkillBundle

A collection of skills with metadata and composition rules.
"""
struct SkillBundle
    name::Symbol
    version::VersionNumber
    skills::Vector{Skill}
    dependencies::Dict{Symbol, VersionSpec}
    composition::Dict{Symbol, Vector{Skill}}
    metadata::Dict{Symbol, Any}
end
```

## Operations

### Bundle Creation

```julia
"""
    create_bundle(name::Symbol; skills, dependencies, composition)

Create a new skill bundle.
"""
function create_bundle(name::Symbol; skills, dependencies=Dict(), composition=Dict())
    bundle = SkillBundle(
        name=name,
        version=v"1.0.0",
        skills=skills,
        dependencies=dependencies,
        composition=composition,
        metadata=Dict()
    )
    return bundle
end
```

### Bundle Composition

```julia
"""
    compose(bundle1::SkillBundle, bundle2::SkillBundle)

Monoidal product: combine two bundles (union of skills).
"""
function compose(bundle1::SkillBundle, bundle2::SkillBundle)
    combined_skills = union(bundle1.skills, bundle2.skills)
    return SkillBundle(
        name=Symbol("$(bundle1.name)_$(bundle2.name)"),
        version=v"1.0.0",
        skills=combined_skills,
        merge(bundle1.dependencies, bundle2.dependencies),
        merge(bundle1.composition, bundle2.composition),
        metadata=Dict()
    )
end

"""
    alternate(bundle1::SkillBundle, bundle2::SkillBundle)

Monoidal sum: alternative bundles (choose one).
"""
function alternate(bundle1::SkillBundle, bundle2::SkillBundle)
    return SkillBundle(
        name=Symbol("either_$(bundle1.name)_$(bundle2.name)"),
        version=v"1.0.0",
        skills=union(bundle1.skills, bundle2.skills),
        Dict(),  # No new deps
        Dict(:choice1 => bundle1.skills, :choice2 => bundle2.skills),
        Dict()
    )
end

"""
    sequence(bundle1::SkillBundle, bundle2::SkillBundle)

Tensor: pipeline composition (bundle1 then bundle2).
"""
function sequence(bundle1::SkillBundle, bundle2::SkillBundle)
    return SkillBundle(
        name=Symbol("$(bundle1.name)_then_$(bundle2.name)"),
        version=v"1.0.0",
        union(bundle1.skills, bundle2.skills),
        merge(bundle1.dependencies, bundle2.dependencies),
        Dict(:pipeline => vcat(bundle1.skills, bundle2.skills)),
        Dict()
    )
end
```

### Bundle Resolution

```julia
"""
    resolve_dependencies(bundle::SkillBundle, registry::SkillRegistry)

Resolve dependencies and return complete skill set.
"""
function resolve_dependencies(bundle::SkillRegistry)
    resolved = Dict{Symbol, Skill}()
    
    for (name, version_spec) in bundle.dependencies
        resolved[name] = find_in_registry(registry, name, version_spec)
    end
    
    for skill in bundle.skills
        resolved[skill.name] = skill
    end
    
    return resolved
end
```

## Version Management

### Semantic Versioning

```julia
"""
    bump_version(bundle::SkillBundle, level::Symbol)

Bump version: :patch, :minor, or :major
"""
function bump_version(bundle::SkillBundle, level::Symbol)
    v = bundle.version
    new_version = if level == :patch
        VersionNumber(v.major, v.minor, v.patch + 1)
    elseif level == :minor
        VersionNumber(v.major, v.minor + 1, 0)
    elseif level == :major
        VersionNumber(v.major + 1, 0, 0)
    else
        error("Invalid level: $level")
    end
    
    return @set bundle.version = new_version
end
```

### Compatibility

```julia
"""
    is_compatible(bundle1::SkillBundle, bundle2::SkillBundle)

Check if two bundles are compatible (no conflicting versions).
"""
function is_compatible(bundle1::SkillBundle, bundle2::SkillBundle)
    for (name, v1) in bundle1.dependencies
        if haskey(bundle2.dependencies, name)
            v2 = bundle2.dependencies[name]
            if !compatible(v1, v2)
                return false
            end
        end
    end
    return true
end
```

## Registry Operations

### Publishing

```julia
"""
    publish(bundle::SkillBundle, registry::SkillRegistry)

Publish bundle to registry.
"""
function publish(bundle::SkillBundle, registry::SkillRegistry)
    if haskey(registry, bundle.name)
        existing = registry[bundle.name]
        if bundle.version <= existing.version
            error("Version $(bundle.version) is not newer than existing $(existing.version)")
        end
    end
    
    return register(registry, bundle)
end
```

### Installation

```julia
"""
    install(name::Symbol, version::VersionSpec, registry::SkillRegistry)

Install a bundle from registry.
"""
function install(name::Symbol, version::VersionSpec, registry::SkillRegistry)
    bundle = resolve(registry, name, version)
    skills = resolve_dependencies(bundle, registry)
    return skills
end
```

## Predefined Bundles

### ASI Core

```yaml
name: asi-core
version: 1.0.0
description: Core ASI capabilities - self-awareness, meta-reasoning, evolution

skills:
  - skill-self-awareness
  - skill-meta-reasoning
  - skill-uncertainty
  - skill-graceful-degradation
  - skill-composition
  - skill-orchestration
  - skill-evolution
  - skill-value-alignment
```

### Development Workflow

```yaml
name: dev-workflow
version: 1.0.0
description: Complete development workflow from spec to deployed code

skills:
  - topos-package-development
  - topos-testing
  - topos-benchmarking
  - topos-linting

composition:
  full: [topos-package-development, topos-testing, topos-benchmarking, topos-linting]
```

### Topos Ecosystem

```yaml
name: topos-ecosystem
version: 1.0.0
description: All Topos-related skills

skills:
  - topos-yon-cli
  - topos-testing
  - topos-package-development
  - topos-algebra
  - topos-theory-foundations
  - topos-poly
  - topos-freeschema
  - topos-benchmarking
  - topos-linting
  - topos-categorical-reframing
  - topos-dogfooding
```

### Compound Loop

```yaml
name: compound-loop
version: 1.0.0
description: Full compound feedback loop

skills:
  - compound-feedback-loop
  - topos-package-development
  - testy-property-testing
  - homtime-optimization
  - homtime-ci-integration
  - poly-ui-representation
  - poly-widget-composition
  - yoneda-representability

composition:
  default: [topos-package-development, testy-property-testing, homtime-optimization, poly-ui-representation]
```

## CLI Interface

```sh
# Create a new bundle
yon bundle create mybundle --skills skill1,skill2

# List available bundles
yon bundle list

# Install a bundle
yon bundle install topos-ecosystem

# Publish a bundle
yon bundle publish ./bundle.yaml

# Compose bundles
yon bundle compose bundle1.yaml bundle2.yaml --mode union
yon bundle compose bundle1.yaml bundle2.yaml --mode choice
yon bundle compose bundle1.yaml bundle2.yaml --mode pipeline
```

## Bundle Validation

```julia
"""
    validate(bundle::SkillBundle)

Validate bundle structure and dependencies.
"""
function validate(bundle::SkillBundle)
    errors = []
    
    if isempty(bundle.skills)
        push!(errors, "Bundle must have at least one skill")
    end
    
    for skill in bundle.skills
        if !isdefined(skill)
            push!(errors, "Skill $(skill.name) not found")
        end
    end
    
    return isempty(errors) ? Valid(bundle) : Invalid(errors)
end
```

## Integration

This skill integrates with:
- **superpowers:skill-composition** - Bundle composition operators
- **superpowers:skill-evolution** - Version management
- **superpowers:compound-feedback-loop** - Using bundles in the loop
- **superpowers:topos-package-development** - Package structure

## Key Principles

1. **Monoidal structure** - Bundles combine via ⊗, +, ▷
2. **Semantic versioning** - Clear compatibility rules
3. **Dependency resolution** - Automatic transitive deps
4. **Composition patterns** - Union, choice, pipeline modes
5. **Registry publication** - Share bundles with others
