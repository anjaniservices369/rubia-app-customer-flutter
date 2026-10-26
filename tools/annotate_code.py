#!/usr/bin/env python3
"""
Adds START / END markers around every class and method in lib/**/*.dart so a
reader can see where each piece of functionality begins and ends.

    // >>> START: <plain description>
    ... the code ...
    // <<< END: <plain description>

The script is idempotent (running it twice changes nothing) and only ever
inserts whole comment lines, so it cannot change how the app behaves.

Usage:
    python tools/annotate_code.py            # annotate everything under lib/
    python tools/annotate_code.py --refresh  # rewrite all markers (after editing function_notes.py)
    python tools/annotate_code.py --check    # list files with missing markers (exit 1)
"""
import os
import re
import sys

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', 'lib'))
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
try:
    from function_notes import NOTES
except ImportError:  # notes are optional
    NOTES = {}
START = '// >>> START: '
END = '// <<< END: '

# ----------------------------------------------------------------------------
# 1. Mask strings and comments so braces inside them are ignored.
# ----------------------------------------------------------------------------

def mask_source(s):
    """Return s with string/comment characters replaced by spaces (newlines kept)."""
    out = list(s)
    n = len(s)
    i = 0

    def blank(a, b):
        for k in range(a, min(b, n)):
            if out[k] != '\n':
                out[k] = ' '

    def skip_string(i):
        # i points at the opening quote (after an optional r prefix handled by caller)
        raw = i > 0 and s[i - 1] == 'r' and (i < 2 or not s[i - 2].isalnum())
        q = s[i]
        triple = s.startswith(q * 3, i)
        j = i + (3 if triple else 1)
        while j < n:
            c = s[j]
            if c == '\\' and not raw:
                j += 2
                continue
            if triple:
                if s.startswith(q * 3, j):
                    return j + 3
            elif c == q:
                return j + 1
            elif c == '\n':
                return j
            if c == '$' and not raw and j + 1 < n and s[j + 1] == '{':
                j = skip_code(j + 2)
                continue
            j += 1
        return j

    def skip_code(j):
        depth = 1
        while j < n and depth:
            c = s[j]
            if c in '\'"':
                j = skip_string(j)
                continue
            if c == '{':
                depth += 1
            elif c == '}':
                depth -= 1
            j += 1
        return j

    while i < n:
        c = s[i]
        if s.startswith('//', i):
            j = s.find('\n', i)
            j = n if j == -1 else j
            blank(i, j)
            i = j
        elif s.startswith('/*', i):
            j = s.find('*/', i + 2)
            j = n if j == -1 else j + 2
            blank(i, j)
            i = j
        elif c in '\'"':
            j = skip_string(i)
            blank(i, j)
            i = j
        else:
            i += 1
    return ''.join(out)


# ----------------------------------------------------------------------------
# 2. Find declarations.
# ----------------------------------------------------------------------------

def match_brace(m, i):
    """m[i] == '{'. Return the index of the matching '}' in masked text m."""
    depth = 0
    n = len(m)
    while i < n:
        if m[i] == '{':
            depth += 1
        elif m[i] == '}':
            depth -= 1
            if depth == 0:
                return i
        i += 1
    return -1


CLASS_RE = re.compile(
    r'(?m)^[ \t]*(?:abstract\s+|final\s+|base\s+|sealed\s+)*'
    r'(class|mixin|extension)\s+(\w+)?[^{;]*\{')
KEYWORDS = {'if', 'for', 'while', 'switch', 'catch', 'return', 'else', 'do', 'try'}


def members(m, open_idx, close_idx):
    """Yield (name, header_start, brace_open, brace_close, header_text) of members
    with a block body directly inside the class body m[open_idx..close_idx]."""
    i = open_idx + 1
    start = i
    paren = 0
    while i < close_idx:
        c = m[i]
        if c == '(':
            paren += 1
        elif c == ')':
            paren -= 1
        elif paren == 0 and c == ';':
            start = i + 1
        elif paren == 0 and c == '{':
            end = match_brace(m, i)
            header = m[start:i].strip()
            if end == -1:
                return
            if header and '=' not in header.split('(')[0] and \
                    ('(' in header or re.search(r'\b(get|set)\s+\w+$', header)):
                yield header, start, i, end
            elif header and '=>' not in header and '(' in header and '=' in header.split('(')[0]:
                pass  # field initialised with a call
            i = end
            start = end + 1
        elif paren == 0 and c == '}':
            start = i + 1
        i += 1


# ----------------------------------------------------------------------------
# 3. Plain-English descriptions.
# ----------------------------------------------------------------------------

def words(name):
    name = name.lstrip('_')
    parts = re.sub(r'([a-z0-9])([A-Z])', r'\1 \2', name).replace('_', ' ')
    return parts.lower().strip()


FIXED = {
    'build': 'draws this screen/widget on the display',
    'initState': 'runs once when the screen opens - sets up data and listeners',
    'dispose': 'runs when the screen closes - frees resources and stops listeners',
    'didChangeDependencies': 'reacts when inherited data (theme, provider) changes',
    'didUpdateWidget': 'reacts when the parent hands this widget new settings',
    'createState': 'creates the object that holds this screen\'s changing data',
    'main': 'program start - prepares services and launches the app',
    'toString': 'text form of this object (for logs)',
    'fromJson': 'builds this object from the server reply',
    'toJson': 'turns this object into the form the server expects',
}
PREFIX = [
    ('get', 'gets'), ('fetch', 'fetches'), ('load', 'loads'), ('set', 'sets'),
    ('on', 'reacts to'), ('check', 'checks'), ('show', 'shows'), ('handle', 'handles'),
    ('update', 'updates'), ('delete', 'deletes'), ('remove', 'removes'),
    ('add', 'adds'), ('send', 'sends'), ('verify', 'verifies'), ('apply', 'applies'),
    ('start', 'starts'), ('stop', 'stops'), ('init', 'initialises'),
    ('navigate', 'opens'), ('open', 'opens'), ('save', 'saves'),
    ('calculate', 'calculates'), ('validate', 'validates'), ('select', 'selects'),
    ('is', 'tells whether'), ('has', 'tells whether it has'), ('reset', 'resets'),
    ('create', 'creates'), ('cancel', 'cancels'), ('clear', 'clears'),
    ('upload', 'uploads'), ('login', 'logs in'), ('logout', 'logs out'),
]


def describe_member(name, header, cls):
    if name in NOTES:
        return f'{name} - {NOTES[name]}'
    if name in FIXED:
        return f'{name} - {FIXED[name]}'
    n = name.lstrip('_')
    for p, verb in PREFIX:
        if n.startswith(p) and len(n) > len(p) and n[len(p)].isupper():
            return f'{name} - {verb} {words(n[len(p):])}'
    if n == cls:
        return f'{name} - constructor (creates the object)'
    return f'{name} - {words(n)}'


def describe_class(name, header):
    if name in NOTES:
        return f'{name} - {NOTES[name]}'
    h = re.sub(r'\s+', ' ', header)
    if 'extends StatefulWidget' in h:
        return f'{name} - screen/widget shell (the visible part is in its State class)'
    if 'extends State<' in h:
        return f'{name} - the data and logic behind its screen'
    if 'extends StatelessWidget' in h:
        return f'{name} - screen/widget'
    if 'ChangeNotifier' in h:
        return f'{name} - shared app memory (provider) other screens listen to'
    if 'Translations' in h:
        return f'{name} - all on-screen texts in each language'
    return f'{name} - helper class'


# ----------------------------------------------------------------------------
# 4. Apply to one file.
# ----------------------------------------------------------------------------

def line_of(s, idx):
    return s.count('\n', 0, idx)


def strip_markers(src):
    keep = [l for l in src.split('\n')
            if not (l.strip().startswith(START.strip()) or l.strip().startswith(END.strip()))]
    return '\n'.join(keep)


def annotate(path, refresh=False):
    src = open(path, encoding='utf-8').read()
    if refresh:
        src = strip_markers(src)
    m = mask_source(src)
    lines = src.split('\n')
    inserts = []  # (line_index_to_insert_before, text)

    def has_marker_before(li):
        k = li - 1
        while k >= 0 and (lines[k].strip().startswith('@') or lines[k].strip().startswith('///')):
            k -= 1
        return k >= 0 and lines[k].strip().startswith(START.strip())

    def block_start_line(li):
        # climb over annotations and doc comments that belong to the declaration
        k = li
        while k - 1 >= 0 and (lines[k - 1].strip().startswith('@') or lines[k - 1].strip().startswith('///')):
            k -= 1
        return k

    def add_block(header_idx, close_idx, text):
        start_li = block_start_line(line_of(src, header_idx))
        end_li = line_of(src, close_idx)
        if has_marker_before(start_li):
            return
        indent = re.match(r'\s*', lines[start_li]).group(0)
        inserts.append((start_li, indent + START + text))
        inserts.append((end_li + 1, indent + END + text))

    pos = 0
    top_depth_ranges = []
    for cm in CLASS_RE.finditer(m):
        if cm.start() < pos:
            continue  # nested inside a class we already processed
        kind, name = cm.group(1), cm.group(2) or 'extension'
        # only top-level declarations (no indentation)
        if re.match(r'[ \t]+', m[cm.start():cm.start() + 1] or ''):
            continue
        brace = cm.end() - 1
        end = match_brace(m, brace)
        if end == -1:
            continue
        header = m[cm.start():brace]
        # members first (they are inside the class)
        for hdr, hs, bo, bc in members(m, brace, end):
            mname_match = re.search(r'(\w+)\s*\(', hdr)
            gs = re.search(r'\b(get|set)\s+(\w+)$', hdr)
            if gs:
                mname = f'{gs.group(1)} {gs.group(2)}'
            elif mname_match and mname_match.group(1) not in KEYWORDS:
                mname = mname_match.group(1)
            else:
                continue
            add_block(hs + (len(m[hs:bo]) - len(m[hs:bo].lstrip())), bc,
                      describe_member(mname.split()[-1], hdr, name))
        add_block(cm.start() + (len(m[cm.start():cm.end()]) - len(m[cm.start():cm.end()].lstrip())),
                  end, describe_class(name, header) if kind == 'class' else f'{name} - {kind}')
        pos = end

    # top-level functions
    FUNC_RE = re.compile(
        r'(?m)^(?:[\w<>?,\[\]\.]+\s+)+(\w+)\s*\([^;{}]*\)\s*(?:async\*?|sync\*)?\s*\{')
    for fm in FUNC_RE.finditer(m):
        name = fm.group(1)
        if name in KEYWORDS:
            continue
        # skip if inside a class (indentation) - regex anchors at column 0 already
        brace = fm.end() - 1
        end = match_brace(m, brace)
        if end == -1:
            continue
        add_block(fm.start(), end, describe_member(name, '', ''))

    if not inserts:
        if refresh:
            open(path, 'w', encoding='utf-8', newline='').write(src)
        return 0
    # apply from the bottom so line numbers stay valid
    inserts.sort(key=lambda t: t[0], reverse=True)
    for li, text in inserts:
        lines.insert(li, text)
    open(path, 'w', encoding='utf-8', newline='').write('\n'.join(lines))
    return len(inserts) // 2


def main():
    check = '--check' in sys.argv
    refresh = '--refresh' in sys.argv
    total = 0
    pending = []
    for dp, dn, fn in os.walk(ROOT):
        for f in sorted(fn):
            if not f.endswith('.dart'):
                continue
            p = os.path.join(dp, f)
            if check:
                src = open(p, encoding='utf-8').read()
                if 'class ' in src and START.strip() not in src and \
                        any(l for l in src.split('\n') if l and not l.lstrip().startswith('//')):
                    pending.append(os.path.relpath(p, ROOT))
            else:
                total += annotate(p, refresh)
    if check:
        for p in pending:
            print('no START/END markers:', p)
        sys.exit(1 if pending else 0)
    print('blocks annotated:', total)


if __name__ == '__main__':
    main()
