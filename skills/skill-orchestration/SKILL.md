---
name: skill-orchestration
description: Chaining skills into complex pipelines with orchestration, monitoring, and error recovery
---

# Skill Orchestration

## Categorical Foundation

Orchestration is the **execution functor** that runs composed skills:

```
O: Composition → Execution
```

It maps skill compositions (from skill-composition) to executable pipelines with monitoring, recovery, and observability.

## The Orchestration Pipeline

### Stage 1: Planning

```julia
"""
    OrchestrationPlan - the complete execution plan.
"""
struct OrchestrationPlan
    composition::SkillComposition
    steps::Vector{OrchestrationStep}
    resources::ResourceAllocation
    checkpoints::Vector{Checkpoint}
    rollback_plan::RollbackPlan
end

function plan_orchestration(composition::SkillComposition, context)
    # Analyze composition
    steps = decompose(composition)
    
    # Allocate resources
    resources = allocate(steps)
    
    # Define checkpoints
    checkpoints = define_checkpoints(steps)
    
    # Create rollback
    rollback = create_rollback(steps)
    
    return OrchestrationPlan(composition, steps, resources, checkpoints, rollback)
end
```

### Stage 2: Initialization

```julia
"""
    OrchestrationState - current execution state.
"""
struct OrchestrationState
    current_step::Int
    completed_steps::Vector{StepResult}
    active_tasks::Vector{Task}
    data_flow::Dict{Symbol, Any}
    metrics::Metrics
end

function initialize(plan::OrchestrationPlan)
    return OrchestrationState(
        current_step = 1,
        completed_steps = [],
        active_tasks = [],
        data_flow = Dict{Symbol, Any}(),
        metrics = Metrics()
    )
end
```

### Stage 3: Execution

```julia
"""
    Execute the orchestration plan.
"""
function execute(plan::OrchestrationPlan, context)
    state = initialize(plan)
    
    while state.current_step <= length(plan.steps)
        step = plan.steps[state.current_step]
        
        # Execute step
        result = execute_step(step, state, context)
        
        # Record result
        push!(state.completed_steps, result)
        
        # Checkpoint
        if should_checkpoint(step, result)
            checkpoint!(state, plan.checkpoints)
        end
        
        # Handle result
        if result.success
            state.current_step += 1
        elseif can_retry(step)
            retry_step!(state, step)
        else
            # Trigger rollback
            return rollback(plan, state)
        end
        
        # Update metrics
        update_metrics!(state.metrics, result)
    end
    
    return OrchestrationResult(
        state = state,
        outcome = :success,
        results = state.completed_steps
    )
end
```

## Step Types

### Sequential Step

```julia
"""
    SequentialStep - wait for previous, then run.
"""
struct SequentialStep
    skill::Skill
    input_from::Union{Symbol, Nothing}
    output_to::Union{Symbol, Nothing}
    timeout::Float64
    retry_policy::RetryPolicy
end
```

### Parallel Step

```julia
"""
    ParallelStep - run multiple skills concurrently.
"""
struct ParallelStep
    skills::Vector{Skill}
    input_from::Union{Symbol, Nothing}
    outputs_to::Vector{Symbol}
    sync_policy::SyncPolicy
end
```

### Conditional Step

```julia
"""
    ConditionalStep - branch based on condition.
"""
struct ConditionalStep
    condition::Condition
    then_skill::Skill
    else_skill::Union{Skill, Nothing}
end
```

### Loop Step

```julia
"""
    LoopStep - iterate until condition.
"""
struct LoopStep
    iteration_skill::Skill
    condition::LoopCondition
    max_iterations::Int
    early_exit::Bool
end
```

## Data Flow

```julia
"""
    DataFlow - how data moves between steps.
"""
struct DataFlow
    step_outputs::Dict{Symbol, Any}
    step_inputs::Dict{Symbol, Any}
    transformations::Dict{Symbol, Function}
end

# Pass data between steps
function pass_data(from_step, to_step, flow::DataFlow)
    output_key = symbol(from_step)
    input_key = symbol(to_step)
    
    data = flow.step_outputs[output_key]
    
    # Apply transformation if any
    if haskey(flow.transformations, (output_key, input_key))
        data = flow.transformations[(output_key, input_key)](data)
    end
    
    flow.step_inputs[input_key] = data
end
```

## Monitoring

### Metrics Collection

```julia
"""
    OrchestrationMetrics - what's being tracked.
"""
struct OrchestrationMetrics
    step_durations::Dict{Symbol, Float64}
    step_results::Dict{Symbol, StepResult}
    resource_usage::Dict{Symbol, Resource}
    errors::Vector{Error}
    retries::Int
end

function collect_metrics(state::OrchestrationState)
    return OrchestrationMetrics(
        step_durations = get_durations(state),
        step_results = get_results(state),
        resource_usage = get_usage(state),
        errors = get_errors(state),
        retries = count_retries(state)
    )
end
```

### Checkpointing

```julia
"""
    Checkpoint - save state for recovery.
"""
struct Checkpoint
    step::Int
    data_flow::DataFlow
    timestamp::DateTime
    metrics::Metrics
end

function checkpoint!(state, checkpoints)
    for cp in checkpoints
        if should_save(cp, state.current_step)
            save(Checkpoint(
                step = state.current_step,
                data_flow = copy(state.data_flow),
                timestamp = now(),
                metrics = state.metrics
            ))
        end
    end
end
```

## Error Recovery

### Retry Policy

```julia
"""
    RetryPolicy - how to handle failures.
"""
struct RetryPolicy
    max_attempts::Int
    backoff::BackoffStrategy  # :constant, :linear, :exponential
    max_delay::Float64
    retryable_errors::Set{ErrorType}
end

function should_retry(error, policy::RetryPolicy)
    if error.type ∈ policy.retryable_errors
        return error.attempt < policy.max_attempts
    end
    return false
end
```

### Rollback

```julia
"""
    RollbackPlan - how to undo partial execution.
"""
struct RollbackPlan
    checkpoint_path::Vector{Int}
    compensating_actions::Vector{CompensatingAction}
    rollback_timeout::Float64
end

function rollback(plan::OrchestrationPlan, state::OrchestrationState)
    # Load last checkpoint
    checkpoint = load_last_checkpoint()
    
    # Apply compensating actions in reverse
    for action in reverse(plan.rollback_plan.compensating_actions)
        compensate(action, checkpoint.data_flow)
    end
    
    return OrchestrationResult(
        state = state,
        outcome = :rolled_back,
        checkpoint = checkpoint
    )
end
```

## Observability

### Tracing

```julia
"""
    Trace - complete execution history.
"""
struct Trace
    spans::Vector{Span}    # Each step is a span
    events::Vector{Event}  # Significant events
    relationships::Vector{Relationship}
end
```

### Logging

```julia
"""
    StructuredLog - contextual logging.
"""
struct StructuredLog
    timestamp::DateTime
    level::LogLevel
    step::Symbol
    message::String
    context::Dict{Any, Any}
    trace_id::UUID
end
```

## Integration with Composition

```julia
# Orchestration executes composition
function orchestrate(composition::SkillComposition, context)
    # Convert composition to orchestration plan
    plan = plan_orchestration(composition, context)
    
    # Execute
    return execute(plan, context)
end
```

## Integration with Meta-Reasoning

```julia
# Meta-reasoning decides orchestration strategy
function orchestrate_with_strategy(composition, context, strategy)
    match strategy begin
        :fast => orchestrate_minimal(composition, context)
        :thorough => orchestrate_complete(composition, context)  
        :adaptive => orchestrate_adaptive(composition, context)
    end
end
```

## Key Principles

1. **Plan first** - Always create orchestration plan
2. **Checkpoint often** - Save state for recovery
3. **Monitor continuously** - Track metrics live
4. **Recover gracefully** - Rollback on failure
5. **Observable everything** - Trace, log, metrics

## Integration

This skill integrates with:
- **superpowers:skill-composition** - Executes composed skills
- **superpowers:skill-self-awareness** - Uses resource awareness
- **superpowers:skill-uncertainty** - Handles failures
- **superpowers:skill-graceful-degradation** - Degrades on resource issues
- **superpowers:compound-feedback-loop** - The orchestration engine

## References

- Orchestration: Distributed systems
- Checkpointing: Fault tolerance
- Observability: Monitoring/Tracing
