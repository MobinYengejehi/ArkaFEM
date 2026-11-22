# Registry validation benchmark — 01B

**Capability:** data registry and validation, not an element/solver benchmark. **Observed MATLAB result: NOT_RUN**, no MATLAB executable in the authoring runtime. **Date of source preparation:** 2026-11-20. Source test: `tests/unit/TestModelRegistry.m`; negative counterpart: `tests/negative/TestModelValidation.m`.

## Independently authored worked fixture

Create a 2D truss-family *data model* in SI units:

1. Add node ID 10 at `[3,0]` m, then node ID 2 at `[0,0]` m. The expected output of `listNodes` is `[2,10]` by ascending ID even though records were added in reverse order.
2. Add a linear isotropic steel-tagged material ID 5 with `E=210e9 Pa`, `nu=0.30`, `rho=7850 kg/m^3`, `alpha=12e-6 1/K`.
3. Compute the isotropic shear modulus **by hand**: `G = 210e9 / (2*(1+0.30)) = 80,769,230,769.23077 Pa`.
4. Add General section `BarA` referencing material ID 5 with manually supplied `A = 0.002 m^2`. Expected `MaterialId=5`; unknown torsional property `J=[]`.
5. Expected `Revision=4` for four successful additions (two nodes, material, section). The expected summary counts are two nodes, one material, one section.
6. Modify the returned snapshot's node coordinates/material modulus. The registered model values and revision must not change.
7. Attempt a duplicate node ID 2 and a section whose material name does not exist. Both must fail with stable error IDs and keep revision 4.

```matlab
m = arka.Model("2D", "Truss");
m.addNode(10, [3 0]);
m.addNode(2, [0 0]);
m.addMaterial("Steel", 'Id', 5, 'Kind', "steel", ...
    'E', 210e9, 'nu', .30, 'rho', 7850, 'alpha', 12e-6);
m.addSection("BarA", 5, 'A', .002);
ns = m.listNodes();
assert(isequal([ns.Id], [2 10]));
steel = m.getMaterial(5);
assert(abs(steel.G - 210e9/2.6) < 1e-5);
assert(m.Revision == 4);
```

**Expected (analytical):** above, manually computed from parameters. **Computed in MATLAB:** `NOT_RUN` in this environment. **Tolerance proposed for the G fixture:** abs difference `<1e-5 Pa` (for this single well-scaled example only); the test uses relative tolerance `1e-14`. No blanket FEM accuracy assertion is made; no displacement/reaction claims exist for Stage 01B.

**Coordinate/DOF conventions:** model axes are global Cartesian x,y, distances in metres. **No DOF matrix, forces, displacements, kinematics, element transformations, or sign-dependent reaction forces are assembled at this stage.** No gravity is inferred from mass density.

**Reference/provenance:** D. L. Logan, *A First Course in the Finite Element Method*, 6th ed., elasticity and model data concepts; chapter/page **unverified**. The benchmark itself is independently authored and not copied from a textbook example.
