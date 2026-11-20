# MATLAB Project metadata: deferred until MATLAB is available

Stage 01A contains a runnable package-parent setup script, tests and initial MATLAB source. It does **not** include an `ArkaFEM.prj`, because generating/validating MATLAB Project metadata without MATLAB would be misleading. S01.01 remains incomplete.

When MATLAB R2024b+ becomes available:
1. Open the unpacked ArkaFEM repository root in MATLAB.
2. Create a MATLAB Project using **Home > New > Project > From Folder**, selecting this repository root; retain project metadata in the repo.
3. Ensure only `src` is on MATLAB path for the public `arka` namespace. Do not recursively add tests, examples, or internals as user path entries.
4. Run `run(fullfile(pwd,'scripts','setupArkaFEM.m'))`, `which('arka.version')`, `make smoke`, and `make test`, recording actual MATLAB release and logs.
5. Update `docs/STATUS.md` and `docs/progress.json` once all S01.01 acceptance evidence exists.

This procedure is proposed; no MATLAB Project was opened or executed by the authoring environment.
