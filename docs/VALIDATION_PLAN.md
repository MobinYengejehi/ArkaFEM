# QA layers and acceptance policy

1. **Static repository contract**: `make lint` runs Python file/schema/path checks. This is a real execution check, but does not parse or execute MATLAB source.
2. **MATLAB smoke**: `make smoke` runs `smokeArkaFEM.m`, validating namespace resolution and version metadata, not structural calculations.
3. **MATLAB Code Analyzer**: `make matlab-lint` runs `checkcode` on project MATLAB files; fail if diagnostics found.
4. **MATLAB unit tests**: `make test` calls MATLAB `runtests`; success requires at least one test and zero fail/incomplete.
5. **Stage 01 numerical benchmark**: implement in 01C, then test spring chain using `k1=1e6 N/m`, `k2=2e6 N/m`, `F3=3000 N`, `u=[0;0.003;0.0045] m`, `R=[-3000;0;0] N`, plus nonzero prescribed displacement and singular matrix. **NOT IMPLEMENTED IN 01A.**
6. **External verification**: independent solver comparisons only after same modeling assumptions, not considered a substitute for MATLAB unit tests.

Any missing MATLAB runtime must be recorded as `NOT_RUN`. Targets fail with an explanatory error rather than returning false PASS. The exact current log is at `docs/qa/01A_REPORT.md`.
