# Changelog

## [0.0.1-dev] — 2026-11-24 (01C review, unpublished)

- Rechecked the raw ZIP MATLAB sources; no escaped Markdown operators or non-ASCII bytes were found in the original archive.
- Hardened solver argument and finite arithmetic checks, and DOF map query validation. Added five MATLAB regression tests.
- Added MATLAB source text-integrity checks to the static audit. MATLAB execution and Code Analyzer remain NOT_RUN.

## [0.0.1-dev] — 2026-11-20 (01C, unpublished)

### Added
- Public `arka.dofMap` (one family at a time) and `arka.dofIndex`; pure internal deterministic 1-based builder sorted by node ID.
- Public `arka.solveDirichlet` as a convenience wrapper over a pure numerical partitioned sparse solver with nonzero prescribed displacements and reactions `K*U-F`.
- Positive, benchmark and negative MATLAB tests (NOT_RUN in authoring environment); documented spring-chain benchmark, theory and running example.

### Changed
- `arka.version().Stage` to `01C`, expanded `AvailableAPI`; version remains `0.0.1-dev`.
- Static audit contracts, progress, API/roadmap, QA, handoff and SHA-256 source manifest.

### Limitations
- This is a manual supplied-K,F numerical proof, **not** FEM assembly or `Model.solveStatic`. MATLAB runtime and Code Analyzer not executed in authoring environment.

## [0.0.1-dev] — 2026-11-20 (01B, unpublished)

### Added
- Provisional `arka.Model` handle-based model data facade; private node, material, General section registries with deterministic numeric IDs and revisions.
- Input validators for spatial dimension, strict coordinates, scalar linear isotropic E/nu/rho/alpha/G, section property positivity, duplicate names/IDs, missing references and stable `arka:validation:*` error IDs.
- Sorted lookup/list operations, detached value snapshots, data `summary()` and `validate()` diagnostics; explicit regression and negative tests and 01B example.
- API, model-data, theory, benchmark and QA documentation; patch-oriented delivery manifest for only 01B changes.

### Changed
- `arka.version().Stage` is 01B; `AvailableAPI` enumerates available entry points as a string array instead of one string. Version remains 0.0.1-dev, API still provisional.
- Stage status/progress now distinguishes implemented registry features from MATLAB runtime verification.
- User explicitly requested incremental patch ZIP instead of original full-source ZIP delivery; runtime/GitHub metadata files are left intact.

### Not yet verified / unavailable
- MATLAB test and Code Analyzer results have **not** been executed in the source-authoring environment; user can run supplied scripts and report their output.
- No solver, elements, DOF mapper, parametric section computation, nonlinear material law, GUI, or MATLAB-certified compatibility yet.

## [0.0.1-dev] — 2026-11-14 (01A, unpublished)

### Added
- Repository skeleton, root GNU Make targets, opt-in Git helpers and static QA checks.
- `arka.version()` metadata API, path-only MATLAB setup, smoke example, MATLAB tests and Code Analyzer entrypoints (runtime verification pending).
- Architecture, numerical contracts, API specification, roadmap, ADR and self-contained original prompt kit.
- Static-only GitHub workflow and contributor/issue/PR guidelines.

### Pending
- User runtime test log and actual MATLAB Project validation in authoring records.
- Deterministic DOF mapping and manually assembled spring-chain Dirichlet solver (01C).
- Owner's license approval before public publication.
