---
name: testy-stateful-testing
description: Stateful property testing via automaton categories, transition morphisms, and invariant equalizers using Testy
---

# Testy Stateful Testing

## Categorical Foundation

A stateful system is a **Moore machine** - a functor from the input alphabet to (output × state). In categorical terms:

- The system is a **morphism** in the category of automata
- State transitions form a **functor** from the action category
- Invariants are **equalizers** - states where spec equals behavior

## Core Concept: Automaton as Functor

```julia
using Testy

# A stateful system: Input → (Output × State)
# 
# This is a functor F: InputAlph → (Output × State)
# Where (Output × State) is the product category

stateful_system = StatefulSystem(
    initial,
    transition,
    output
)
```

## The StatefulSystem Type

```julia
# A stateful system is defined by:
# - initial: Initial state s₀
# - transition: s × a → s' (state morphism)
# - output: s → o (observation morphism)
```

## State Transitions as Morphisms

### Transition Function

```julia
# The transition morphism: s × a → s'
function transition(state::S, action::A)::S
    # Compute next state
end
```

### Output Function

```julia
# The observation morphism: s → o
function output(state::S)::O
    # Extract observable output
end
```

## Invariants as Equalizers

An invariant is an **equalizer** - the subset of states where behavior matches specification:

```julia
# Invariant: states where spec(s) = obs(s)
# This is the equalizer of spec and observation morphisms

invariant = Invariant(
    condition,
    generator  # generates states to test
)
```

### Testing Invariants

```julia
# Test invariant across all reachable states
result = check_invariant(system, invariant)
```

## Generators for Stateful Systems

### State Generators

```julia
# Generate initial states
init_gen = generate(State, 100)

# Generate action sequences  
action_gen = generate(Vector{Action}, 100)
```

### Transition Sequences

```julia
# Generate valid transition sequences
sequence = generate_sequence(system, 100)

# Returns: [(state, action, next_state), ...]
```

## Property Patterns

### Transition Property

```julia
@stateful_property "valid transition" begin
    s ∈ generate(State, 100)    # Initial state
    a ∈ generate(Action, 100)  # Action
    
    # Apply transition
    s' = transition(s, a)
    
    # Property: next state is valid
    is_valid_state(s')
end
```

### Output Property

```julia
@stateful_property "output reflects state" begin
    s ∈ generate(State, 100)
    
    o = output(s)
    
    # Output uniquely determines state (for observable systems)
    recover_state(o) == s
end
```

### Sequence Property

```julia
@stateful_property "sequence maintains invariant" begin
    s₀ ∈ generate(State, 100)
    actions ∈ generate(Vector{Action}, 50)
    
    # Apply sequence
    final_state = foldl(transition, actions; init=s₀)
    
    # Invariant: final state satisfies property
    invariant_holds(final_state)
end
```

## State Machine Categories

### Category of Automata

- **Objects**: State types S
- **Morphisms**: Transition functions s × a → s'
- **Composition**: Sequential transitions

### Product Category

```julia
# Input × State forms product category
# (Input, State) with projections and pair morphisms
```

## Transition Systems

### Defining a Transition System

```julia
# Define the transition system
system = @stateful begin
    initial = Empty()
    
    transition(state, action) = ...
    output(state) = ...
    
    generator = StateGenerator(100)
end
```

### Running Tests

```julia
# Run all stateful properties
result = check(system)
```

## Law Verification

### Functoriality of Transition

```julia
@stateful_property "transition is functional" begin
    s ∈ State
    a₁ ∈ Action
    a₂ ∈ Action
    
    # compose(transition(s, a₁), a₂) = transition(transition(s, a₁), a₂)
end
```

### Observer Compatibility

```julia
@stateful_property "output consistent with transition" begin
    s ∈ State
    a ∈ Action
    
    s' = transition(s, a)
    output(s') == transition_output(s, a)
end
```

## Events and Monitoring

### Event Functor

Events form a **functor** from the transition category to the event category:

```julia
# Events track state changes
events = EventLog()

# Transition emits events
emit!(events, :transition, s, a, s')

# Query events
transitions = filter_events(events, :transition)
```

### Property Events

```julia
# Track property violations
on_violation(property) do event
    log("Property violated: $(event.property)")
end
```

## Integration

Use with:
- **superpowers:testy-property-testing** - Base property testing
- **superpowers:compound-feedback-loop** - Test → Benchmark cycle

## Key Principles

1. **Systems are functors** - Input → (Output × State)
2. **Invariants are equalizers** - spec = observation
3. **Transitions are morphisms** - compose in the automaton category
4. **Events form functor** - track morphism applications

## References

- Testy.jl: Stateful.jl
- Automata theory: Moore machines, Mealy machines
- Category theory: Functor categories, products
