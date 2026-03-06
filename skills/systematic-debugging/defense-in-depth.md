# Defense-in-Depth Validation

## Overview

When you fix a bug caused by invalid data, adding validation at one place feels sufficient. But that single check can be bypassed by different code paths, refactoring, or mocks.

**Core principle:** Validate at EVERY layer data passes through. Make the bug structurally impossible.

## Why Multiple Layers

Single validation: "We fixed the bug"
Multiple layers: "We made the bug impossible"

Different layers catch different cases:
- Entry validation catches most bugs
- Business logic catches edge cases
- Environment guards prevent context-specific dangers
- Debug logging helps when other layers fail

## The Four Layers

### Layer 1: Entry Point Validation
**Purpose:** Reject obviously invalid input at API boundary

```julia
function create_project(name::String, working_directory::String)
    isempty(strip(working_directory)) &&
        throw(ArgumentError("working_directory cannot be empty"))
    !isdir(working_directory) &&
        throw(ArgumentError("working_directory does not exist: $working_directory"))
    # ... proceed
end
```

### Layer 2: Business Logic Validation
**Purpose:** Ensure data makes sense for this operation

```julia
function initialize_workspace(project_dir::String, session_id::String)
    isempty(project_dir) &&
        throw(ArgumentError("project_dir required for workspace initialization"))
    # ... proceed
end
```

### Layer 3: Environment Guards
**Purpose:** Prevent dangerous operations in specific contexts

```julia
function git_init(directory::String)
    # In tests, refuse git init outside temp directories
    if get(ENV, "JULIA_ENV", "") == "test"
        normalized = abspath(directory)
        tmp = abspath(tempdir())

        if !startswith(normalized, tmp)
            error("Refusing git init outside temp dir during tests: $directory")
        end
    end
    # ... proceed
end
```

### Layer 4: Debug Instrumentation
**Purpose:** Capture context for forensics

```julia
function git_init(directory::String)
    st = stacktrace()
    @debug "About to git init" directory pwd=pwd() stack=st
    # ... proceed
end
```

## Applying the Pattern

When you find a bug:

1. **Trace the data flow** - Where does bad value originate? Where used?
2. **Map all checkpoints** - List every point data passes through
3. **Add validation at each layer** - Entry, business, environment, debug
4. **Test each layer** - Try to bypass layer 1, verify layer 2 catches it

## Example from Session

Bug: Empty `project_dir` caused `git init` in source code

**Data flow:**
1. Test setup -> empty string
2. `create_project("name", "")`
3. `create_workspace("")`
4. `git init` runs in `pwd()`

**Four layers added:**
- Layer 1: `create_project()` validates not empty/exists/writable
- Layer 2: `create_workspace()` validates project_dir not empty
- Layer 3: `git_init()` refuses git init outside tmpdir in tests
- Layer 4: Stack trace logging before git init

**Result:** All 1847 tests passed, bug impossible to reproduce

## Key Insight

All four layers were necessary. During testing, each layer caught bugs the others missed:
- Different code paths bypassed entry validation
- Mocks bypassed business logic checks
- Edge cases on different platforms needed environment guards
- Debug logging identified structural misuse

**Don't stop at one validation point.** Add checks at every layer.
