# ArkaFEM — GNU Make helpers (POSIX shell; on Windows use WSL/MSYS2/Git Bash with Make)
# Commands never implicitly initialize Git, commit, tag, push, reset or clean.
SHELL := /bin/sh
MATLAB ?= matlab
PYTHON ?= python3
.DEFAULT_GOAL := help
.PHONY: help doctor git-init git-status git-diff git-stage git-staged git-commit git-log git-tag smoke test lint matlab-lint verify

help:
	@printf '%s\n' 'ArkaFEM commands:' '  make doctor' '  make lint          # Python STATIC checks only' '  make smoke         # MATLAB import smoke test' '  make matlab-lint   # MATLAB Code Analyzer' '  make test          # MATLAB unit tests' '  make verify        # lint + MATLAB lint + tests' '  make git-init' '  make git-status' '  make git-diff' '  make git-stage' '  make git-staged' '  make git-commit MSG="feat: message"' '  make git-log' '  make git-tag TAG="vX.Y.Z" MSG="Release vX.Y.Z"'

doctor:
	@printf 'Git: '; git --version || exit 1
	@printf 'Python: '; "$(PYTHON)" --version || { echo 'ERROR: Python 3 is required for static lint'; exit 2; }
	@printf 'MATLAB command: '; command -v "$(MATLAB)" || { echo 'ERROR: MATLAB unavailable or not on PATH; smoke, MATLAB lint and tests NOT RUN'; exit 2; }

git-init:
	@if [ -d .git ]; then echo 'Git already initialized'; else git init; fi

# Explicit repository precondition: no silent git init.
git-status:
	@git rev-parse --is-inside-work-tree >/dev/null 2>&1 || { echo 'ERROR: not in a Git repository. Run make git-init explicitly.'; exit 2; }
	@git status --short --branch

git-diff:
	@git rev-parse --is-inside-work-tree >/dev/null 2>&1 || { echo 'ERROR: run make git-init first'; exit 2; }
	@git diff --check && git diff

git-stage:
	@git rev-parse --is-inside-work-tree >/dev/null 2>&1 || { echo 'ERROR: run make git-init first'; exit 2; }
	@git add -A && git status --short

git-staged:
	@git rev-parse --is-inside-work-tree >/dev/null 2>&1 || { echo 'ERROR: run make git-init first'; exit 2; }
	@git diff --cached --check && git diff --cached --stat && git diff --cached

git-commit:
	@test -n "$(strip $(MSG))" || { echo 'ERROR: make git-commit MSG="feat: description"'; exit 2; }
	@git rev-parse --is-inside-work-tree >/dev/null 2>&1 || { echo 'ERROR: run make git-init first'; exit 2; }
	@if git diff --cached --quiet; then echo 'ERROR: nothing staged; run make git-stage first'; exit 2; fi
	@git commit -m "$(MSG)"

git-log:
	@git rev-parse --is-inside-work-tree >/dev/null 2>&1 || { echo 'ERROR: run make git-init first'; exit 2; }
	@git rev-parse --verify HEAD >/dev/null 2>&1 || { echo 'ERROR: no Git commits yet; git-log is unavailable until the user commits.'; exit 2; }
	@git log --oneline --decorate -12

git-tag:
	@test -n "$(strip $(TAG))" || { echo 'ERROR: provide TAG="vX.Y.Z"'; exit 2; }
	@test -n "$(strip $(MSG))" || { echo 'ERROR: provide MSG="Release vX.Y.Z"'; exit 2; }
	@git rev-parse --is-inside-work-tree >/dev/null 2>&1 || { echo 'ERROR: run make git-init first'; exit 2; }
	@git rev-parse --verify HEAD >/dev/null 2>&1 || { echo 'ERROR: no Git commit exists to tag yet.'; exit 2; }
	@git tag -a "$(TAG)" -m "$(MSG)"

lint:
	@"$(PYTHON)" scripts/static_audit.py

smoke:
	@command -v "$(MATLAB)" >/dev/null 2>&1 || { echo 'ERROR: MATLAB unavailable; smoke NOT RUN'; exit 2; }
	@"$(MATLAB)" -batch "run(fullfile(pwd,'scripts','smokeArkaFEM.m'))"

matlab-lint:
	@command -v "$(MATLAB)" >/dev/null 2>&1 || { echo 'ERROR: MATLAB unavailable; MATLAB Code Analyzer NOT RUN'; exit 2; }
	@"$(MATLAB)" -batch "run(fullfile(pwd,'scripts','run_lint.m'))"

test:
	@command -v "$(MATLAB)" >/dev/null 2>&1 || { echo 'ERROR: MATLAB unavailable; tests NOT RUN'; exit 2; }
	@"$(MATLAB)" -batch "run(fullfile(pwd,'scripts','run_all_tests.m'))"

verify: lint matlab-lint test
	@echo 'ArkaFEM STATIC + MATLAB lint and unit tests completed without error.'
