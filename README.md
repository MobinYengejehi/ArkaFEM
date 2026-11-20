# ArkaFEM

**ArkaFEM** is a code-first MATLAB library project for structural finite-element analysis. The mathematical baseline is Daryl L. Logan, *A First Course in the Finite Element Method*, 6th edition. SAP2000 inspires general modeling terminology, not compatibility with its API or results. **Current state: Stage 01A bootstrap, not a structural solver.**

| Field | Actual status |
|---|---|
| Version | `0.0.1-dev` |
| MATLAB compatibility target | R2024b+; **unverified** |
| Required MATLAB toolboxes | Base MATLAB planned; **not runtime checked** |
| Implemented MATLAB API | `arka.version()` — metadata only |
| Model, materials, sections | **Not implemented**; Stage 01B onward |
| Assembly, structural analysis, reactions | **Not implemented**; subsequent stages |
| License | MIT **proposed, not approved**; do not publish as MIT until authorized |

## Getting started

1. Install MATLAB (target R2024b+) and make the `matlab` command available on the PATH for Make-based commands. On Windows, GNU Make is available via a compatible shell such as WSL/MSYS2 with an appropriate MATLAB command mapping; Windows does not ship GNU Make by default.
2. Unzip this repository and open MATLAB in the `ArkaFEM` folder.
3. Execute the following **supported Stage 01A example**:

```matlab
run(fullfile(pwd, 'scripts', 'setupArkaFEM.m')); % only src/ added
info = arka.version();
disp(info)
run(fullfile(pwd, 'scripts', 'smokeArkaFEM.m'));
```

The optional setup script is idempotent. **Do not** recursively add the full project to the MATLAB path; `+arka` is a package folder, so only `src` is added.

## Tests and quality gates

```bash
make help
make lint               # Python static repository checks; does NOT test MATLAB
make doctor             # must report MATLAB missing as an error
make smoke              # MATLAB batch smoke
make matlab-lint        # MATLAB Code Analyzer
make test               # matlab.unittest
make verify             # all static + MATLAB checks; fails without MATLAB
```

No MATLAB / Octave executable was available in the authoring environment. MATLAB tests, Code Analyzer, project import and the R2024b compatibility claim are **NOT RUN**, not PASS. `docs/qa/01A_REPORT.md` contains observed results and `docs/progress.json` is the numerical progress source of truth. No `.prj` project file is fabricated; the MATLAB Project setup will be created and checked in MATLAB before accepting S01.01.

## Git workflow (explicit user action only)

```bash
make git-init
make git-status
make git-diff
make git-stage
make git-staged
make git-commit MSG="chore: bootstrap ArkaFEM repository"
# Optional, only after release approval:
# make git-tag TAG="v0.1.0" MSG="Release v0.1.0"
```

No Git commit, tag, push or remote setup was made on your behalf. See [CONTRIBUTING.md](CONTRIBUTING.md), [docs/API_SPEC.md](docs/API_SPEC.md) and [docs/HANDOFF.md](docs/HANDOFF.md).

## Source-of-truth and scope

The unchanged supplied prompt kit is included under `spec/ArkaFEM_PromptKit_v2/` for portable continuation. It describes **planned work**, not completed implementation. Active status is in `docs/STATUS.md`; current rules are in `docs/NUMERICAL_CONTRACTS.md`. Next execution prompt is **01B**, but must not be executed until instructed.

**Engineering safety:** early research/education software; not qualified for safety-critical design or code compliance.
