# ArkaFEM Model data registry — Stage 01B

**Capability:** implementation authored; **MATLAB runtime verification: NOT_RUN** in authoring environment. The model has no finite-element analysis capability yet.

## Ownership, mutation and deterministic ordering

The public class `src/+arka/Model.m` subclasses `handle`, while registries `Nodes`, `Materials`, and `Sections` have `Access=private`. Model metadata (`Space`, `Family`, `Revision`) is externally readable but has private setters. The registered value records contain no mutable handle objects. Every successful addition writes a fresh record with `Revision = Model.Revision + 1`, then advances the model's revision once; all required validation finishes **before** the append. Thus rejected additions leave the model untouched.

Node `Id` is user-controlled and positive. Material/section IDs may be user-supplied or allocated deterministically as `max Id + 1`. IDs are unique **within** each registry; names for materials and sections are independently unique, trimmed and case-sensitive. Lists and snapshots sort by numeric ID, independent of insertion order. There is no implicit conversion between node IDs and global DOFs.

`m.snapshot()` returns one detached MATLAB struct containing schema version, space/family, model revision, units and three ordered struct arrays. Ordinary MATLAB copy-on-write/value semantics mean changing that struct does not mutate the model. It is an **isolated copy**, not a read-only immutable MATLAB type. There is no backdoor to a `containers.Map` or internal handle in any public return value.

## Node coordinate contract

- `2D`: exactly `[x,y]`, `3D`: exactly `[x,y,z]`, in metres; row or column input is normalized to a row of doubles.
- Only finite real numeric vectors. No NaN, Inf, complex coordinates, sparse input, implicit third coordinate, or unit inference.
- `Truss`/`Frame` family is accepted as model metadata only. DOF mapping begins in 01C and no structural analysis has been enabled.

## Material record

`Id, Name, Kind, ConstitutiveModel, E, Nu, Rho, Alpha, G, Revision`. The constitutive label is `linearIsotropic`. The stored shear modulus is derived by the elastic-isotropic relation; user-supplied `G` is checked, not substituted. `Alpha=0` is an explicitly documented default, with units 1/K. Kind tags alone never trigger code-design/nonlinear behavior.

## General section record

`Id, Name, MaterialId, MaterialName, Shape, A, Iy, Iz, J, Asy, Asz, CalculationMethod, ReferenceSource, Modifiers, Revision`. The section must reference a material already in the **same** model. `Shape="General"` is the only accepted shape here. `A>0` is mandatory, optional positive moments and shear areas remain `[]` when unknown. Values are supplied by the caller, **not** geometrically derived. The all-one `Modifiers` struct is metadata reserved for future analysis, not an active stiffness multiplier. No double-application or default gravity is possible at 01B because there is no element or loading API.

## Data validation and limitations

`m.validate()` produces a value struct `IsValid`, `Issues`, `Revision`, `Summary`. Input validation enforces record requirements at creation; `validate()` additionally checks section→material ID references. Because registries cannot be directly edited externally, the latter normally reports valid state. It is **not** a structural geometry, topology, or physical stability check.

There are no update/remove APIs, imported catalogs, release/rebar detail, parametric profiles, solver cache, elements, constraints or results. These are future development stages. `arka:validation:*` is the stable namespace for validation errors; see `docs/API_SPEC.md`.

## Reference tests and example

- `tests/unit/TestModelRegistry.m` — positive examples; sorting, section references, constitutive scalar, snapshot isolation, revisions.
- `tests/negative/TestModelValidation.m` — invalid inputs, duplicate names/IDs, orphan section reference, failed edit is atomic.
- `examples/example_01_model_basics.m` — runnable data example after MATLAB runtime verification.
- `docs/benchmarks/model_validation.md` — independently authored expected-value fixture.

**Primary scientific reference:** D. L. Logan, *A First Course in the Finite Element Method*, 6th ed., basic finite-element modeling and elastic properties; specific page/section **unverified** (no book excerpt used). Mathematical and implementation conventions are in `docs/NUMERICAL_CONTRACTS.md` and the original kit.
