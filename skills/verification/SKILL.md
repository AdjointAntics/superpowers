---
name: verification
description: Use before claiming any work is complete, fixed, or passing
allowed-tools: [Bash, Read, Grep, Glob]
---
# Verification

## When
Before claiming code works, tests pass, builds succeed, or tasks are complete. Before committing, opening PRs, or proceeding. No exceptions.

## Iron Laws
1. No claim without fresh evidence. Run the command, read the output, then speak.
2. Never say "should work." Confidence is not evidence.
3. Check output correctness, not just exit codes.
4. If verification fails, fix and re-verify. Do not explain away failures.
5. Agent reports are claims, not evidence. Verify independently.

## Process
1. Identify what command proves the claim.
2. Run the full command fresh -- no reusing stale results.
3. Read complete output. Count passes, failures, errors.
4. Does output confirm the claim? If yes: state claim with evidence ("42/42 pass").
5. If no: state actual status. Fix the problem. Re-run from step 2.
8. For regression tests: verify the red-green cycle.
9. For delegated work: check the diff, run the tests yourself.
10. Only after evidence confirms: claim, commit, or proceed.

## Composability
Input: state where a completion claim is imminent. Output: verified claim with evidence, or honest status report.
