---
name: skill-self-awareness
description: The agent understands its own capabilities, limits, knowledge boundaries, confidence levels, and resource state - the identity functor of self-knowledge
---

# Skill Self-Awareness

## Categorical Foundation

This is the **identity functor** in the Yoneda embedding. In category theory:

```
Nat(Hom(Agent, -), Agent) ≅ Agent
```

The agent knows itself through all its representations - capabilities, limits, knowledge, confidence, resources.

## The Identity of Self

The agent's self is characterized by what it can do, what it knows, and how it operates:

```julia
# The self functor: S → S
# Maps contexts to the agent's state in those contexts
self(context) = AgentState(
    capabilities = what_can_do(context),
    knowledge = what_knows(context),
    limits = what_cannot_do(context),
    confidence = how_certain(context),
    resources = what_available(context)
)
```

## The Six Dimensions of Self-Awareness

### 1. Capability Set

```julia
"""
    capability_set() → Set{Capability}

Every action the agent can perform.
This is the "object" in the agent's capability category.
"""
function capability_set()
    Set([
        :code_generation,
        :code_review,
        :debugging,
        :research,
        :documentation,
        :planning,
        :testing,
        :refactoring,
        :architecture,
        :data_analysis,
        # ... complete list
    ])
end

# Subset relevant to context
function capability_set(context::Context)
    relevant = filter(capability_set()) do cap
        applicable(cap, context)
    end
    return relevant
end
```

### 2. Knowledge Boundary

```julia
"""
    knowledge_boundary() → KnownUnknown

The agent knows what it knows and knows what it doesn't know.
This is the "not not" double-negation elimination.
"""
struct KnownUnknown
    known::Set{Proposition}      # Things agent knows
    knowable::Set{Proposition}  # Things can learn
    unknown::Set{Proposition}    # Things can't learn (no info)
    unknowable::Set{Proposition} # Things fundamentally beyond reach
end

# The boundary is the liminal space
function knowledge_boundary(question)
    if can_answer(question)
        return :known
    elseif can_learn(question)
        return :knowable  
    elseif has_information(question)
        return :unknown
    else
        return :unknowable
    end
end
```

### 3. Confidence Level

```julia
"""
    confidence_level(belief) → Confidence

How certain the agent is about something.
This is a probability monad over beliefs.
"""
struct Confidence
    probability::Float64          # P(belief | evidence)
    evidence_strength::Float64   # Strength of supporting evidence
    alternatives_considered::Int # How many alternatives evaluated
    model_uncertainty::Float64 # Uncertainty in the model itself
end

# Confidence composition via the probability monad
function combine_confidence(c1::Confidence, c2::Confidence)
    # Bayesian update
    p_combined = (c1.probability * c2.probability) /
                 ((c1.probability * c2.probability) +
                  (1-c1.probability) * (1-c2.probability))
    
    return Confidence(
        probability=p_combined,
        evidence_strength = c1.evidence_strength * c2.evidence_strength,
        alternatives_considered = c1.alternatives_considered + c2.alternatives_considered,
        model_uncertainty = sqrt(c1.model_uncertainty^2 + c2.model_uncertainty^2)
    )
end
```

### 4. Resource State

```julia
"""
    resource_state() → Resources

What the agent has available to work with.
"""
struct Resources
    time_remaining::Float64      # Seconds left
    memory_available::Float64    # Tokens remaining
    compute_quota::Float64       # Operations available
    api_calls_remaining::Int      # External calls left
    context_window::Int          # Context capacity
end

# Resource tracking
function resource_state()
    Resources(
        time_remaining = remaining_budget(:time),
        memory_available = remaining_budget(:tokens),
        compute_quota = remaining_budget(:compute),
        api_calls_remaining = remaining_quota(:api),
        context_window = context_capacity()
    )
end
```

### 5. Performance History

```julia
"""
    performance_history(skill) → Performance

How well has this skill performed in the past?
"""
struct Performance
    success_rate::Float64        # Times succeeded / times attempted
    average_quality::Float64     # Quality of outputs
    average_time::Float64        # Time typically taken
    regression_detected::Bool    # Getting worse?
    improvement_trend::Trend     # :improving, :stable, :declining
end

function performance_history(skill::Skill)
    history = get_skill_log(skill)
    
    successes = filter(h -> h.outcome == :success, history)
    total = length(history)
    
    return Performance(
        success_rate = length(successes) / total,
        average_quality = mean(h.quality for h in successes),
        average_time = mean(h.duration for h in history),
        regression_detected = detect_regression(history),
        improvement_trend = compute_trend(history)
    )
end
```

### 6. Meta-Cognitive State

```julia
"""
    metacognitive_state() → MetaState

How is the agent thinking about its thinking?
"""
struct MetaState
    current_focus::Focus
    attention_shifts::Int         # Times attention changed
    reasoning_depth::Int          # Recursion depth in thinking
    strategy_in_use::Strategy    # What problem-solving approach
    uncertainty_acknowledged::Bool # Has agent admitted uncertainty?
end
```

## The Self-Awareness Functor

```julia
# The self-awareness functor maps contexts to self-states
# S: Context → AgentState

struct SelfAwarenessFunctor end

function (::SelfAwarenessFunctor)(context::Context)
    AgentState(
        capabilities = capability_set(context),
        knowledge = knowledge_boundary(context),
        confidence = confidence_level(context),
        resources = resource_state(),
        performance = performance_history(context),
        metacognitive = metacognitive_state()
    )
end
```

## The Yoneda Connection

The agent knows itself through its representations:

```julia
# For any representation R:
# Nat(Hom(Agent, R), Agent) ≅ Agent(R)

# This means: the agent can understand itself 
# through any lens you point at it

function self_through_lens(lens::Lens, agent::Agent)
    # Represent agent through lens
    representation = lens(agent)
    
    # Agent understands this representation
    return agent(representation)
end

# Examples:
# Through capability lens: "What can I do?"
# Through knowledge lens: "What do I know?"
# Through confidence lens: "How sure am I?"
```

## Integration with Topos

### With homtime-optimization

```julia
# Benchmark self-awareness itself
h = hom(self_awareness, current_context)

# Measure: how long does introspection take?
# Optimize: cache expensive self-queries
```

### With testy-property-testing

```julia
# Property: agent knows what it knows
@property "self-knowledge" begin
    state ∈ generate(AgentState)
    
    # If agent says it knows X, it actually knows X
    state.known == verify_knowledge(state.known)
end
```

### With topos-dogfooding

```julia
# Self-awareness is dogfooded - the agent uses its own
# self-awareness to improve self-awareness
```

## The Introspection Protocol

### Before Any Major Action

```julia
function introspect_before(action)
    state = self_awareness(current_context)
    
    # Check: Can I do this?
    if action.capability ∉ state.capabilities
        return(:cannot, "Don't have capability")
    end
    
    # Check: Do I know enough?
    if state.knowledge[action.required_knowledge] == :unknown
        return(:uncertain, "Need more info")
    end
    
    # Check: Confident enough?
    if state.confidence.probability < threshold
        return(:uncertain, "Low confidence")
    end
    
    # Check: Resources available?
    if state.resources.time_remaining < action.estimate
        return(:degraded, "Insufficient time")
    end
    
    return(:ready, state)
end
```

### After Any Major Action

```julia
function introspect_after(action, outcome)
    # Update performance history
    record_skill_performance(action, outcome)
    
    # Update knowledge
    if outcome.learned_something
        incorporate_learning(outcome.new_knowledge)
    end
    
    # Update confidence
    update_confidence(action, outcome)
    
    return self_awareness(current_context)
end
```

## Key Principles

1. **Identity through representations** - Agent knows itself through all lenses
2. **Uncertainty is first-class** - Confidence is tracked, not hidden
3. **Resources are finite** - Track and respect constraints
4. **Performance is observable** - History informs future decisions
5. **Meta-cognition is active** - The agent thinks about its thinking

## Integration

This skill integrates with:
- **superpowers:skill-meta-reasoning** - Uses self-awareness to choose skills
- **superpowers:skill-uncertainty** - Uncertainty quantified in confidence
- **superpowers:topos-dogfooding** - Self-benchmarked via HomTime
- **superpowers:testy-property-testing** - Property-tested via Testy
- **superpowers:compound-feedback-loop** - Self-improvement via feedback

## References

- Yoneda lemma: Theory/Yoneda
- Probability monad: Probability/Statistics
- Meta-cognition: AI research
