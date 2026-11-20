#!/usr/bin/env python3
"""Static repository contract checks, NOT a MATLAB syntax or numerical test."""
from pathlib import Path
import hashlib
import json
import re
import sys

ROOT = Path(__file__).resolve().parents[1]
REQUIRED = [
    'Makefile', 'README.md', 'VERSION', 'CHANGELOG.md', '.gitignore',
    'CONTRIBUTING.md', 'src/+arka/version.m', 'scripts/setupArkaFEM.m',
    'scripts/smokeArkaFEM.m', 'scripts/run_all_tests.m',
    'scripts/run_lint.m', 'scripts/static_audit.py',
    'tests/unit/TestBootstrap.m', 'examples/example_00_version.m',
    'docs/ARCHITECTURE.md', 'docs/NUMERICAL_CONTRACTS.md',
    'docs/API_SPEC.md', 'docs/ROADMAP.md', 'docs/STATUS.md',
    'docs/HANDOFF.md', 'docs/adr/0001-foundation.md',
    'docs/progress.json', 'spec/ArkaFEM_PromptKit_v2/PROMPTS/01A_REPOSITORY_BOOTSTRAP.md',
]

def check():
    issues = []
    for name in REQUIRED:
        f = ROOT / name
        if not f.is_file() or f.stat().st_size == 0:
            issues.append(f'missing/empty: {name}')
    version = (ROOT / 'VERSION').read_text(encoding='utf-8').strip()
    matlab = (ROOT / 'src/+arka/version.m').read_text(encoding='utf-8')
    if f'info.Version = "{version}"' not in matlab:
        issues.append('VERSION and MATLAB metadata disagree')
    setup = (ROOT / 'scripts/setupArkaFEM.m').read_text(encoding='utf-8')
    if 'addpath(arkaSetupSrcDirectory' not in setup or re.search(r'addpath\s*\(\s*genpath', setup):
        issues.append('setup must add only src and never recursive genpath')
    for f in sorted((ROOT / 'src').rglob('*.m')):
        code = f.read_text(encoding='utf-8')
        if re.search(r'\binv\s*\(', code):
            issues.append(f'disallowed explicit inverse: {f.relative_to(ROOT)}')
    try:
        progress = json.loads((ROOT / 'docs/progress.json').read_text(encoding='utf-8'))
        expected = (progress['overall']['implemented_pct'], progress['overall']['verified_pct'])
        if expected[1] > expected[0]:
            issues.append('verified progress exceeds implemented progress')
    except (ValueError, KeyError, TypeError, OSError) as ex:
        issues.append(f'invalid progress.json: {ex}')
    bad_whitespace = []
    for directory in ['src', 'scripts', 'tests', 'examples']:
        for f in (ROOT / directory).rglob('*'):
            if f.is_file() and f.suffix in {'.m', '.py'}:
                blob = f.read_bytes()
                if not blob.endswith(b'\n') or b'\r\n' in blob:
                    bad_whitespace.append(str(f.relative_to(ROOT)))
    if bad_whitespace:
        issues.append('file newline convention: ' + ', '.join(bad_whitespace))
    for issue in issues:
        print('FAIL:', issue, file=sys.stderr)
    if issues:
        return 1
    print(f'PASS: static repository contract ({len(REQUIRED)} required files, '
          'metadata/path/inverse/JSON/newline checks).')
    print('Scope: static only; MATLAB execution NOT RUN.')
    return 0

if __name__ == '__main__':
    sys.exit(check())
