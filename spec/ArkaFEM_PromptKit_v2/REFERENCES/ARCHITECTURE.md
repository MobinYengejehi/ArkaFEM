# ArkaFEM — Software Architecture Specification

**Design revision:** 1.0 (2026-11-14)  
**Project status:** planning; no implementation is claimed  
**Initial release target:** 0.1.0  
**Primary computational reference:** Daryl L. Logan, *A First Course in the Finite Element Method*, 6th edition (prefer SI edition when checking examples).

## 1. Product mission

ArkaFEM is a code-first MATLAB library for finite-element and matrix-based structural analysis. Its public API provides ergonomic model construction; its computational core is modular, verifiable, and optimized for large sparse linear systems. It is **not** a SAP2000-compatible replica or a graphical application in its initial scope.

Priorities: **numerical correctness > clear contracts > reproducibility > API stability > extensibility > optimization > visualization**. No safety-critical engineering suitability is asserted until independently qualified for those use cases.

## 2. Technology decisions

| Decision | Baseline |
|---|---|
| Language | MATLAB |
| Compatibility target | MATLAB R2024b and newer, to be verified in CI |
| Required toolboxes | None beyond base MATLAB |
| Architecture | Object-oriented public facade; functional numerical kernels |
| Internal arithmetic | Real IEEE 754 double in first releases |
| Internal unit system | SI only; no implicit conversions |
| Global assembly | Sparse triplet format: `sparse(I,J,V,n,n)` |
| Numerical solve | MATLAB `\`, optionally cached `decomposition`; **never** `inv(K)` |
| Documentation | Markdown with ADRs and executable examples |
| Testing | `matlab.unittest` and independent analytical benchmarks |
| Distribution | Git source first; `.mltbx` after initial stability |
| License | MIT proposed; confirm before public release |

Namespace conventions use `src/+arka` and nested namespaces. Only named, documented `arka.*` objects/functions are supported public API. `arka.internal.*` paths are implementation details (not an access-control boundary).

## 3. Layered design

1. **Public API** — `arka.Model`, later `arka.Results` and convenience functions. Validates user inputs and provides construction/query operations; does no element matrix algebra.
2. **Model data** — Node, Material, Section, Element definitions, LoadCase, Constraint; stable identifier maps and revision counters.
3. **Model compilation** — element connectivity, active DOF inference, deterministic DOF mapping, validation, numeric assembly plan.
4. **Element kernels** — pure functions receiving element state and returning local stiffness, optional mass, equivalent nodal load, transformation and recovery data.
5. **Assembly** — sparse triplet accumulation and matrix/vector build; independent of element family.
6. **Constraints** — Dirichlet first; multipoint constraints and releases in later stages.
7. **Solver** — linear-static first, modal, geometric/material nonlinear and time-history later.
8. **Post-processing** — recover element local response, nodal reaction/displacements, diagnostics and reports.
9. **Adapters/IO** — import/export, reproducible serialization, optional plotting and graphical tools.

Do not couple element code to a global mutable workspace. Do not use `eval`, `assignin`, or `global` for core state.

## 4. Public API design

The initial API is intentionally small, with subsequent capabilities additive where feasible. Future-facing code (not runnable in Stage 01):

```matlab
m = arka.Model("2D", "Truss");
m.addNode(1, [0, 0]);
m.addNode(2, [3, 0]);
m.addMaterial("steel", E=210e9, nu=0.30, rho=7850);
m.addSection("bar", A=0.002);
m.addTruss(1, 1, 2, "steel", "bar");
m.fixNode(1);
m.restrain(2, "UY", 0);
m.addNodalLoad("LC1", 2, [10000, 0]);
r = m.solveStatic("LC1");
ux = r.nodeDisplacement(2, "UX");
```

Expected analytic answer for the single axial bar: `ux = 10000*3/(210e9*0.002) = 7.142857142857e-5 m`. The above is a **future interface example**, not an implementation claim.

### API lifecycle
- Public model objects are **handle classes**; edits mutate the model and increment `Model.Revision`.
- A compiled analysis is tied to a revision. Structural/material/boundary modifications invalidate cached assembly/factorization. Load changes invalidate the RHS but need not invalidate K where appropriate.
- Result objects are **value-like snapshots** with read-only public properties. They retain model revision, load-case ID, unit metadata and solver diagnostics.
- Documented API is semantically stabilized only at 0.1.0; Stage 01 API is provisional, but changes require documented decisions.
- Identifiers: positive integer node/element IDs initially; material/section/load-case names are nonempty string scalars.
- No silent ID overwrite; duplicate IDs fail immediately.

## 5. Model families and staged support

| Family | DOFs per node | Stage |
|---|---|---|
| 1D spring/bar | UX | 02–03 |
| 2D truss | UX, UY | 03 |
| 2D frame | UX, UY, RZ | 03 |
| 3D truss | UX, UY, UZ | 04 |
| 3D frame | UX, UY, UZ, RX, RY, RZ | 04 |
| Plane stress/strain | UX, UY | 06 |
| Shell / solid | element-specific | 06+ |

Initial models select one kinematic family (`Truss` or `Frame`) and spatial dimension (`2D` or `3D`). A mixed model with per-node inferred union of DOFs is a planned extension; it must not be emulated by retaining unconstrained empty DOFs.

## 6. Element plugin contract

An element kernel shall expose at least:
- `elementType`, `schemaVersion`, `requiredNodalDofs`, `nodeCount`, compatible `space`/`kinematics`;
- `validate(geometry, material, section, options)`;
- `stiffnessLocal(context) -> Ke`, a real finite `nd x nd` matrix;
- `transformation(context) -> T`, where `u_local = T*u_global`;
- `equivalentNodalLoadLocal(context, loadCase) -> pe_local` (zero by default where supported);
- `recover(context, u_local, loadCase) -> local end forces / stresses`.

`massLocal` and `geometricStiffnessLocal` are **optional capabilities** and must return an explicit unsupported-capability error when requested, not a fabricated zero matrix. Built-in elastic elements should be symmetric where mathematically required. Elements must not directly address global system indices; the compiler supplies the DOF map.

## 7. Numerical core decisions

- Construct assembled matrices from triplets; repeated `(i,j)` entries are summed by `sparse`.
- Apply essential boundary conditions via partitioning; **never** replace constrained equations by giant penalties as the default.
- On suspected rank deficiency, instability or severe conditioning, return a diagnostic/failure instead of silently treating a least-squares solution as a physical solution.
- Avoid matrix inverses. Cache decompositions only when the stiffness matrix, boundary state and relevant solver configuration are unchanged.
- For each solve report `nNodes`, `nElements`, `nDOFs`, `nFreeDOFs`, `nnz(K)`, solver selection, condition indicators where available, residual metrics, and warnings.
- Plotting and reporting must not mutate computational results.

## 8. Distribution and reproducibility

- Repository root has MATLAB Project settings, setup/test scripts, docs, test benchmarks, and examples.
- Version each benchmark fixture and describe assumptions/units/sign conventions.
- Serialize a versioned model schema before introducing long-term disk persistence; do not rely on the object layout being permanently compatible with MAT-file persistence.
- Treat exporting to SAP2000 as an independent interoperability feature and not a source of numerical truth.
- Use references, not reproduced copyrighted book problem solutions in public docs unless independently authored or permissioned.

## 9. Stage roadmap

- **Stage 01**: project scaffold, formal contracts, baseline Model API, validation, deterministic DOF mapping prototype, small manually assembled spring-chain Dirichlet numerical proof, unit tests, docs.
- **Stage 02**: element-independent sparse assembly engine, model compilation, general linear-static solver, boundary conditions and reactions.
- **Stage 03**: spring, bar, 2D truss, beam and 2D frame elements, load recovery, 2D benchmark suite. Target release `0.1.0`.
- **Stage 04**: 3D truss/frame, local axes and orientation, releases, 3D benchmarks. Target `0.2.0`.
- **Stage 05**: load cases/combinations, distributed element loads, mass and modes, scale optimization. Target `0.3.0`.
- **Stage 06**: plane stress/strain, isoparametric and continuum; shell/plate/solid only after formulation-specific validation.
- **Stage 07**: geometric stiffness, buckling, P-Delta, nonlinear formulations, time integration.
- **Stage 08**: benchmark hardening, performance, documentation, installable toolbox, stable API and scientific quality gates.

## 10. Logan chapter mapping

Logan 6e: Ch.2 springs/direct stiffness; Ch.3 bars/trusses; Ch.4 beams; Ch.5 frames/grids; Ch.6–10 plane stress-strain, triangles, axisymmetric and isoparametric elements; Ch.11 3D stress; Ch.12 plate bending; Ch.16 dynamics. For advanced nonlinear, inelastic, shell and implementation algorithms, supplement Logan with specialized sources and independently checked benchmarks.

**External documentation:**
- MathWorks namespaces: https://www.mathworks.com/help/matlab/matlab_oop/namespaces.html
- MATLAB Projects: https://www.mathworks.com/help/matlab/matlab_prog/create-projects.html
- Sparse matrices: https://www.mathworks.com/help/matlab/ref/sparse.html
- Logan 6e publisher TOC: https://www.cengage.com/c/a-first-course-in-the-finite-element-method-enhanced-edition-6e-logan/9780357676424
