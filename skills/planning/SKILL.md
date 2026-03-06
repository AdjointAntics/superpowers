---
name: planning
description: Use when you have a design or spec to decompose into tasks, write a plan, and execute it
user-invocable: true
argument-hint: "Feature name or spec to plan"
---
# Planning

## When

You have an approved design or spec to turn into concrete tasks. Covers both writing the plan and executing it. Invoked after brainstorming or when given a spec directly.

## Iron Laws

1. Every task completable in 30 minutes or less.
2. Every task lists: files to touch, acceptance criteria, verification command.
3. Task dependencies must be explicit.
4. No task begins until the previous batch is verified.
5. Stop and ask when blocked — never guess past a blocker.

## Process

1. **Review the design.** Read critically. Raise concerns before proceeding.
2. **Decompose into tasks.** Each task is one focused unit. Target 2-5 minute steps within each task.
3. **Write the plan.** Save to `docs/plans/YYYY-MM-DD-<feature>.md`. Per task:
   ```
   ### Task N: [Name]
   Files: [create/modify/test paths]
   Steps: [numbered, bite-sized]
   Verify: [command + expected output]
   Acceptance: [what done looks like]
   Depends on: [task numbers or none]
   ```
4. **Add header.** Goal (one sentence), Architecture (2-3 sentences).
5. **Choose mode.** Sequential: batches of 3, checkpoint after each. Parallel: dispatch independent tasks to subagents.
6. **Execute.** Per task: mark in-progress, follow steps, run verification, mark complete.
7. **Checkpoint.** After each batch: show results, verification output, say "Ready for feedback." Wait.
8. **Apply feedback.** Incorporate changes. Update plan doc if needed.
9. **Handle blockers.** Failed verification, missing dependency, unclear instruction — stop and ask.
10. **Complete.** All tasks verified. Summarize what was built.

## Composability

Input: approved design or spec. Output: plan written, tasks executed, verified, committed.
