# 01A execution QA report — 2026-11-14

**Environment:** container Linux, GNU Make, Git 2.47.3, Python 3.13.5. Neither `matlab` nor `octave` executable exists on PATH. This is a static development environment, **not** verified MATLAB R2024b.

## Observed results (only actual actions recorded)

| Check | Command / evidence | Result |
|---|---|---|
| Input Prompt Kit hash manifest | `sha256sum -c MANIFEST.sha256` from extracted prompt-kit root | **PASS** — every listed original input file checked |
| Source tree/file requirements | `make lint` (Python `scripts/static_audit.py`) | **PASS** — 23 required locations; metadata, source-path policy, forbidden inverse, valid JSON, newlines |
| GNU Make syntax/helper availability | `make help` | **PASS** — 14+ documented helper commands listed |
| Git helper status/diff/stage/staged | `make git-status`, `make git-diff`, `make git-stage`, `make git-staged` in isolated uncommitted Git test repo | **PASS** — helpers behaved as documented, **no commit/push/tag run** |
| Git helper log before first commit | `make git-log` in isolated uncommitted Git test repo | **PASS (negative behavior)** — explicit failure: no commits yet |
| Git helper status outside repo | `make git-status` in source folder lacking `.git` | **PASS (negative behavior)** — explicit failure requiring `make git-init` |
| Commit without message | `make git-commit` | **PASS (negative behavior)** — explicit missing-MSG error, no commit |
| Tag without arguments | `make git-tag` | **PASS (negative behavior)** — explicit missing-TAG error, no tag |
| Missing MATLAB diagnostics | `make doctor`, `make test`, `make matlab-lint`, `make verify` | **PASS (negative behavior)** — fail with nonzero status and clear MATLAB unavailability, **not a MATLAB test pass** |
| MATLAB namespace/import smoke | `make smoke` or MATLAB `which('arka.version')` | **NOT_RUN** — MATLAB not installed |
| MATLAB unit tests | `make test`; `tests/unit/TestBootstrap.m` | **NOT_RUN** — MATLAB not installed |
| MATLAB Code Analyzer | `make matlab-lint` | **NOT_RUN** — MATLAB not installed |
| `.prj` creation/project import | MATLAB Project UI | **NOT_RUN / BLOCKED** — MATLAB not installed; `.prj` deliberately ungenerated |
| Sparse numerical benchmarks | Solver not in Stage 01A | **NOT_RUN** — no numerical solver implemented |
| GitHub Actions static CI | `.github/workflows/static.yml` authored | **NOT_RUN** — no repository remote/workflow execution |

## Acceptance interpretation

- **S01.02 documentation**: accepted as implemented and verified by *static document inspection* only. Normative contract was copied verbatim and architecture/API/ADR documents were checked for scope and consistency. Does **not** certify MATLAB runtime behavior or structural accuracy.
- **S01.01**: incomplete; checkout/import and `.prj` acceptance must be completed using real MATLAB.
- **S01.07–S01.09**: partial/unaccepted: some runnable scripts and documents are written but MATLAB execution, full test suite and final release gates remain pending.
- Whole-task weighted progress: **Stage 01 implemented 15%, verified 15%; project implemented 1.2%, verified 1.2%, remaining verified 98.8%**.

## Open issues

- `QA-01A-001` [BLOCKED]: no MATLAB installation/license/runtime in execution environment; can't validate namespace, tests, lint or `.prj`.
- `QA-01A-002` [OPEN]: MIT license proposed but not approved, so no `LICENSE` file.
- `QA-01A-003` [PLANNED]: numerical benchmark, Model facade and input validation are for 01B–01D, not implied implemented here.

## Packaging verification

Source archive must be independently opened, `ZipFile.testzip()` checked, and its manifest verified. The source manifest `docs/FILE_MANIFEST.sha256` intentionally excludes itself to avoid a recursive hash cycle. Hashes reported alongside download in the delivery message and separate SHA256 file.
