---
name: topos-linting
description: Strict linter - functor-based AST analysis and code quality in Topos
---

# Topos Linting

## Overview

Strict provides functor-based AST analysis as a Julia linter. It uses categorical principles (functors) to transform and analyze code.

## Running Linting

```sh
# Lint all packages
yon lint

# Lint specific package
yon lint Algebra

# Auto-fix issues
yon fix

# Verbose
yon -v lint
```

## How It Works

Strict uses functors to analyze AST:

```julia
using Strict

# Define linting functor
struct MyLinter <: Strict.Linter
    # Configuration
end

# Transform AST
transform(linter::MyLinter, ast) = # analyze
```

## Lint Rules

### Naming Conventions

- Functions: `snake_case`
- Types: `PascalCase`
- Files: `TitleCase.jl`

### Style Rules

- No global state
- Typed struct fields required
- Docstrings on public APIs

### Performance Rules

- Type stability hints
- Allocation warnings

## Custom Linters

```julia
using Strict

# Create custom rule
struct NoGlobals <: Strict.Rule end

function Strict.check(rule::NoGlobals, ast)
    # Find global variables
    # Return violations
end
```

## Integration

Linting runs in CI:

```yaml
# .github/workflows/ci.yml
- run: yon lint
```

## Testing

```sh
yon lint
yon fix
```

## Known Issues

From CLAUDE.md:
- `test_package_rules.jl` has 2 known failures in package self-analysis
- Not a bug - Strict analyzes its own package structure

## Integration with superpowers

Use with:
- **superpowers:topos-yon-cli** - For running lint
