# Stage 01C QA report — 2026-11-24 (reviewed replacement)

## Source review and regression additions

The original delivered ZIP was opened directly. All 10 MATLAB files contained ASCII text with clean operators, including `uf = Kff \ rhs;`; no HTML entities or Markdown-escaped operators were found. The pasted representation is inconsistent with those archived bytes; the local file has not been inspected. The replacement ZIP is intended for direct extraction, not copying from chat. Added five tests covering missing solver arguments, malformed map structs, reduced RHS overflow, a nonsingular system with no prescribed DOFs, and the sparse condition-estimation branch. Existing tests remain in place. No MATLAB parser or runtime is available in the authoring environment; source inspection and byte checks are not a syntax or runtime certification.

## Scope and evidence classes

- Baseline: GitHub `MobinYengejehi/ArkaFEM`, `main` commit `1cc07e72619457ade19fc53ea8a75190bcd7fe8c` (Stage 01B), whose core Git blob SHA values were matched to a locally reconstructed source tree using exact archived 01A+01B/repair patches. Existing `Model.m` remains unchanged.
- 01C implements canonical deterministic single-family DOF mapping and manual matrix Dirichlet linear solution with prescribed nonzero settlements, reactions and normalized residual.
- This QA report distinguishes static source audit, independent arithmetic cross-check, patch archive verification, **and MATLAB execution (not available in authoring environment)**. Python arithmetic is **not** proof of MATLAB execution.

## Acceptance matrix

| Category | Status | Evidence and restrictions |
|---|---|---|
| Python static audit | PASS | `python scripts/static_audit.py` checks required files, staged metadata, API presence, sources/newlines, inverse prohibition and progress logic. |
| SHA-256 source manifest | PASS | `python scripts/check_manifest.py` after final regenerated manifest; local-only generated `.prj` remains outside source baseline. |
| Independent arithmetic cross-check | PASS | Python NumPy double precision solves NC-11 and `U1=.001m`, confirms `[0;.003;.0045]`, `[.001;.004;.0055]` m and `[-3000;0;0]` N within fixture tolerances. This is a mathematical cross-check, not execution of MATLAB source. |
| 01C MATLAB DOF mapping tests | NOT_RUN | Authoring environment has no MATLAB executable. |
| 01C MATLAB spring and settlement tests | NOT_RUN | Authoring environment has no MATLAB executable. |
| 01C MATLAB invalid/singular tests | NOT_RUN | Authoring environment has no MATLAB executable. |
| Existing 01A/01B MATLAB regressions | PASS (USER-REPORTED) | User supplied 25/25 01B MATLAB tests passed in this conversation; final lint hotfix confirmed afterwards, but no independently replayed 01B MATLAB run here. |
| MATLAB Code Analyzer | NOT_RUN | No MATLAB executable. |
| GitHub Actions / commit / push | NOT_RUN | Not requested by user; no repository mutation. |
| Patch ZIP and replay | PASS | Full CRC and SHA-256 audit; independently applied this patch on the locally reconstructed 01B baseline and compared resulting files. Patch file counts and replay reported in `PATCH_INFO.json`; unchanged 01B `Model.m` is intentionally omitted. |

## Analytical benchmark

Input `K=sparse([1e6,-1e6,0;-1e6,3e6,-2e6;0,-2e6,2e6])` N/m, `F=[0;0;3000]` N, `U1=0` m. Independent hand expected `U=[0;.003;.0045]` m; support reaction `R1=-3000` N. Nonzero settlement `U1=+.001` m produces `U=[.001;.004;.0055]` m and identical reaction. Tolerances: `1e-12` m, `1e-7` N and `1e-12` normalized residual in well-conditioned benchmark. **Measured MATLAB outputs remain NOT_RUN**, and no numeric pass is claimed for that environment.

## Risk and gate disposition

- `S01.05` DOF mapper and `S01.06` manual Dirichlet solver: **implemented**, source/static reviewed, **not MATLAB-verified**.
- No automatic spring/truss element assembly, generic FEM compilation, multipoint constraints, mixed active DOFs, or Model.solveStatic; current solver only accepts manually supplied matrices.
- Conservative conditioning threshold 1e12 and reduced 1-norm residual guard 1e-8 are prototype safeguards; not a universal numerical certification.
- Stage01 acceptance remains blocked on MATLAB tests/lint, generated project evidence and 01D final gate.

## Running tests on user's MATLAB

From root `P:\projects\ArkaFEM\ArkaFEM`:

```matlab
run(fullfile(pwd,'scripts','setupArkaFEM.m'));
run(fullfile(pwd,'examples','example_02_spring_system.m'));
run(fullfile(pwd,'scripts','run_all_tests.m'));
run(fullfile(pwd,'scripts','run_lint.m'));
```

Record MATLAB version (e.g. `version('-release')`), complete result summary, warnings/errors and result file hashes before upgrading the verified task status.

## Reviewed patch reproducibility checks

- Original ZIP: 10 `.m` files scanned, zero reported text-escape/non-ASCII artifacts; correct MATLAB left division present.
- New source-integrity audit: clean replay passes; deliberate injected NBSP, escaped `~=`, escaped `*`, HTML entity and UTF-8 BOM each cause the audit to fail. These injections were made only in a temporary replay and removed.
- Independent NumPy spring-chain checks (zero and nonzero prescribed displacement, plus two prescribed supports): PASS.
- Reviewed source: 21 new MATLAB test methods, 46 total in reconstructed baseline + patch. Actual MATLAB execution and Code Analyzer: NOT_RUN.
- Reconstructed baseline Model.m Git blob matches the observed GitHub SHA `96bdae6e2054977a20f6132f48fd7c888b000a8f`; it is not included in the replacement patch.
