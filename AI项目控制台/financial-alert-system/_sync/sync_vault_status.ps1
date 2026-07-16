# sync_vault_status.ps1
# Thin wrapper — all grading lives in sync_vault_status.js + code-repo acceptance_status.js
# (Plan §10.1: PS1 must not implement file_exists-only ACCEPTED logic.)
$ErrorActionPreference = "Stop"
$SyncDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$Js = Join-Path $SyncDir "sync_vault_status.js"
if (-not (Test-Path -LiteralPath $Js)) {
  throw "Missing sync_vault_status.js at $Js"
}
$node = Get-Command node -ErrorAction SilentlyContinue
if (-not $node) { throw "node not found on PATH" }

& node $Js @args
exit $LASTEXITCODE
