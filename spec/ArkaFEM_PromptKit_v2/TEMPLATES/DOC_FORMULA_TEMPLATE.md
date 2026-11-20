# <Element/section/solver name> — theory and numerical proof

- Capability: implemented / experimental / planned
- Implementation: `src/+arka/...`
- Automated test: `tests/...`
- Reference: Logan 6e, **verified** chapter/section/page or `page not verified`; complementary research reference
- Author-created benchmark (not copied from copyrighted textbook): <name>

## Physical assumptions and scope
Linearity, kinematics, material law, DOF order, local x/y/z, geometry, unit convention, sign convention, expected element applicability.

## Derivation and equations
Provide governing differential/weak form as relevant, interpolation/shape functions, matrix `Ke` and transformation `T`, assembly, boundary and recovery. Show **LaTeX** equations with dimensions.

## Worked example
Geometry, material, section, loads, restraints and system units. Hand calculation step by step, resulting numerical answer including precision, force balance, deformation, reactions and stress as applicable.

## MATLAB usage
```matlab
% Include ONLY functioning syntax for this version; otherwise label PSEUDOCODE
```

## QA and benchmark
Reference expected numerical values (independent provenance); actual runtime output; absolute/relative error, tolerance rationale, normalized equilibrium residual, test path; `NOT RUN` if not executed.

## Known limitations and next extensions
What cannot be modeled, singular cases, numerical limitations, release notes.
