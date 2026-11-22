#!/usr/bin/env python3
"""Verify SHA-256 source file manifest, excluding the manifest itself."""
from pathlib import Path
import argparse
import hashlib
import sys

ROOT = Path(__file__).resolve().parents[1]
MANIFEST = ROOT / 'docs/FILE_MANIFEST.sha256'


def included(path):
    parts = path.relative_to(ROOT).parts
    if any(part in {'.git', '__pycache__', 'build', 'dist', 'cache'} for part in parts):
        return False
    return path != MANIFEST


def main():
    parser = argparse.ArgumentParser(description='Verify SHA-256 source manifest.')
    parser.add_argument('--allow-unlisted', action='store_true',
                        help='Allow locally generated project files not in baseline manifest.')
    args = parser.parse_args()
    try:
        lines = MANIFEST.read_text(encoding='utf-8').splitlines()
    except FileNotFoundError:
        print('FAIL: missing docs/FILE_MANIFEST.sha256', file=sys.stderr)
        return 1
    expected = {}
    for line in lines:
        if not line.strip():
            continue
        try:
            sha, name = line.split('  ', 1)
            if len(sha) != 64 or any(c not in '0123456789abcdef' for c in sha):
                raise ValueError('bad digest')
            if name in expected:
                raise ValueError('duplicate path')
            expected[name] = sha
        except ValueError as ex:
            print(f'FAIL: invalid manifest line: {line!r} ({ex})', file=sys.stderr)
            return 1
    actual = {p.relative_to(ROOT).as_posix(): hashlib.sha256(p.read_bytes()).hexdigest()
              for p in ROOT.rglob('*') if p.is_file() and included(p)}
    problems = []
    for name in sorted(set(expected) | set(actual)):
        if name not in expected:
            if not args.allow_unlisted:
                problems.append(f'untracked: {name}')
        elif name not in actual:
            problems.append(f'missing: {name}')
        elif expected[name] != actual[name]:
            problems.append(f'checksum differs: {name}')
    if problems:
        for problem in problems:
            print('FAIL:', problem, file=sys.stderr)
        return 1
    print(f'PASS: {len(expected)} SHA-256 source files match manifest; manifest itself excluded.'
          + (' Unlisted local files allowed.' if args.allow_unlisted else ''))
    return 0


if __name__ == '__main__':
    sys.exit(main())
