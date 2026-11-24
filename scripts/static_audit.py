#!/usr/bin/env python3
"""Static repository contract checks, NOT a MATLAB syntax or numerical test."""
from pathlib import Path
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
    'src/+arka/Model.m', 'src/+arka/+internal/+core/validateNode.m',
    'src/+arka/+internal/+core/validateMaterial.m',
    'src/+arka/+internal/+core/validateSection.m',
    'src/+arka/+internal/+core/validateId.m',
    'src/+arka/+internal/+core/validateName.m',
    'src/+arka/+internal/+core/validateScalar.m',
    'src/+arka/+internal/+core/parseOptions.m',
    'tests/unit/TestModelRegistry.m', 'tests/negative/TestModelValidation.m',
    'examples/example_01_model_basics.m', 'docs/model_data.md',
    'docs/theory/isotropic_material_registry.md',
    'docs/benchmarks/model_validation.md', 'docs/qa/01B_REPORT.md',
    'src/+arka/dofMap.m', 'src/+arka/dofIndex.m',
    'src/+arka/solveDirichlet.m', 'src/+arka/+internal/+core/buildDofMap.m',
    'src/+arka/+internal/+numerics/solveDirichlet.m',
    'tests/unit/TestDofMapping.m', 'tests/negative/TestDofSolverValidation.m',
    'tests/benchmarks/TestManualSpringChain.m',
    'examples/example_02_spring_system.m',
    'docs/theory/dof_mapping.md', 'docs/theory/dirichlet_partition.md',
    'docs/benchmarks/manual_spring_chain.md', 'docs/qa/01C_REPORT.md',
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
    model = (ROOT / 'src/+arka/Model.m').read_text(encoding='utf-8')
    for method in ('addNode', 'addMaterial', 'addSection', 'getNode',
                   'getMaterial', 'getSection', 'listNodes', 'listMaterials',
                   'listSections', 'summary', 'validate', 'snapshot'):
        if not re.search(r'function\s+[^\n]*\b'+method+r'\s*\(', model):
            issues.append(f'missing Model method: {method}')
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
    damaged_matlab = []
    for directory in ['src', 'scripts', 'tests', 'examples']:
        for f in (ROOT / directory).rglob('*'):
            if f.is_file() and f.suffix in {'.m', '.py'}:
                blob = f.read_bytes()
                if f.suffix == '.m':
                    # ArkaFEM MATLAB sources use printable ASCII and LF/tab.
                    # Reject escaped Markdown operators and HTML entities.
                    # A single left-division backslash remains valid.
                    if (any(b not in (9, 10, 13) and not 32 <= b <= 126
                            for b in blob) or
                            re.search(rb'\\[~*]|&(?:#[0-9]+|#x[0-9a-fA-F]+|nbsp|lt|gt|amp|quot);', blob)):
                        damaged_matlab.append(str(f.relative_to(ROOT)))
                if not blob.endswith(b'\n') or b'\r\n' in blob:
                    bad_whitespace.append(str(f.relative_to(ROOT)))
    if damaged_matlab:
        issues.append('MATLAB text corruption: ' + ', '.join(damaged_matlab))
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
