# Dirichlet elimination for a supplied linear system — Stage 01C

- **Capability:** implemented numerical prototype, **MATLAB verification NOT_RUN**
- **Implementation:** `src/+arka/+internal/+numerics/solveDirichlet.m` (public wrapper `src/+arka/solveDirichlet.m`)
- **Automated tests:** `tests/benchmarks/TestManualSpringChain.m`, `tests/negative/TestDofSolverValidation.m`
- **Example:** `examples/example_02_spring_system.m`
- **Reference:** ArkaFEM NC-05, NC-06, NC-08, NC-11; Daryl L. Logan, *A First Course in the Finite Element Method*, 6e, spring/direct stiffness method (**page not verified**). Benchmark is independently authored, not a verbatim textbook exercise.

## Assumptions, units, sign and limitations

Small-displacement **linear** spring system with no geometric/material nonlinearity, in global +X. For the illustrative translational spring chain, `U` is metres, `F` and `R` newtons, stiffness `K` N/m. Positive `F` acts in positive global +X; a negative support reaction opposes the applied positive load. DOFs are enumerated 1-based. `arka.solveDirichlet` is a pure numerical kernel and accepts any real finite square `double` K with a sufficiently well-conditioned unconstrained block; it does not infer physical units or assert that user-supplied K has a valid structural derivation. It does not assemble element stiffness, infer supports, create load cases, or modify a Model.

Nonfinite reduced right-hand sides and overflow in residual normalization are rejected explicitly.

No element orientation transforms are needed for this one-axis manually assembled example; if local coordinates existed, transformation would be `K_g=T^T K_l T` by NC-04. Singular/mechanism cases are rejected, not regularized by fictitious springs. No multipoint constraints or nonlinear solution is available.

## Derivation and matrix block partition

Equilibrium is

\[
  \underbrace{K}_{N\times N}\underbrace{U}_{N\times1}=
  \underbrace{F}_{N\times1}+\underbrace{R}_{N\times1}.
\]

Partition degrees of freedom into unconstrained/free set `f` and known/prescribed set `c`:

\[
  \begin{bmatrix}K_{ff}&K_{fc}\\K_{cf}&K_{cc}\end{bmatrix}
  \begin{bmatrix}U_f\\U_c\end{bmatrix}
  =\begin{bmatrix}F_f\\F_c+R_c\end{bmatrix},
  \quad\Rightarrow\quad
  K_{ff} U_f=F_f-K_{fc} U_c.
\]

When the reduced system is non-singular and well conditioned,

\[
 U_f=K_{ff}\backslash(F_f-K_{fc}U_c),\qquad R=KU-F.
\]

For numerical diagnostics, let `b=F_f-K_fc*U_c` and `r_f=K_ff*U_f-b`. With the 1-norm,

\[
 \eta_f = \frac{\lVert r_f\rVert_1}{
 \max(\lVert K_{ff}\rVert_1\lVert U_f\rVert_1+\lVert b\rVert_1,\epsilon)}.
\]

For this prototype, estimated `cond_1(Kff)` >= `1e12` is rejected, and normalized residual > `1e-8` is rejected. These are **conservative prototype diagnostics, not universal FEM error thresholds**; matrix scaling and conditioning matter. For <=128 free DOFs the code uses dense `rcond` **only as a diagnostic**, solves via sparse backslash; for larger blocks it uses sparse `condest`. No `inv(K)` and no penalty are used. Fully constrained models have `FreeDofs=[]`, `NormalizedFreeResidual=0` and reactions recovered directly.

## Hand calculations: manual spring chain

For k1 = 1,000,000 N/m between nodes 1 and 2, k2 = 2,000,000 N/m between nodes 2 and 3, +3,000 N at node 3, and prescribed `U1=0`:

\[
 K = \begin{bmatrix}
 10^6 & -10^6 & 0\\
 -10^6 & 3\cdot10^6 & -2\cdot10^6\\
 0 & -2\cdot10^6 & 2\cdot10^6
 \end{bmatrix}\;\mathrm{N/m},\quad
 F = [0,0,3000]^T\;\mathrm{N}.
\]

The third equilibrium equation is `2e6(U3-U2)=3000`, hence `U3-U2=.0015m`. The second equation gives `-1e6 U1 + 1e6 U2 - 2e6(U3-U2)=0`, so `U2=.003m` (as `U1=0`) and `U3=.0045m`. Thus

\[
 U=[0,0.003,0.0045]^T\;\mathrm{m},\qquad
 R=KU-F=[-3000,0,0]^T\;\mathrm{N}.
\]

Force equilibrium `sum(F+R)=0`. For nonzero support settlement `U1=+0.001m`, relative deformations remain unchanged under rigid translation: `U=[.001,.004,.0055]^T`, same `R1=-3000 N`.

## Executable MATLAB (no automated FEM assembly)

```matlab
K = sparse([1e6 -1e6 0; -1e6 3e6 -2e6; 0 -2e6 2e6]);
F = [0;0;3000];
out = arka.solveDirichlet(K, F, 1, 0);
disp(out.Displacements);         % expected [0; .003; .0045] m
disp(out.SupportReactions);       % expected -3000 N
out.NormalizedFreeResidual
```

## QA and benchmark disposition

Benchmark `docs/benchmarks/manual_spring_chain.md` defines expected values, analytical provenance, target tolerances and paths; **actual MATLAB results remain NOT_RUN** until the user's runtime test output is reviewed. Reverse connectivity/element sign testing is not applicable to a hand-supplied K and belongs to future element tests. Test failure diagnostics include `arka:solver:InvalidMatrix`, `InvalidVector`, `InvalidConstraint`, `NonFiniteData`, `ConflictingConstraint`, `DuplicateConstraint`, `SingularSystem`, `IllConditionedSystem`, `ResidualTooLarge`.
