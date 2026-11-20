# ArkaFEM — Numerical and Structural Contracts

**Revision:** NC-1.0 | **Applies to:** all engine code and benchmark fixtures.

Normative words: **MUST** = mandatory; **SHOULD** = strongly preferred; **FUTURE** = not implemented in current release. A contract change requires a documented Architecture Decision Record (ADR) and migration/tests.

## NC-01: Units and scalar types

All internal quantities MUST be real finite IEEE-754 `double`, unless a future solver explicitly declares an alternative. Internal units MUST be SI. **No automatic or implicit unit conversions.**

| Quantity | Internal unit |
|---|---|
| Length / displacement | m |
| Area / inertia | m² / m⁴ |
| Young's/shear modulus / stress | Pa = N/m² |
| Force | N |
| Moment / torque | N·m |
| Mass / density | kg / kg/m³ |
| Acceleration / acceleration of gravity | m/s² |
| Distributed line load | N/m |
| Rotations | rad |
| Spring translational stiffness / rotational stiffness | N/m / N·m/rad |
| Time / temperature difference | s / K |

Load application MUST state its coordinate basis. Self-weight MUST NOT be injected by default. Model examples may use `[0,0,-9.80665]` m/s² for gravity in 3D, or `[0,-9.80665]` in 2D, when explicitly requested.

## NC-02: Coordinates and geometry

- Global Cartesian system is **right-handed**, `X × Y = Z`.
- 2D models use XY plane, with Y conventionally 'up' in examples; positive RZ is counterclockwise looking along +Z by right-hand rule.
- 3D building examples use +Z as vertical, but the numerical core accepts any world orientation; an explicit gravity vector defines physical down.
- Strict 2D nodal input is a 1x2 vector `[x,y]`; strict 3D input is 1x3 `[x,y,z]`. No implicit padding.
- Every member has directed connectivity `i -> j`; length `L > 0` must be verified.
- 2D member local x points `i -> j`, local y is obtained by 90° CCW rotation. With `c=dx/L`, `s=dy/L`, global-to-local rotation is `R2 = [c s; -s c]`.
- 3D local x is normalized `(xj - xi)`. A reference direction is projected orthogonal to local x to obtain local y, then local z = local x × local y. Parallel reference vectors MUST be rejected or resolved by a documented deterministic fallback; never create undefined axes silently.

## NC-03: Degrees of freedom (DOFs)

- Indexing is **MATLAB 1-based** internally.
- Model node IDs and DOF indices MUST NOT be conflated.
- Canonical DOF labels: `UX, UY, UZ, RX, RY, RZ`.
- First-generation DOF order by family: 1D `[UX]`; 2D truss `[UX UY]`; 2D frame `[UX UY RZ]`; 3D truss `[UX UY UZ]`; 3D frame `[UX UY UZ RX RY RZ]`.
- Within a family, global DOFs are ordered by **ascending node ID**, then prescribed family DOF order. This is a reproducible serialization/benchmark rule.
- Stage 01 must implement deterministic DOF-map generation for supported family definitions without performing full mesh analysis.
- Missing nodes, orphan DOFs, incompatible restraints and unconstrained rigid-body modes MUST be diagnosed, not silently padded with dummy stiffness.
- Mixed-family models are postponed until an active-DOF-union compiler is designed and tested.

## NC-04: Element transformation

Let `u_e^g` be an element's global displacement vector and `u_e^l` its local vector. Define

`u_e^l = T_e u_e^g`.

For a compatible element formulation:

`K_e^g = T_e' K_e^l T_e`, `p_e^g = T_e' p_e^l`.

For ordinary orthonormal orientation rotations, `T_e` is block orthogonal. Any offset, condensation, eccentricity or non-orthogonal transformation must specify the correct mapping explicitly, not reuse a pure rotation incorrectly.

**Elastic symmetry contract:** for a linear conservative elastic element and compatible coordinates, `K_e ≈ K_e'` and partition blocks satisfy `K_ji = K_ij'`. Unsymmetric tangent formulations later may opt out only with a declared capability and dedicated solver.

## NC-05: Stiffness assembly

For global dimension `n`, each element returns a map `d_e` and an element matrix `K_e^g`. Assemble entries of `(d_e(a), d_e(b), K_e^g(a,b))`, then use `K = sparse(I,J,V,n,n)`. Repeated index pairs MUST accumulate. The matrix's dimensions MUST match the mapped active DOFs.

The global equilibrium equation is `K U = F`, where `F` is the **total equivalent nodal external action vector**, including explicitly applied nodal loads and properly transformed consistent element loads. Avoid counting both distributed loads and their equivalent actions as independent forces.

## NC-06: Boundary conditions and reactions

Partition unknown/free and known/constrained DOFs as `f` and `c`. Given prescribed `U_c`:

`K_ff U_f = F_f - K_fc U_c`

The full residual/reaction vector is:

`R = K U - F`.

`R_c` gives reactions at constrained DOFs; `R_f` is the free-equilibrium residual and SHOULD be approximately zero. Prescribed settlement MUST work even when nonzero. A zero-restraint shortcut must not corrupt the general method.

Dirichlet elimination is the default. Penalty approaches are not a default substitute. Multipoint constraints (FUTURE) may use `U = C q + U_0`; their reduced equations become `C' K C q = C'(F - K U_0)` when the transformation method is applicable.

## NC-07: Internal element actions

For linear element recovery, local nodal end actions follow:

`q_end^l = K_e^l u_e^l - p_equiv^l`

The local coordinate basis, index order, positive axial tension, bending-end sign convention, element loads and release handling must be part of each element's documentation. Do not claim SAP2000 force-diagram sign equivalence without a checked conversion mapping.

## NC-08: Solver policy and failures

- NEVER compute `inv(K)` as a solution strategy; use partitioned `\` or appropriate decomposition.
- For sparse, symmetric, positive-definite reduced systems, solver selection may exploit that structure after checks; a solver must not assume definiteness based only on a label.
- Nonfinite K/F/U, incompatible shapes, missing constraints, singular/unstable systems, duplicate constraints with conflicting prescribed values, and severe ill-conditioning must yield clear diagnostics.
- Suggested error IDs: `arka:validation:DuplicateId`, `arka:validation:InvalidCoordinates`, `arka:validation:InvalidProperty`, `arka:solver:SingularSystem`, `arka:solver:NonFiniteData`, `arka:feature:Unsupported`.
- No success status for `NaN`, `Inf`, physically unbounded or unstable output.
- Report normalized equilibrium residual `norm(K_ff*U_f-rhs) / max(norm(K_ff)*norm(U_f)+norm(rhs),eps)` as a diagnostic; a single universal tolerance MUST NOT be claimed for every badly conditioned model.

## NC-09: Material and section validation

Elastic isotropic material: `E>0`, `rho>=0`, `-1<nu<0.5`, finite values; if both E/nu and G are provided, either validate consistency `G=E/(2*(1+nu))` within documented tolerance or explicitly select an independent constitutive law. Section dimensions `A>0`, moments of inertia `Iy>0`, `Iz>0`, torsional `J>0` when required by a given element. Do not demand irrelevant section fields for a truss.

## NC-10: Results, determinism, versioning

- A result belongs to a `Model.Revision`, an analysis type, load case, units and solver settings.
- Any edit changing the model matrix must invalidate stale numerical caches.
- Result arrays should not be mutated by plotting/export.
- Deterministic node/DOF ordering enables reproducible tests; floating-point summation may still vary by runtime/platform, so use scale-aware numerical tolerances rather than bitwise equality.
- Retain `sourceReference`, `expected`, `actual`, `absoluteError`, `relativeError`, `tolerance` and status for benchmark evidence.

## NC-11: Benchmarks

**Stage 01 mandatory manually assembled spring-chain benchmark:**

- 3 horizontal DOFs; `k1=1.0e6 N/m`, `k2=2.0e6 N/m`, left DOF fixed at `u1=0`, force `F3=3000 N`.
- `K=[k1,-k1,0; -k1,k1+k2,-k2; 0,-k2,k2]`, `F=[0;0;3000]`.
- `u = [0;0.003;0.0045] m` and `R=[-3000;0;0] N`.
- Tests: nonzero prescribed displacement, contradictory restraints, malformed dimensions, nonfinite data, and a singular free matrix.

**Later analytical benchmark:** one 3 m axial bar (`A=0.002 m²`, `E=210e9 Pa`, `F=10000 N`) must give `u = FL/(AE)=7.142857142857e-5 m` after correct restraints. This belongs to Stage 03, not Stage 01.

## NC-12: Verification hierarchy

1. Analytical closed forms and independently hand-derived matrices.
2. Logan 6e *chapter/section/example* mappings with units and equation conventions documented.
3. Matrix properties, symmetry where expected, equilibrium and rigid-body/constant-strain patch tests.
4. Independent solver comparison (e.g., SAP2000) using equivalent modeling assumptions; comparisons are evidence, not absolute proof.
5. Convergence studies and stress/displacement recovery checks for continuum elements.

Advanced claims of safety-critical accuracy require additional independent qualification outside these early-stage tests.
