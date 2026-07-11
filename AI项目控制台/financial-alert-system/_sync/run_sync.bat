@echo off
setlocal
cd /d "%~dp0\..\..\.."
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0sync_vault_status.ps1"
if errorlevel 1 (
  echo SYNC FAILED
  exit /b 1
)
echo.
echo SYNC DONE
exit /b 0
