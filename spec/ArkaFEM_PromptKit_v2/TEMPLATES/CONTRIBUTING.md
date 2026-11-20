# Contributing to ArkaFEM

ArkaFEM is an open-source educational/research structural FEM library. Submit changes with a deterministic test, a theory/benchmark note for any numerical change and updates to docs/STATUS.md + CHANGELOG.md. Follow MATLAB conventions, use namespace `arka`, do not modify unrelated APIs silently, and declare all units/DOFs/sign conventions.

Local prerequisites: MATLAB R2024b or later (compatibility verified only in tested environments), Git, and optional GNU Make (`make` in Git Bash/WSL/MSYS2 for Windows).

```bash
make doctor
make verify
make git-status
make git-diff
make git-stage
make git-staged
make git-commit MSG="feat: short explanation"
```

Do not include commercial section databases, copyrighted textbook solutions, API keys or licensed SAP2000 binaries. Benchmark comparisons to proprietary software must describe independently reconstructed model assumptions. Report failed and unrun tests transparently.
