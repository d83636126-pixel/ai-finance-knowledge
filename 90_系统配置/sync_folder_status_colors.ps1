# Sync folder CSS + rename folder index files to 00_<emoji>索引.md
# powershell -NoProfile -ExecutionPolicy Bypass -File "90_系统配置\sync_folder_status_colors.ps1"

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$vault = Split-Path -Parent $PSScriptRoot
$ymlPath = Join-Path $PSScriptRoot 'folder_status.yml'
$cssPath = Join-Path $vault '.obsidian\snippets\vault-folder-status-colors.css'

function Emoji([int]$cp) { return [char]::ConvertFromUtf32($cp) }

$emojiOf = @{
  green  = (Emoji 0x1F7E2)
  blue   = (Emoji 0x1F535)
  orange = (Emoji 0x1F7E0)
  red    = (Emoji 0x1F534)
  gray   = (Emoji 0x26AA)
}
$palette = @{
  green  = @{ bar = '#3d9a6a'; text = '#2f6f4e' }
  blue   = @{ bar = '#5b9fd4'; text = '#3d6f9c' }
  orange = @{ bar = '#d4a05a'; text = '#9a7040' }
  red    = @{ bar = '#d97a7a'; text = '#a05050' }
  gray   = @{ bar = '#a0a6b0'; text = '#6e737a' }
}
$allEmoji = @($emojiOf.Values)

if (-not (Test-Path -LiteralPath $ymlPath)) { throw 'Missing folder_status.yml' }

$lines = Get-Content -LiteralPath $ymlPath -Encoding UTF8
$folders = @()
$cur = $null
foreach ($line in $lines) {
  if ($line -match '^\s*-\s*path:\s*(.+)\s*$') {
    if ($null -ne $cur) { $folders += $cur }
    $cur = @{ path = $Matches[1].Trim(); status = 'gray'; note = '' }
  } elseif ($null -ne $cur -and $line -match '^\s*status:\s*(\w+)\s*$') {
    $cur.status = $Matches[1].Trim().ToLowerInvariant()
  } elseif ($null -ne $cur -and $line -match '^\s*note:\s*(.+)\s*$') {
    $cur.note = $Matches[1].Trim()
  }
}
if ($null -ne $cur) { $folders += $cur }

# --- CSS ---
$parts = New-Object System.Collections.Generic.List[string]
[void]$parts.Add('/* AUTO-GENERATED from folder_status.yml */')
[void]$parts.Add('/* In-progress = soft BLUE bar */')
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

# --- Rename 00_*index files + patch wiki links ---
# Target filename: 00_<emoji>索引.md  (visible in explorer)
$indexSuffix = [string]([char]0x7D22) + [char]0x5F15 + '.md'  # 索引.md
$renames = @()

foreach ($f in $folders) {
  $st = $f.status
  if (-not $emojiOf.ContainsKey($st)) { $st = 'gray' }
  $em = $emojiOf[$st]
  $folderFs = Join-Path $vault (($f.path -replace '/', [IO.Path]::DirectorySeparatorChar))
  if (-not (Test-Path -LiteralPath $folderFs)) { continue }

  $candidates = Get-ChildItem -LiteralPath $folderFs -File -Filter '00*.md' -ErrorAction SilentlyContinue |
    Where-Object { $_.Name -match ('^00_.*' + [regex]::Escape(([char]0x7D22).ToString() + ([char]0x5F15).ToString()) + '\.md$') -or $_.Name -eq ('00_' + ([char]0x7D22) + ([char]0x5F15) + '.md') }

  # Simpler: match names containing 索引 and starting with 00_
  $suoYin = ([char]0x7D22).ToString() + ([char]0x5F15).ToString()
  $candidates = @(Get-ChildItem -LiteralPath $folderFs -File -Filter '00*.md' -ErrorAction SilentlyContinue |
    Where-Object { $_.Name.Contains($suoYin) })

  $targetName = '00_' + $em + $suoYin + '.md'
  $targetPath = Join-Path $folderFs $targetName

  if ($candidates.Count -eq 0) { continue }

  $src = $candidates | Select-Object -First 1
  if ($src.FullName -ne $targetPath) {
    if (Test-Path -LiteralPath $targetPath) { Remove-Item -LiteralPath $targetPath -Force }
    Rename-Item -LiteralPath $src.FullName -NewName $targetName
    $renames += [pscustomobject]@{
      folder = $f.path.Replace('\', '/')
      from = $src.Name
      to = $targetName
    }
  }

  # Link patch for this folder: any 00_<optional emoji>索引 -> new name
  $folderWiki = $f.path.Replace('\', '/')
  $oldPatterns = @()
  $oldPatterns += ($folderWiki + '/00_' + $suoYin)
  foreach ($e in $allEmoji) {
    $oldPatterns += ($folderWiki + '/00_' + $e + $suoYin)
  }
  $newLink = $folderWiki + '/00_' + $em + $suoYin

  $mdFiles = Get-ChildItem -LiteralPath $vault -Recurse -Filter '*.md' -File |
    Where-Object { $_.FullName -notmatch '\\\.trash\\' }
  foreach ($md in $mdFiles) {
    $text = [System.IO.File]::ReadAllText($md.FullName, [System.Text.Encoding]::UTF8)
    $orig = $text
    foreach ($op in $oldPatterns) {
      if ($op -eq $newLink) { continue }
      $text = $text.Replace($op, $newLink)
    }
    # also bare ]] links without path rare; skip
    if ($text -ne $orig) {
      [System.IO.File]::WriteAllText($md.FullName, $text, $utf8)
    }
  }
}

Write-Host ("OK folders={0} renames={1}" -f $folders.Count, $renames.Count)
$renames | ForEach-Object { Write-Host ("  {0}: {1} -> {2}" -f $_.folder, $_.from, $_.to) }
