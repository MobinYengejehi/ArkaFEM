# ArkaFEM roadmap — after 01C

Source of truth remains `spec/ArkaFEM_PromptKit_v2/CONTRACTS/ROADMAP_PROGRESS.json` and active `docs/progress.json`. Percent weights measure the planned scope, not calendar or effort.

| Stage | Scope | Substeps | Scope weight |
|---|---|---|---:|
| 01 | Foundation, model registry, DOF / manual solver proof | 01A–01D | 8% |
| 02 | Material/section catalogs, generalized sparse solve | 02A–02D | 15% |
| 03 | Spring, bar, 2D truss/frame | 03A–03D | 20% |
| 04 | 3D truss/frame and member controls | 04A–04D | 15% |
| 05 | Loads, combinations, modal | 05A–05D | 12% |
| 06 | Plane, plate, shell, solid | 06A–06E | 15% |
| 07 | Geometric/nonlinear/transient | 07A–07C | 10% |
| 08 | Hardening, Toolbox, release | 08A–08C | 5% |

## Stage 01 task accounting

| Task | Weight | 01C state |
|---|---:|---|
| S01.01 repository/MATLAB Project | 10 | Partial; user reports setup complete, author has no `.prj`/test log |
| S01.02 architecture/contracts/API/ADR | 15 | Implemented and accepted by docs-only static review |
| S01.03 Model facade | 15 | Verified by user: 01B tests 25/25 PASS |
| S01.04 model validation | 10 | Verified by user: 01B tests 25/25 PASS |
| S01.05 DOF mapper | 10 | Implemented; MATLAB NOT_RUN |
| S01.06 Dirichlet solver proof | 15 | Implemented; MATLAB NOT_RUN |
| S01.07 unit, negative, regression tests | 15 | Test files expanded; entire task unaccepted pending MATLAB test execution and future tests |
| S01.08 scripts/examples runner | 5 | Expanded; task pending complete Stage 01 acceptance |
| S01.09 documentation/QA release gate | 5 | In progress, not accepted |

**Weighted status:** Stage 01 implemented 65%, verified 15%; whole project implemented 5.2%, verified 1.2%. Matlab installed on user's workstation does not constitute recorded executed evidence in this authoring environment. Next executable prompt (only on command): `01D_TESTS_FINALIZE_AND_STAGE01_GATE.md`.
