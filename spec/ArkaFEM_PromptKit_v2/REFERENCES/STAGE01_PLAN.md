# ArkaFEM — Stage 01 Execution Plan

**Stage name:** FOUNDATION & CONTRACT LOCK  
**Target dev version:** `0.0.1-dev`  
**Status:** PLANNED — 0/100 weighted points completed  
**Hard constraint:** Stage 01 is not the complete FEM solver and must not imply it is.

## Goal

Produce an importable, structured, validated MATLAB library skeleton with clear computational contracts, test infrastructure, a small usable model-data facade, reproducible degree-of-freedom mapping, and a minimal real linear-system proof using a manually assembled spring chain.

## Work packages and weights

| ID | Weight | Work | Acceptance evidence |
|---|---:|---|---|
| S01.01 | 10 | Git repository, directories, MATLAB Project, version metadata | clone/open project, correct path, no path pollution |
| S01.02 | 15 | Write architecture, numerical contracts, API spec and ADRs | docs complete; interface and sign conventions consistent |
| S01.03 | 15 | Implement provisional `arka.Model`, `arka.version`, Node/Material/Section data records and model revision | construct model, add/query records, snapshot/summary |
| S01.04 | 10 | Validate inputs and error identifiers | invalid geometry/properties/IDs fail deterministically |
| S01.05 | 10 | Implement deterministic active-family DOF mapper prototype | consistent 2D-truss/2D-frame ordering independent of input insertion order |
| S01.06 | 15 | Implement internal Dirichlet partition solver for manually supplied K/F | exact benchmark with nonzero prescription and reaction recovery |
| S01.07 | 15 | Create unit, negative and regression tests | documented test runs; no failed or incomplete tests |
| S01.08 | 5 | Setup, version/smoke examples, test-runner script | documented clean install and example run |
| S01.09 | 5 | README, changelog, dependency check, CI config where license available, release report | test log, warnings, blocked items, and next-stage handoff |
| **Total** | **100** | | |

## Planned repository tree

```text
ArkaFEM/
├── src/
│   └── +arka/
│       ├── Model.m
│       ├── version.m
│       └── +internal/
│           ├── +core/
│           │   ├── validateNode.m
│           │   ├── validateMaterial.m
│           │   └── buildDofMap.m
│           └── +numerics/
│               └── solveDirichlet.m
├── tests/
│   ├── unit/
│   ├── integration/
│   └── benchmarks/
├── examples/
│   ├── example_01_model_basics.m
│   └── example_02_spring_system.m
├── scripts/
│   ├── setupArkaFEM.m
│   └── runArkaTests.m
├── docs/
│   ├── ARCHITECTURE.md
│   ├── NUMERICAL_CONTRACTS.md
│   ├── API_SPEC.md
│   ├── ELEMENT_INTERFACE.md
│   ├── VALIDATION_PLAN.md
│   ├── ROADMAP.md
│   └── adr/
├── .github/workflows/                 # CI if a compatible MATLAB license is available
├── README.md
├── CHANGELOG.md
├── LICENSE                             # finalize MIT choice before publishing
├── .gitignore
└── ArkaFEM.prj                         # generate in MATLAB rather than hand-crafting metadata
```

**Path rule:** add only `<repo>/src` to MATLAB search path; namespace children are resolved through `+arka`. Test/example folders should not be permanently added to end-user paths.

## Exact Stage 01 public API scope

Functions/classes required:
- `arka.version()` — reports version and compatibility metadata.
- `m = arka.Model("2D", "Truss")` or `arka.Model("2D", "Frame")` (future 3D family definitions may be recognized in mapper tests, but are not yet operational).
- `m.addNode(id,[x,y])` — strict 2D input; 3D node support can be a well-tested data-only feature if added.
- `m.addMaterial(name, ...)`, `m.addSection(name, ...)` — validated stored definitions only, without promising element usage.
- `m.summary()` and `m.validate()` — report counts and validation diagnostics; `m.Revision` increments on a successful edit.

Reserved but **not callable** until their implementation stages: `addTruss`, `addFrame`, `addNodalLoad`, `fixNode`, `solveStatic`, `plotDeformed`. Do not ship error-prone stubs that appear operational.

## Internal Stage 01 numerical proof

`arka.internal.numerics.solveDirichlet(K,F,constrainedDofs,values)` must:
1. Validate K is square, real, finite; F matches size; prescribed DOFs and values have matching shapes; no conflicting DOFs.
2. Compute sorted free and constrained DOF index lists.
3. Solve `K_ff U_f = F_f - K_fc U_c` without `inv` or penalty.
4. Reconstruct full `U` and `R=K*U-F`.
5. Return diagnostics or a typed error on singular / nonfinite input.
6. Provide explicit tests of the 3-spring-node/2-element chain in `NUMERICAL_CONTRACTS.md`.

There is **no** general element assembly or automatic FEM spring element in this stage; Stage 02–03 implement those.

## Stage 01 test registry

| Test ID | Objective | Required result |
|---|---|---|
| T01 | `arka.version`, project imports | pass |
| T02 | strict 2D node creation | pass |
| T03 | duplicate ID / invalid coordinates / NaN | correct errors |
| T04 | E, ν, ρ and section validation | correct errors |
| T05 | canonical deterministic DOF ordering | expected mappings |
| T06 | 3-node manually assembled spring benchmark | U2=0.003m, U3=0.0045m, R1=-3000N |
| T07 | nonzero prescribed displacement | correct partition solution |
| T08 | singular/unconstrained system | fail clearly, no false numerical success |
| T09 | API summary, revision invalidation | consistent states |
| T10 | test runner + setup on clean path | pass (record actual MATLAB release) |

For well-conditioned benchmark cases, compare `U`, `R` using named, scale-aware tolerances. No universal `1e-10` accuracy claim for arbitrary models.

## Completion criteria — Definition of Done

- [ ] All mandatory deliverables exist and are committed.
- [ ] Running `setupArkaFEM` exposes the public namespace correctly; re-running is idempotent.
- [ ] Model data APIs work for the declared Stage 01 scope; invalid input is rejected.
- [ ] Deterministic DOF mapping produces exactly the specified ordering.
- [ ] Dirichlet solver passes normal, nonzero-displacement and singular cases.
- [ ] Tests pass with **zero failed and zero incomplete tests** on a documented MATLAB release.
- [ ] README distinguishes **implemented** from **future** API examples.
- [ ] No unnecessary required toolboxes; dependence scan documented.
- [ ] CI execution recorded if licensed; otherwise mark CI **BLOCKED**, not passed.
- [ ] Final delivery includes source ZIP or repository reference, test logs, `STATUS.md` and Stage 02 handoff.

## Commands after implementation

From the repository root in MATLAB:

```matlab
run(fullfile(pwd,"scripts","setupArkaFEM.m"))
arka.version()
result = runtests(fullfile(pwd,"tests"),IncludeSubfolders=true);
assert(all([result.Passed]),"ArkaFEM tests did not all pass")
```

These commands are **acceptance instructions**, not evidence that project files have been implemented or executed.

## Reporting contract

At the end of each completed subtask, write/update `STATUS.md`:
- Current stage and subtask ID, actual version, exact work done.
- Files added/modified, reasoning for architectural contract changes.
- Tests actually run, MATLAB version/platform, passed/failed/incomplete counts.
- Known limitations and blockers; **do not mark unexecuted tests PASS**.
- Weighted progress calculated only from accepted subtasks; no percentages assigned for intentions or generated placeholders.
- Next action, and whether user testing is needed.

**Next stage handoff:** Stage 02 will implement general sparse assembly, compilation of element mappings into global DOFs, constraint manager and model-integrated linear static analysis. It must reuse Stage 01 contracts instead of bypassing them.
