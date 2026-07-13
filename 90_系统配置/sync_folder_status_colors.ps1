# Sync folder CSS + rename indexes + rename file_status files
# powershell -NoProfile -ExecutionPolicy Bypass -File "90_系统配置\sync_folder_status_colors.ps1"

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$vault = Split-Path -Parent $PSScriptRoot
$folderYml = Join-Path $PSScriptRoot 'folder_status.yml'
$fileYml = Join-Path $PSScriptRoot 'file_status.yml'
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
$utf8 = New-Object System.Text.UTF8Encoding $false
$suoYin = ([char]0x7D22).ToString() + ([char]0x5F15).ToString()

function Parse-StatusList {
  param([string]$Path, [string]$KeyName)
  if (-not (Test-Path -LiteralPath $Path)) { return @() }
  $lines = Get-Content -LiteralPath $Path -Encoding UTF8
  $items = @()
  $cur = $null
  foreach ($line in $lines) {
    if ($line -match ("^\s*-\s*" + [regex]::Escape($KeyName) + ":\s*(.+)\s*$")) {
      if ($null -ne $cur) { $items += $cur }
      $cur = @{ path = $Matches[1].Trim(); status = 'gray'; note = '' }
    } elseif ($null -ne $cur -and $line -match '^\s*status:\s*(\w+)\s*$') {
      $cur.status = $Matches[1].Trim().ToLowerInvariant()
    } elseif ($null -ne $cur -and $line -match '^\s*note:\s*(.+)\s*$') {
      $cur.note = $Matches[1].Trim()
    }
  }
  if ($null -ne $cur) { $items += $cur }
  return $items
}

function Strip-EmojiPrefix {
  param([string]$Name)
  # strip leading <emoji>_ from basename (with or without .md)
  foreach ($e in $allEmoji) {
    $pref = $e + '_'
    if ($Name.StartsWith($pref)) { return $Name.Substring($pref.Length) }
  }
  return $Name
}

function Patch-WikiLinks {
  param([string[]]$OldLinks, [string]$NewLink)
  $mdFiles = Get-ChildItem -LiteralPath $vault -Recurse -Filter '*.md' -File |
    Where-Object { $_.FullName -notmatch '\\\.trash\\' }
  foreach ($md in $mdFiles) {
    $text = [System.IO.File]::ReadAllText($md.FullName, [System.Text.Encoding]::UTF8)
    $orig = $text
    foreach ($op in $OldLinks) {
      if ([string]::IsNullOrEmpty($op)) { continue }
      if ($op -eq $NewLink) { continue }
      $text = $text.Replace($op, $NewLink)
    }
    if ($text -ne $orig) {
      [System.IO.File]::WriteAllText($md.FullName, $text, $utf8)
    }
  }
}

if (-not (Test-Path -LiteralPath $folderYml)) { throw 'Missing folder_status.yml' }
$folders = @(Parse-StatusList -Path $folderYml -KeyName 'path')
$files = @(Parse-StatusList -Path $fileYml -KeyName 'path')

# --- CSS (folders + files) ---
$parts = New-Object System.Collections.Generic.List[string]
[void]$parts.Add('/* AUTO-GENERATED from folder_status.yml + file_status.yml */')
[void]$parts.Add('/* In-progress = soft BLUE bar */')
[void]$parts.Add('')
[void]$parts.Add('.nav-folder-title[data-path] { border-left: 3px solid transparent; padding-left: 6px; font-weight: 500; }')
[void]$parts.Add('.nav-file-title[data-path] { border-left: 3px solid transparent; padding-left: 6px; }')
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

$renames = @()

# Precompute target file wiki paths for CSS (after rename)
$fileTargets = @()
foreach ($f in $files) {
  $st = $f.status
  if (-not $emojiOf.ContainsKey($st)) { $st = 'gray' }
  $em = $emojiOf[$st]
  $rel = $f.path.Replace('\', '/')
  if ($rel -notmatch '\.md$') { $rel = $rel + '.md' }
  $dirPart = ''
  $base = $rel
  if ($rel.Contains('/')) {
    $dirPart = $rel.Substring(0, $rel.LastIndexOf('/'))
    $base = $rel.Substring($rel.LastIndexOf('/') + 1)
  }
  $bare = Strip-EmojiPrefix -Name $base
  # skip folder indexes — owned by folder sync
  if ($bare -match ('^00_.*' + [regex]::Escape($suoYin) + '\.md$') -or $bare -eq ('00_' + $suoYin + '.md')) {
    continue
  }
  $targetBase = $em + '_' + $bare
  $targetRel = if ($dirPart) { $dirPart + '/' + $targetBase } else { $targetBase }
  $fileTargets += [pscustomobject]@{ status = $st; rel = $targetRel.Replace('\', '/') }
}

foreach ($ft in $fileTargets) {
  $st = $ft.status
  if (-not $palette.ContainsKey($st)) { $st = 'gray' }
  $p = $palette[$st]
  $path = $ft.rel
  [void]$parts.Add(".nav-file-title[data-path=`"$path`"] {")
  [void]$parts.Add("  border-left-color: $($p.bar) !important;")
  [void]$parts.Add("  color: $($p.text) !important;")
  [void]$parts.Add('}')
  [void]$parts.Add('')
}

$dir = Split-Path $cssPath -Parent
if (-not (Test-Path -LiteralPath $dir)) { New-Item -ItemType Directory -Path $dir | Out-Null }
[System.IO.File]::WriteAllText($cssPath, ($parts -join "`n"), $utf8)

# --- Rename folder indexes ---
foreach ($f in $folders) {
  $st = $f.status
  if (-not $emojiOf.ContainsKey($st)) { $st = 'gray' }
  $em = $emojiOf[$st]
  $folderFs = Join-Path $vault (($f.path -replace '/', [IO.Path]::DirectorySeparatorChar))
  if (-not (Test-Path -LiteralPath $folderFs)) { continue }

  $candidates = @(Get-ChildItem -LiteralPath $folderFs -File -Filter '00*.md' -ErrorAction SilentlyContinue |
    Where-Object { $_.Name.Contains($suoYin) })
  $targetName = '00_' + $em + $suoYin + '.md'
  $targetPath = Join-Path $folderFs $targetName
  if ($candidates.Count -eq 0) { continue }

  $src = $candidates | Select-Object -First 1
  if ($src.FullName -ne $targetPath) {
    if (Test-Path -LiteralPath $targetPath) { Remove-Item -LiteralPath $targetPath -Force }
    Rename-Item -LiteralPath $src.FullName -NewName $targetName
    $renames += [pscustomobject]@{ kind = 'index'; from = $src.Name; to = $targetName; folder = $f.path }
  }

  $folderWiki = $f.path.Replace('\', '/')
  $oldPatterns = @($folderWiki + '/00_' + $suoYin)
  foreach ($e in $allEmoji) { $oldPatterns += ($folderWiki + '/00_' + $e + $suoYin) }
  $newLink = $folderWiki + '/00_' + $em + $suoYin
  Patch-WikiLinks -OldLinks $oldPatterns -NewLink $newLink
}

# --- Rename listed files ---
foreach ($f in $files) {
  $st = $f.status
  if (-not $emojiOf.ContainsKey($st)) { $st = 'gray' }
  $em = $emojiOf[$st]
  $rel = $f.path.Replace('\', '/')
  if ($rel -notmatch '\.md$') { $rel = $rel + '.md' }

  $dirPart = ''
  $base = $rel
  if ($rel.Contains('/')) {
    $dirPart = $rel.Substring(0, $rel.LastIndexOf('/'))
    $base = $rel.Substring($rel.LastIndexOf('/') + 1)
  }
  $bare = Strip-EmojiPrefix -Name $base
  if ($bare -match ('^00_.*' + [regex]::Escape($suoYin) + '\.md$') -or $bare -eq ('00_' + $suoYin + '.md')) {
    continue
  }

  $folderFs = if ($dirPart) {
    Join-Path $vault ($dirPart -replace '/', [IO.Path]::DirectorySeparatorChar)
  } else { $vault }
  if (-not (Test-Path -LiteralPath $folderFs)) { continue }

  $targetName = $em + '_' + $bare
  $targetPath = Join-Path $folderFs $targetName

  # find existing: exact bare, or any emoji_bare
  $srcPath = $null
  $tryNames = @($bare)
  foreach ($e in $allEmoji) { $tryNames += ($e + '_' + $bare) }
  # also accept path as written in yml (may already have wrong emoji)
  $tryNames += $base
  $tryNames = $tryNames | Select-Object -Unique
  foreach ($tn in $tryNames) {
    $p = Join-Path $folderFs $tn
    if (Test-Path -LiteralPath $p) { $srcPath = $p; break }
  }
  if ($null -eq $srcPath) {
    Write-Host ("SKIP missing: {0}" -f $rel)
    continue
  }

  if ($srcPath -ne $targetPath) {
    if ((Test-Path -LiteralPath $targetPath) -and ($srcPath -ne $targetPath)) {
      Remove-Item -LiteralPath $targetPath -Force
    }
    Rename-Item -LiteralPath $srcPath -NewName $targetName
    $renames += [pscustomobject]@{
      kind = 'file'
      from = [IO.Path]::GetFileName($srcPath)
      to = $targetName
      folder = $dirPart
    }
  }

  # wiki link bases without .md
  $bareNoExt = [IO.Path]::GetFileNameWithoutExtension($bare)
  $targetNoExt = [IO.Path]::GetFileNameWithoutExtension($targetName)
  $prefix = if ($dirPart) { $dirPart + '/' } else { '' }
  $oldLinks = @($prefix + $bareNoExt)
  foreach ($e in $allEmoji) {
    $oldLinks += ($prefix + $e + '_' + $bareNoExt)
  }
  $newLink = $prefix + $targetNoExt
  Patch-WikiLinks -OldLinks $oldLinks -NewLink $newLink
}

Write-Host ("OK folders={0} files={1} renames={2}" -f $folders.Count, $files.Count, $renames.Count)
$renames | ForEach-Object {
  Write-Host ("  [{0}] {1}: {2} -> {3}" -f $_.kind, $_.folder, $_.from, $_.to)
}
