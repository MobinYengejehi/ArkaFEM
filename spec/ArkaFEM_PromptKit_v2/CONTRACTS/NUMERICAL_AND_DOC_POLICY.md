# Numerical, references, testing & documentation policy

**Inherit fully:** `REFERENCES/NUMERICAL_CONTRACTS.md` (NC-01..NC-12), and source-of-truth `REFERENCES/ARCHITECTURE.md`. In conflict, stop and record ADR and reconciliation; do not silently adopt inconsistent sign/axis/DOF rules.

## Required documentation for EVERY element/formulation
1. Purpose, capability flag (`implemented`, `experimental`, `planned`), mathematical assumptions: small/large displacement, Euler-Bernoulli vs Timoshenko, linear elastic, shape functions, integration quadrature.
2. Define coordinate conventions, DOF order and directional connectivity i→j, local↔global mapping, material/section requirements, units and sign of forces/end actions.
3. State constitutive matrix/element stiffness (LaTeX), derivation/assembly steps, consistent nodal loads, boundary treatment, what is *unsupported*.
4. Source: Logan 6th edition and **chapter/section/page only if actually inspected**; any alternative sources with accurate citation. Avoid long reproduced copyrighted solutions.
5. Independently authored numeric benchmark with input, expected analytical/reference answer, MATLAB invocation, computed answer, absolute/relative error, tolerance and interpretation. Check equilibrium, units, sensitivity and sign (including reversed orientation).
6. Regression test file path + example location + date/version when actually run. If runtime absent, mark `NOT RUN`, not `PASS`.

## Core math and baseline tests
- Element local→global: `u_local = T*u_global`, `K_global=T.'*K_local*T` for real matrices; equivalent load `p_global=T.'*p_local`. Offsets may require general transformation; do not conflate rotation and eccentricity.
- Assemble `sparse(I,J,V,n,n)`, duplicates sum, deterministic ID map.
- Essential boundary with known prescribed displacement: `K_ff u_f=F_f-K_fc u_c` then `R=K*u-F`.
- Default `inv(K)` prohibited; zero/near-zero mechanisms must raise explicit diagnostics. Unstable systems never silently regularize by phantom spring.
- Stage01 spring chain: K=[1e6 -1e6 0; -1e6 3e6 -2e6;0 -2e6 2e6], F=[0;0;3000], U1=0, expected U=[0;0.003;0.0045], reaction [-3000;0;0] N.
- Stage03 axial bar: E=210e9 Pa, A=0.002 m², L=3m, F=10000 N; expected UX = F*L/(A*E) = 7.142857142857e-5m. Model constrain transverse rigid modes explicitly.
- Stage02 rectangle b=0.30m,h=0.50m, expected A=.15m², Iy=.003125m⁴, Iz=.001125m⁴ using local axes declared in section spec.
- 3D truss/frame: unit axes orthonormal, det(R)=+1, identity and rotated model invariance, inverted connectivity sign recovery; no singular solver accepted.
- Section torsion J for noncircles must come from defensible formulation; may require user supplied value or approximation with explicit error bounds, never use `Iy+Iz` as default.

## Tolerance policy
Absolute and relative tolerances must be scale-aware; define benchmark-specific thresholds, never assert one unconditional tolerance across ill-conditioned systems. `relativeError` undefined/ill-scaled at zero reference must be handled by abs test. Report normalized residual, reaction force balance and algorithm diagnostic; convergence rate tests on meshed continua.

## Safety and code hygiene
No global `eval`, hidden workspace state, silent property overwrites, NaN success, fabricated model responses. Do not claim formal code-design qualification. No copyrighted textbook pages/exercises copied wholesale. Any solver in `experimental` must be excluded from stable default path and marked in docs/tests.

## Required path conventions
- `docs/theory/<element-or-solver>.md`: formula-centric detailed design
- `docs/materials`, `docs/sections`: properties/catalog/reference and metadata
- `docs/benchmarks/<case>.md`: numeric worked example and test outcome
- `tests/unit`, `tests/integration`, `tests/benchmarks`, `tests/negative`, `examples/`
- Document actual source code path and MATLAB version for observed results.
