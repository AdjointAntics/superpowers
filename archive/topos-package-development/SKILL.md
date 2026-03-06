---
name: topos-package-development
description: Create new packages in the Topos monorepo, implement yon() identity, and work with dependency tiers
---

# Topos Package Development

## Overview

Topos is a tiered monorepo where every package must implement `yon()` for self-description. Package development follows strict dependency rules.

## Package Structure

Each package lives in `packages/<PkgName>/` with:

```
packages/<Pkg>/
├── src/
│   └── <Pkg>.jl      # Main module + exports
├── test/
│   └── test_*.jl    # Test files
├── bench/
│   └── *_benchmark.jl
├── Project.toml
├── README.md
└── CLAUDE.md         # Package-specific guidance
```

## Tier System

Packages are organized by dependency tier:

| Tier | Packages | Rule |
|------|----------|------|
| T0 | Theory, YonedaStyle, HomTime | Zero or only stdlib deps |
| T1 | Algebra, Poly, Strict | Deps on T0 only |
| Higher | Future packages | Deps on T0/T1 only |

**Rule**: No transitive chains longer than 1. Flat dependency graph.

## Creating a New Package

### Step 1: Create Directory

```sh
mkdir -p packages/NewPkg/src packages/NewPkg/test
```

### Step 2: Create Project.toml

```toml
name = "NewPkg"
uuid = "generate-a-uuid"  # use uuidgen or Julia's UUIDs
authors = ["Your Name <email>"]
version = "0.1.0"

[deps]
# Only Topos local packages - no external deps for T0
# For T1: Theory = { path = "../Theory" }
```

### Step 3: Create Main Module

```julia
# src/NewPkg.jl
module NewPkg

using PkgVersion @version

export yon

"""
NewPkg - description of what this package provides
"""
function yon()
    (
        name="NewPkg",
        version=v"0.1.0",
        description="What this package does",
        deps=[],  # or [(name="Theory", ...), ...]
        exports=[:yon, :exported_function]
    )
end

# Your code here

end
```

### Step 4: Implement Package

Write the actual functionality following Topos conventions.

### Step 5: Add Tests

Create `test/test_*.jl` files testing all categorical laws.

### Step 6: Test

```sh
yon test NewPkg
yon check NewPkg
```

## Implementing yon()

Every package MUST export `yon()` returning its identity:

```julia
function yon()
    (
        name="PkgName",
        version=pkgversion(@__MODULE__),
        description="What this package provides",
        deps=[  # Topos local deps only
            (name="Theory", version=v"0.1.0", path="../Theory"),
            (name="YonedaStyle", version=v"0.1.0", path="../YonedaStyle"),
        ],
        exports=[:yon, :public_symbol1, :public_symbol2]
    )
end
```

### Identity Fields

| Field | Description |
|-------|-------------|
| `name` | Package name (String) |
| `version` | Version (use `pkgversion(@__MODULE__)`) |
| `description` | Brief description of purpose |
| `deps` | Vector of (name, version, path) tuples |
| `exports` | Vector of exported symbols |

### Getting Exports

Use `_public_names(@__MODULE__)` from Theory if available:

```julia
exports = _public_names(@__MODULE__)
```

## Dependency Rules

### Allowed Dependencies

- Julia stdlibs (Random, Statistics, etc.)
- Local Topos packages only
- NO external packages for T0 (foundations)
- T1 can depend on T0 packages

### Adding Dependencies

```toml
[deps]
Theory = { path = "../Theory" }
YonedaStyle = { path = "../YonedaStyle" }
```

### Zero-Dependency (T0)

For foundational packages:
```toml
[deps]
# Empty - no external deps allowed
```

## Package Conventions

### Naming

- `PascalCase` for modules
- `snake_case` for functions
- `TitleCase.jl` for files

### Structs

```julia
# Immutable by default
struct MyType{T}
    field1::T
    field2::Int
end

# All fields typed
```

### Docstrings

Every public symbol needs:

```julia
"""
    function_name(arg1::Type1, arg2::Type2) -> ReturnType

Brief description.

## Arguments
- `arg1::Type1`: What it does
- `arg2::Type2`: What it does

## Returns
Description of return value.

## Examples
```julia
julia> function_name(x, y)
result
```
"""
function function_name(arg1, arg2)
    # implementation
end
```

### Exports

Only export what users need. Use:

```julia
export yon, public_function, PublicType
```

Don't export internal `_function`.

## Testing Requirements

Every categorical abstraction MUST have law tests:

```julia
# test/test_functor.jl
function test_functor_identity(f, x)
    @test fmap(identity, x) == x
end

function test_functor_compose(f, x)
    @test fmap(f ∘ g, x) == fmap(f, fmap(g, x))
end
```

## Verification

```sh
# Run tests
yon test NewPkg

# Check compilation
yon check NewPkg

# Lint
yon lint NewPkg

# View identity
yon eval NewPkg 'yon()'
```

## Package-Specific Guidance

Always read `packages/<Pkg>/CLAUDE.md` before modifying.

### Existing Packages

| Package | Purpose | Tier |
|---------|---------|------|
| Theory | Algebraic theory protocols, Yoneda, recursion schemes | T0 |
| YonedaStyle | ANSI styling, trees, tables | T0 |
| HomTime | Hom-functor measurement | T0 |
| Testy | Property testing, law suites | T0 |
| FreeSchema | Refinement telescopes, codegen | T0 |
| Algebra | Free/cofree constructions | T1 |
| Poly | Polynomial functors, optics | T1 |
| Strict | Functor-based linting | T1 |

## Red Flags

- Don't add external dependencies to T0 packages
- Don't skip implementing `yon()`
- Don't forget categorical law tests
- Don't export internal functions
- Don't use untyped struct fields

## Integration with superpowers

Use with:
- **superpowers:topos-yon-cli** - For testing and verification
- **superpowers:topos-testing** - For law testing
- **superpowers:topos-theory-foundations** - For understanding abstractions
