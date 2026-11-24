# Canonical single-family DOF mapping — Stage 01C

- **Capability:** implemented (MATLAB runtime verification **NOT_RUN**)
- **Source:** `src/+arka/dofMap.m`, `src/+arka/dofIndex.m`, `src/+arka/+internal/+core/buildDofMap.m`
- **Tests:** `tests/unit/TestDofMapping.m`, `tests/negative/TestDofSolverValidation.m`
- **Reference:** ArkaFEM NC-02, NC-03; Daryl L. Logan, *A First Course in the Finite Element Method*, 6e, matrix/direct-stiffness basics (**page not verified**). The exact API and ordering are project conventions, not textbook quotations.
- **Author-created example:** three 1D node IDs `[20 1 10]` (see `examples/example_02_spring_system.m`).

## Physical assumptions, scope, and conventions

Mapper is **kinematic, not an element stiffness**. For single-family meshes, every node is assigned the same nominal active DOF labels, independently of connected elements. Missing nodes/IDs, duplicate IDs and unsupported family combinations raise errors. Disconnected/dangling DOFs are not inferred without an element topology; later compilation must reject orphan active DOFs rather than install phantom stiffness.

Global Cartesian axes follow a right-handed system; 2D examples use XY with +RZ counter-clockwise about +Z. Translational DOF values are metres; rotations radians, with index values dimensionless positive MATLAB integers. Node coordinates aren't transformed by the mapper; local-to-global element matrices are **not** assembled in Stage 01C.

| Family | Per-node ordering |
|---|---|
| `1D` | `UX` |
| `2DTruss` | `UX UY` |
| `2DFrame` | `UX UY RZ` |
| `3DTruss` | `UX UY UZ` |
| `3DFrame` | `UX UY UZ RX RY RZ` |

Mixed families, plane/solid union DOFs, element release and MPC mapping are not implemented. The `arka.Model` public constructor currently only accepts `2D`/`3D` with `Truss`/`Frame`; use `arka.dofMap(nodeIds,"1D")` for the independent 1D proof.

## Derivation / definition

Let the distinct positive IDs be sorted in increasing order, `n_1 < n_2 < ... < n_N`. Each node has the ordered DOF set `q_1,...,q_d` from the family table. The global MATLAB index is

\[
  \operatorname{index}(n_i,q_j) = d(i-1)+j,
  \qquad i=1,\ldots,N;\quad j=1,\ldots,d.
\]

Thus the output `Indices` is an `N × d` matrix. The canonical flattening is **node-major**, not MATLAB column-major: for two 2D frame nodes it is `[[1,2,3];[4,5,6]]`. `ModelRevision` records the source model revision when mapping from `arka.Model`; the map is an immutable-by-copy snapshot, and the caller must invalidate it after editing that model.

## Hand-worked example and MATLAB

For IDs `[20,1,10]`, sorted IDs are `[1,10,20]`; `d=1`, giving index `1` for node 1 UX, `2` for node 10 UX, `3` for node 20 UX. For a 2D frame with IDs `[20,1]`, node 1 has `[UX,UY,RZ]=[1,2,3]`, and node 20 `[UX,UY,RZ]=[4,5,6]`.

```matlab
m = arka.Model("2D", "Frame");
m.addNode(20, [1 0]);
m.addNode(1, [0 0]);
map = arka.dofMap(m);
disp(map.Indices);                  % [1 2 3; 4 5 6]
idx = arka.dofIndex(map, 20, "RZ"); % 6
```

## QA, numerical limitations, and next extension

Acceptance: exact index/ID equality (no floating tolerance), insertion order invariance, all five families, absent node/DOF and duplicate/nonfinite ID rejection. **MATLAB observed output: NOT_RUN** at authoring time; run `scripts/run_all_tests.m`. No benchmark error measurement is claimed for a discrete integer mapping. Stage 02 adds compiled per-element active-DOF connectivity and structural completeness checks.
