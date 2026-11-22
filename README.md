# ArkaFEM

**ArkaFEM** is an educational/research, code-first finite element analysis library for MATLAB. The mathematical reference is Daryl L. Logan, *A First Course in the Finite Element Method*, 6th ed. General SAP2000-style modeling concepts inform the terminology, **not** any claim of API compatibility. **Current stage: 01B data-only registry; NOT a structural solver.**

| Item                                               | State                                                                                   |
| -------------------------------------------------- | --------------------------------------------------------------------------------------- |
| Source version                                     | `0.0.1-dev`, Stage 01B                                                                |
| MATLAB compatibility target                        | R2024b+, **not observed/verified in the authoring environment**                   |
| Intended dependency                                | Base MATLAB only; runtime dependence not yet checked                                    |
| Available APIs                                     | `arka.version()`, `arka.Model` data registry, lookup, snapshot, summary, validation |
| FEM elements, analysis, reactions, loads, DOF maps | **Not implemented**                                                               |
| License                                            | MIT proposed **but not approved**; do not publish as MIT without owner approval   |

## Setup (Windows or any MATLAB installation)

Open MATLAB from the **repository root** (the folder containing `src`, `Makefile`, `README.md`). Run:

```matlab
run(fullfile(pwd, 'scripts', 'setupArkaFEM.m'));
info = arka.version();
model = arka.Model("2D", "Truss");
model.addNode(1, [0, 0]);
model.addNode(2, [3, 0]);
model.addMaterial("Steel", 'Kind', "steel", 'E', 210e9, ...
    'nu', 0.3, 'rho', 7850);
model.addSection("Bar", "Steel", 'A', 0.002);
disp(model.summary());
disp(model.snapshot());
disp(model.validate());
run(fullfile(pwd, 'examples', 'example_01_model_basics.m'));
```

The setup script adds **only** `src/` to MATLAB path, idempotently. Do not run recursive `genpath` across the repository or put `src/+arka` directly onto the path.

## Regression and QA

```matlab
run(fullfile(pwd, 'scripts', 'run_all_tests.m'));
run(fullfile(pwd, 'scripts', 'run_lint.m'));
```

For Windows PowerShell in the root with MATLAB on PATH:

```powershell
matlab -batch "run(fullfile(pwd,'scripts','run_all_tests.m'))"
```

Tests for 01B live at `tests/unit/TestModelRegistry.m` and `tests/negative/TestModelValidation.m`. The authoring environment **does not contain MATLAB**. Source and MATLAB tests have been written but **MATLAB execution is NOT_RUN** here. Record your local MATLAB release and test output before treating 01B as MATLAB-verified. Independent Python static audit: `python scripts/static_audit.py`. GNU Make under Git Bash/WSL/MSYS2 supports `make help`, `make doctor`, `make lint`, `make matlab-lint`, `make test`, and `make verify`. See `docs/qa/01B_REPORT.md`.

## User-selected patch delivery mode (after 01A)

Unlike the original prompt-kit full-ZIP policy, this project now delivers **only added or modified files** in a ZIP with `ArkaFEM/` at its top level and a separate metadata file `PATCH_INFO.json` (deletions are explicitly listed there). To apply a stage patch from PowerShell:

```powershell
# Confirm you have the 01A baseline and no conflicting local edits.
cd C:\Projects\ArkaFEM
git status --short
# Expand patch from inside the parent folder, not inside ArkaFEM.
Expand-Archive -Path "$env:USERPROFILE\Downloads\ArkaFEM_01B_PATCH_0.0.1-dev.zip" -DestinationPath 'C:\Projects' -Force
cd C:\Projects\ArkaFEM
```

Replace the downloaded filename with the actual stage patch artifact name. This preserves unrelated project files, notably the locally generated MATLAB `.prj` and any MATLAB Project metadata. `docs/FILE_MANIFEST.sha256` describes the source tree packaged at authoring time. If the local checkout contains extra `.prj` and Project metadata, use `python scripts/check_manifest.py --allow-unlisted` to verify known files without erroneously treating the locally generated extras as baseline failures.

## Version control (user actions only)

```bash
make git-status
make git-diff
make git-stage
make git-staged
make git-commit MSG="feat: add validated ArkaFEM model facade (01B)"
# Explicit user action only: git push origin main
```

No commit, tag, push, remote modification or GitHub repository action is performed automatically by the stage author. Avoid adding secrets, licensed section databases, MATLAB activation files or local credentials.

## Documents

- [Public API](docs/API_SPEC.md) — implemented versus planned calls and stable error identifiers.
- [Model data contract](docs/model_data.md) — registries, IDs, revision and snapshot guarantees.
- [Isotropic material metadata](docs/theory/isotropic_material_registry.md) — equation/units and example.
- [Data-validation benchmark](docs/benchmarks/model_validation.md) — worked expected outputs and test paths.
- [Stage status](docs/STATUS.md), [handoff](docs/HANDOFF.md), [QA](docs/qa/01B_REPORT.md).

Original source of truth is in `spec/ArkaFEM_PromptKit_v2`. The 01B implementation is provisional; deterministic DOF mapping/Dirichlet spring proof are for 01C. This software is **not qualified for safety-critical or code-compliant structural design**.
