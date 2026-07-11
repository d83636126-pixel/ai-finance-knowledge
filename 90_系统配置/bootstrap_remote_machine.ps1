# bootstrap_remote_machine.ps1
# First-time setup on a remote / new PC for vault + code + status sync.
$ErrorActionPreference = "Stop"

$VaultUrl = "https://github.com/d83636126-pixel/ai-finance-knowledge.git"
$CodeUrl  = "https://github.com/d83636126-pixel/financial-alert-system.git"

$VaultPath = if ($env:FS_VAULT_PATH) { $env:FS_VAULT_PATH } else { "D:\AI  金融知识点" }
$CodePath  = if ($env:FS_CODE_PATH)  { $env:FS_CODE_PATH }  else { "D:\financial-alert-system" }

function Ensure-Clone([string]$Url, [string]$Path) {
  if (Test-Path -LiteralPath (Join-Path $Path ".git")) {
    Write-Output "[pull] $Path"
    Push-Location -LiteralPath $Path
    git fetch origin
    git pull --ff-only
    Pop-Location
    return
  }
  if (Test-Path -LiteralPath $Path) {
    throw "Path exists but is not a git repo: $Path"
  }
  $parent = Split-Path -Parent $Path
  if ($parent -and -not (Test-Path -LiteralPath $parent)) {
    New-Item -ItemType Directory -Path $parent -Force | Out-Null
  }
  Write-Output "[clone] $Url -> $Path"
  git clone $Url $Path
}

Write-Output "=== bootstrap remote machine ==="
Ensure-Clone $VaultUrl $VaultPath
Ensure-Clone $CodeUrl $CodePath

$sync = Join-Path $VaultPath "AI项目控制台\financial-alert-system\_sync\sync_vault_status.ps1"
if (-not (Test-Path -LiteralPath $sync)) {
  # fallback: find _sync under vault
  $hit = Get-ChildItem -LiteralPath $VaultPath -Recurse -Filter "sync_vault_status.ps1" -ErrorAction SilentlyContinue |
    Select-Object -First 1 -ExpandProperty FullName
  if ($hit) { $sync = $hit }
}

if (Test-Path -LiteralPath $sync) {
  Write-Output "[sync] $sync"
  powershell -NoProfile -ExecutionPolicy Bypass -File $sync
} else {
  Write-Warning "sync_vault_status.ps1 not found; skip status sync"
}

Write-Output ""
Write-Output "DONE"
Write-Output "vault=$VaultPath"
Write-Output "code =$CodePath"
Write-Output "Next: Open vault in Obsidian; install Obsidian Git; open vault in Cursor."
