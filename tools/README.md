# tools/ - keeping the documentation in step with the code

Nothing here changes how the app behaves. These scripts only read the code and
write comments / documents.

| Script | What it does | When it runs |
|---|---|---|
| `update_docs.py` | Rebuilds `docs/CODE_MAP.md`, `docs/API_ENDPOINTS.md`, `docs/STATUS_CODES.md` and the generated block of `PROJECT_GUIDE.md` from the code. Lists files that still have no explanatory header. | automatically after every code edit made through Claude Code (`.claude/settings.json`), and by `sync_docs.bat` |
| `annotate_code.py` | Adds `// >>> START:` / `// <<< END:` markers around every class and method (safe to re-run). `--refresh` rewrites all of them after you change `function_notes.py`. | `sync_docs.bat` |
| `function_notes.py` | The plain-language description of important functions. Add a line here and run `annotate_code.py --refresh`. | edited by hand |
| `sync_docs.bat` | Runs both scripts in one go. | double-click |

## What is automatic and what is not

**Automatic** (always right, regenerated from the code):
- the list of files, endpoints and status numbers,
- START/END markers for new classes and methods,
- warnings about files that have no header.

**Needs a person (or an AI assistant)**: the *sentence that explains why* a new
file or function exists. The tools cannot invent business meaning, so a new file
shows up in the list as `TODO: add a "// WHAT :" header` until someone writes
one. Put that header at the top of the file:

```
// =============================================================================
// WHAT : one plain-English sentence
// NOTES: where it fits / gotchas
// =============================================================================
```

## Checking in a build pipeline

`python tools/update_docs.py --check` exits with an error if the generated
documents are out of date or a file has no header, so a CI job or a git
pre-commit hook can refuse the change until the docs are updated.
