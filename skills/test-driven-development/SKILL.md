---
name: test-driven-development
description: Use when implementing any feature or bugfix — failing test first, make it pass, refactor
---
# Test-Driven Development

## When

You are about to write or change production code: features, bug fixes, refactoring, behavior changes. Exceptions (prototypes, generated code, config) need explicit user permission.

## Iron Laws

1. No production code without a failing test first.
2. Wrote code before the test? Delete it. No "reference" copies.
3. One behavior per test. "and" in the name means split it.
4. Refactor only when all tests are green.
5. If you did not watch it fail, you do not know it tests the right thing.

## Process

1. **RED.** Write one failing test. Clear name, real behavior, one assertion.
2. **Verify RED.** Run it. Must fail because feature is missing, not a typo. Passes? Fix the test.
3. **GREEN.** Minimal code to pass. No extras.
4. **Verify GREEN.** All tests pass. Output clean.
5. **REFACTOR.** Duplication, names, helpers. Stay green. No new behavior.
6. **Repeat.** Next test, next behavior.
7. **Bug fixes.** Same cycle: failing test reproduces bug, fix, verify.
8. **Stuck?** Hard to test = too complex. Must mock everything = too coupled.

## Rationalizations That Mean Start Over

"Too simple to test" — the test takes 30 seconds. "Test after" — immediate pass proves nothing. "Keep as reference" — you will adapt, not rewrite. "Already manually tested" — ad-hoc is not systematic.

## Composability

Input: behavior to implement or bug to fix. Output: tested, minimal code with proof the test catches failure.
