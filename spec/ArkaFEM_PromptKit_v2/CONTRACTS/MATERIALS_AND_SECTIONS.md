# Materials & Section Catalog — normative specification (SAP-like concepts, independent implementation)

A **Material** is a constitutive record, a **Section** is a geometric/properties record that references one material, and an **Element** references a section (or material+area for legacy adapters where documented). This mirrors the *conceptual separation* found in SAP2000, not its proprietary internal data. All registries are name/ID-based with explicit assignment, versioning, validation and querying.

## M-01 Material registry
Required in first elastic version: `id`, `name`, `kind` (`steel`, `concrete`, `aluminum`, `rebar`, `generic` as classification metadata only), `constitutiveModel='linearIsotropic'`, `E [Pa]`, `nu [-]`, `rho [kg/m^3]`, `alpha [1/K]` (thermal expansion; optional explicit default 0 only when documented), `G [Pa]` computed `E/(2*(1+nu))` unless an explicitly supported independent law. `g [m/s²]` belongs to an *applied load case/analysis context*, not material; weight density must never silently equal mass density. `fy [Pa]`, `fu [Pa]`, `fc [Pa]`, `grade`, `standard`, `region`, `color`, `notes` may be metadata for future design/nonlinear work; they do not automatically change elastic stiffness. Enforce `E>0`, `rho>=0`, `-1<nu<0.5`, finite values, unique IDs. Steel/concrete tags do not imply constitutive response absent implementation.

Potential later laws (each with distinct capability flag, calibration and tests): orthotropic elasticity, stress-strain curve, bilinear elastoplastic, temperature dependence, RC cracking/creep/shrinkage. No misleading fake support.

## S-01 Section registry
All sections: `id`, `name`, `materialId`, `shape`, `parameterSchema`, `geometricProperties`, `calculationMethod`, `referenceSource`, `modifiers` and revision. Geometry in m and derived `A [m²]`, `Iy/Iz [m⁴]`, `J [m⁴]` (Saint-Venant torsion constant, **NOT** polar second moment for non-circular sections), `Asy/Asz [m²]` if needed by Timoshenko formulation, local principal axes orientation. Optional `Iyz`, centroid, shear center, warping constants with explicit capability and geometry method. For truss only A is required; frame requires moment/torsional props applicable to its kinematics; do not require irrelevant fields.

### Rollout: types and calculation policy
- **Early (Stage 02)**: `General` manually supplied `A,Iy,Iz,J,Asy,Asz` where required; `Rectangle(b,h)` with verified A/I and explicit local-axis dimension orientation; `Circle(d)` and `Pipe(D,t)` with correct area, centroid and circular torsion. Every dimension positive and consistent; `D>2t` for pipe.
- **Later (Stage 05/08)**: `Tube(B,H,t)`, `I/WideFlange(h,bf,tw,tf)`, `Channel`, `Tee`, `Angle`, `built-up`, `nonprismatic`, `section library JSON/CSV`, Section Designer-like custom geometry. These need independently verified second moments, centroids, torsion, shear areas; **never assume J = Iy+Iz for open thin-walled shapes**. Thin-wall approximations must be labeled with applicability.
- **Plate/Shell**: membrane/bending thickness, material, integration options. **Solid**: element material; no fictitious beam-section requirement. Composite/laminated sections later with explicit constitutive model, not an automatic extension of isotropic section.
- `frame modifiers` should distinguish `A,Asy,Asz,J,Iy,Iz` and optional mass/weight multipliers, define whether they apply at section or object level and prohibit unintended double application; record result in model revision. Default all multipliers to 1.
- Reinforcement/rebar definitions are **future metadata**, not verified RC design; when added specify covers, bars, longitudinal/transverse layout, core model and design-standard dependencies. Keep geometry vs analysis properties distinct.

## M-02 Provenance and catalogs
Support `addMaterial`, `getMaterial`, `listMaterials`, `cloneMaterial` and section create/query/assign functions; immutable external snapshots. Unit and version metadata. Avoid bundling SAP2000 licensed libraries or copyrighted section databases. JSON/CSV import can accept **user-provided or redistributable** catalogs with validated schema and units; test round-trip. External product equivalence is never assumed.

## M-03 Suggested public API (future only)
```matlab
m.addMaterial("Steel", E=200e9, nu=0.3, rho=7850, alpha=12e-6);
m.addMaterial("Concrete", E=30e9, nu=0.20, rho=2400);
m.addSectionRect("R30x50", "Concrete", b=0.30, h=0.50);
m.addSectionGeneral("GEN1", "Steel", A=0.01, Iy=8e-5, Iz=3e-5, J=1e-6);
m.addFrame(11, 1, 2, "R30x50");
m.setFrameModifiers(11, Iy=0.7, Iz=0.7);
```
Stage 02 returns property outputs `A,Iy,Iz,J` with dimension/unit and reference method; assignment to beam elements becomes runnable in Stage 03.

## M-04 Numerical checks & explicit examples
- Rectangular: `A = b*h`; with local y along width `b` and local z along depth `h`: `Iy = b*h^3/12` (about local y), `Iz = h*b^3/12` (about local z); document axis convention visibly and verify by benchmark. This axis selection must be consistent with frame bending DOFs and matrix. Geometric I formulas cannot be swapped when section rotated. Validate using b=0.3m, h=0.5m: `A=0.15 m²`, `Iy=0.003125 m⁴`, `Iz=0.001125 m⁴`.
- Solid circle radius r: `A=pi*r²`, `Iy=Iz=pi*r^4/4`, `J=pi*r^4/2` for a circular isotropic bar under Saint-Venant torsion.
- Tube: subtract concentric circular properties, `D_inner=D-2t`.
- Isotropic shear modulus: `G=E/[2(1+nu)]`, unit Pa.
- Must create negative tests: duplicate material/section, missing references, zero/negative dimension, inconsistent `E,G,nu`, missing torsional property in 3D frame, and unwanted modifier double-application.

## Documentation files
- `docs/materials/material_catalog.md` and one material validation/capability page.
- `docs/sections/section_catalog.md`, one theory page per *implemented* section type.
- `docs/benchmarks/section_rectangle.md`, `material_isotropic.md` and geometry regression fixtures.
- Each page must state equation, source/provenance, coordinate axes, units, assumptions, worked numerical example, MATLAB call, exact expected result, measured result and test.

## SAP2000 concept references (not copyable code)
- https://docs.csiamerica.com/help-files/sap/Menus/Define/Material/Define_Materials.htm
- https://docs.csiamerica.com/help-files/sap/Menus/Define/Section_Properties/Frame_Sections/Frame_Section.htm
- https://docs.csiamerica.com/help-files/sap/Menus/Define/Section_Properties/Frame_Sections/General_Section.htm
- https://docs.csiamerica.com/help-files/sap/Menus/Assign/Frame/Frame_Property_Modifiers.htm
