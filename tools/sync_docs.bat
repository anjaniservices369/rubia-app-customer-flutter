@echo off
rem ---------------------------------------------------------------------------
rem Keeps code comments and documents in step with the code.
rem   1. adds START/END markers to any new class or method
rem   2. regenerates docs/CODE_MAP.md, docs/API_ENDPOINTS.md, docs/STATUS_CODES.md
rem      and the AUTO block of PROJECT_GUIDE.md
rem Double-click it, or run:  tools\sync_docs.bat
rem ---------------------------------------------------------------------------
cd /d "%~dp0\.."
python tools\annotate_code.py
python tools\update_docs.py
echo.
echo Done. New files/functions that still need a human description are listed above.
pause
