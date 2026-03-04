---
name: categorical-reframing
description: Use to reframe any development concept, problem, or process through the lens of category theory - enabling deeper abstraction and clearer reasoning
---

# Categorical Reframing

## Overview

Category theory provides a universal language for understanding software development. This skill maps everyday development concepts to their categorical counterparts, enabling:

- Deeper abstraction through universal properties
- Clearer reasoning about composition and structure
- Identifying dual problems and solutions
- Finding optimal solutions via adjunctions

## Core Mappings

### Development Concepts → Category Theory

| Development Concept | Category Theory Mapping |
|---------------------|------------------------|
| Function/method | **Morphism** (arrow between objects) |
| Type/class | **Object** (in a category) |
| Interface/protocol | **Universal property** |
| Refactoring | **Isomorphism** (same behavior, different representation) |
| Testing | **Property verification** (preservation of structure) |
| Bug | **Kernel** of a morphism (where it fails to preserve structure) |
| Debugging | **Kernel tracing** - finding where structure breaks |
| Feature | **New morphism** in the category |
| Composition | **Morphism composition** (f ∘ g) |
| Dependency injection | **Functor** (mapping between categories) |
| Pattern | **Natural transformation** |
| Refinement | **Monomorphism** (specialization) |
| Generalization | **Epimorphism** (broadening) |
| State management | **Morphism to/from state object** |
| Error handling | **Zero object** (null) or **coproduct** (Either type) |
| Empty case | **Initial object** |
| Default case | **Terminal object** |

### The Universal Property Technique

When facing a design decision, ask:

> "What is the **universal property** that characterizes the ideal solution?"

This is finding the **initial object** in the category of solutions satisfying certain constraints.

**Example:**
- Instead of "How should we structure this cache?"
- Ask "What is the universal property of an ideal cache?"
- Answer: "Given any computation, the cache either returns a stored value or computes fresh - this is a universal mapping from time to value"

### Duality Principle

Every concept has a **dual** - flip the arrows. Use this to find complementary perspectives:

| Concept | Dual |
|---------|------|
| Push (emit) | Pull (subscribe) |
| Push down (complexity) | Pull up (abstraction) |
| Producer | Consumer |
| Strict evaluation | Lazy evaluation |
| Eager composition | Lazy composition |

**Example:**
- Problem: "How do we push updates efficiently?"
- Dual question: "How do we pull updates efficiently?"
- Considering both often reveals the optimal solution

### Adjunction Thinking

An **adjunction** is when one operation is the optimal solution to an optimization problem defined by another.

**The Adjunction Pattern:**
```
Left adjoint = "Free" construction (minimal structure)
Right adjoint = "Co-free" construction (maximal structure)
```

**Examples in development:**
- `map` is left adjoint to `flatMap` (free monad construction)
- `Promise.all` is left adjoint to... (think about what preserves more structure)
- Validation (accumulate all errors) vs. Fail-fast (short-circuit)

## How to Use This Skill

### Step 1: Identify the Concept

What are you working with? A function, type, pattern, problem, process?

### Step 2: Find Its Categorical Mapping

Use the Core Mappings table above to find the category theory equivalent.

### Step 3: Apply Categorical Reasoning

Ask categorical questions:
- What is the **domain** and **codomain** of this morphism?
- What **commutes** with what?
- Is this an **isomorphism**? A **monomorphism**? An **epimorphism**?
- What is the **universal property** we're preserving?
- What is the **dual** of this problem?

### Step 4: Translate Back

Apply the categorical insight to the concrete implementation.

## Example Dialogues

### Example 1: Choosing a Data Structure

**Dev:** "Should we use an array or a linked list?"

**Categorical reframing:**
- Array = **sequence** with random access (product structure)
- Linked list = **coinductive** structure (great for streaming)
- Question: What is the **morphism** we're optimizing for?
- If iteration: linked list is **isomorphic** to array in some categories
- If random access: array is **terminal** in the access-time category

**Insight:** Choose based on the **category of operations** you need.

### Example 2: Error Handling Strategy

**Dev:** "Should we use exceptions or Result types?"

**Categorical reframing:**
- Exceptions = **throw to caller** (non-local goto)
- Result types = **explicit morphism** to error category
- Exceptions break **composability** - they don't preserve morphism structure
- Result types form a **monad** - composition-friendly

**Insight:** Result types preserve the categorical structure of composition.

### Example 3: API Design

**Dev:** "Should this function take many parameters or a config object?"

**Categorical reframing:**
- Many parameters = **product** of domains
- Config object = **record** (product in type theory)
- Question: What is the **universal property** of this function?
- If parameters are independent → product makes sense
- If parameters have dependencies → need **dependent types** (pullback)

**Insight:** Use product types for independent parameters, dependent types for related ones.

## Integration

This skill complements:
- **brainstorming**: Apply categorical framing when exploring approaches
- **test-driven-development**: Tests verify universal properties
- **systematic-debugging**: Find the kernel of the failure

## The Category Theory Mindset

1. **Everything is a morphism** - focus on relationships, not just objects
2. **Composition is fundamental** - build complex from simple
3. **Universal properties** - characterize ideal solutions
4. **Duality** - every problem has a complementary view
5. **Structure preservation** - functors preserve structure; breakages are bugs
