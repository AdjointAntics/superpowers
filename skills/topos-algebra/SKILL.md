---
name: topos-algebra
description: Free/cofree constructions, effects, monad transformers, and the Algebra package in Topos
---

# Topos Algebra

## Overview

Algebra implements the **Free/Cofree duality** - syntax vs observation. It merges free constructions (effects, monad transformers) and cofree comonad in one package.

## Core Duality

```
Algebra/Free  <->  Algebra/Cofree
   (syntax)        (observation)
```

- **Free**: Build syntax from descriptions (effect handlers, monads)
- **Cofree**: Observe behavior from data (comonads, streams)

## Packages Dependencies

Algebra depends on:
- Theory (core abstractions)
- YonedaStyle (display)
- Testy (testing)
- FreeSchema (schema support)

## Free Constructions

### Free Monads

```julia
using Algebra

# Define effect signature
@sig EffectF{X} = Return{X} | IO{X}

# Build free monad
free_effect = Free{EffectF}(io_action)

# Run it
result = run(free_effect)
```

### Free Applicative

```julia
# Build applicative from pure + lift
pure_value = pure(5)
lifted_fn = lift_applicative(fn, arg1, arg2)
```

### Free Functor

```julia
# Functorial mapping
mapped = fmap(f, free_expr)
```

## Cofree Constructions

### Cofree Comonad

```julia
using Algebra

# Build cofree from observation
cofree_state = cofree{State}(initial, observe_fn)

# Extract observations
observations = extract(cofree_state)

# Extend with new behavior
extended = extend(cofree_state, new_observe)
```

### Anamorphisms (Cofree streams)

```julia
# Unfold from seed
stream = ana(coalg, seed)
```

## Effects and Handlers

### Effect Signature

```julia
@sig Stateful{X} = 
    Get{X} |
    Put{X}
```

### Effect Handler

```julia
function handle_stateful(effect, state)
    @match effect begin
        Get{_} => (state, state)
        Put{s} => ((), s)
    end
end
```

### Running Effects

```julia
# Run free effect with handler
result = run_effect(free_expr, handler, initial_state)
```

## Monad Transformers

### Transformer Stack

```julia
# Compose transformers
Stack = StateT ∘ ErrorT ∘ IO

# Lift into stack
lifted = lift(Stack, pure_value)
```

### Common Transformers

| Transformer | Effect |
|-------------|--------|
| StateT | State threading |
| ErrorT | Error handling |
| ReaderT | Environment |
| WriterT | Logging |
| IO | Side effects |

## Algebraic Laws

Every categorical construction MUST be tested:

### Functor Laws

```julia
@test fmap(id, fx) == fx
@test fmap(f ∘ g, fx) == fmap(f, fmap(g, fx))
```

### Monad Laws

```julia
# Left identity
@test (return >=> f)(x) == f(x)

# Right identity  
@test (m >=> return)(x) == m(x)

# Associativity
@test ((f >=> g) >=> h)(x) == (f >=> (g >=> h))(x)
```

### Comonad Laws

```julia
# Left identity
@test extend(extract, w) == w

# Right identity
@test extract(extend(f, w)) == f(w)

# Associativity
@test extend(f, extend(g, w)) == extend(x -> extend(f, x), w)
```

## Testing

```sh
yon test Algebra
yon bench Algebra
```

### Test Files

- `test/test_free.jl` - Free constructions
- `test/test_cofreeree constructions
- `test/test_effects.jl` - Effect handlers
- `test/test_transform.jl` - Cofers.jl` - Monad transformers

## Key Types

| Type | Purpose |
|------|---------|
| `Free{F, A}` | Free functor/monad over signature F |
| `Cofree{F, A}` | Cofree comonad over signature F |
| `Lift{F}` | Lifting into free |
| `Handle` | Effect handler |

## Integration with superpowers

Use with:
- **superpowers:topos-yon-cli** - For running tests
- **superpowers:topos-testing** - For law verification
- **superpowers:topos-theory-foundations** - For understanding categories
- **superpowers:topos-freeschema** - For schema-based generation

## Common Patterns

### Creating Effects

```julia
# Define signature
@sig MyEffect{X} = 
    Read{X} |
    Write{X}

# Build
read_action = inject(Read, get_value)
write_action = inject(Write, "message")
```

### Handling Effects

```julia
function handle(effect, state)
    # Match and transform
end

# Run
run(handle, initial_state, effect_expr)
```

### Building Transformers

```julia
# Stack transformers
MyT = StateT{Int} ∘ ErrorT ∘ IO

# Lift base values
lifted_io = lift(MyT, IO, value)

# Run stack
result = run_stack(MyT, lifted_io)
```

## References

- Algebra/src/Free/
- Algebra/src/Cofree/
- Test files in packages/Algebra/test/
