# Contributing

Open-source publication and the MIT license remain **pending approval**. Until licensed, treat the repository as an unpublished development artifact, not as publicly licensed software.

- Run `make lint` and `make verify`, and report separately any tests that could not be executed. `make lint` only performs static Python checks.
- Preserve SI units, ascending node-ID DOF ordering, MATLAB public `arka` namespace, sparse numerical architecture, and Dirichlet elimination. See `docs/NUMERICAL_CONTRACTS.md`.
- Accompany each new formulation by an independently derived benchmark, assumptions, DOF/units/sign convention, and negative tests; avoid protected book passages or proprietary SAP2000 code/database content.
- For changes to normative contracts, write an ADR, migration note and tests, and revise `docs/API_SPEC.md`, `docs/STATUS.md`, `CHANGELOG.md`.
- Before proposing a commit review changes with `make git-diff`, `make git-stage`, `make git-staged`. Commit and push remain user-controlled.
- File bugs with minimal reproducible inputs, expected versus observed output, MATLAB release, `ver` information, and test log. Never report unexecuted tests as successful.
