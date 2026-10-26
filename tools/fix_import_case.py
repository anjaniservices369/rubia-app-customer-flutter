#!/usr/bin/env python3
"""
Fixes imports whose letter case differs from the real file name, e.g.
    import '../profilePage/Components/support.dart';   # folder is 'components'
Windows ignores case, Linux and macOS do not, so such imports break builds
there. Run: python tools/fix_import_case.py
"""
import os
import re

LIB = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', 'lib'))
PKG = 'package:base_project_flutter/'

files = {}
for dp, dn, fn in os.walk(LIB):
    for f in fn:
        if f.endswith('.dart'):
            p = os.path.join(dp, f)
            files[os.path.relpath(p, LIB).replace(os.sep, '/')] = p
lower = {k.lower(): k for k in files}

fixed = 0
for rel, p in files.items():
    src = open(p, encoding='utf-8').read()

    def repl(m):
        global fixed
        imp = m.group(2)
        if imp.startswith(PKG):
            cand = imp[len(PKG):]
            if cand not in files and cand.lower() in lower:
                fixed += 1
                return f"{m.group(1)}'{PKG}{lower[cand.lower()]}'"
        elif not imp.startswith(('package:', 'dart:')):
            cand = os.path.normpath(os.path.join(os.path.dirname(rel), imp)).replace(os.sep, '/')
            if cand not in files and cand.lower() in lower:
                real = lower[cand.lower()]
                new = os.path.relpath(real, os.path.dirname(rel) or '.').replace(os.sep, '/')
                if not new.startswith('.'):
                    new = new
                fixed += 1
                return f"{m.group(1)}'{new}'"
        return m.group(0)

    new_src = re.sub(r"(?m)^(\s*import\s+)'([^']+)'", repl, src)
    if new_src != src:
        open(p, 'w', encoding='utf-8', newline='').write(new_src)
print('imports corrected:', fixed)
