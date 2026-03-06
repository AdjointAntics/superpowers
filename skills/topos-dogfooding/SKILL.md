---
name: topos-dogfooding
description: Use when running the self-referential feedback loop -- skills benchmark, test, lint, and visualize themselves using Topos tools
---
# Topos Dogfooding

## When
Invoke when running the full self-verification cycle on Topos skills, or when setting up CI for self-referential quality checks.

## Iron Laws
1. Every skill must be tested, benchmarked, and linted using the same Topos tools it describes.
2. The five pillars (benchmark, test, lint, visualize, represent) must all pass before convergence.
3. Replace manual verification with automated `yon dogfood` commands wherever possible.

## Process
1. Run the full dogfooding cycle: `yon dogfood`.
2. Run individual pillars as needed:
   - `yon dogfood --benchmark` -- measure skill invocation performance via HomTime.
   - `yon dogfood --test` -- property-test skills via Cofree.
   - `yon dogfood --lint` -- lint skills via Strict.
   - `yon dogfood --visualize` -- visualize results via Poly.
3. Review output for regressions, law violations, or lint failures.
4. Iterate until all five pillars pass: no regressions, all laws hold, no lint violations, insights stabilize.

## The Five Pillars
1. **Benchmark** (HomTime) -- measure skill invocation and composition timing.
2. **Test** (Cofree) -- property-based verification of skill correctness and categorical laws.
3. **Lint** (Strict) -- code quality and convention compliance.
4. **Visualize** (Poly) -- render performance dashboards and dependency graphs.
5. **Represent** (Yoneda) -- every skill is a representable functor with a universal interface.

## CI Integration

```yaml
name: Dogfood
on: [push, pull_request]
jobs:
  dogfood:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: yon dogfood
```

## Composability
Expects all Topos packages to be functional. Produces a convergence report across all five pillars, feeding back into the asi development loop.
