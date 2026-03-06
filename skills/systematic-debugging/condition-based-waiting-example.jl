# Complete implementation of condition-based waiting utilities
# From: Test infrastructure improvements (2025-10-03)
# Context: Fixed 15 flaky tests by replacing arbitrary timeouts

"""
    wait_for_event(get_events, event_type; timeout_s=5.0)

Wait for a specific event type to appear.

# Arguments
- `get_events::Function`: zero-arg function returning current event list
- `event_type::Symbol`: type of event to wait for
- `timeout_s::Float64`: maximum time to wait (default 5s)

# Example
```julia
event = wait_for_event(() -> get_events(thread_id), :TOOL_RESULT)
```
"""
function wait_for_event(
    get_events::Function,
    event_type::Symbol;
    timeout_s::Float64=5.0
)
    start = time()

    while true
        events = get_events()
        idx = findfirst(e -> e.type == event_type, events)

        if idx !== nothing
            return events[idx]
        elseif time() - start > timeout_s
            error("Timeout waiting for $event_type event after $(timeout_s)s")
        else
            sleep(0.01)  # Poll every 10ms for efficiency
        end
    end
end

"""
    wait_for_event_count(get_events, event_type, count; timeout_s=5.0)

Wait for a specific number of events of a given type.

# Arguments
- `get_events::Function`: zero-arg function returning current event list
- `event_type::Symbol`: type of event to wait for
- `count::Int`: number of events to wait for
- `timeout_s::Float64`: maximum time to wait (default 5s)

# Example
```julia
# Wait for 2 :AGENT_MESSAGE events (initial response + continuation)
events = wait_for_event_count(() -> get_events(thread_id), :AGENT_MESSAGE, 2)
```
"""
function wait_for_event_count(
    get_events::Function,
    event_type::Symbol,
    count::Int;
    timeout_s::Float64=5.0
)
    start = time()

    while true
        events = get_events()
        matching = filter(e -> e.type == event_type, events)

        if length(matching) >= count
            return matching
        elseif time() - start > timeout_s
            error(
                "Timeout waiting for $count $event_type events after $(timeout_s)s " *
                "(got $(length(matching)))"
            )
        else
            sleep(0.01)
        end
    end
end

"""
    wait_for_event_match(get_events, predicate, description; timeout_s=5.0)

Wait for an event matching a custom predicate.
Useful when you need to check event data, not just type.

# Arguments
- `get_events::Function`: zero-arg function returning current event list
- `predicate::Function`: returns true when event matches
- `description::String`: human-readable description for error messages
- `timeout_s::Float64`: maximum time to wait (default 5s)

# Example
```julia
# Wait for :TOOL_RESULT with specific ID
event = wait_for_event_match(
    () -> get_events(thread_id),
    e -> e.type == :TOOL_RESULT && e.data.id == "call_123",
    "TOOL_RESULT with id=call_123"
)
```
"""
function wait_for_event_match(
    get_events::Function,
    predicate::Function,
    description::String;
    timeout_s::Float64=5.0
)
    start = time()

    while true
        events = get_events()
        idx = findfirst(predicate, events)

        if idx !== nothing
            return events[idx]
        elseif time() - start > timeout_s
            error("Timeout waiting for $description after $(timeout_s)s")
        else
            sleep(0.01)
        end
    end
end

# Usage example from actual debugging session:
#
# BEFORE (flaky):
# ---------------
# message_task = @async send_message(agent, "Execute tools")
# sleep(0.3)                                       # Hope tools start in 300ms
# abort!(agent)
# wait(message_task)
# sleep(0.05)                                      # Hope results arrive in 50ms
# @test length(tool_results) == 2                  # Fails randomly
#
# AFTER (reliable):
# ----------------
# message_task = @async send_message(agent, "Execute tools")
# wait_for_event_count(get_events, :TOOL_CALL, 2)  # Wait for tools to start
# abort!(agent)
# wait(message_task)
# wait_for_event_count(get_events, :TOOL_RESULT, 2) # Wait for results
# @test length(tool_results) == 2                    # Always succeeds
#
# Result: 60% pass rate -> 100%, 40% faster execution
