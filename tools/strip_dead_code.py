#!/usr/bin/env python3
"""
Removes blocks of COMMENTED-OUT CODE (old code someone disabled by putting //
in front of it) from lib/**/*.dart. Explanatory comments are never touched.

A comment line counts as commented-out code when it looks like code
(ends with ; { } ) , or contains Dart syntax such as =>, child:, setState(...)).
Only runs of at least MIN_RUN consecutive such lines are removed, and files
that are entirely commented out (flagged INACTIVE) are left alone.

Usage:
    python tools/strip_dead_code.py --dry-run   # show what would be removed
    python tools/strip_dead_code.py             # remove it
"""
import os
import re
import sys

LIB = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', 'lib'))
MIN_RUN = 3

CODE_HINT = re.compile(
    r'(=>|;\s*$|[{}]\s*$|\)\s*,?\s*$|^\s*(child|children|onTap|style|padding|margin|decoration|'
    r'height|width|color|borderRadius|boxShadow|text|Text|Container|Column|Row|SizedBox|Padding|'
    r'Icon|Image|Center|Expanded|Navigator|Twl|setState|print|import|final|var|if|else|return|'
    r'await|async|void|class|Widget|BuildContext|context)\b|\w+\(.*\)|\w+\.\w+)')


def is_marker(line):
    t = line.strip()
    return t.startswith('// >>>') or t.startswith('// <<<') or t.startswith('// ===') \
        or t.startswith('// WHAT') or t.startswith('// NOTES') or t.startswith('//        ')


def looks_like_code(line):
    t = line.strip()
    if not t.startswith('//') or t.startswith('///'):
        return False
    if is_marker(line):
        return False
    body = t[2:].strip()
    if not body:
        return True  # blank comment line inside a dead block
    # prose comments usually start with a capital letter followed by words and
    # contain no code punctuation at the end
    if re.match(r'^[A-Z][a-z]+( [\w\'",.:()-]+){2,}[.:!?]?$', body) and not body.endswith((';', '{', '}')):
        return False
    return bool(CODE_HINT.search(body))


def process(path, dry):
    with open(path, encoding='utf-8') as f:
        lines = f.read().split('\n')
    total_code = sum(1 for l in lines if l.strip() and not l.strip().startswith('//')
                     and not l.strip().startswith('import'))
    if total_code <= 2:
        return 0  # fully inactive file: leave as is
    out, i, removed = [], 0, 0
    while i < len(lines):
        if looks_like_code(lines[i]):
            j = i
            while j < len(lines) and looks_like_code(lines[j]):
                j += 1
            run = lines[i:j]
            real = [l for l in run if l.strip() not in ('//', '')]
            if len(real) >= MIN_RUN:
                removed += len(run)
                i = j
                continue
        out.append(lines[i])
        i += 1
    if removed and not dry:
        with open(path, 'w', encoding='utf-8', newline='') as f:
            f.write('\n'.join(out))
    return removed


def main():
    dry = '--dry-run' in sys.argv
    grand, files = 0, 0
    for dp, dn, fn in os.walk(LIB):
        for f in sorted(fn):
            if f.endswith('.dart'):
                n = process(os.path.join(dp, f), dry)
                if n:
                    files += 1
                    grand += n
                    print(f'{n:5d}  {os.path.relpath(os.path.join(dp, f), LIB)}')
    print(f'{"would remove" if dry else "removed"} {grand} lines of commented-out code in {files} files')


if __name__ == '__main__':
    main()
