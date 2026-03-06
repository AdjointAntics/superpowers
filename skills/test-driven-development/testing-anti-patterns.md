# Testing Anti-Patterns

**Load this reference when:** writing or changing tests, adding stubs, or tempted to add test-only methods to production code.

## Overview

Tests must verify real behavior, not stub behavior. Stubs are a means to isolate, not the thing being tested.

**Core principle:** Test what the code does, not what the stubs do.

**Following strict TDD prevents these anti-patterns.**

## The Iron Laws

```
1. NEVER test stub behavior
2. NEVER add test-only methods to production types
3. NEVER stub without understanding dependencies
```

## Anti-Pattern 1: Testing Stub Behavior

**The violation:**
```julia
# BAD: Testing that the stub exists
@testset "renders sidebar" begin
    page = render_page(sidebar=StubSidebar())
    @test haskey(page.components, :sidebar_stub)  # Testing the stub!
end
```

**Why this is wrong:**
- You're verifying the stub works, not that the component works
- Test passes when stub is present, fails when it's not
- Tells you nothing about real behavior

**your human partner's correction:** "Are we testing the behavior of a stub?"

**The fix:**
```julia
# GOOD: Test real component or don't stub it
@testset "renders sidebar" begin
    page = render_page()  # Don't stub sidebar
    @test has_navigation(page)
end

# OR if sidebar must be stubbed for isolation:
# Don't assert on the stub - test page behavior with sidebar present
```

### Gate Function

```
BEFORE asserting on any stub element:
  Ask: "Am I testing real component behavior or just stub existence?"

  IF testing stub existence:
    STOP - Delete the assertion or remove the stub

  Test real behavior instead
```

## Anti-Pattern 2: Test-Only Methods in Production

**The violation:**
```julia
# BAD: cleanup!() only used in tests
struct Session
    id::String
    workspace::Union{Workspace, Nothing}
end

function cleanup!(s::Session)  # Looks like production API!
    s.workspace !== nothing && destroy_workspace!(s.workspace, s.id)
end

# In tests
@testset "session" begin
    s = Session("id1", workspace)
    # ...
    cleanup!(s)  # test-only method on production type
end
```

**Why this is wrong:**
- Production type polluted with test-only code
- Dangerous if accidentally called in production
- Violates YAGNI and separation of concerns
- Confuses object lifecycle with entity lifecycle

**The fix:**
```julia
# GOOD: Test utilities handle test cleanup
# Session has no cleanup!() - it's stateless in production

# In test/test_helpers.jl
function cleanup_session(s::Session)
    ws = s.workspace
    ws !== nothing && destroy_workspace!(ws, s.id)
end

# In tests
@testset "session" begin
    s = Session("id1", workspace)
    try
        # ... test logic
    finally
        cleanup_session(s)
    end
end
```

### Gate Function

```
BEFORE adding any method to production type:
  Ask: "Is this only used by tests?"

  IF yes:
    STOP - Don't add it
    Put it in test utilities instead

  Ask: "Does this type own this resource's lifecycle?"

  IF no:
    STOP - Wrong type for this method
```

## Anti-Pattern 3: Stubbing Without Understanding

**The violation:**
```julia
# BAD: Stub kills side effect test depends on
@testset "detects duplicate server" begin
    # discover_and_cache stub prevents config write that test depends on!
    add_server(config; discover=(args...) -> nothing)
    add_server(config; discover=(args...) -> nothing)  # Should throw - but won't!
end
```

**Why this is wrong:**
- Stubbed method had side effect test depended on (writing config)
- Over-stubbing to "be safe" breaks actual behavior
- Test passes for wrong reason or fails mysteriously

**The fix:**
```julia
# GOOD: Stub at correct level
@testset "detects duplicate server" begin
    add_server(config; start=(args...) -> nothing)   # Config written, startup skipped
    @test_throws DuplicateServerError add_server(config; start=(args...) -> nothing)
end
```

### Gate Function

```
BEFORE stubbing any method:
  STOP - Don't stub yet

  1. Ask: "What side effects does the real method have?"
  2. Ask: "Does this test depend on any of those side effects?"
  3. Ask: "Do I fully understand what this test needs?"

  IF depends on side effects:
    Stub at lower level (the actual slow/external operation)
    OR use test doubles that preserve necessary behavior
    NOT the high-level method the test depends on

  IF unsure what test depends on:
    Run test with real implementation FIRST
    Observe what actually needs to happen
    THEN add minimal stubbing at the right level

  Red flags:
    - "I'll stub this to be safe"
    - "This might be slow, better stub it"
    - Stubbing without understanding the dependency chain
```

## Anti-Pattern 4: Incomplete Test Fixtures

**The violation:**
```julia
# BAD: Partial fixture - only fields you think you need
mock_response = (
    status = :success,
    data = (user_id = "123", name = "Alice"),
    # Missing: metadata that downstream code uses
)

# Later: breaks when code accesses response.metadata.request_id
```

**Why this is wrong:**
- **Partial fixtures hide structural assumptions** - You only included fields you know about
- **Downstream code may depend on fields you didn't include** - Silent failures
- **Tests pass but integration fails** - Fixture incomplete, real API complete
- **False confidence** - Test proves nothing about real behavior

**The Iron Rule:** Mock the COMPLETE data structure as it exists in reality, not just fields your immediate test uses.

**The fix:**
```julia
# GOOD: Mirror real API completeness
mock_response = (
    status = :success,
    data = (user_id = "123", name = "Alice"),
    metadata = (request_id = "req-789", timestamp = 1234567890),
    # All fields real API returns
)
```

### Gate Function

```
BEFORE creating test fixtures:
  Check: "What fields does the real API response contain?"

  Actions:
    1. Examine actual API response from docs/examples
    2. Include ALL fields system might consume downstream
    3. Verify fixture matches real response schema completely

  Critical:
    If you're creating a fixture, you must understand the ENTIRE structure
    Partial fixtures fail silently when code depends on omitted fields

  If uncertain: Include all documented fields
```

## Anti-Pattern 5: Integration Tests as Afterthought

**The violation:**
```
Implementation complete
No tests written
"Ready for testing"
```

**Why this is wrong:**
- Testing is part of implementation, not optional follow-up
- TDD would have caught this
- Can't claim complete without tests

**The fix:**
```
TDD cycle:
1. Write failing test
2. Implement to pass
3. Refactor
4. THEN claim complete
```

## When Stubs Become Too Complex

**Warning signs:**
- Stub setup longer than test logic
- Stubbing everything to make test pass
- Stubs missing methods real components have
- Test breaks when stub changes

**your human partner's question:** "Do we need to be using a stub here?"

**Consider:** Integration tests with real components often simpler than complex stubs

## TDD Prevents These Anti-Patterns

**Why TDD helps:**
1. **Write test first** -> Forces you to think about what you're actually testing
2. **Watch it fail** -> Confirms test tests real behavior, not stubs
3. **Minimal implementation** -> No test-only methods creep in
4. **Real dependencies** -> You see what the test actually needs before stubbing

**If you're testing stub behavior, you violated TDD** - you added stubs without watching test fail against real code first.

## Quick Reference

| Anti-Pattern | Fix |
|--------------|-----|
| Assert on stub elements | Test real component or remove stub |
| Test-only methods in production | Move to test utilities |
| Stub without understanding | Understand dependencies first, stub minimally |
| Incomplete test fixtures | Mirror real API completely |
| Tests as afterthought | TDD - tests first |
| Over-complex stubs | Consider integration tests |

## Red Flags

- Assertion checks for stub/mock test markers
- Methods only called in test files
- Stub setup is >50% of test
- Test fails when you remove stub
- Can't explain why stub is needed
- Stubbing "just to be safe"

## The Bottom Line

**Stubs are tools to isolate, not things to test.**

If TDD reveals you're testing stub behavior, you've gone wrong.

Fix: Test real behavior or question why you're stubbing at all.
