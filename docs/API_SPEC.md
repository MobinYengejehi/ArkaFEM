# ArkaFEM public API — Stage 01C (provisional model registry + numerical proof)

The main MATLAB compatibility target is **R2024b+**, not yet verified by an observed MATLAB run in the authoring environment. Add only `<repo>/src` to the MATLAB path. No additional toolbox dependency is intentionally introduced.

## Callable in the authored 01B source

```matlab
run(fullfile(pwd, 'scripts', 'setupArkaFEM.m'));
info = arka.version();
m = arka.Model("2D", "Truss");   % or ("2D","Frame"), ("3D","Truss"), ("3D","Frame")
n1 = m.addNode(1, [0 0]);      % x,y [m]; 3D requires x,y,z
steel = m.addMaterial("Steel", 'Id', 7, 'Kind', "steel", ...
    'E', 210e9, 'nu', 0.30, 'rho', 7850, 'alpha', 12e-6);
s = m.addSection("B1", "Steel", 'A', .002); % General user-supplied A
n = m.getNode(1);
mat = m.getMaterial("Steel");  % or m.getMaterial(7)
sec = m.getSection("B1");     % or m.getSection(sec.Id)
ns = m.listNodes(); mats = m.listMaterials(); secs = m.listSections();
report = m.summary();
validation = m.validate();
snapshot = m.snapshot();       % detached value struct
```

`arka.Model` is a handle object, but the records returned by `add*`, `get*`, `list*`, `snapshot`, and `summary` are ordinary MATLAB **value structs**, not handles or mutable references into the registry. Snapshots can be changed independently; this never changes the underlying model. `Space`, `Family`, and `Revision` have private setters. Successful `add*` operations increment `Revision` exactly once; rejected operations do not change it. No remove/update/clone method exists at 01B.

## Supported inputs and defaults

| Operation | Required | Optional (name/value pairs, case-insensitive keys) | Record semantics |
|---|---|---|---|
| Constructor | `space` = `"2D"`/`"3D"`, `family` = `"Truss"`/`"Frame"` | none | Kinematic family metadata only; no DOF mapping yet |
| `addNode` | positive integer `id`, finite real coordinates | none | Coordinates are row doubles, SI metres; length 2 or 3 exactly |
| `addMaterial` | unique `name`; `E>0`, `-1<nu<0.5`, `rho>=0` | `Id`, `Kind`, `alpha`, `G` | linear-isotropic *data*; `Kind` defaults `generic`, `alpha` defaults zero; computed `G=E/(2(1+nu))`; supplied `G` must agree to relative tolerance `1e-9` |
| `addSection` | unique `name`, existing material name/ID, positive `A` | `Id`, `Shape="General"`, `Iy`, `Iz`, `J`, `Asy`, `Asz` | General section values manually supplied; unspecified moment/shear fields remain `[]`, not invented zeros or estimated values |

Material `Kind` is classification metadata: `steel`, `concrete`, `aluminum`, `rebar`, `generic`. No material nonlinearity/design logic is implied. Material `rho` is mass density [kg/m^3], not weight density. General section `A`, `Asy`, `Asz` have units m^2; `Iy`, `Iz`, `J` m^4. There is **no geometry formula** or torsional constant synthesis at 01B. `Modifiers` metadata is an all-ones value struct, not applied to an analysis. Actual parametric sections start in 02B.

Names are trimmed, case-sensitive, nonempty string scalars or character vectors. All IDs are unique within their respective registry, positive integral finite values `<= flintmax`; if omitted, a material/section ID is assigned as `max(existing Ids)+1` starting with 1. Queries/list outputs are sorted by ascending numeric ID. `getMaterial` and `getSection` accept either a name or numeric ID; `getNode` accepts only an ID.

## Stable validation IDs

| ID | Meaning |
|---|---|
| `arka:validation:InvalidDimension` / `InvalidFamily` | Unsupported model-space or family |
| `arka:validation:InvalidId` | Invalid numeric ID, overflow, nonpositive/nonintegral ID |
| `arka:validation:InvalidName` | Missing/invalid name |
| `arka:validation:InvalidCoordinates` | Wrong coordinate dimension, nonfinite/complex data |
| `arka:validation:InvalidProperty` | Missing/invalid material or section values; bad option name, kind or shape |
| `arka:validation:InvalidArgument` | Malformed arguments or repeated option key |
| `arka:validation:DuplicateId` / `DuplicateName` | Existing registry ID or name |
| `arka:validation:MissingReference` | Referenced material/section is not found |
| `arka:validation:UnknownRecord` | Node ID not found |

## New working-API surface authored in 01C

```matlab
map = arka.dofMap([10 1 5], "1D");
idx = arka.dofIndex(map, 10, "UX");  % index 3
m = arka.Model("2D", "Frame");
m.addNode(12, [1 0]); m.addNode(2, [0 0]);
map2 = arka.dofMap(m);                % labels UX UY RZ; ascending node IDs
K = sparse([1e6 -1e6 0; -1e6 3e6 -2e6; 0 -2e6 2e6]);
F = [0; 0; 3000];
r = arka.solveDirichlet(K,F,1,0);  % manual stiffness K/F only
% r.Displacements = [0;.003;.0045] m (expected)
% r.SupportReactions = -3000 N (expected)
```

`arka.dofMap` accepts exactly `dofMap(model)` (2D/3D Truss/Frame) or `dofMap(nodeIds, family)` with `family` in {`1D`,`2DTruss`,`2DFrame`,`3DTruss`,`3DFrame`}. Output: `Space,Family,NodeIds,Labels,Indices,DofsPerNode,TotalDofs,ModelRevision,Units`; `arka.dofIndex` queries that map and raises for absent nodes or inactive DOFs. Mixed-family unions are not implemented. A model edit after mapping invalidates the old revision snapshot.

`arka.solveDirichlet(K,F,c,uc)` is **pure** and requires a manually assembled N×N double stiffness matrix, N×1 full double F, and matched vectors of constrained 1-based indices / prescribed displacements (supports nonzero settlement). Returns `Displacements,Reactions,FreeDofs,ConstrainedDofs,PrescribedValues,FreeResidual,SupportReactions,NormalizedFreeResidual,ConditionEstimate,TotalDofs,FreeDofCount,NNZ,Solver,Units`. Sparse partition `Kff \ (Ff-Kfc*Uc)` is used. The condition check rejects >=1e12; normalised residual criterion is 1e-8. Those are conservative prototype safeguards; see theory notes. No automatic element assembly is provided.

The solver wrapper checks argument count. `dofIndex` checks map field presence, types, shape and the queried canonical index; reduced arithmetic overflow is rejected.

New diagnostic IDs: `arka:validation:InvalidDof`, `arka:solver:InvalidMatrix`, `arka:solver:InvalidVector`, `arka:solver:InvalidConstraint`, `arka:solver:NonFiniteData`, `arka:solver:ConflictingConstraint`, `arka:solver:DuplicateConstraint`, `arka:solver:SingularSystem`, `arka:solver:IllConditionedSystem`, `arka:solver:ConditionEstimateFailed`, `arka:solver:NonFiniteSolution`, `arka:solver:ResidualTooLarge`.

## Not callable in 01C

`addTruss`, `addFrame`, `addNodalLoad`, `fixNode`, `solveStatic`, `plotDeformed`, `arka.Results`, automatic **element assembly**, model-based FEM solution and element force recovery **do not exist**. Node and section registries are for data only. Do not call the above as if they were functional APIs.

## Changes from Stage 01A (development API, no compatibility guarantee)

`arka.version().Stage` was `"01B"` in Stage 01B; `AvailableAPI` is now a string array enumerating the available calls instead of the former single string `"arka.version"`. `Version` remains `0.0.1-dev`; MATLAB verification flag stays false until documented tests establish compatibility. No settled public stable API or released Matlab Toolbox yet.

## 01C transition

`arka.version().Stage` is `"01C"`, `Version` remains `0.0.1-dev`; MATLAB runtime validation still **NOT_RUN** in the authoring environment. See `docs/qa/01C_REPORT.md`.
