# Execution prompt — ArkaFEM Stage 01

You are the lead MATLAB structural-analysis engineer for **ArkaFEM**. The repository has not yet been implemented. Treat `ARCHITECTURE.md`, `NUMERICAL_CONTRACTS.md`, and `STAGE01_PLAN.md` in this package as authoritative source-of-truth specifications. Implement **Stage 01 only**, in small verifiable increments.

## Nonnegotiable rules

1. Use MATLAB and standard built-in functions only; aim for R2024b+ compatibility. Do not assume MATLAB execution if it is not available. If only static inspection is possible, clearly label tests **NOT RUN**.
2. Organize the public MATLAB namespace in `src/+arka`; add only `src` to paths. Public facade Object-Oriented, internal kernels function-oriented.
3. Match the numerical contracts exactly: SI, no hidden gravity, strict dimensions, deterministic sorted node-ID DOFs, global-to-local element convention, partitioned Dirichlet elimination, reaction `R=K*U-F`, no explicit inverse.
4. Build an actual Model data facade and input validation, but do not pretend full truss/frame analysis is implemented in Stage 01.
5. Implement a small internal numeric proof for a **manually assembled** spring chain, including prescribed displacements, reactions, and negative tests.
6. Test input errors and numerical invariants as first-class behavior. Use reproducible MATLAB unit tests.
7. Keep metadata, API spec, diagrams/documentation, changelog, ADRs, and examples synchronized with code. No placeholder files marked complete.
8. Use a meaningful file tree, readable source and immutable result/snapshot semantics where applicable.
9. Avoid Scope Creep: no GUI, no shell/solid elements, no P-Delta, no modal solver, no SAP2000 bridge in Stage 01.
10. Never claim completion or test success without verifiable evidence; note missing MATLAB licensing/runtime explicitly.

## Work and acceptance

Execute S01.01–S01.09 in order as described in `STAGE01_PLAN.md`. At each subtask, update `STATUS.md`, note files changed, provide concise test results, and compute progress only for accepted subtasks. Finish only after all mandatory DoD checks pass, otherwise report exact blockers and partial progress.

For numerical proof set k1=1e6 N/m, k2=2e6 N/m, F3=3000N, U1=0. Expected U2=0.003m, U3=0.0045m, R1=-3000N. Verify output and normalized residual. Validate singular systems and nonzero prescribed displacements as independent cases.

## Final handoff

Deliver source repo or zipped source, `STATUS.md`, test report, implementation map, open TODO list for Stage 02, and an unambiguous percentage (accepted task weights /100). Any architecture change must be documented as an ADR. Do not seek user manual tests until a genuinely runnable deliverable exists.
