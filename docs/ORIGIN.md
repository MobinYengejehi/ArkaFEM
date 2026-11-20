# Origin and source-of-truth boundary

- Input: `ArkaFEM_PromptKit_v2_StageByStage.zip`, supplied for this development task on 2026-11-14.
- An unmodified unpacked copy is stored in `spec/ArkaFEM_PromptKit_v2/`, including all contracts, original references and all 31 execution prompts.
- The original design kit and its roadmap initial progress represent **planning**; they are not the current implementation. Current implementation evidence lives in `src/`, `docs/STATUS.md`, `docs/progress.json`, and the actual test logs.
- Normative numerical contract copied verbatim to `docs/NUMERICAL_CONTRACTS.md` from the supplied reference; changes require an ADR.
- Next-stage agent should inspect both the current source ZIP and this spec copy; do not restart the project or execute two prompts in one turn.
