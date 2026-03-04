---
name: skill-evolution
description: How skills improve over time through feedback, learning, and systematic improvement - the fixed point of skill development
---

# Skill Evolution

## Categorical Foundation

Skill evolution is finding the **fixed point** of skill improvement:

```
Skills ≅ Improve(Skills)
```

This is the least fixed point - the convergent state where skills stabilize as good.

## The Evolution Functor

```julia
"""
    Improve: Skills → Skills
    
    The improvement functor maps skills to better skills.
"""
struct ImprovementFunctor
    feedback_processor::FeedbackProcessor
    pattern_detector::PatternDetector
    synthesizer::ImprovementSynthesizer
end

# Apply one iteration of improvement
function improve(skills, feedback; functor)
    # Process feedback
    processed = functor.feedback_processor(feedback)
    
    # Detect patterns
    patterns = functor.pattern_detector(processed)
    
    # Synthesize improvements
    improved = functor.synthesizer(skills, patterns)
    
    return improved
end
```

## The Evolution Cycle

### Phase 1: Feedback Collection

```julia
"""
    Feedback types from skill execution.
"""
struct SkillFeedback
    skill_id::Symbol
    execution_context::Context
    outcome::Outcome
    user_satisfaction::Union{Float64, Nothing}
    duration::Float64
    errors::Vector{Error}
    improvements_suggested::Vector{String}
end

function collect_feedback(execution_history)
    feedbacks = []
    
    for execution in execution_history
        push!(feedbacks, SkillFeedback(
            skill_id = execution.skill,
            execution_context = execution.context,
            outcome = execution.outcome,
            user_satisfaction = execution.satisfaction,
            duration = execution.duration,
            errors = execution.errors,
            improvements_suggested = execution.suggestions
        ))
    end
    
    return feedbacks
end
```

### Phase 2: Pattern Analysis

```julia
"""
    PatternDetector - find recurring issues/opportunities.
"""
struct Patterns
    success_patterns::Vector{Pattern}
    failure_patterns::Vector{Pattern}
    improvement_opportunities::Vector{Opportunity}
end

function detect_patterns(feedbacks)
    # Group by skill
    by_skill = groupby(feedbacks, :skill_id)
    
    patterns = Patterns([], [], [])
    
    for (skill, group) in by_skill
        # Detect success factors
        successes = filter(f -> f.outcome.success, group)
        if length(successes) > 10
            push!(patterns.success_patterns, analyze(successes))
        end
        
        # Detect failure factors
        failures = filter(f -> !f.outcome.success, group)
        if length(failures) > 3
            push!(patterns.failure_patterns, analyze(failures))
        end
        
        # Find improvement opportunities
        opportunities = find_opportunities(group)
        push!(patterns.improvement_opportunities, opportunities...)
    end
    
    return patterns
end
```

### Phase 3: Synthesis

```julia
"""
    ImprovementSynthesizer - create improved skill versions.
"""
struct SynthesisResult
    new_skills::Vector{Skill}
    modified_skills::Vector{Skill}
    deprecated_skills::Vector{Skill}
    rationale::String
end

function synthesize(skills, patterns)
    new_skills = []
    modified = []
    deprecated = []
    
    for opportunity in patterns.improvement_opportunities
        # Decide: create new, modify, or deprecate
        action = decide_action(opportunity)
        
        match action begin
            :create => push!(new_skills, create_skill(opportunity))
            :modify => push!(modified, modify_skill(opportunity))
            :deprecate => push!(deprecated, mark_deprecated(opportunity))
        end
    end
    
    return SynthesisResult(new_skills, modified, deprecated, rationale)
end
```

### Phase 4: Deployment

```julia
"""
    Deploy improvements.
"""
struct DeploymentResult
    deployed::Vector{Skill}
    rolled_back::Vector{Skill}
    issues::Vector{Issue}
end

function deploy(synthesis_result; strategy=:canary)
    match strategy begin
        :canary => deploy_canary(synthesis_result)
        :blue_green => deploy_blue_green(synthesis_result)
        :immediate => deploy_immediate(synthesis_result)
    end
end

function deploy_canary(result)
    deployed = []
    for skill in result.new_skills
        # Deploy to 5% of traffic
        canary = deploy_percentage(skill, 5)
        if canary.success
            push!(deployed, scale_up(skill))
        else
            rollback(skill)
        end
    end
    return DeploymentResult(deployed, [], [])
end
```

### Phase 5: Validation

```julia
"""
    Validate improvements.
"""
function validate(deployed_skills)
    # Run A/B tests
    # Measure performance
    # Collect user feedback
    
    for skill in deployed_skills
        # Compare to previous version
        comparison = compare(skill.new_version, skill.old_version)
        
        if comparison.improvement > threshold
            mark_stable(skill)
        else
            rollback(skill)
        end
    end
end
```

## Fixed Point Detection

```julia
"""
    Detect when skills have converged.
"""
function converged(skill_history; threshold=0.01)
    if length(skill_history) < 3
        return false
    end
    
    recent = skill_history[end-2:end]
    
    # Quality should be stable
    qualities = [s.quality for s in recent]
    quality_variance = var(qualities)
    
    # Improvement should be diminishing
    improvements = [recent[i].quality - recent[i-1].quality 
                    for i in 2:length(recent)]
    improvement_rate = sum(improvements) / length(improvements)
    
    return quality_variance < threshold && improvement_rate < threshold
end
```

## Version Management

### Semantic Versioning

```julia
"""
    Skill versions follow semantic versioning.
"""
struct SkillVersion
    major::Int  # Breaking changes
    minor::Int  # New features
    patch::Int # Bug fixes
end

function bump_version(current::SkillVersion, change_type)
    match change_type begin
        :breaking => SkillVersion(current.major + 1, 0, 0)
        :feature => SkillVersion(current.major, current.minor + 1, 0)
        :fix => SkillVersion(current.major, current.minor, current.patch + 1)
    end
end
```

### Deprecation

```julia
"""
    Skill deprecation lifecycle.
"""
struct DeprecationPlan
    skill::Skill
    deprecated_in::Version
    removed_in::Version
    migration_guide::String
    alternative_skills::Vector{Skill}
end

function deprecate(skill, version)
    return DeprecationPlan(
        skill = skill,
        deprecated_in = version,
        removed_in = Version(version.major + 1, 0, 0),
        migration_guide = generate_migration(skill),
        alternative_skills = find_alternatives(skill)
    )
end
```

## Integration with Topos

### With homtime-optimization

```julia
# Benchmark skill improvements
h = hom(improve, skills, feedback)

# Measure: does evolution actually improve skills?
```

### With testy-property-testing

```julia
# Property: evolution never degrades quality
@property "evolution_monotonic" begin
    history ∈ generate(SkillHistory)
    
    # Later versions should be >= earlier
    for i in 2:length(history)
        @assert history[i].quality >= history[i-1].quality - 0.01
    end
end
```

## The Evolution Monad

```julia
"""
    The skill evolution monad:
    
    Skills → Feedback → Patterns → Improvements → Skills
"""
struct EvolutionMonad
    skills::Vector{Skill}
    feedback::Vector{Feedback}
    patterns::Patterns
    improvements::Vector{Improvement}
end

# Bind: chain improvements
function (>>=)(monad, f)
    improved = f(monad.patterns)
    return EvolutionMonad(
        skills = apply(improved, monad.skills),
        feedback = monad.feedback,
        patterns = detect(monad.feedback),
        improvements = [monad.improvements..., improved]
    )
end
```

## Key Principles

1. **Feedback-driven** - Real usage drives improvement
2. **Pattern-based** - Systematic issues become patterns
3. **Safe deployment** - Canary before full rollout
4. **Convergent** - Fixed point when stable
5. **Versioned** - Clear evolution history

## Integration

This skill integrates with:
- **superpowers:skill-testing** - Validates improvements
- **superpowers:skill-metrics** - Measures effectiveness
- **superpowers:topos-dogfooding** - Self-improvement loop
- **superpowers:compound-feedback-loop** - The evolution mechanism

## References

- Fixed point: Category theory
- Evolution: Machine learning
- Deployment: DevOps
