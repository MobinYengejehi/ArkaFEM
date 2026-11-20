# ArkaFEM — GNU Make helper (run from repository root)
# On Windows use a GNU Make-compatible shell (Git Bash/WSL/MSYS2).
# This file only defines targets; it never automatically pushes or commits.
SHELL := /bin/sh
MATLAB ?= matlab

.PHONY: help doctor git-init git-status git-diff git-stage git-staged git-commit git-log git-tag test lint verify
.DEFAULT_GOAL := help

help:
	@printf '%s\n' 'ArkaFEM commands:' '  make doctor' '  make test' '  make lint' '  make verify' '  make git-init' '  make git-status' '  make git-diff' '  make git-stage' '  make git-staged' '  make git-commit MSG="feat: message"' '  make git-log' '  make git-tag TAG="vX.Y.Z" MSG="Release vX.Y.Z"'

doctor:
	@printf 'Git: '; git --version || exit 1
	@printf 'MATLAB command: '; command -v "$(MATLAB)" || { echo 'MATLAB not on PATH; tests cannot run here'; exit 2; }

# Setup is explicit, and no remote is configured by this target.
git-init:
	@if [ -d .git ]; then echo 'Git already initialized'; else git init; fi

git-status:
	@git status --short --branch

git-diff:
	@git diff --check && git diff

git-stage:
	@git add -A && git status --short

git-staged:
	@git diff --cached --check && git diff --cached --stat && git diff --cached

git-commit:
	@test -n "$(strip $(MSG))" || { echo 'ERROR: make git-commit MSG="feat: description"'; exit 2; }
	@if git diff --cached --quiet; then echo 'ERROR: nothing staged; run make git-stage first'; exit 2; fi
	@git commit -m "$(MSG)"

git-log:
	@git log --oneline --decorate -12

git-tag:
	@test -n "$(strip $(TAG))" || { echo 'ERROR: provide TAG="vX.Y.Z"'; exit 2; }
	@test -n "$(strip $(MSG))" || { echo 'ERROR: provide MSG="Release vX.Y.Z"'; exit 2; }
	@git tag -a "$(TAG)" -m "$(MSG)"

# S01A/S01D must create scripts/run_all_tests.m and run_lint.m (or update these targets)
# MATLAB -batch returns nonzero on an uncaught exception. No success if runtime absent.
test:
	@"$(MATLAB)" -batch "run(fullfile(pwd,'scripts','run_all_tests.m'))"

lint:
	@"$(MATLAB)" -batch "run(fullfile(pwd,'scripts','run_lint.m'))"

verify: lint test
	@echo 'ArkaFEM lint + MATLAB tests completed without an error.'
