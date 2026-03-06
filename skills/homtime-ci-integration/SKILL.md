---
name: homtime-ci-integration
description: Use when detecting performance regressions in CI, comparing benchmark baselines, bisecting commits for regressions, or building evidence-based performance reports -- uses HomTime compare/bisect/ci_* API
---
# HomTime CI Integration

## When
Invoke when you need to compare current benchmarks against a saved baseline, detect regressions with statistical rigor, bisect to find the offending commit, or generate CI reports with exit codes.

## Iron Laws
1. Always save baselines with `save_results()` before comparing.
2. Use evidence-based comparison (`evidence=true`) over raw ratio thresholds when possible.
3. Never mark a regression without checking both statistical significance and effect size.
4. Exit CI with `ci_exit(comparison)` -- 0 for clean, 1 for regression.

## Process
1. Save current benchmarks: `save_results("results.json", suite)` or `ci_save(suite)`.
2. Load baseline: `baseline = load_results("baseline.json")` or `baseline = ci_baseline_path() |> load_results`.
3. Compare: `comparison = compare(baseline, current; threshold=1.2, evidence=true)`. Ratio > 1.2 = `:regression`, < 0.83 = `:improvement`, else `:unchanged`.
4. Inspect deltas: each `BenchmarkDelta` has fields `name`, `baseline_ns`, `current_ns`, `ratio`, `status`, `ci`, `test`, `evidence`.
5. Run statistical test: `test = mann_whitney(baseline_homset, current_homset)` -- returns `p_value`, `effect_size`, `reject`, `alpha`.
6. Classify effect size: `es = effect_size(baseline, current)` -- `cohens_d`, `cliffs_delta`, classification (`:negligible`/`:small`/`:medium`/`:large`).
7. Build full evidence: `evidence = build_evidence(baseline, current; threshold=1.2)` -- returns `status`, `significance`, `effect`, `ci`, `trust_baseline`, `trust_current`, `practical_significance`, `recommendation`.
8. Generate report: `ci_report(result; format=:terminal)`.
9. Exit CI: `ci_exit(comparison)`.
10. Bisect regressions:
    ```julia
    result = bisect_regression(
        benchmark=:sort_1000,
        good_commit="abc123",
        bad_commit="def456",
        bisect_script="run_bench.sh"
    )
    # Returns: bad_commit, good_commit, commits_tested, ratios, steps
    ```

### Aggregate & Time Series
- Aggregate runs: `combined = aggregate("bench_results/")` or `aggregate_dir("results/")`.
- Detect trends: `trend = detect_trend(hom_series(f, x; samples=100))` -- returns `:stable`, `:improving`, or `:degrading` with slope and confidence.

## Composability
Expects HomSet or suite values from `hom()` / `suite()` (see homtime-optimization). Produces comparison reports, exit codes, and bisection results suitable for CI pipelines.
