---
name: skill-meta-reasoning
description: Choosing what skill to use, when to use it, and how to compose them - the higher-order functor between skill categories
---

# Skill Meta-Reasoning

## Categorical Foundation

This is a **higher-order functor** - a functor between skill categories. In category theory:

```
M: [Skills, Context] → [Skills, Outcome]
```

Where `[Skills, Context]` is the category of contexts with skill-valued morphisms, and `[Skills, Outcome]` maps to execution outcomes.

## The Meta-Reasoning Functor

```julia
# Meta-reasoning is a functor:
# M: Problem → Skill
#
# M preserves composition:
# M(f ∘ g) = M(f) ∘ M(g)
#
# M preserves identity:
# M(id_context) = id_skill

struct MetaReasoningFunctor end
```

## The Six Stages of Meta-Reasoning

### 1. Problem Classification

```julia
"""
    problem_classification(problem) → ProblemCategory

What type of problem is this?
This is the "object" in the problem category.
"""
struct ProblemCategory
    domain::Symbol            # :coding, :research, :design, :analysis
    complexity::Complexity    # :simple, :moderate, :complex, :wicked
    urgency::Urgency         # :now, :soon, :later
    stakes::Stakes           # :low, :medium, :high, :critical
    reversibility::Bool     # Can undo?
end

function classify_problem(problem::Problem)
    ProblemCategory(
        domain = infer_domain(problem),
        complexity = assess_complexity(problem),
        urgency = assess_urgency(problem),
        stakes = assess_stakes(problem),
        reversibility = assess_reversibility(problem)
    )
end
```

### 2. Skill Selection

```julia
"""
    skill_selection(problem::Problem, self_state::AgentState) → Skill

Which skill(s) to use?
This is the "morphism" from problem to skill.
"""
struct SkillSelection
    primary_skill::Skill
    alternative_skills::Vector{Skill}     # Fallbacks
    confidence::Confidence                 # How confident in choice
    rationale::String                     # Why this choice
end

function select_skill(problem::Problem, self_state::AgentState)
    # Get relevant skills
    candidates = find_relevant_skills(problem, self_state.capabilities)
    
    # Score each
    scored = [
        (skill, score_skill(skill, problem, self_state))
        for skill in candidates
    ]
    
    # Select best
    best = maximum(scored, by = s -> s[2].score)
    
    return SkillSelection(
        primary_skill = best[1],
        alternative_skills = [s[1] for s in sort(scored, by=s->s[2].score)[2:4]],
        confidence = best[2].score,
        rationale = best[2].reasoning
    )
end
```

### 3. Composition Planning

```julia
"""
    composition_planner(primary_skill, problem) → SkillComposition

How should skills be composed?
"""
struct SkillComposition
    strategy::CompositionStrategy  # :sequential, :parallel, :branching, :pipeline
    skills::Vector{Skill}         # Ordered skills
    connectors::Vector{Connector} # How to connect
    branching::Union{Nothing, BranchPoint} # Conditional paths
end

function plan_composition(primary_skill::Skill, problem::Problem)
    # Analyze dependencies
    deps = analyze_dependencies(primary_skill, problem)
    
    # Determine strategy
    if has_parallel_dependencies(deps)
        return SkillComposition(:parallel, deps.parallel, connector_parallel)
    elseif has_sequential_dependencies(deps)
        return SkillComposition(:pipeline, deps.sequential, connector_pipe)
    elseif has_conditional_paths(deps)
        return SkillComposition(:branching, deps.all, deps.branch_point)
    else
        return SkillComposition(:sequential, [primary_skill], connector_identity)
    end
end
```

### 4. Execution Strategy

```julia
"""
    execution_strategy(composition, resources) → ExecutionPlan

In what order and manner to execute?
"""
struct ExecutionPlan
    steps::Vector{ExecutionStep}
    checkpoints::Vector{Checkpoint}
    rollback_plan::Union{Nothing, Rollback}
    timeout::Float64
    parallel_ok::Bool
end

function plan_execution(composition::SkillComposition, resources::Resources)
    steps = ExecutionStep[]
    
    for skill in composition.skills
        # Check prerequisites
        prereqs = get_prerequisites(skill)
        
        # Add prerequisite steps
        for prereq in prereqs
            push!(steps, ExecutionStep(prereq, :must_succeed))
        end
        
        # Add main step
        push!(steps, ExecutionStep(skill, :try))
    end
    
    return ExecutionPlan(
        steps = steps,
        checkpoints = generate_checkpoints(steps),
        rollback_plan = create_rollback(steps),
        timeout = estimate_timeout(steps, resources),
        parallel_ok = can_parallelize(steps)
    )
end
```

### 5. Monitoring

```julia
"""
    monitor_execution(execution_plan) → ExecutionState

Track progress and adapt.
"""
struct ExecutionState
    current_step::Int
    completed_steps::Vector{StepResult}
    current_confidence::Confidence
    adaptations::Vector{Adaptation}
end

function monitor(execution_plan::ExecutionPlan, state::ExecutionState)
    # Check current step
    step = execution_plan.steps[state.current_step]
    
    # Evaluate progress
    if step_succeeding(step)
        state.current_step += 1
    elseif step_failing(step)
        # Trigger fallback
        return adapt_to_failure(state, step)
    else
        # Continue monitoring
        return state
    end
    
    # Update confidence
    state.current_confidence = update_confidence(state)
    
    return state
end
```

### 6. Reflection

```julia
"""
    reflect_on_execution(outcome, execution_state) → MetaLearning

What did we learn about skill selection?
"""
struct MetaLearning
    skill_effectiveness::Dict{Skill, Float64}
    composition_patterns::Vector{Pattern}
    new_skill_candidates::Vector{Skill}
    recommendations::Vector{Recommendation}
end

function reflect(outcome::Outcome, state::ExecutionState)
    # Analyze what worked
    effective = analyze_effectiveness(state)
    
    # Extract patterns
    patterns = extract_patterns(state)
    
    # Suggest improvements
    suggestions = make_suggestions(effective, patterns)
    
    return MetaLearning(
        skill_effectiveness = effective,
        composition_patterns = patterns,
        new_skill_candidates = suggestions.new_skills,
        recommendations = suggestions.recommendations
    )
end
```

## The Meta-Reasoning Category

### Objects

- Problems
- Skills
- Contexts
- Outcomes

### Morphisms

- Problem → Skill (selection)
- Skill → Skill (composition)
- Context → Outcome (execution)

### Functors

- M: Problem → Skill
- E: Skill → Outcome  
- R: Outcome → Problem (reflection)

### Natural Transformations

- η: I → E∘M (planning)
- ε: M∘R → I (learning)

## Confidence Calibration

```julia
"""
    calibrate_confidence(selection, actual_outcome) → CalibratedConfidence

Meta-reasoning learns from its predictions.
"""
function calibrate(selection::SkillSelection, outcome::Outcome)
    # How good was our prediction?
    predicted_confidence = selection.confidence
    actual_outcome = outcome.quality
    
    # Update model
    calibration_error = predicted_confidence - actual_outcome
    
    # Adjust future predictions
    return update_calibration_model(calibration_error)
end
```

## The Exploration-Exploitation Adjunction

```
Exploration ⊣ Exploitation

Exploration: Try new skills, new compositions
Exploitation: Use known good skills

η: Id → Exploitation∘Exploration (learning from exploration)
ε: Exploration∘Exploitation → Id (exploiting learned knowledge)
```

## Integration with Self-Awareness

```julia
# Meta-reasoning uses self-awareness
function select_skill(problem, self_state)
    # What can I do?
    capabilities = self_state.capabilities
    
    # What have I done well?
    performance = self_state.performance
    
    # What do I know?
    knowledge = self_state.knowledge
    
    # Combine with problem
    return choose_best(problem, capabilities, performance, knowledge)
end
```

## Integration with Topos

### With homtime-optimization

```julia
# Benchmark skill selection decisions
h = hom(select_skill, problems)

# Find: which selection heuristics are fastest?
```

### With testy-property-testing

```julia
# Property: meta-reasoning improves over time
@property "learning" begin
    selections ∈ generate(SkillSelections, 100)
    
    # Earlier selections should be worse than later
    earlier = selections[1:50]
    later = selections[51:100]
    
    mean(earlier.quality) <= mean(later.quality)
end
```

## The Meta-Learning Loop

```julia
function meta_learn(problems::Vector{Problem})
    insights = []
    
    for problem in problems
        # Select
        selection = select_skill(problem, self_state)
        
        # Execute
        outcome = execute(selection)
        
        # Reflect
        learning = reflect(outcome, execution_state)
        
        # Update self-awareness
        update_self_awareness(learning)
        
        push!(insights, learning)
    end
    
    return synthesize_insights(insights)
end
```

## Key Principles

1. **Higher-order functors** - Meta-reasoning maps problem categories to skill categories
2. **Composition is explicit** - Not just "use skill X" but "compose X, Y, Z"
3. **Confidence is tracked** - Selection has calibrated confidence
4. **Learning is explicit** - Every selection teaches meta-reasoner
5. **Self-aware** - Uses skill-self-awareness to inform choices

## Integration

This skill integrates with:
- **superpowers:skill-self-awareness** - Uses self-state to inform selection
- **superpowers:skill-composition** - Composes skills based on plan
- **superpowers:skill-uncertainty** - Quantifies uncertainty in selection
- **superpowers:compound-feedback-loop** - The meta-adjunction in action

## References

- Functor categories: Category Theory
- Meta-learning: AI Research
- Exploration-exploitation: Reinforcement Learning
