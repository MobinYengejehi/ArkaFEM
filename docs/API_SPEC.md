# ArkaFEM API specification — Stage 01A

## Implemented, not yet MATLAB-verified

`arka.version()` — zero-argument function at `src/+arka/version.m`. Returns scalar MATLAB struct:

| Field | Value at Stage 01A | Type |
|---|---|---|
| `Name` | `"ArkaFEM"` | string scalar |
| `Version` | `"0.0.1-dev"` | string scalar |
| `Stage` | `"01A"` | string scalar |
| `MATLABTarget` | `"R2024b+"` | string scalar |
| `MATLABVerified` | `false` | logical scalar |
| `Units` | `"SI"` | string scalar |
| `AvailableAPI` | `"arka.version"` | string scalar |

**Import:** run `scripts/setupArkaFEM.m` or add only `src` to MATLAB path. **Evidence:** static file and metadata inspection; no MATLAB runtime, so behavior is **NOT RUN**.

## Planned, not callable at 01A

- `m = arka.Model("2D", "Truss")`, `arka.Model("2D", "Frame")` — Stage 01B (model-data facade), with strict coordinates and versioned revisions.
- `m.addNode`, `m.addMaterial`, `m.addSection`, `m.summary`, `m.validate` — Stage 01B provisional, with field validation.
- Deterministic internal DOF mapping and manual `arka.internal.numerics.solveDirichlet` — Stage 01C.
- `m.addTruss`, `m.addFrame`, `m.fixNode`, `m.addNodalLoad`, `m.solveStatic` — subsequent Stage 02–03, **not implemented**.
- Plotting, advanced dynamics and general nonlinear capabilities — later stages.

No stub APIs are shipped for capabilities not yet implemented. Any material/section name is a registry reference and must not be implicitly replaced; nodes and element IDs are positive integers. Internal units are SI; radian rotations, force N, displacement m. See `docs/NUMERICAL_CONTRACTS.md` for binding future solver rules.

## Compatibility / evolution

This is a pre-1.0 development API. Semantically significant alterations require an ADR and migration notes. MATLAB base-only dependency and R2024b+ support are **targeted but not validated**.
