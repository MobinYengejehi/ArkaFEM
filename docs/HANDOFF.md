# Handoff — Stage 01C → Stage 01D (incremental patch)

## Inputs and delta conventions

GitHub authoritative baseline is `MobinYengejehi/ArkaFEM` main at `1cc07e72619457ade19fc53ea8a75190bcd7fe8c`. The local working snapshot was reconstructed from the original Stage 01A, Stage 01B and 01B hotfix archives; critical Git object hashes were compared to the live repository. The GitHub README differs in whitespace formatting, but this file is intentionally rewritten for Stage 01C. This 01C output contains **only added/modified ArkaFEM paths**, with `PATCH_INFO.json` enumerating additions, replacements, deletions and SHA-256. Extract **into the parent directory** of `ArkaFEM/`, for example `P:\projects\ArkaFEM`, and only after ensuring the 01B stage was applied. The user's `.git`, MATLAB `.prj`, tool settings and extra local files are not included/removed. Verify the existing baseline and review local Git diff before overlay.

## Reviewed replacement patch

Use `ArkaFEM_01C_GITHUB_BASED_REVIEWED_PATCH.zip` instead of the earlier 01C ZIP. It also overlays an already extracted 01C patch. The baseline remains unchanged. Static audit now checks MATLAB source bytes and escaped operators; MATLAB runtime is still required.

## Authored API and design boundaries

- Public `arka.dofMap`, `arka.dofIndex` and internal pure `arka.internal.core.buildDofMap` canonical node ID/DOF family mapping. `arka.Model` only supports `2D`/`3D`; 1D mapping is possible using explicit node IDs/family.
- Public `arka.solveDirichlet` wraps the pure numerical `arka.internal.numerics.solveDirichlet` accepting **manual K/F**, sorting constraints, validating finite data, rejecting duplicates/conflicts/singular and severely ill-conditioned free systems; reconstructs `R=KU-F`, computes normalized residual.
- No automatic elements, mesh, multipoint constraints, loads, full Model solver, `arka.Results` or GUI. `arka.version().Stage` is `01C`.
- Documentation added: DOF and Dirichlet theory + independently hand-derived spring-chain benchmark. New MATLAB positive/negative tests provided.

## QA and recovery

Environment where code was authored has **no MATLAB**; all MATLAB tests and Code Analyzer remain `NOT_RUN` here. Do not upgrade S01.05 or S01.06 to verified until actual MATLAB test output and release are supplied. Static audit/ZIP+manifest source integrity are independent of actual MATLAB execution.

Run locally from repo root:

```matlab
run(fullfile(pwd,'scripts','setupArkaFEM.m'));
run(fullfile(pwd,'examples','example_02_spring_system.m'));
run(fullfile(pwd,'scripts','run_all_tests.m'));
run(fullfile(pwd,'scripts','run_lint.m'));
```

On Windows PowerShell with MATLAB on PATH:

```powershell
cd P:\projects\ArkaFEM\ArkaFEM
matlab -batch "run(fullfile(pwd,'examples','example_02_spring_system.m')); run(fullfile(pwd,'scripts','run_all_tests.m'))"
```

For manifest on a working tree containing additional MATLAB Project metadata:

```powershell
python scripts/check_manifest.py --allow-unlisted
python scripts/static_audit.py
```

## Stage 01D contract

Stage 01D must review all S01.01–S01.09 tasks, target tests/lint real execution and clean-source setup. Do not claim Stage 01 gate accepted based solely on Python/static checks. Include user-generated MATLAB `.prj` only via explicit user-provided source/evidence; do not erase it via patch. Maintain source/document lineage and stage01 weight accounting. No commits/pushes/tags without user instruction.

**Next exact prompt:** `spec/ArkaFEM_PromptKit_v2/PROMPTS/01D_TESTS_FINALIZE_AND_STAGE01_GATE.md`.

## Base-commit safeguard

The patch is based on `1cc07e72619457ade19fc53ea8a75190bcd7fe8c`. Review `git rev-parse HEAD` and require a clean working tree before extraction. No automated GitHub commit/push was made; existing `src/+arka/Model.m` and local MATLAB Project files stay untouched.
