# Stage 01B QA report — 2026-11-20

## Scope

- Baseline: unchanged source from `ArkaFEM_01A_0.0.1-dev.zip`; current delivery **delta patch**, per user's explicit override of original kit full-source ZIP rule.
- New authored source: `arka.Model` facade, internal validators, positive/negative registry tests, runnable example, docs, patch manifest.
- Actual capability: data-only, no DOF mapper, spring, element, assembly, solver or results.
- Development environment has Python/Git/GNU Make; **MATLAB is installed on the user's computer, not in the authoring container**, and the user's claimed 01A test run has not supplied machine-readable logs here.

## Observed / unobserved tests

| Check | Status | Evidence / limitation |
|---|---|---|
| Python static repository audit | PASS | `python scripts/static_audit.py`: 38 required files; metadata/path/no-inverse/JSON/newline checks (static-only) |
| Repository SHA-256 manifest | PASS | Regenerated for authored source and compared to every listed file (excluding manifest itself); `python scripts/check_manifest.py` |
| Patch consistency vs 01A baseline | PASS | Patch builder independently compared SHA-256 with 01A ZIP; only new/modified paths; no deleted paths; ZIP CRC and extracted overlay verified |
| MATLAB positive registry tests | NOT_RUN | MATLAB executable unavailable in authoring environment |
| MATLAB negative registry tests | NOT_RUN | MATLAB executable unavailable in authoring environment |
| MATLAB 01A regression tests | NOT_RUN | No supplied user test log for this run |
| MATLAB Code Analyzer | NOT_RUN | MATLAB executable unavailable in authoring environment |
| GitHub Actions | NOT_RUN | No remote workflow execution requested/performed |

## Acceptance disposition

`S01.03` (Model facade, 15 points) and `S01.04` (validation, 10 points) may count as **implemented** after code and static checks, but are **not verified** until their positive and negative MATLAB tests execute and results are inspected. Other tasks remain at previous recorded status. Static Python checks are **not** substitutes for MATLAB tests.

## Outstanding issues

- `QA-01B-001`: MATLAB R2024b+ runtime and MATLAB Code Analyzer results requested from user.
- `QA-01B-002`: owner must approve license before declaring MIT/public release.
- `QA-01B-003`: user-generated `.prj` and MATLAB Project files are not in author's baseline ZIP. Patch deliberately never deletes or alters them.
