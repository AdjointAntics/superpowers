---
name: strict-custom-rules
description: Use when creating domain-specific lint rules for Strict, composing rules via product/sum, or registering custom rules globally or per-project
---
# Strict Custom Rules

## When
Invoke when the built-in Strict rules do not cover your domain requirements and you need to define, compose, or register custom lint rules.

## Iron Laws
1. Every custom rule must subtype `Strict.Rule` and implement `Strict.check()`.
2. Register metadata (name, category, description) for every rule.
3. Prefer composing existing rules over writing new ones from scratch.
4. Test custom rules against known-violating and known-clean code before registering.

## Process
1. Define a custom rule struct:
   ```julia
   struct NoGlobals <: Strict.Rule
       allow_readonly::Bool
   end
   ```
2. Implement the check function:
   ```julia
   function Strict.check(rule::NoGlobals, node::Expr)
       violations = Violation[]
       for n in traverse(node)
           if is_global(n)
               push!(violations, Violation(
                   rule=:no_globals, node=n,
                   message="Global variable reference: $(n)",
                   severity=:warning
               ))
           end
       end
       return violations
   end
   ```
3. Register metadata:
   ```julia
   Strict.rule_name(::Type{NoGlobals}) = :no_globals
   Strict.category(::Type{NoGlobals}) = :warning
   Strict.description(::Type{NoGlobals}) = "Disallow global variable references"
   ```
4. Compose rules with product and sum:
   ```julia
   strict = @rule NoGlobals x NoShadowing      # product: all must pass
   permissive = @rule NoGlobals + NoTypePiracy  # sum: any triggers
   ```
5. Set rule precedence:
   ```julia
   config = @rule precedence(critical_rule, warning_rule, style_rule)
   ```
6. Register globally: `Strict.register_rule!(NoGlobals)`.
7. Register per-project: `Strict.register_rule!(NoGlobals; scope=:project)`.
8. For stateful rules, use mutable state and `Strict.check!()`:
   ```julia
   struct StatefulRule <: Strict.Rule
       seen::Set{Symbol}
   end
   function Strict.check!(rule::StatefulRule, node::Expr)
       push!(rule.seen, get_symbol(node))
       check_with_state(rule, node)
   end
   ```

## Composability
Expects a `Strict.Rule` subtype with `check()` implementation. Produces `Violation` values compatible with the strict-linting pipeline. Compose multiple custom rules into product or sum configurations.
