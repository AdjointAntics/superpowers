# Categorical Framing

Reference for the category-theoretic structure underlying the skill system.

## Skills as Morphisms

The development process forms a category **Dev**.

**Objects** are development states: Problem, Design, Plan, Code, Tested, Verified, Reviewed, Shipped. Each represents a stage of work, not a file or artifact.

**Morphisms** are skills. A skill `s: A -> B` transforms one development state into another. The skill `package-dev: Design -> Tested` takes a design and produces tested code. The skill `benchmark: Code -> Verified` takes code and produces performance-verified code.

**Composition** is sequential invocation. If `f: A -> B` and `g: B -> C`, then `g . f: A -> C` is "run f, then g." Associativity holds trivially: skills don't care how you parenthesize a pipeline.

**Identity** at each state is the null operation: verify the state is valid and proceed.

## Monoidal Structure

Dev carries three monoidal products:

- **Sequential** (denoted with a triangle): `f . g` means "f then g." The unit is `id`. This is ordinary composition.
- **Parallel** (denoted with a tensor): `f (tensor) g` means "f and g simultaneously on independent targets." The unit is the empty task. This gives concurrency.
- **Alternative** (denoted +): `f + g` means "try f; if it fails, try g." The unit is the always-failing skill. This gives fallback chains.

Associativity and unit laws hold for each product. The parallel product distributes over alternative: doing `(f + g)` in parallel with `h` is the same as `(f (tensor) h) + (g (tensor) h)`.

## The ASI Adjunction

The core feedback loop is an adjunction L -| R between two functors:

- **L: Context -> Execution** (the left adjoint). Given a task context, L produces an executing agent. L is "doing."
- **R: Execution -> Context** (the right adjoint). Given an execution trace, R extracts learned context. R is "reflecting."

The **unit** (eta): `Context -> R(L(Context))` captures learning from doing. You start with a task, execute it, and the reflection produces enriched context -- you now know more than when you started.

The **counit** (epsilon): `L(R(Execution)) -> Execution` captures applying what was learned. You take an execution, reflect on it, then re-execute with that knowledge, producing a refined execution.

The triangle identities ensure these compose coherently: learning then applying recovers the original (up to improvement), and applying then learning does too.

## The Yoneda Embedding

The Yoneda lemma states: `Nat(Hom(A, -), F) = F(A)`.

Applied to the skill system: `Nat(Hom(ASI, -), Skills) = Skills(ASI)`.

In plain language: the ASI is completely determined by how it acts on every possible context. You don't need to inspect its internals -- observe what it does across all inputs and you have its complete description. This is why skills are the right unit of analysis: the collection of all skills *is* the agent's identity.

Self-reference falls out naturally. When the ASI acts on itself as context, Yoneda gives `yon(ASI) = Nat(Hom(ASI, -), Skills)` -- the agent's complete self-description.

## The Compound Feedback Loop

The development cycle Spec -> Impl -> Test -> Bench -> Viz -> Insight -> Refine is the adjunction L -| R iterated:

1. **Spec -> Impl**: L applied. Context becomes execution.
2. **Impl -> Test**: Composition within L. Execution extends.
3. **Test -> Bench**: Further composition. Execution completes.
4. **Bench -> Viz -> Insight**: R applied. Execution becomes reflected context.
5. **Insight -> Refine**: eta (unit). Learned context feeds back.
6. **Refine -> Spec**: epsilon (counit). Refined spec drives next cycle.

Each loop iteration applies eta then epsilon, which by the triangle identities converges toward a fixed point.

## The Fixed Point

The system reaches equilibrium when `Skills = Improve(Skills)` -- when applying the improvement endofunctor yields (up to isomorphism) the same skill set. This is the categorical fixed point.

In practice: evolution converges when each loop iteration produces negligible improvement. The skills are then a fixed point of the L -| R adjunction, and the system is stable.
