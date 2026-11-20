# ArkaFEM — active architecture (Stage 01A)

Design baseline: `spec/ArkaFEM_PromptKit_v2/REFERENCES/ARCHITECTURE.md` (preserved unchanged). This active document describes the intended design without claiming unbuilt features are implemented.

## Layers and status

| Layer | Planned responsibility | Actual at 01A |
|---|---|---|
| Public facade | `arka.Model`, eventually `arka.Results` | **Planned**; only `arka.version` implemented |
| Data registry | Nodes, materials, sections, element descriptors | Planned 01B/02 |
| Model compiler | Kinematics, active DOF map and deterministic ordering | Planned 01C/02 |
| Pure element kernels | Local stiffness, transformation and recovery | Planned 03+ |
| Sparse assembly | `(I,J,V) -> sparse` triplets | Planned 02D |
| Constraints and solver | Partitioned Dirichlet solve, reactions | Planned 01C internal proof |
| Postprocessing | Revision-locked results | Planned |

## Packaging and path

Public files belong in `src/+arka`. Source-only `src` is added with `scripts/setupArkaFEM.m`. `+internal` will be created as actual internal kernels arrive; it is a naming contract, not a security mechanism. MATLAB R2024b+ remains a test target, not verified compatibility. No additional MATLAB toolboxes are planned as core dependencies.

## Normative contracts

The canonical rules are preserved without silent modification in `docs/NUMERICAL_CONTRACTS.md`: SI units, double, fixed DOF families, sorted node IDs, global-to-local `u_l=T*u_g`, `K_g=T'K_l*T`, sparse assembly, `K_ff U_f=F_f-K_fc U_c`, reaction `R=K U-F`, no default gravity, and never solve with matrix `inv`.

A sample **future** API is documented in `docs/API_SPEC.md` and must not be run at Stage 01A. Every contract change requires an ADR, migration note and tests.

## Release posture

Version `0.0.1-dev` is a development label. MIT is proposed but unapproved. The next release target `v0.1.0` is conditional on completed Stage 03 validation, and no engineering-certification claim is made.
