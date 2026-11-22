# 01B — Section count and Code Analyzer regression repair

## Observed on user's MATLAB installation

- `example_01_model_basics.m` ran without an exception after the section schema hotfix.
- The example produced `NodeCount=2`, `MaterialCount=1`, **`SectionCount=2`** after one `addSection` call; expected count is 1.
- MATLAB suite reported **18 passed, 1 failed**: `TestModelRegistry/sectionReferencesAndRevisions`, actual `[0 1 2]`, expected `[0 1 1]`.
- MATLAB Code Analyzer reported 5 diagnostics across `Model.m`, `parseOptions.m`, `validateMaterial.m`, and `validateName.m` (`AGROW` and `NOPRT`).
- The local test method name/line differs from the archived 01B source; the author **does not have the complete local source tree**, so the exact local drift is not proven.

## Scope of this repair

1. `Model` constructor explicitly normalizes the section registry to **zero elements** while preserving the schema.
2. First `addSection` replaces a legacy single empty placeholder rather than appending beside it. Later insertions retain strict field-set and field-order checking.
3. `Model.validate` preallocates issue slots to remove the `AGROW` pattern.
4. Restore known-good semicolon-terminated 01B reference copies of `parseOptions`, `validateMaterial` and `validateName` to silence the reported `NOPRT` emissions.
5. Add three MATLAB regression tests in `TestSectionCountIntegrity.m` for initial, single, multiple, and rejected section operations.

## Verification status

- Python static contract audit: PASS in reconstructed baseline (not MATLAB runtime).
- SHA-256 file manifest: PASS for reconstructed baseline with this patch.
- MATLAB unit tests and Code Analyzer: **NOT RUN** in patch-authoring environment (MATLAB not installed).
- Before declaring stage 01B verified, execute in MATLAB on a freshly launched session:

```matlab
cd('P:\projects\ArkaFEM\ArkaFEM')
run(fullfile(pwd,'scripts','setupArkaFEM.m'))
m = arka.Model("2D", "Truss");
disp(m.summary())
m.addMaterial("Steel", 'E', 200e9, 'nu', 0.3, 'rho', 7850);
m.addSection("BarA", "Steel", 'A', 0.002);
disp(m.summary()) % SectionCount must be exactly 1
run(fullfile(pwd,'scripts','run_all_tests.m'))
run(fullfile(pwd,'scripts','run_lint.m'))
```

## Risk / integration notes

The package is assembled from the archived 01A, 01B, two earlier single-file repair patches and the 01B schema hotfix. If the user's Git tree has additional local modifications, review `git diff` after extracting and check the active MATLAB `which('arka.Model','-all')` path. Do not override meaningful local edits blindly. The new digest manifest describes this reconstructed source baseline, not unknown local edits or MATLAB project-generated files.
