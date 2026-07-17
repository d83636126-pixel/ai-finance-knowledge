@echo off
REM Obsidian / Explorer: one-click day-open for financial-alert-system
setlocal
set REPO=F:\financial-alert-system
if not exist "%REPO%\scripts\day_open_dev_session.ps1" (
  echo Missing %REPO%\scripts\day_open_dev_session.ps1
  exit /b 1
)
powershell -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%REPO%\scripts\day_open_dev_session.ps1" %*
endlocal
