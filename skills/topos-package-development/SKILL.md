---
name: topos-package-development
description: Use when creating or modifying packages in the Topos monorepo -- directory structure, tiers, yon() identity, and conventions
---
# Topos Package Development

## When
Invoke when creating a new package, adding dependencies, implementing the `yon()` identity function, or ensuring a package follows Topos monorepo conventions.

## Iron Laws
1. Every package MUST export `yon()` returning `(name, version, description, deps, exports)`.
2. T0 packages have zero external dependencies. T1 depends on T0 only. No transitive chains longer than 1.
3. Every categorical abstraction MUST have algebraic law tests.
4. All struct fields must be typed. All public symbols must have docstrings.
5. Always read `packages/<Pkg>/CLAUDE.md` before modifying a package.

## Process
1. Create directory structure: `mkdir -p packages/NewPkg/src packages/NewPkg/test packages/NewPkg/bench`.
2. Create `Project.toml` with name, uuid, version. For T1, add path deps: `Theory = { path = "../Theory" }`.
3. Create `src/NewPkg.jl` with module, `yon()` export, and implementation.
4. Implement `yon()` returning the package identity NamedTuple.
5. Write `test/test_*.jl` files covering all categorical laws.
6. Run `yon test NewPkg` and `yon check NewPkg`.
7. Run `yon lint NewPkg` and `yon eval NewPkg 'yon()'`.

## Package Directory Structure
```
packages/<Pkg>/
  src/<Pkg>.jl       # Main module + exports
  test/test_*.jl     # Test files (auto-discovered)
  bench/*_benchmark.jl
  Project.toml
  CLAUDE.md          # Package-specific guidance
```

## Tier System

| Tier | Packages | Rule |
|------|----------|------|
| T0 | LawKit, Theory, YonedaStyle, HomTime | Zero or stdlib deps only |
| T1 | Yoneda, ExprFunctor | Deps on T0 only |
| T2 | Initial, Terminal | Deps on T0-T1 |
| T3 | Free, Cofree, Poly | Deps on T0-T2 |
| T4 | PolyModes | Deps on T0-T3 |
| App | Strict | Theory + stdlib |

## yon() Implementation Template
```julia
function yon()
    (
        name="NewPkg",
        version=pkgversion(@__MODULE__),
        description="What this package provides",
        deps=[(name="Theory", version=v"0.1.0", path="../Theory")],
        exports=_public_names(@__MODULE__)
    )
end
```

## Conventions
- **Naming**: `snake_case` functions, `PascalCase` types, `TitleCase.jl` files, `_prefix` internals.
- **Structs**: Immutable by default. All fields typed.
- **Docstrings**: Signature line, blank line, substantive explanation on every public symbol.
- **Exports**: Only export what users need. Never export `_internal` functions.

## Composability
Expects the Topos monorepo structure with `packages/` directory. Produces a fully conformant package that integrates with `yon test`, `yon bench`, `yon lint`, and `yon check`.
