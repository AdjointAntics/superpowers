---
name: skill-graceful-degradation
description: Operating when optimal tools are unavailable - the degradation functor that preserves core functionality
---

# Skill Graceful Degradation

## Categorical Foundation

This implements the **degradation functor** - when optimal paths are unavailable, find the best available while preserving core functionality:

```julia
# D: Optimal → Degraded
# 
# D preserves the essential structure:
# D(f ∘ g) = D(f) ∘ D(g)
#
# Core functionality is preserved even as quality degrades
```

## The Degradation Lattice

```
Best Possible
     │
     ▼  (acceptable degradation)
Acceptable
     │
     ▼  (minimal viable)
Minimum Viable
     │
     ▼  (emergency only)
Emergency
     │
     ▼  (no skill available)
None
```

## Degradation Levels

### Level 0: Optimal

```julia
"""
    Optimal execution - everything available.

This is the identity functor.
"""
struct Optimal
    skill::Skill
    quality::Quality     # 1.0
    resources::Resources
end
```

### Level 1: Acceptable

```julia
"""
    Acceptable - some degradation but still good.

The equivalence class of "good enough".
"""
struct Acceptable
    skill::Skill
    alternative_skills::Vector{Skill}
    quality_degradation::Float64    # e.g., 0.9
    functionality_preserved::Set{Symbol}
end
```

### Level 2: Minimum Viable

```julia
"""
    Minimum Viable - core functionality only.

The smallest subset that still solves the problem.
"""
struct MinimumViable
    skill::Skill
    core_features::Set{Symbol}
    missing_features::Set{Symbol}
    workaround_available::Bool
end
```

### Level 3: Emergency

```julia
"""
    Emergency - last resort.

Something is better than nothing.
"""
struct Emergency
    fallback::Any               # Could be manual, could be guess
    confidence::Float64         # Very low
    risk::Float64            # Very high
    documentation::String     # How to recover
end
```

### Level 4: None

```julia
"""
    None - cannot proceed.

The initial object - no path forward.
"""
struct None
    reason::String
    blocked_by::Constraint
    alternatives_tried::Vector{Attempt}
end
```

## The Degradation Functor

```julia
"""
    The degradation functor D: Optimal → Available
    
    Maps the ideal execution path to what's actually possible.
"""
struct DegradationFunctor
    constraints::Vector{Constraint}
    fallback_map::Dict{Skill, Vector{Skill}}
end

# Apply degradation
function apply_degradation(skill::Skill, resources::Resources, fun::DegradationFunctor)
    if can_execute(skill, resources)
        return Optimal(skill, Quality(1.0), resources)
    elseif has_acceptable_fallback(skill, fun.fallback_map)
        return Acceptable(skill, find_fallbacks(skill), Quality(0.9))
    elseif has_minimum_viable(skill, fun.fallback_map)
        return MinimumViable(skill, find_core(skill), find_missing(skill))
    elseif has_emergency(skill, fun.fallback_map)
        return Emergency(skill, Quality(0.1))
    else
        return None("No path forward")
    end
end
```

## Resource Constraints

### Time Degradation

```julia
"""
    TimeConstraint - not enough time for optimal execution.
"""
struct TimeDegradation
    optimal_time::Float64
    available_time::Float64
    strategy::TimeStrategy
end

function handle_time_constraint(available::Float64, optimal::Float64)
    if available >= optimal
        return OptimalTime()
    elseif available >= optimal * 0.8
        return AcceptableTime(optimize=false)
    elseif available >= optimal * 0.5
        return MinimumTime(skip_validation=true)
    else
        return EmergencyTime(estimate_only=true)
    end
end
```

### Knowledge Degradation

```julia
"""
    KnowledgeConstraint - not enough context/knowledge.
"""
struct KnowledgeDegradation
    required_knowledge::Set{Proposition}
    available_knowledge::Set{Proposition}
    gap::Set{Proposition}
end

function handle_knowledge_constraint(required, available)
    gap = setdiff(required, available)
    
    if isempty(gap)
        return FullKnowledge()
    elseif can_acquire_quickly(gap)
        return PartialKnowledge(acquire=true)
    elseif can_approximate(gap)
        return ApproximateKnowledge()
    else
        return UnknownKnowledge(gap)
    end
end
```

### Tool Degradation

```julia
"""
    ToolConstraint - optimal tools unavailable.
"""
struct ToolDegradation
    optimal_tool::Tool
    available_tools::Vector{Tool}
    substitution_quality::Float64
end

function handle_tool_constraint(optimal, available)
    if optimal ∈ available
        return OptimalTool(optimal)
    else
        # Find best substitute
        substitute = best_substitute(optimal, available)
        quality = compute_substitution_quality(optimal, substitute)
        
        return ToolDegradation(optimal, [substitute], quality)
    end
end
```

## The Preservation Principle

```julia
"""
    CoreFunctionality must be preserved through degradation.

This is an invariant: D(skill).core ⊆ skill.core
"""
function verify_preservation(degraded::DegradedExecution)
    # Core features must be in degraded version
    for core in degraded.original.core_features
        if core ∉ degraded.current.core_features
            return false
        end
    end
    return true
end
```

## Fallback Strategies

### Strategy 1: Parallel Fallback

```julia
"""
    Try multiple skills in parallel, use first success.
"""
function parallel_fallback(skills::Vector{Skill}, context)
    results = @parallel execute(skill, context) for skill in skills
    
    # Return first success
    first_success = findfirst(r -> r.success, results)
    return results[first_success]
end
```

### Strategy 2: Sequential Fallback

```julia
"""
    Try skills one by one, accumulating partial results.
"""
function sequential_fallback(skills::Vector{Skill}, context)
    accumulated = empty_accumulator()
    
    for skill in skills
        result = execute(skill, context)
        accumulated = merge(accumulated, result)
        
        if is_complete(accumulated)
            return accumulated
        end
    end
    
    return accumulated  # Best effort
end
```

### Strategy 3: Approximate Fallback

```julia
"""
    Use approximate version when exact unavailable.
"""
function approximate_fallback(skill::Skill, context, approximation)
    # Execute skill with approximation
    result = execute(skill, context; approximation=approximation)
    
    # Quantify quality loss
    quality_loss = compute_quality_diff(skill, result, exact_result)
    
    return result, quality_loss
end
```

## Recovery Paths

```julia
"""
    RecoveryPath - how to get back to optimal.

The return functor: Available → Optimal
"""
struct RecoveryPath
    current_level::DegradationLevel
    target_level::DegradationLevel
    steps::Vector{RecoveryStep}
    estimated_time::Float64
end

# Plan recovery from degraded to optimal
function plan_recovery(current::DegradedExecution)
    path = RecoveryPath[]
    
    # Level by level
    while current.level > Optimal
        next_step = find_recovery_step(current)
        push!(path, next_step)
        current = apply_step(current, next_step)
    end
    
    return path
end
```

## Integration with Uncertainty

```julia
# Degradation is informed by uncertainty
function degrade_appropriately(skill, context, uncertainty)
    # If very uncertain, degrade more aggressively
    if uncertainty.probability < 0.3
        return aggressive_degradation(skill)
    # If moderately uncertain, moderate degradation  
    elseif uncertainty.probability < 0.7
        return moderate_degradation(skill)
    # If certain, try optimal first
    else
        return try_optimal(skill)
    end
end
```

## Integration with Self-Awareness

```julia
# Use self-awareness to know limits
function graceful_degrade(skill, context, self_state)
    # What's available?
    resources = self_state.resources
    
    # What's my confidence?
    confidence = self_state.confidence
    
    # Degrade based on both
    return apply_degradation(
        skill, 
        resources,
        confidence_to_constraints(confidence)
    )
end
```

## Key Principles

1. **Preserve core** - Minimum viable is non-negotiable
2. **Explicit degradation** - Know what you're giving up
3. **Plan recovery** - Always have path back to optimal
4. **Graceful paths** - Multiple fallback strategies
5. **Transparent** - User knows quality level

## Integration

This skill integrates with:
- **superpowers:skill-self-awareness** - Knows resource constraints
- **superpowers:skill-uncertainty** - Informed by confidence
- **superpowers:skill-meta-reasoning** - Selection includes degradation options

## References

- Degradation: Fault tolerance
- Fallback strategies: Resilience patterns
- Recovery: System design
