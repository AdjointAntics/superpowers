---
name: skill-uncertainty
description: What to do when skills conflict, fail, or produce uncertain results - the probability monad over skill execution
---

# Skill Uncertainty

## Categorical Foundation

This implements the **probability monad** over skill execution - handling the Maybe/Either pattern when skills may fail or conflict:

```
M(A) = Maybe(Either(State(Writer(A))))
```

In simpler terms: When skills produce uncertain results, we track:
- What might happen
- How likely each outcome is
- What to do in each case

## The Uncertainty Hierarchy

### Level 1: Ignorance

```julia
"""
    Ignorance - we don't know what we don't know.

This is the initial object in the uncertainty category.
"""
struct Ignorance
    unknown_dimensions::Set{Symbol}
    evidence_absence::Bool
end

# The starting state
function initial_uncertainty(problem)
    Ignorance(
        unknown_dimensions = identify_unknowns(problem),
        evidence_absence = true
    )
end
```

### Level 2: Risk

```julia
"""
    Risk - we know the probabilities.

This is the probability functor over outcomes.
"""
struct Risk
    outcomes::Vector{Outcome}
    probabilities::Vector{Float64}
    
    function Risk(outcomes, probs)
        @assert sum(probs) ≈ 1.0 "Probabilities must sum to 1"
        new(outcomes, probs)
    end
end

# Expected value
function expected_value(risk::Risk)
    sum(o.value * p for (o, p) in zip(risk.outcomes, risk.probabilities))
end
```

### Level 3: Uncertainty

```julia
"""
    Uncertainty - we don't know the probabilities.

This is the imprecise probability functor.
"""
struct Uncertainty
    outcomes::Vector{Outcome}
    lower_bounds::Vector{Float64}   # p_min
    upper_bounds::Vector{Float64}   # p_max
    
    # p_lower ≤ p ≤ p_upper
end

# Possibility distribution
function possibility_distribution(uncertainty::Uncertainty)
    # If p_upper > 0, it's possible
    filter(o -> uncertainty.upper_bounds[i] > 0, uncertainty.outcomes)
end
```

### Level 4: Ambiguity

```julia
"""
    Ambiguity - multiple interpretations possible.

This is the non-deterministic functor.
"""
struct Ambiguity
    interpretations::Vector{Interpretation}
    current_selected::Union{Nothing, Interpretation}
end

# Resolve ambiguity by choosing interpretation
function resolve(ambiguity::Ambiguity, criteria)
    best = argmax(ambiguity.interpretations, criteria)
    return Ambiguity(ambiguity.interpretations, best)
end
```

## The Uncertainty Functor

```julia
# Uncertainty over skill execution
# U: Skill → Distribution over Outcomes

struct UncertaintyFunctor{F}
    skill::F
end

# Map skill to uncertainty distribution
function apply_uncertainty(skill::Skill, context)
    # Sample skill multiple times
    outcomes = [execute(skill, context) for _ in 1:100]
    
    # Build distribution
    return build_distribution(outcomes)
end
```

## The Maybe/Either Monad

### Maybe - Skill Might Fail

```julia
"""
    Maybe - the skill might not produce a result.

The Maybe monad: nothing or just.
"""
struct Maybe{T}
    value::Union{T, Nothing}
end

# Functor: map over Maybe
function map(f, maybe::Maybe)
    maybe.value === nothing ? Maybe(nothing) : Maybe(f(maybe.value))
end

# Monad: flatten Maybe of Maybe
function flat_map(f, maybe::Maybe)
    maybe.value === nothing ? Maybe(nothing) : f(maybe.value)
end
```

### Either - Skill Might Error

```julia
"""
    Either - the skill might produce an error.

The Either monad: left is error, right is success.
"""
struct Either{E, A}
    left::Union{E, Nothing}
    right::Union{A, Nothing}
end

# Functor: map over Either
function map(f, either::Either{E, A})
    either.right === nothing ? Either(either.left, nothing) : Either(nothing, f(either.right))
end

# Monad: flatten Either of Either
function flat_map(f, either::Either)
    if either.left !== nothing
        return Either(either.left, nothing)
    elseif either.right === nothing
        return Either(nothing, nothing)
    else
        return f(either.right)
    end
end
```

## Uncertainty Quantification

```julia
"""
    quantify_uncertainty(skill, context) → Uncertainty

How uncertain is this skill execution?
"""
function quantify(skill::Skill, context)
    # Sample multiple executions
    samples = [execute(skill, context) for _ in 1:100]
    
    # Build uncertainty distribution
    outcomes = categorize_outcomes(samples)
    
    return Uncertainty(
        outcomes = outcomes,
        lower_bounds = [p_lower(o) for o in outcomes],
        upper_bounds = [p_upper(o) for o in outcomes]
    )
end
```

## Confidence Threshold

```julia
"""
    confidence_threshold() → Float64

When is confidence high enough to proceed?
"""
struct ConfidenceThreshold
    proceed_below::Float64    # Proceed if confidence > this
    ask_above::Float64       # Ask human if confidence < this
    stop_below::Float64       # Stop entirely if confidence < this
end

DEFAULT_THRESHOLD = ConfidenceThreshold(0.7, 0.5, 0.3)

function should_proceed(confidence::Confidence)
    if confidence.probability > DEFAULT_THRESHOLD.proceed_below
        return :proceed
    elseif confidence.probability > DEFAULT_THRESHOLD.ask_above
        return :ask_human
    else
        return :stop
    end
end
```

## Fallback Chains

```julia
"""
    FallbackChain - try skills in order until one works.

This is the "orelse" monad.
"""
struct FallbackChain
    skills::Vector{Skill}
    current::Int
end

function execute(chain::FallbackChain, context)
    for skill in chain.skills
        result = execute(skill, context)
        if result.success
            return result
        end
    end
    
    return Failure("All skills in chain failed")
end
```

## Conflict Resolution

```julia
"""
    ConflictResolution - when skills disagree.

The skill disagreement problem.
"""
struct ConflictResolution
    skill_outputs::Dict{Skill, Outcome}
    resolution_strategy::Strategy
    resolved_output::Outcome
end

function resolve_conflict(outputs::Dict{Skill, Outcome})
    # Different strategies:
    # :unanimous - all agree
    # :majority - vote
    # :confidence_weighted - weight by skill confidence
    # :cascade - primary skill wins
    
    if all_equal(values(outputs))
        return :unanimous, only(values(outputs))
    elseif count_majority(outputs) > length(outputs) / 2
        return :majority, majority_winner(outputs)
    else
        return :confidence_weighted, confidence_winner(outputs)
    end
end
```

## The Probability Monad Over Skills

```julia
"""
    The full probability monad for skill execution:

Maybe(Either(State(Writer(SkillOutcome))))

- Writer: Logging what happened
- State: Tracking what we've tried
- Either: Success or error  
- Maybe: We might not have a result
"""
struct SkillProbabilityMonad
    writer_logs::Vector{Log}
    state_attempts::Vector{Attempt}
    either_result::Either{Error, Success}
    maybe_result::Union{Success, Nothing}
end

# Bind: chain uncertain skill executions
function bind(monad::SkillProbabilityMonad, f)
    # Log current state
    log!(monad.writer_logs, monad.state_attempts)
    
    # Try next skill if previous succeeded
    if monad.either_result.right !== nothing
        next_result = f(monad.either_result.right)
    else
        next_result = monad.either_result.left
    end
    
    return SkillProbabilityMonad(
        writer_logs = monad.writer_logs,
        state_attempts = [monad.state_attempts..., next_result.state_attempt],
        either_result = next_result.either,
        maybe_result = next_result.maybe
    )
end
```

## Integration with Self-Awareness

```julia
# Uncertainty uses self-awareness to calibrate
function quantify(skill::Skill, context, self_state)
    # What is my confidence in this skill?
    skill_performance = self_state.performance[skill]
    
    # Adjust uncertainty based on past performance
    uncertainty = base_quantify(skill, context)
    
    # If I've done well, reduce uncertainty
    if skill_performance.success_rate > 0.9
        uncertainty = reduce_by_factor(uncertainty, 0.5)
    end
    
    return uncertainty
end
```

## Integration with Topos

### With homtime-optimization

```julia
# Measure cost of uncertainty
h = hom(quantify_uncertainty, skill, context)

# What's the time cost of being uncertain?
# Should we invest in reducing uncertainty?
```

### With testy-property-testing

```julia
# Property: uncertainty quantification is accurate
@property "uncertainty_calibrated" begin
    skill ∈ generate(Skill)
    context ∈ generate(Context)
    
    predicted = quantify(skill, context)
    actual = run_many_times(skill, context, 1000)
    
    # Predicted bounds should contain actual
    actual.p ∈ [predicted.lower, predicted.upper]
end
```

## Decision Framework

```julia
"""
    decide_with_uncertainty(skill, context) → Decision

The full decision under uncertainty framework.
"""
function decide(skill::Skill, context, self_state)
    # Quantify uncertainty
    uncertainty = quantify(skill, context, self_state)
    
    # Get expected value
    expected = expected_value(uncertainty)
    
    # Get confidence
    confidence = compute_confidence(uncertainty)
    
    # Decide
    action = should_proceed(confidence)
    
    return Decision(
        action = action,
        uncertainty = uncertainty,
        expected_value = expected,
        confidence = confidence,
        recommendation = make_recommendation(action, uncertainty)
    )
end
```

## Key Principles

1. **Track uncertainty explicitly** - Don't hide what you don't know
2. **Calibrate confidence** - Verify your uncertainty estimates
3. **Have fallbacks** - When primary skills fail
4. **Resolve conflicts** - When skills disagree
5. **Use probability monad** - Chain uncertain operations cleanly

## Integration

This skill integrates with:
- **superpowers:skill-self-awareness** - Uses confidence from self-awareness
- **superpowers:skill-meta-reasoning** - Informed by selection confidence
- **superpowers:skill-graceful-degradation** - Falls back when uncertain
- **superpowers:compound-feedback-loop** - Uncertainty in the feedback

## References

- Probability monad: Functional programming
- Imprecise probability: Decision theory
- Conflict resolution: Multi-agent systems
