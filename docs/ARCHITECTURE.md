# ArkaFEM — active architecture after Stage 01B

Canonical planned design: `spec/ArkaFEM_PromptKit_v2/REFERENCES/ARCHITECTURE.md`. This active status distinguishes implemented source from still-planned layers.

| Layer | Responsibility | Source status |
|---|---|---|
| Public facade | `arka.Model`, later `arka.Results` | `arka.Model` **implemented as data-only facade**; MATLAB runtime NOT_RUN |
| Data registry | Nodes, material and section definitions | `Model` private struct-array registries, strict validators, deterministic ID ordering, revisioned mutation |
| Model compiler | Deterministic active DOF mapping | Planned 01C/02 |
| Element kernels | Local stiffness/coordinate transforms | Planned 03+ |
| Sparse assembly | `(I,J,V) -> sparse` | Planned 02D |
| Constraints/solver | Dirichlet and reactions | 01C manual matrix proof; general solver 02D |
| Postprocessing | Revision-locked results | Planned |

`src/+arka` is the public namespace, with internal validation helpers under `src/+arka/+internal/+core`. `+internal` is a naming convention (not access control). The setup script adds only the parent `src` folder to the MATLAB search path. MATLAB R2024b+ compatibility is a **target** until measured.

Private value records provide detached external snapshots. Each successful edit increments model revision exactly once. No solver/cache exists yet, so revision-based factorization invalidation has no current computational effect. All named materials/sections and node IDs are registry-local and individually validated. `get*` and lists are data retrieval, not analysis.

The unchanged numerical contracts in `docs/NUMERICAL_CONTRACTS.md` establish SI units, future DOF families, sparse assembly, local/global matrix transforms, partitioned support solution, and reactions. No load or gravitational acceleration is implicit. The only new formula in 01B derives metadata shear modulus `G=E/(2(1+nu))` with a worked check in `docs/theory/isotropic_material_registry.md`.

No API commitment for `addFrame`, `solveStatic`, stress/reaction, section geometry computation or numerical conditioning is made at this stage. Structural design/code checking is out of scope. MIT license is proposed but not approved.
