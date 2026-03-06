---
name: topos-linting
description: Use when linting Julia code with Strict -- functor-based AST analysis, auto-fix, naming conventions, and CI integration
---
# Topos Linting

## When
Invoke when checking code quality, enforcing naming conventions, or auto-fixing style violations across Topos packages using Strict.

## Iron Laws
1. Run `yon lint` before every commit. Run `yon fix` to auto-correct fixable issues.
2. All public APIs must have docstrings. All struct fields must be typed.
3. Follow naming conventions: `snake_case` functions, `PascalCase` types, `TitleCase.jl` files.
4. `test_package_rules.jl` has 2 known failures in package self-analysis -- this is not a bug.

## Process
1. Lint all packages: `yon lint`.
2. Lint a specific package: `yon lint Algebra`.
3. Auto-fix issues: `yon fix`.
4. Run verbose: `yon -v lint`.
5. For custom lint rules, define a struct extending `Strict.Rule` and implement `Strict.check(rule, ast)`.
6. Add linting to CI:
   ```yaml
   - run: yon lint
   ```

## Naming Conventions
- Functions: `snake_case`
- Types: `PascalCase`
- Files: `TitleCase.jl`
- Internals: `_prefixed`

## Style Rules
- No global state.
- Typed struct fields required.
- Docstrings on all public APIs.
- Type stability hints for performance-critical paths.
- Allocation warnings on hot loops.

## Custom Linter Pattern
```julia
using Strict
struct NoGlobals <: Strict.Rule end
function Strict.check(rule::NoGlobals, ast)
    # Find global variables, return violations
end
```

## Composability
Expects Julia source files in standard package layout. Produces lint reports and auto-fixed source files consumed by CI and development workflows.
