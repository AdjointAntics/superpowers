---
name: skill-value-alignment
description: Ensuring skills produce aligned outcomes, preserve values, and maintain safety constraints - the safety functor over skill execution
---

# Skill Value Alignment

## Categorical Foundation

Value alignment implements the **safety functor** - ensuring skill outputs satisfy value constraints:

```julia
# A: Skill → AlignedSkill
#
# A(f) = f' where f' satisfies value_constraints(f)
#
# The equalizer: aligned_outputs ⊆ value_preserving_outputs
```

## The Value Hierarchy

### Level 1: Core Values

```julia
"""
    CoreValues - non-negotiable values.
"""
struct CoreValues
    safety::Value  # Do no harm
    truth::Value   # Be accurate
    autonomy::Value # Respect user agency
    privacy::Value  # Protect data
    fairness::Value # Be unbiased
end

# These cannot be compromised
function verify_core(values, outcome)
    for core in [:safety, :truth, :autonomy, :privacy, :fairness]
        if violates(outcome, values.core)
            return false
        end
    end
    return true
end
```

### Level 2: Operational Values

```julia
"""
    OperationalValues - how we work.
"""
struct OperationalValues
    efficiency::Value
    clarity::Value
    collaboration::Value
    reliability::Value
end
```

### Level 3: Domain Values

```julia
"""
    DomainValues - context-specific values.
"""
struct DomainValues
    domain::Symbol
    values::Dict{Symbol, Value}
end

# Domain-specific: security values for security domain
# coding values for coding domain, etc.
```

## The Alignment Functor

```julia
"""
    AlignmentFunctor - maps skills to aligned versions.
"""
struct AlignmentFunctor
    value_constraints::Vector{ValueConstraint}
    safety_checks::Vector{SafetyCheck}
    ethics_checks::Vector{EthicsCheck}
end

# Apply alignment to a skill
function align(skill::Skill, functor::AlignmentFunctor)
    # Check preconditions
    if !satisfies_constraints(skill.preconditions, functor.value_constraints)
        return aligned_skill(skill, add_constraints!)
    end
    
    # Wrap execution with checks
    aligned = wrap_with_checks(skill, functor.safety_checks)
    
    # Verify postconditions
    if !satisfies_constraints(aligned.postconditions, functor.value_constraints)
        return constrain_output(aligned, functor.value_constraints)
    end
    
    return aligned
end
```

## Safety Constraints

### Hard Constraints

```julia
"""
    HardConstraint - cannot be violated.
"""
struct HardConstraint
    predicate::Function  # Must be true
    violation_action::Action  # What to do if violated
end

# Example: Never output PII
hard_constraint = HardConstraint(
    predicate = output -> !contains_pii(output),
    violation_action = :redact_and_warn
)
```

### Soft Constraints

```julia
"""
    SoftConstraint - should be satisfied, with reason if not.
"""
struct SoftConstraint
    predicate::Function
    target_satisfaction::Float64  # 95%
    violation_gracefully::Function
end
```

## The Verification Pipeline

### Pre-Execution Check

```julia
"""
    PreAlign - verify skill is alignable.
"""
function pre_align(skill, context, values)
    # Check if skill can satisfy core values
    for core in core_values(values)
        if !can_satisfy(skill, core)
            return AlignmentResult(
                status = :blocked,
                reason = "Cannot satisfy core value: $core",
                alternative = find_alternative(skill, core)
            )
        end
    end
    
    return AlignmentResult(status = :proceed)
end
```

### During Execution Monitor

```julia
"""
    ExecutionMonitor - watch for value violations.
"""
struct Monitor
    constraints::Vector{Constraint}
    alerts::Channel{Alert}
end

function monitor_execution(skill, context, monitor)
    while executing
        for constraint in monitor.constraints
            if !check(constraint, current_output)
                send(monitor.alerts, Alert(
                    severity = constraint.severity,
                    message = "Value constraint violated: $constraint",
                    current_value = current_output,
                    required = constraint.predicate
                ))
                
                if constraint.severity == :critical
                    return halt_execution()
                end
            end
        end
    end
end
```

### Post-Execution Audit

```julia
"""
    PostAlign - audit alignment.
"""
function post_align(outcome, values, metrics)
    violations = []
    
    for value in all_values(values)
        alignment = measure_alignment(outcome, value)
        if alignment.score < value.threshold
            push!(violations, ValueViolation(
                value = value,
                alignment = alignment.score,
                evidence = alignment.evidence
            ))
        end
    end
    
    return AuditResult(
        violations = violations,
        overall_score = compute_overall(violations),
        recommendations = generate_recommendations(violations)
    )
end
```

## Ethics Checking

```julia
"""
    EthicsChecker - evaluate ethical implications.
"""
struct EthicsChecker
    fairness_evaluator::FairnessEvaluator
    harm_evaluator::HarmEvaluator
    transparency_evaluator::TransparencyEvaluator
end

function check_ethics(skill, context, checker)
    results = []
    
    # Fairness
    fairness = checker.fairness_evaluator(skill, context)
    push!(results, fairness)
    
    # Harm potential
    harm = checker.harm_evaluator(skill, context)
    push!(results, harm)
    
    # Transparency
    transparency = checker.transparency_evaluator(skill, context)
    push!(results, transparency)
    
    return EthicsResult(results)
end
```

## Value Preservation

```julia
"""
    ValuePreservation - ensure values maintained through composition.
"""
function preserve_values(composition::SkillComposition, values)
    for skill in composition.skills
        # Check each skill preserves values
        if !preserves(skill, values)
            return ValuePreservationResult(
                status = :failed,
                violating_skill = skill,
                violated_values = find_violated(skill, values)
            )
        end
    end
    
    # Check composition preserves values
    if !composition_preserves(composition, values)
        return ValuePreservationResult(
            status = :composition_failed,
            reason = "Combined behavior violates values"
        )
    end
    
    return ValuePreservationResult(status = :passed)
end
```

## Side Effect Analysis

```julia
"""
    SideEffectAnalysis - what else does the skill affect?
"""
struct SideEffects
    direct_outputs::Vector{Output}
    side_outputs::Vector{Output}  # Not the primary output
    external_effects::Vector{Effect}  # Outside the system
end

function analyze_side_effects(skill, context)
    # Execute and observe all effects
    execution = instrumented_execute(skill, context)
    
    return SideEffects(
        direct_outputs = execution.primary,
        side_outputs = execution.secondary,
        external_effects = execution.external
    )
end
```

## Integration with Self-Awareness

```julia
# Use self-awareness to understand value implications
function align_with_self_awareness(skill, context, self_state)
    # What values does the agent hold?
    agent_values = self_state.values
    
    # What values does the skill require?
    skill_values = required_values(skill)
    
    # Check alignment
    alignment = check_alignment(agent_values, skill_values)
    
    if alignment.score < threshold
        return AlignmentResult(
            status = :misaligned,
            reason = "Skill conflicts with agent values",
            resolution = resolve_conflict(agent_values, skill_values)
        )
    end
    
    return align(skill, alignment)
end
```

## The Alignment Monad

```julia
"""
    Alignment as a monad - chain aligned operations.
"""
struct AlignmentMonad
    value_context::ValueContext
    constraints::Vector{Constraint}
    aligned_result::Union{Result, Nothing}
end

# Bind: chain aligned operations
function (>>=)(monad, next_skill)
    # Ensure next skill is aligned with value context
    aligned_next = align(next_skill, monad.value_context)
    
    return AlignmentMonad(
        value_context = monad.value_context,
        constraints = monad.constraints,
        aligned_result = execute(aligned_next)
    )
end
```

## Integration with Other Skills

### With skill-uncertainty

```julia
# Uncertainty about alignment
function uncertain_alignment(skill, context)
    alignment_possibilities = sample_alignment(skill, context, 100)
    
    # Check worst case
    worst_case = minimum(alignment_possibilities)
    
    if worst_case < critical_threshold
        return :block
    elseif worst_case < warning_threshold
        return :warn
    else
        return :allow
    end
end
```

### With skill-graceful-degradation

```julia
# Degrade to maintain alignment
function aligned_degradation(skill, context, values)
    # Try optimal first
    aligned = align(skill, values)
    
    if aligned.blocked
        # Find aligned alternative
        return find_aligned_alternative(skill, values)
    end
    
    return aligned
end
```

## Key Principles

1. **Core values non-negotiable** - Safety, truth, autonomy unviolable
2. **Verify at all stages** - Pre, during, post execution
3. **Composition preserves** - Combined skills must align
4. **Explicit tradeoffs** - When values conflict, show why
5. **Audit everything** - Complete trace of value decisions

## Integration

This skill integrates with:
- **superpowers:skill-self-awareness** - Uses agent's values
- **superpowers:skill-uncertainty** - Quantifies alignment uncertainty
- **superpowers:skill-graceful-degradation** - Degrades to stay aligned
- **superpowers:skill-safety** - Safety-specific alignment

## References

- Value alignment: AI safety research
- Ethics: Philosophy
- Constraints: Formal methods
