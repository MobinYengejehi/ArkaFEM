# Handoff — 01B → 01C (patch delivery)

## Baseline and applied delta

**Base:** `ArkaFEM_01A_0.0.1-dev.zip` containing `ArkaFEM/`. **01B output:** ZIP **with only files added or modified relative to that baseline**, all paths prefixed `ArkaFEM/` so extraction to the **parent** repository folder overlays correct locations. Its top-level `PATCH_INFO.json` lists additions/changes/deletions with SHA-256. No file deletions in 01B. Preserve the user's own `.git`, `.prj`, MATLAB Project metadata, and workspace changes. The original prompt-kit rule of a full ZIP is superseded by explicit user request for patch-based delivery.

## New authored capability

- `src/+arka/Model.m`: 2D/3D Truss/Frame data-only model, node/material/general-section records, revisioned atomic inserts, queries/sorted lists/snapshots/summary/integrity check.
- `src/+arka/+internal/+core/*`: validation helpers and strict name/value parser; `G = E/[2(1+nu)]` consistency check.
- `tests/unit/TestModelRegistry.m`, `tests/negative/TestModelValidation.m`, `examples/example_01_model_basics.m`.
- `docs/API_SPEC.md`, `docs/model_data.md`, `docs/theory/isotropic_material_registry.md`, `docs/benchmarks/model_validation.md`.

## What is unavailable / not proved

- No element APIs, DOF mapping, Dirichlet partition, spring element, mesh assembly, FEM solver, results or meaningful structural stress/deflection.
- No actual MATLAB runtime available inside the source-authoring environment; tests authored but execution `NOT_RUN`. User reported installing MATLAB and configuring the repo but did not provide a log for external acceptance. Neither R2024b+ compatibility nor published QA is certified.
- No Git operations have been executed on the user's repository; no license was chosen.

## Apply and test

```powershell
cd C:\Projects\ArkaFEM
git status --short
# Extract the ZIP into C:\Projects (not C:\Projects\ArkaFEM).
Expand-Archive -Path '<actual-downloaded-01B-patch.zip>' -DestinationPath 'C:\Projects' -Force
cd C:\Projects\ArkaFEM
```

```matlab
cd('C:\Projects\ArkaFEM')
run(fullfile(pwd, 'scripts', 'setupArkaFEM.m'))
run(fullfile(pwd, 'examples', 'example_01_model_basics.m'))
run(fullfile(pwd, 'scripts', 'run_all_tests.m'))
run(fullfile(pwd, 'scripts', 'run_lint.m'))
```

Suggested commit **by user**, after review and QA:

```powershell
git add -A
git diff --cached --check
git diff --cached --stat
git commit -m "feat: add validated ArkaFEM model facade (01B)"
git push origin main
```

## Next execution boundary

Only on explicit instruction, read `spec/ArkaFEM_PromptKit_v2/PROMPTS/01C_DOF_MAPPING_AND_DIRICHLET_SOLVER_PROOF.md`. Stage 01C will map deterministic active-family DOFs and solve a **manually assembled** Dirichlet spring chain. Do not claim general FEM assembly and do not skip the MATLAB QA gate.
