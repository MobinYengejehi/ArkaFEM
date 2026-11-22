# Isotropic elastic property metadata — Stage 01B

**Capability:** `implemented` as a registry formula only; `NOT_RUN` in MATLAB. **Not** a constitutive finite-element solver. Formula source: elementary isotropic linear elasticity; Logan 6e topical background, page and exact section **unverified**.

## Assumptions and definitions

- Small-strain linear-isotropic elasticity **is declared as material metadata**. No material stiffness matrix `D` is constructed in this stage.
- `E` Young's modulus in pascals (Pa = N/m²); `nu` dimensionless Poisson ratio; `G` shear modulus in Pa; `rho` mass density kg/m³; `alpha` thermal coefficient 1/K.
- Constitutive admissibility in this first elastic metadata model: `E>0`, `-1<nu<0.5`, `rho>=0`, finite real input and output; `alpha` finite. Optionally provided `G` must agree with derived `G` to `1e-9` relative error.
- The stored classification `Kind` (steel, concrete, aluminum, rebar, generic) does not automatically select any nonlinear/design behavior. Temperature, mass and self-weight are not applied to models.

## Formula

\[
G = \frac{E}{2(1+\nu)}
\]

For the example `E=210e9 Pa`, `nu=0.30`,

\[
G=\frac{210\times 10^9}{2(1.30)}
 = 80{,}769{,}230{,}769.23077\ \mathrm{Pa}
\]

This is a scalar material-data check, not a structural equilibrium or finite-element approximation.

## Geometry, axes, DOF, sign and reference

There are no local or global element axes, element orientations, nodal DOFs, load signs, support reactions, integration schemes, or displacement outputs in this feature. They will be declared when corresponding elements and solver are implemented. The model itself uses global Cartesian x/y(/z) coordinates in metres; no coordinate transformation occurs.

## Reproducible MATLAB call and test

```matlab
m = arka.Model("2D", "Truss");
mat = m.addMaterial("Steel", 'E', 210e9, 'nu', 0.30, 'rho', 7850);
expected = 210e9/2.6;
assert(abs(mat.G-expected) <= 1e-9*expected);
```

**Expected:** computed above. **Observed MATLAB output:** `NOT_RUN` (2026-11-20; no MATLAB binary in authoring environment). **Regression test:** `tests/unit/TestModelRegistry.m::materialValuesAndModulus`. An invalid independent `G` must produce `arka:validation:InvalidProperty` (test `tests/negative/TestModelValidation.m`).
