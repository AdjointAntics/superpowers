---
name: executing-plans
description: Use when you have a written implementation plan to execute in a separate session with review checkpoints
---

# Executing Plans

## Overview

Load plan, review critically, execute tasks in batches, report for review between batches.

**Core principle:** Batch execution with checkpoints for architect review.

**Announce at start:** "I'm using the executing-plans skill to implement this plan."

## The Process

### Step 1: Load and Review Plan
1. Read plan file
2. Review critically - identify any questions or concerns about the plan
3. If concerns: Raise them with your human partner before starting
4. If no concerns: Create TodoWrite and proceed

### Step 2: Execute Batch
**Default: First 3 tasks**

For each task:
1. Mark as in_progress
2. Follow each step exactly (plan has bite-sized steps)
3. Run verifications as specified
4. Mark as completed

### Step 3: Report
When batch complete:
- Show what was implemented
- Show verification output
- Say: "Ready for feedback."

### Step 4: Continue
Based on feedback:
- Apply changes if needed
- Execute next batch
- Repeat until complete

### Step 5: Complete Development

After all tasks complete and verified:
- Announce: "I'm using the finishing-a-development-branch skill to complete this work."
- **REQUIRED SUB-SKILL:** Use superpowers:finishing-a-development-branch
- Follow that skill to verify tests, present options, execute choice

## When to Stop and Ask for Help

**STOP executing immediately when:**
- Hit a blocker mid-batch (missing dependency, test fails, instruction unclear)
- Plan has critical gaps preventing starting
- You don't understand an instruction
- Verification fails repeatedly

**Ask for clarification rather than guessing.**

## When to Revisit Earlier Steps

**Return to Review (Step 1) when:**
- Partner updates the plan based on your feedback
- Fundamental approach needs rethinking

**Don't force through blockers** - stop and ask.

## Remember
- Review plan critically first
- Follow plan steps exactly
- Don't skip verifications
- Reference skills when plan says to
- Between batches: just report and wait
- Stop when blocked, don't guess
- Never start implementation on main/master branch without explicit user consent

## Integration

**Required workflow skills:**
- **superpowers:using-git-worktrees** - REQUIRED: Set up isolated workspace before starting
- **superpowers:writing-plans** - Creates the plan this skill executes
- **superpowers:finishing-a-development-branch** - Complete development after all tasks

---

## Categorical Framing

<EXTREMELY-IMPORTANT>
This section provides a category-theoretic interpretation of plan execution. Use this framing when working with developers who think in abstract mathematical terms.
</EXTREMELY-IMPORTANT>

### Execution as Functor Composition

Executing a plan is **functor composition**:

```
PlanFunctor: Tasks → Implementations
TDDCycle: Test → Implement → Verify → Commit

FullExecution = TDDCycle ∘ PlanFunctor
```

Each task flows through the TDD cycle - this is composing functors.

### Parallel Tasks as Coproduct

Independent tasks that can run in parallel represent a **coproduct** (sum):
- Task A ⊔ Task B = parallel execution
- Results combine via the universal property of coproduct

### Sequential Tasks as Product

Dependent tasks that must run in order represent a **product**:
- Task A × Task B = sequential execution
- Output of A becomes input to B

### Batches as Natural Transformations

Moving between batches is a **natural transformation**:
- Batch 1 results → Batch 2 inputs
- The transformation preserves the structure of the plan functor

### Checkpoints as Pullbacks

Verification checkpoints are **pullbacks**:
- Verify task completed = pullback of implementation against expected
- Pullback ensures: does the implementation match the spec?

### Commit as Identity Morphism

Each commit is an **identity morphism** in the development category:
- Preserves the current state
- Enables future composition (branching, merging)

### Terminal State: All Tasks Complete

The goal is reaching the **terminal object** where:
- All functors have composed
- All pullbacks have resolved
- Ready for merge (isomorphism to main)

### Using categorical-reframing

When analyzing task dependencies or execution flow, invoke `superpowers:categorical-reframing` to map the execution structure to categorical terms.

---

## Summary Table

| Categorical Concept | Plan Execution Application |
|--------------------|---------------------------|
| Execution | Functor composition: plan → implementation |
| Parallel tasks | Coproduct (A ⊔ B) |
| Sequential tasks | Product (A × B) |
| Between batches | Natural transformation |
| Checkpoint | Pullback: implementation ↔ spec |
| Commit | Identity morphism |
| All complete | Terminal object |
