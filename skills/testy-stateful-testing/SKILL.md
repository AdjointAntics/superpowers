---
name: testy-stateful-testing
description: Use when testing stateful systems, verifying state machine invariants, generating action sequences, or monitoring state transitions -- uses Testy's StatefulSystem and @stateful_property
---
# Testy Stateful Testing

## When
Invoke when you need to test a system with mutable state, verify that invariants hold across arbitrary action sequences, or generate and validate transition paths.

## Iron Laws
1. Define every stateful system with explicit `initial`, `transition`, and `output` functions.
2. Test invariants across generated action sequences, not just single transitions.
3. Always generate both states and actions -- do not hardcode test inputs.
4. Log transition events for debugging failing sequences.

## Process
1. Define the stateful system:
   ```julia
   system = StatefulSystem(initial, transition, output)
   ```
   Where `transition(state, action) -> state'` and `output(state) -> observable`.
2. Define invariants:
   ```julia
   invariant = Invariant(condition, generator)
   result = check_invariant(system, invariant)
   ```
3. Generate states and actions:
   ```julia
   init_gen = generate(State, 100)
   action_gen = generate(Vector{Action}, 100)
   sequence = generate_sequence(system, 100)  # [(state, action, next_state), ...]
   ```
4. Write transition properties:
   ```julia
   @stateful_property "valid transition" begin
       s in generate(State, 100)
       a in generate(Action, 100)
       s_next = transition(s, a)
       is_valid_state(s_next)
   end
   ```
5. Write output properties:
   ```julia
   @stateful_property "output reflects state" begin
       s in generate(State, 100)
       o = output(s)
       recover_state(o) == s
   end
   ```
6. Write sequence properties:
   ```julia
   @stateful_property "sequence maintains invariant" begin
       s0 in generate(State, 100)
       actions in generate(Vector{Action}, 50)
       final = foldl(transition, actions; init=s0)
       invariant_holds(final)
   end
   ```
7. Use the `@stateful` macro for concise definition:
   ```julia
   system = @stateful begin
       initial = Empty()
       transition(state, action) = ...
       output(state) = ...
       generator = StateGenerator(100)
   end
   ```
8. Run all stateful properties: `result = check(system)`.
9. Monitor events:
   ```julia
   events = EventLog()
   emit!(events, :transition, s, a, s_next)
   on_violation(property) do event
       log("Violated: $(event.property)")
   end
   ```

## Composability
Expects a StatefulSystem definition with typed state and actions. Produces test results with counterexample sequences. Builds on testy-property-testing for generators and shrinking.
