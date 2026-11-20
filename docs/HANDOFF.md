# Handoff — ArkaFEM 01A → 01B

**Latest complete-source artifact**: `ArkaFEM_01A_0.0.1-dev.zip` (root `ArkaFEM/`), source manifests in `docs/FILE_MANIFEST.sha256`. The original supplied kit is also embedded under `spec/`.

## What exists and how to run it

- `src/+arka/version.m`: only actual callable public source function so far (MATLAB untested).
- `scripts/setupArkaFEM.m`: adds only package parent `src` to MATLAB path; idempotent design.
- `scripts/smokeArkaFEM.m`, `examples/example_00_version.m`, `tests/unit/TestBootstrap.m`: authored but NOT_RUN in MATLAB.
- `Makefile`: explicit Git helpers, Python static lint, real MATLAB-dependent smoke/Code Analyzer/tests and `verify`; MATLAB absence causes errors.
- `docs/ARCHITECTURE.md`, `docs/NUMERICAL_CONTRACTS.md`, `docs/API_SPEC.md`, `docs/ROADMAP.md`, ADR-0001; `docs/progress.json` is the machine-readable progress record.
- `.github/workflows/static.yml`: configured static-only GitHub action, remote run not observed.

## What was NOT done

- MATLAB and Octave were not available; no MATLAB syntax, smoke, Code Analyzer or unit-test run occurred.
- No valid `.prj` was manufactured or verified; S01.01 remains partial.
- No `arka.Model`, materials, sections, DOF manager, solver, structural example, numerical benchmark or full model facade exists.
- No permission to use MIT was inferred. No Git commit/push/tag took place.

## Next prompt (ONLY on explicit instruction)

`spec/ArkaFEM_PromptKit_v2/PROMPTS/01B_PUBLIC_MODEL_FACADE_AND_VALIDATION.md` — implement provisional validated public Model data facade. Consult all contracts and preserve existing files; do not leap ahead to DOF mapping or solver. Keep MATLAB test status NOT_RUN unless executed.

## Remaining 01A blockers to revisit

1. Generate and test actual MATLAB Project in a licensed MATLAB environment (`docs/MATLAB_PROJECT.md`).
2. Run setup/smoke/unit/Code Analyzer in target R2024b+; record full logs.
3. Obtain owner license choice before public publishing.

## Suggested Git commit (user-controlled)

`chore: bootstrap ArkaFEM MATLAB package and QA contracts`
