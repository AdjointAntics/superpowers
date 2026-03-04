---
name: topos-freeschema
description: Refinement telescopes, validated construction, and codegen for TypeScript, Lean, Avro in Topos
---

# Topos FreeSchema

## Overview

FreeSchema implements refinement telescopes - dependent context sequences with constraints. Provides validated construction, serialization, and cross-language codegen.

## Core Concepts

### Refinement Telescope

A telescope is a sequence of types with constraints:

```julia
using FreeSchema

# Define telescope
telescope = @telescope [
    x::Int,
    y::String | y > 0,
    z::Float64 | z > x
]
```

### Schema

A schema defines types and relationships:

```julia
# Define schema
@schema MySchema begin
    User
        id::UUID
        name::String
        email::String | is_valid_email(email)
    
    Post
        id::UUID
        user_id::User.id
        title::String
        content::String
end
```

## Validation

### Construction

```julia
# Build with validation
user = User(;
    id=uuid4(),
    name="Alice",
    email="alice@example.com"
)
```

### Constraint Checking

```julia
# Validate constraint
validate(telescope, value)

# Get refinement path
path = refinement_path(schema, type)
```

## Serialization

### JSON

```julia
using FreeSchema.Repr

# Encode
json = to_json(schema, instance)

# Decode
instance = from_json(schema, json)
```

### TOML

```julia
# Encode
toml = to_toml(schema, instance)

# Decode
instance = from_toml(schema, toml)
```

### YAML

```julia
# Encode
yaml = to_yaml(schema, instance)

# Decode
instance = from_yaml(schema, yaml)
```

## Codegen

### TypeScript

```typescript
# Generate TypeScript types
codegen_typescript(schema, "output.ts")
```

Generates:
- Interface definitions
- Validation functions
- Serialization helpers

### Lean

```lean
# Generate Lean definitions
codegen_lean(schema, "Output.lean")
```

### Avro

```avro
# Generate Avro schema
codegen_avro(schema, "schema.avsc")
```

### SQL DDL/DML

```sql
-- Generate SQL
codegen_sql(schema, "schema.sql")

-- CREATE TABLE statements
-- Constraints
-- Indexes
```

## Testing

```sh
yon test FreeSchema
yon bench FreeSchema
```

## Integration with superpowers

Use with:
- **superpowers:topos-yon-cli** - For running tests
- **superpowers:topos-testing** - For validation testing
- **superpowers:topos-algebra** - For free constructions

## References

- FreeSchema/src/
- FreeSchema/codegen/
- FreeSchema/repr/
