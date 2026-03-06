---
name: writing-plans
description: Use when you have a spec or requirements for a multi-step task, before touching code
---

# Writing Plans

## Overview

Write comprehensive implementation plans assuming the engineer has zero context for our codebase and questionable taste. Document everything they need to know: which files to touch for each task, code, testing, docs they might need to check, how to test it. Give them the whole plan as bite-sized tasks. DRY. YAGNI. TDD. Frequent commits.

Assume they are a skilled developer, but know almost nothing about our toolset or problem domain. Assume they don't know good test design very well.

**Announce at start:** "I'm using the writing-plans skill to create the implementation plan."

**Context:** This should be run in a dedicated worktree (created by brainstorming skill).

**Save plans to:** `docs/plans/YYYY-MM-DD-<feature-name>.md`

## Bite-Sized Task Granularity

**Each step is one action (2-5 minutes):**
- "Write the failing test" - step
- "Run it to make sure it fails" - step
- "Implement the minimal code to make the test pass" - step
- "Run the tests and make sure they pass" - step
- "Commit" - step

## Plan Document Header

**Every plan MUST start with this header:**

```markdown
# [Feature Name] Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** [One sentence describing what this builds]

**Architecture:** [2-3 sentences about approach]

**Tech Stack:** [Key technologies/libraries]

---
```

## Task Structure

````markdown
### Task N: [Component Name]

**Files:**
- Create: `exact/path/to/file.py`
- Modify: `exact/path/to/existing.py:123-145`
- Test: `tests/exact/path/to/test.py`

**Step 1: Write the failing test**

```python
def test_specific_behavior():
    result = function(input)
    assert result == expected
```

**Step 2: Run test to verify it fails**

Run: `pytest tests/path/test.py::test_name -v`
Expected: FAIL with "function not defined"

**Step 3: Write minimal implementation**

```python
def function(input):
    return expected
```

**Step 4: Run test to verify it passes**

Run: `pytest tests/path/test.py::test_name -v`
Expected: PASS

**Step 5: Commit**

```bash
git add tests/path/test.py src/path/file.py
git commit -m "feat: add specific feature"
```
````

## Remember
- Exact file paths always
- Complete code in plan (not "add validation")
- Exact commands with expected output
- Reference relevant skills with @ syntax
- DRY, YAGNI, TDD, frequent commits

## Execution Handoff

After saving the plan, offer execution choice:

**"Plan complete and saved to `docs/plans/<filename>.md`. Two execution options:**

**1. Subagent-Driven (this session)** - I dispatch fresh subagent per task, review between tasks, fast iteration

**2. Parallel Session (separate)** - Open new session with executing-plans, batch execution with checkpoints

**Which approach?"**

**If Subagent-Driven chosen:**
- **REQUIRED SUB-SKILL:** Use superpowers:subagent-driven-development
- Stay in this session
- Fresh subagent per task + code review

**If Parallel Session chosen:**
- Guide them to open new session in worktree
- **REQUIRED SUB-SKILL:** New session uses superpowers:executing-plans

---

## Categorical Framing

<EXTREMELY-IMPORTANT>
This section provides a category-theoretic interpretation of plan writing. Use this framing when working with developers who think in abstract mathematical terms.
</EXTREMELY-IMPORTANT>

### Plans as Functors

A plan is a **functor** mapping from the task category to the implementation category:

- **Domain category**: Tasks with dependencies (partial order)
- **Codomain category**: Implementation actions (code, tests, commits)
- **The functor preserves structure**: Task dependencies → implementation order

### Tasks as Morphisms

Each task in the plan is a **morphism**:
- Input: context + files to modify
- Output: implemented feature + tests + commit

The composition of tasks must **commute** properly - sequential tasks compose to the final implementation.

### Task Decomposition as Fiber

Breaking down a feature into tasks is finding the **fibers** of the implementation functor:
- Each task is a fiber over a specific implementation goal
- Dependencies between tasks are the **coboundary** - how fibers connect

### Granularity as Unit/Counit

Fine-grained tasks (2-5 min) vs. coarse-grained:
- **Fine-grained**: More morphisms, easier to verify each composes
- **Coarse-grained**: Fewer morphisms, but composition harder to verify

The ideal task size is where the **unit** of the adjunction is balanced.

### Bite-Sized as Minimal Morphisms

Each step should be a **minimal morphism** - the smallest change that achieves one goal:
- "Write failing test" = minimal morphism to RED state
- "Run test" = verification morphism
- "Implement minimal code" = minimal morphism to GREEN state
- "Commit" = identity morphism preserving state

### Plan Header as Universal Property

The plan header establishes the **universal property** of the implementation:
- **Goal**: Specifies the terminal object (what success looks like)
- **Architecture**: Specifies the category structure (how components relate)
- **Context**: Specifies the domain (what constraints apply)

### Using categorical-reframing

When decomposing a feature into tasks, invoke `superpowers:categorical-reframing` to:
- Identify the universal property of the overall feature
- Map tasks to morphisms in the implementation category
- Verify task composition commutes properly

---

## Summary Table

| Categorical Concept | Plan Writing Application |
|---------------------|------------------------|
| Plan | Functor: tasks → implementation |
| Task | Morphism: context → implemented feature |
| Task decomposition | Fibers of the implementation functor |
| Task granularity | Balance of unit/counit in adjunction |
| Minimal step | Minimal morphism achieving one goal |
| Plan header | Universal property of success |
