# Regenerates soft folder CSS from folder_status.yml (CSS only).
# powershell -NoProfile -ExecutionPolicy Bypass -File "90_系统配置\sync_folder_status_colors.ps1"

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$vault = Split-Path -Parent $PSScriptRoot
$ymlPath = Join-Path $PSScriptRoot 'folder_status.yml'
$cssPath = Join-Path $vault '.obsidian\snippets\vault-folder-status-colors.css'

if (-not (Test-Path -LiteralPath $ymlPath)) { throw 'Missing folder_status.yml' }

$palette = @{
  green  = @{ bar = '#3d9a6a'; text = '#2f6f4e' }
  blue   = @{ bar = '#5b9fd4'; text = '#3d6f9c' }
  orange = @{ bar = '#d4a05a'; text = '#9a7040' }
  red    = @{ bar = '#d97a7a'; text = '#a05050' }
  gray   = @{ bar = '#a0a6b0'; text = '#6e737a' }
}

$lines = Get-Content -LiteralPath $ymlPath -Encoding UTF8
$folders = @()
$cur = $null
foreach ($line in $lines) {
  if ($line -match '^\s*-\s*path:\s*(.+)\s*$') {
    if ($null -ne $cur) { $folders += $cur }
    $cur = @{ path = $Matches[1].Trim(); status = 'gray' }
  } elseif ($null -ne $cur -and $line -match '^\s*status:\s*(\w+)\s*$') {
    $cur.status = $Matches[1].Trim().ToLowerInvariant()
  }
}
if ($null -ne $cur) { $folders += $cur }

$parts = New-Object System.Collections.Generic.List[string]
[void]$parts.Add('/* AUTO-GENERATED — edit folder_status.yml then re-run this script */')
[void]$parts.Add('/* In-progress uses soft BLUE bar, not harsh yellow/gold */')
[void]$parts.Add('')
[void]$parts.Add('.nav-folder-title[data-path] { border-left: 3px solid transparent; padding-left: 6px; font-weight: 500; }')
[void]$parts.Add('')

foreach ($f in $folders) {
  $st = $f.status
  if (-not $palette.ContainsKey($st)) { $st = 'gray' }
  $p = $palette[$st]
  $path = $f.path.Replace('\', '/')
  [void]$parts.Add(".nav-folder-title[data-path=`"$path`"] {")
  [void]$parts.Add("  border-left-color: $($p.bar) !important;")
  [void]$parts.Add("  color: $($p.text) !important;")
  [void]$parts.Add('}')
  [void]$parts.Add('')
}

$dir = Split-Path $cssPath -Parent
if (-not (Test-Path -LiteralPath $dir)) { New-Item -ItemType Directory -Path $dir | Out-Null }
$utf8 = New-Object System.Text.UTF8Encoding $false
[System.IO.File]::WriteAllText($cssPath, ($parts -join "`n"), $utf8)
Write-Host ("OK folders={0} css written" -f $folders.Count)
