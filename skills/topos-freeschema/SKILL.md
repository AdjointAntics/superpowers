---
name: topos-freeschema
description: Use when defining refinement telescopes, validated schemas, or generating code for TypeScript, Lean, Avro, or SQL
---
# Topos FreeSchema

## When
Invoke when defining data schemas with constraints, generating cross-language type definitions, or working with validated construction and serialization in FreeSchema.

## Iron Laws
1. Schemas use `@schema` blocks with typed fields and constraint predicates.
2. Telescopes define dependent context sequences where later fields can reference earlier ones.
3. All generated code (TypeScript, Lean, Avro, SQL) must preserve schema constraints.
4. Validate all constructed instances against their schema constraints before use.

## Process
1. Define a refinement telescope with `@telescope [x::Int, y::String | y > 0, z::Float64 | z > x]`.
2. Define schemas with `@schema MySchema begin ... end`, declaring entities with typed fields and constraint predicates like `email::String | is_valid_email(email)`.
3. Construct validated instances and check constraints with `validate(telescope, value)`.
4. Serialize to JSON (`to_json`/`from_json`), TOML (`to_toml`/`from_toml`), or YAML (`to_yaml`/`from_yaml`).
5. Generate TypeScript types with `codegen_typescript(schema, "output.ts")`.
6. Generate Lean definitions with `codegen_lean(schema, "Output.lean")`.
7. Generate Avro schemas with `codegen_avro(schema, "schema.avsc")`.
8. Generate SQL DDL with `codegen_sql(schema, "schema.sql")`.
9. Run tests: `yon test FreeSchema`.
10. Run benchmarks: `yon bench FreeSchema`.

## Codegen Targets

| Target | Command | Generates |
|--------|---------|-----------|
| TypeScript | `codegen_typescript` | Interfaces, validators, serializers |
| Lean | `codegen_lean` | Type definitions |
| Avro | `codegen_avro` | `.avsc` schema files |
| SQL | `codegen_sql` | CREATE TABLE, constraints, indexes |

## Composability
Expects Theory protocols for algebraic structure. Produces validated schemas and cross-language type definitions consumed by Algebra and downstream packages.
