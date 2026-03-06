---
name: code-review
description: Use when requesting or receiving code review on completed work
user-invocable: true
argument-hint: "PR number, branch name, or describe what to review"
---
# Code Review

## When
After completing a task, major feature, or before merging -- request review. When receiving feedback -- evaluate technically before acting.

## Iron Laws
1. Request review after each significant unit of work. Never skip because "it's simple."
2. Include full context: plan, changed files, standards, base/head SHAs.
3. No performative agreement. Never say "great catch!" then blindly implement.
4. Evaluate every suggestion: is it correct? Is it an improvement for this codebase?
5. Push back with evidence when a suggestion is wrong or violates YAGNI.

## Process
1. **Requesting:** Gather base SHA, head SHA, what was implemented, and original requirements.
2. Dispatch a code-reviewer subagent with all context. It has no prior memory.
3. When feedback arrives, read it completely before reacting.
4. For each item: verify against the codebase. Does it apply here?
5. If unclear, ask for clarification rather than guessing.
6. If wrong, push back with evidence (test results, code references).
7. If correct, fix it. State what changed, not "thanks."
8. Implement in order: blocking issues, simple fixes, complex changes.
9. Test each fix. Verify no regressions.
10. If feedback conflicts with architectural decisions, escalate to the human.

## Composability
Input: completed work needing quality assurance. Output: reviewed code with all feedback resolved or explicitly deferred.
