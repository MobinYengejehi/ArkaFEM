# ArkaFEM roadmap

Ground truth schedule: `spec/ArkaFEM_PromptKit_v2/CONTRACTS/ROADMAP_PROGRESS.json`. Each prompt is an independent deliverable with a mandatory stop. Planned contribution to total scope is **not** a forecast of elapsed time.

| Stage | Scope | Steps | Total weight |
|---|---|---|---:|
| 01 | Foundation, basic solver proof | 01A,01B,01C,01D | 8% |
| 02 | Material/section registries, model data, sparse assembly | 02A–02D | 15% |
| 03 | Springs, bars, 2D truss and frames, v0.1.0 target | 03A–03D | 20% |
| 04 | 3D truss/frame, releases and offsets, v0.2.0 target | 04A–04D | 15% |
| 05 | Loads, combinations, mass/modal, v0.3.0 target | 05A–05D | 12% |
| 06 | Plane/plate/shell/solid elements | 06A–06E | 15% |
| 07 | Buckling, nonlinear, transient | 07A–07C | 10% |
| 08 | API hardening, toolbox packaging, release QA | 08A–08C | 5% |

## Stage 01 acceptance tasks (original weights retained)

| Task | Weight in Stage 01 | 01A reality |
|---|---:|---|
| S01.01 Git/scaffold/MATLAB Project | 10 | PARTIAL: scaffold built, MATLAB `.prj` ungenerated; no runtime |
| S01.02 Architecture/contracts/API spec/ADR | 15 | IMPLEMENTED and statically reviewed |
| S01.03 Model facade | 15 | NOT STARTED (01B) |
| S01.04 Input validation | 10 | NOT STARTED (01B) |
| S01.05 DOF mapper | 10 | NOT STARTED (01C) |
| S01.06 Dirichlet solver | 15 | NOT STARTED (01C) |
| S01.07 Test suite | 15 | PARTIAL: 01A smoke/metadata tests authored, not MATLAB-run |
| S01.08 Setup/examples/test runner | 5 | PARTIAL: authored, not MATLAB-run |
| S01.09 Documentation/QA/release report | 5 | PARTIAL: ongoing through Stage 01 |

## Progress rule

Stage task points only count when an entire task is accepted, not when files are present. Overall implementation/verification uses stage weight times accepted task weight divided by total stage task weight; `docs/progress.json` lists flags and evidence. Documentation can receive static-review verification; MATLAB numerical tasks require actual MATLAB evidence.

**Current execution boundary:** 01A delivered. **Next, on user instruction only:** `PROMPTS/01B_PUBLIC_MODEL_FACADE_AND_VALIDATION.md`.
