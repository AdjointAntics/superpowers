---
name: parallel-execution
description: Use when facing 2+ independent tasks with no shared state
context: fork
---
# Parallel Execution

## When
Multiple tasks that are independent -- no shared files, no sequential dependencies, no shared mutable state. Each solvable without context from the others.

## Iron Laws
1. Only parallelize truly independent work. Shared files or state means serialize.
2. Each agent gets a complete, self-contained prompt with all necessary context.
3. Explicitly state what each agent should NOT touch.
4. Two-stage review: spec compliance first, then code quality.
5. Verify all results compose without conflict before declaring success.

## Process
1. Identify candidate tasks. If fixing one might fix another, investigate together first.
2. Write a self-contained prompt per task: scope, goal, context, constraints, expected output.
3. Use foreground agents when results are needed before continuing; background when independent.
4. Dispatch agents. One task per agent.
5. Review each result. Understand what changed.
6. Check for conflicts: did agents edit the same code?
7. Run the full test suite to verify integration.
8. Synthesize a unified summary of all results.
9. If an agent failed, dispatch a targeted fix agent -- do not fix manually.
10. Apply verification before claiming parallel work is complete.

## Composability
Input: independent tasks requiring concurrent execution. Output: integrated results with verified composition and unified summary.
