# ADR-0001: MATLAB package bootstrap without fabricated Project metadata

- **Date:** 2026-11-14
- **Status:** Accepted for development bootstrap; MATLAB compatibility pending.
- **Context:** The supplied charter requires a script-first MATLAB FEM library, `src/+arka`, no mandatory additional toolbox, and a real MATLAB Project metadata artifact where feasible. The available environment has no MATLAB executable.
- **Decision:** Provide the source-root package and only-`src` setup now, plus `arka.version`, tests and reproducible CLI commands. **Do not** hand-craft an unverified `.prj` and do not label MATLAB test results as passed. Generate/open/check a real MATLAB Project when an actual MATLAB environment is available, without recursively adding the repository root to the MATLAB path.
- **Rationale:** Incorrect project metadata and misleading compatibility assertions are worse than an explicit, tracked missing artifact.
- **Consequences:** S01.01 cannot be fully accepted; tests and smoke are NOT_RUN. Windows needs user-installed GNU Make and MATLAB CLI access. MATLAB package implementation work may continue only with explicit acknowledgment of this blocker.
- **Migration impact:** None for end-user API; adding the verified `.prj` later is a tooling change. No change to numerical contracts.
- **Follow-up test:** In MATLAB R2024b+, create/open the project, run `setupArkaFEM`, `which('arka.version')`, the smoke example, Code Analyzer and `runtests`. Capture MATLAB release and log.
