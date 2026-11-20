# ArkaFEM — STATUS / HANDOFF (update after every prompt)

- Date (UTC): YYYY-MM-DD
- Input source ZIP + SHA-256: ...
- Current stage/step: Sxx / xxY
- Implementation status: IMPLEMENTED | PARTIAL | BLOCKED
- MATLAB runtime and release used: R20xx? / NOT_AVAILABLE
- Step task list with weights, acceptance evidence and implemented/verified flags: ...
- **Stage implemented:** x% / **Stage verified:** x%
- **Overall implemented:** x% / **Overall verified:** x%
- **Overall remaining verified:** 100-x%
- Current runnable public API (only tested): ...

| Test | Input/expected | Execution evidence | Status | Error | Notes |
|---|---|---|---|---|---|
| Unit | ... | MATLAB log / NOT RUN | PASS/FAIL/NOT_RUN | ... | ... |
| Negative | ... | MATLAB log / NOT RUN | PASS/FAIL/NOT_RUN | ... | ... |
| Numerical | ... | MATLAB log / NOT RUN | PASS/FAIL/NOT_RUN | ... | ... |

### Changed files
- `path`: purpose

### Documentation updates
- `docs/theory/...`: matrix, assumptions, worked example, source
- `docs/sections/...` or `docs/materials/...`: validated fields
- `docs/benchmarks/...`: numerical comparison

### Risks / known limitations / unverified capabilities
- ...

### Git instructions (suggest only, no auto commit)
```bash
make git-status
make git-diff
make git-stage
make git-staged
make git-commit MSG="feat: ..."
```

### ZIP integrity
- output ZIP, size, SHA256, opened/tested: ...
- manifest: `docs/FILE_MANIFEST.sha256`

### Exact next prompt
- `PROMPTS/xxY_....md` (do NOT execute until instructed)
