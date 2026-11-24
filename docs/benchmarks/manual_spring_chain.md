# Manual linear spring-chain benchmark — 01C

- **Provenance:** independent hand calculation prescribed by ArkaFEM numerical contract NC-11; direct stiffness methodology consistent with Logan 6e, exact text/page **not verified**.
- **Capability:** manual matrix proof (no automatic element assembly).
- **Source:** `src/+arka/+internal/+numerics/solveDirichlet.m`, wrapper `src/+arka/solveDirichlet.m`.
- **Tests:** `tests/benchmarks/TestManualSpringChain.m`, `tests/negative/TestDofSolverValidation.m`.
- **Example:** `examples/example_02_spring_system.m`.
- **Runtime:** MATLAB R2024b+ is target; code authored 2026-11-20; **NOT_RUN on MATLAB** in authoring environment.

## Problem and expected independent answer

One-dimensional horizontal spring chain: node 1 connected to 2 by `k1=1e6 N/m`, 2 to 3 by `k2=2e6 N/m`. The positive global X axis follows the chain, `F=[0;0;3000] N`, `U1=0 m`. Ascending node IDs are 1,2,3 and the per-node DOF is UX. `K` has dimensions 3x3 and units N/m:

```matlab
K = sparse([1e6 -1e6 0; -1e6 3e6 -2e6; 0 -2e6 2e6]);
F = [0; 0; 3000];
out = arka.solveDirichlet(K, F, 1, 0);
```

By `F3=k2*(U3-U2)` we obtain `U3-U2=.0015m`. Equilibrium at node 2 gives `k1*(U2-U1)=3000N` => `U2=.003m`, `U3=.0045m`. Support equilibrium is `R1=-3000N`. Total external applied + reaction force is `3000-3000=0N`.

| Metric | Expected | MATLAB measured | Acceptance |
|---|---|---|---|
| U1 | 0 m | NOT_RUN | absolute error <= 1e-12 m |
| U2 | .003 m | NOT_RUN | absolute error <= 1e-12 m |
| U3 | .0045 m | NOT_RUN | absolute error <= 1e-12 m |
| R1 | -3000 N | NOT_RUN | absolute error <= 1e-7 N |
| Free reaction R2,R3 | 0 N | NOT_RUN | max absolute error <= 1e-7 N |
| Normalized reduced residual | 0 ideally | NOT_RUN | <= 1e-12 (dimensionless) |
| `sum(F+R)` | 0 N | NOT_RUN | absolute error <= 1e-7 N |

**Nonzero settlement test:** prescribe `U1=.001m`. Expected `U=[.001,.004,.0055]m`, `R1=-3000N` with unchanged spring extension. **Negative tests:** two conflicting U1 constraints, duplicated U1, singular `Kff`, malformed matrix/vector and any NaN/Inf. See QA test suite.

`absoluteError=abs(measured-expected)` and `relativeError=absoluteError/abs(expected)` when expected value is nonzero; for zero-reference entries use the absolute tolerance alone. Numerical residual is computed from the `Kff` partition using the 1-norm diagnostic in the solver theory note. The tolerances above are specifically for this well-conditioned spring benchmark and are not asserted for arbitrary structures.

**Evidence status:** mathematical expected values are independently hand-derived. No MATLAB results/benchmark pass claims have been observed or fabricated. Run:

```matlab
run(fullfile(pwd, 'scripts', 'setupArkaFEM.m'));
run(fullfile(pwd, 'examples', 'example_02_spring_system.m'));
run(fullfile(pwd, 'scripts', 'run_all_tests.m'));
```
