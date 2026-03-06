---
name: systematic-debugging
description: Use for any bug, test failure, or unexpected behavior — find root cause before proposing fixes
---
# Systematic Debugging

## When

Something is broken: test failure, unexpected behavior, performance issue, build error. Use this especially under time pressure, when a "quick fix" seems obvious, or after a failed attempt. Systematic is faster than guessing.

## Iron Laws

1. No fixes without root cause investigation first.
2. One hypothesis, one change, one verification at a time.
3. Read error messages and stack traces completely before acting.
4. Three failed fixes means architectural problem — stop, discuss with user.
5. Fix at the source. Trace backward to the original trigger.

## Process

1. **Reproduce.** Trigger reliably. Document steps. Not reproducible? Gather data, do not guess.
2. **Read the error.** Full message, stack trace, line numbers, paths. Errors often contain the answer.
3. **Check recent changes.** Git diff, commits, dependencies, config, environment.
4. **Trace data flow.** Where does the bad value originate? What called this? Keep tracing to the source.
5. **Hypothesize.** "X is the cause because Y." Be specific.
6. **Test minimally.** Smallest change to confirm or reject. Rejected? New hypothesis, do not pile on.
7. **Write failing test.** Before fixing, reproduce the bug in a test.
8. **Fix.** One change at the root cause. No unrelated improvements.
9. **Verify broadly.** Failing test passes. Full suite passes. No regressions.
10. **Defend in depth.** Add validation at other layers to make the bug structurally impossible.

## Red Flags

STOP, return to step 1: "Quick fix for now." "Just try X." "Don't fully understand but might work." "One more attempt" after two failures.

## Composability

Input: broken behavior with symptoms. Output: root cause found, fix verified, no regressions.
