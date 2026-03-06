---
name: strict-linting
description: Use when linting Julia code, analyzing AST for violations, running yon lint/fix, or configuring lint rules -- uses Strict's analyze() API and 118 built-in rules
---
# Strict Linting

## When
Invoke when you need to lint Julia source files, detect code quality issues, auto-fix violations, or programmatically analyze expressions, files, or modules.

## Iron Laws
1. Run `yon lint` before committing any Julia code.
2. Address all `:error` severity violations -- warnings may be deferred.
3. Configure rules per-project via `StrictConfig` rather than disabling globally.
4. Use `analyze()` programmatically when integrating lint into CI or tooling.

## Process
1. Lint from CLI:
   ```sh
   yon lint            # all packages
   yon lint Algebra     # specific package
   yon fix              # auto-fix
   ```
2. Analyze programmatically:
   ```julia
   using Strict
   violations = analyze(:(x + y))           # single expression
   violations = analyze_file("src/Mod.jl")  # file
   violations = analyze_module(MyModule)     # module
   ```
3. Configure rules:
   ```julia
   config = StrictConfig()
   config.rules[:unused_assignment] = true
   config.rules[:complex_boolean] = false
   result = analyze(code; config=config)
   ```
4. Inspect violations -- each has fields: `rule::Symbol`, `node::Expr`, `message::String`, `severity` (`:error`/`:warning`/`:info`), `line`, `column`.
5. Compose rules: `strict_rules = warning_rules <otimes> performance_rules` (product -- all must pass); `permissive_rules = warning_rules <oplus> performance_rules` (sum -- any triggers).

### Rule Categories

| Category | Description |
|----------|-------------|
| Warning | Potential issues (unused assignment, shadowed variable, unreachable code) |
| Performance | Efficiency issues (allocation in loop, constant condition, val with runtime arg) |
| Readability | Style violations (complex boolean, single-letter variables, needless else) |
| Correctness | Semantic errors |

### Built-in Rules (Selection)
`:unused_assignment`, `:shadowed_variable`, `:unreachable_code`, `:allocation_in_loop`, `:constant_condition`, `:val_with_runtime_arg`, `:complex_boolean`, `:no_single_letter_variables`, `:needless_else`

## Composability
Expects Julia source code (expressions, files, or modules). Produces `Violation` values for reporting or CI gating. Pairs with strict-custom-rules for domain-specific rules and homtime-optimization for benchmarking lint performance.
