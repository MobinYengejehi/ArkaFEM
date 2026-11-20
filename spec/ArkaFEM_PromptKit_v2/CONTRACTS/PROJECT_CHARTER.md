# ArkaFEM — Charter, architecture and public API principles

## Mission
Open-source, script-first MATLAB library for structural finite-element modeling and numerical analysis. SAP2000 inspires **modeling concepts** (material/section catalog, elements, load cases, postprocessing) but is NOT a compatibility or feature-equivalence commitment. GUI is not needed in initial releases. Primary mathematical reference: Daryl L. Logan, *A First Course in the Finite Element Method*, 6e; supplementary cited references are required for advanced formulations.

## Stable decisions
- Numerical contracts: refer to `REFERENCES/NUMERICAL_CONTRACTS.md`; this is mandatory baseline.
- Namespace: `src/+arka` and separate `+internal` (private-by-convention).
- Public MATLAB API: `arka.Model` handle facade + pure `arka.internal` kernels, later `arka.Results` immutable value/snapshot model. MATLAB dependency base only, R2024b+ compatibility **test required**.
- SI, rad, finite double, no hidden gravity, sparse global K, Dirichlet elimination, deterministic DOF order, result-to-model revision, explicit negative tests.
- README must mark available (implemented/tested), planned, experimental separately. Publish changelog and semver versions after tested milestones.
- Revisions: Stage 01 initial skeleton `v0.0.x-dev`; target `v0.1.0` after verified 2D beam/frame solver, `v0.2.0` after 3D; `v0.3.0` after load/mode additions. These are targets not promised dates.
- Open Source: MIT **proposed**, not officially decided; no inclusion of protected product code/book paragraphs/copyrighted section tables. Store third-party attributions if legal reuse verified.

## API sketch (DESIGN ONLY; syntax locked after tests)
```matlab
model = arka.Model("2D","Frame");
model.addNode(1,[0,0]);
model.addNode(2,[4,0]);
model.addMaterial("S355", E=210e9, nu=0.30, rho=7850);
model.addSectionRect("R40x60","S355", b=0.40, h=0.60);
model.addFrame(1,1,2,"R40x60");
model.fixNode(1);
model.addNodalLoad("LC1",2,[0,-10000,0]);
results = model.solveStatic("LC1");
```
Treat these examples as **future API illustrations**, not working functions. An API method must be demonstrated in tests before labeling it usable. Use two-level identifiers: material ID and section ID; section holds a material reference; element holds a section reference. Node/element numeric identifiers positive integers; string IDs for material/section/load cases. No silent replacement.

## Lifecycle
Compile model to a revision-locked active DOF mapping and sparse assembly. Edits to geometry/material/section/restraints invalidate stiffness cache. Loads can invalidate RHS only where correct; settings and active-load cases are versioned. Geometry/data registry operations may use map-based structures initially; computational compilation uses contiguous indexed arrays for performance. Mixed element families need union-of-active-DOF compiler; never add fictitious stiffening for incompatible DOFs.

## Non-goals in v0.1
SAP GUI, design-code automated member design, full cracked RC/nonlinear concrete, bridge-specific advanced effects, nonlinear time history, proprietary SAP databases or file parsing.

## Engineering use disclaimer
Research/education software until extensively verified and independently assessed for use in safety-critical design. Never invent code-compliance approval or guarantee engineering accuracy.
