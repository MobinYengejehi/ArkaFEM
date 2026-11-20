# Development Delivery Contract — ZIP, Make, Git, progress and QA

## Deliverable each prompt
- A new full `ArkaFEM_<step>_<version>.zip` with complete top-level `ArkaFEM/` repository contents. Not a patch-only ZIP. Must contain `Makefile`, `README.md`, `CHANGELOG.md`, `VERSION`, `src`, `tests`, `examples`, `scripts`, `docs` and `.gitignore` (as relevant to stage).
- `docs/STATUS.md`, `docs/HANDOFF.md`, `docs/ROADMAP.md` updated, plus machine-readable `docs/progress.json`, `docs/FILE_MANIFEST.sha256`, brief text QA summary. Exclude `.git/`, build caches, credentials, generated massive outputs.
- ZIP integrity check with listing or `ZipFile.testzip()` and file existence checks. Include reproducible commands, actual test logs (if executed) and *named* unresolved issues.

## Mandatory Makefile targets
`help`, `doctor`, `git-init`, `git-status`, `git-diff`, `git-stage`, `git-staged`, `git-commit MSG="..."`, `git-log`, `git-tag TAG="..." MSG="..."`, `test`, `lint`, `verify`, optionally `smoke`, `bench`, `package`, `release-check` as they become real. Use `/bin/sh` GNU Make targets; Windows users can run GNU Make through Git Bash/WSL/MSYS2, but do not imply GNU Make is installed by default on Windows. Never run actual `git push`, `git reset --hard`, `git clean -fdx` as a hidden build action. `git-commit` and `git-tag` must fail with explicit message if arguments are missing; no automatic commit in routine test/build.

Recommended user flow:
```bash
make help
make doctor
make test
make git-status
make git-diff
make git-stage
make git-staged
make git-commit MSG="feat: add validated element solver"
# optional after reviewed release: make git-tag TAG="v0.1.0" MSG="Release v0.1.0"
```
If Git not initialized, `make git-init` is explicit and should not be secretly invoked by `make test`.

## Numerical QA severity
- Test status enumerations only: `PASS`, `FAIL`, `NOT_RUN`, `BLOCKED`, `SKIPPED` (with reason). No fake logs.
- Must distinguish **static code inspection**, **external numerical cross-check**, and **actual MATLAB execution**.
- A blocked MATLAB run means corresponding verification task incomplete, even if implementation exists.
- Re-run affected tests when material or section formulas, local orientation, DOF ordering, solver or units are modified.
- Benchmarks record expected/computed/tolerance/provenance. Do not pretend a SAP2000 benchmark ran if proprietary program unavailable.

## Progress: calculate, do not guess
Source of truth: `docs/progress.json`, derived from `CONTRACTS/ROADMAP_PROGRESS.json` and acceptance evidence.
- Stage weight contributes to overall project verified progress if its weighted tasks are accepted: `overallVerifiedPct = sum(stage_weight * verified_task_weight/total_task_weight)`.
- The analogous `implementedPct` counts implemented code/docs regardless of executed MATLAB tests, clearly labeled **not verified**.
- Per-step completion based on completed and accepted task IDs, not subjective hours. `verified` requires documented executed relevant tests (or docs-only inspection when relevant).
- Report: stage ID, current step, stage implemented%, stage verified%, overall implemented%, overall verified%, overall remaining%, test summary by category, actual files, new API, documentation/formulas, risks, next prompt, suggested Git commit message.
- Start as 0%. Never mark stage complete if required test is unrun/failed. For internal Stage 01, preserve original S01.01–S01.09 weights (10,15,15,10,10,15,15,5,5); for other stages use explicit numbered task checklist/evidence in progress JSON, not made-up percentages.

## Stop / continuation policy
At end of each step: deliver ZIP, report and **STOP**. Wait for user to request the next prompt. If the prior step is blocked, identify that and request authorization to proceed while clearly recording the blocker; no silent gate bypass. Do not repeat already completed tasks unless a contract regression is detected.
