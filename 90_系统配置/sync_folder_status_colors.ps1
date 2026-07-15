# Sync folder/file status colors (scheme C)
# - Folder indexes: rename to 00_<emoji>索引.md
# - Other files: NEVER rename; strip accidental <emoji>_ prefixes back to bare names
# - CSS: folder bar + all files under folder inherit color + file_status.yml overrides
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

function Test-IsFolderIndexName {
  param([string]$Name)
  if ($Name -eq ('00_' + $suoYin + '.md')) { return $true }
  foreach ($e in $allEmoji) {
    if ($Name -eq ('00_' + $e + $suoYin + '.md')) { return $true }
  }
  return $false
}

function Strip-EmojiPrefix {
  param([string]$Name)
  foreach ($e in $allEmoji) {
    $pref = $e + '_'
    if ($Name.StartsWith($pref)) { return $Name.Substring($pref.Length) }
  }
  return $Name
}

function Patch-WikiLinkExact {
  param([string]$OldLink, [string]$NewLink)
  if ($OldLink -eq $NewLink) { return 0 }
  $count = 0
  $esc = [regex]::Escape($OldLink)
  $mdFiles = Get-ChildItem -LiteralPath $vault -Recurse -Filter '*.md' -File |
    Where-Object { $_.FullName -notmatch '\\\.trash\\' }
  foreach ($md in $mdFiles) {
    $text = [System.IO.File]::ReadAllText($md.FullName, [System.Text.Encoding]::UTF8)
    $newText = [regex]::Replace($text, '\[\[' + $esc + '(?=\]|\|)', '[[' + $NewLink)
    if ($newText -ne $text) {
      [System.IO.File]::WriteAllText($md.FullName, $newText, $utf8)
      $count++
    }
  }
  return $count
}

if (-not (Test-Path -LiteralPath $folderYml)) { throw 'Missing folder_status.yml' }
$folders = @(Parse-StatusList -Path $folderYml -KeyName 'path')
$files = @(Parse-StatusList -Path $fileYml -KeyName 'path')

$renames = @()

# --- 1) Revert non-index <emoji>_ prefixes to bare names + patch links ---
$mdAll = Get-ChildItem -LiteralPath $vault -Recurse -Filter '*.md' -File |
  Where-Object { $_.FullName -notmatch '\\\.trash\\|\\\.obsidian\\' }
foreach ($f in $mdAll) {
  if (Test-IsFolderIndexName -Name $f.Name) { continue }
  $bare = Strip-EmojiPrefix -Name $f.Name
  if ($bare -eq $f.Name) { continue }

  $targetPath = Join-Path $f.DirectoryName $bare
  if ((Test-Path -LiteralPath $targetPath) -and ($targetPath -ne $f.FullName)) {
    throw ("Revert blocked, target exists: {0}" -f $targetPath)
  }
  Rename-Item -LiteralPath $f.FullName -NewName $bare
  $renames += [pscustomobject]@{ kind = 'revert'; from = $f.Name; to = $bare; folder = $f.DirectoryName }

  # wiki: dir/emoji_bare -> dir/bare  (and emoji_bare at root)
  $relDir = $f.DirectoryName.Substring($vault.Length).TrimStart('\', '/').Replace('\', '/')
  $oldNoExt = [IO.Path]::GetFileNameWithoutExtension($f.Name)
  $newNoExt = [IO.Path]::GetFileNameWithoutExtension($bare)
  if ($relDir) {
    [void](Patch-WikiLinkExact -OldLink ($relDir + '/' + $oldNoExt) -NewLink ($relDir + '/' + $newNoExt))
  } else {
    [void](Patch-WikiLinkExact -OldLink $oldNoExt -NewLink $newNoExt)
  }
}

# --- 2) Rename folder indexes only ---
foreach ($f in $folders) {
  $st = $f.status
  if (-not $emojiOf.ContainsKey($st)) { $st = 'gray' }
  $em = $emojiOf[$st]
  $folderFs = Join-Path $vault (($f.path -replace '/', [IO.Path]::DirectorySeparatorChar))
  if (-not (Test-Path -LiteralPath $folderFs)) { continue }

  $candidates = @(Get-ChildItem -LiteralPath $folderFs -File -Filter '00*.md' -ErrorAction SilentlyContinue |
    Where-Object { Test-IsFolderIndexName -Name $_.Name })
  $targetName = '00_' + $em + $suoYin + '.md'
  $targetPath = Join-Path $folderFs $targetName
  if ($candidates.Count -eq 0) { continue }

  $src = $candidates | Select-Object -First 1
  if ($src.FullName -ne $targetPath) {
    if ((Test-Path -LiteralPath $targetPath) -and ($src.FullName -ne $targetPath)) {
      throw ("Refusing to overwrite folder index: {0}" -f $targetPath)
    }
    Rename-Item -LiteralPath $src.FullName -NewName $targetName
    $renames += [pscustomobject]@{ kind = 'index'; from = $src.Name; to = $targetName; folder = $f.path }
  }

  $folderWiki = $f.path.Replace('\', '/')
  $oldIndexes = @($folderWiki + '/00_' + $suoYin)
  foreach ($e in $allEmoji) { $oldIndexes += ($folderWiki + '/00_' + $e + $suoYin) }
  $newIndex = $folderWiki + '/00_' + $em + $suoYin
  foreach ($op in ($oldIndexes | Sort-Object Length -Descending)) {
    if ($op -eq $newIndex) { continue }
    [void](Patch-WikiLinkExact -OldLink $op -NewLink $newIndex)
  }
}

# Normalize file_status paths: strip any emoji_ prefix in yml paths for CSS targets
function Normalize-FileRel {
  param([string]$Rel)
  $rel = $Rel.Replace('\', '/')
  if ($rel -notmatch '\.md$') { $rel = $rel + '.md' }
  $dir = ''
  $base = $rel
  if ($rel.Contains('/')) {
    $dir = $rel.Substring(0, $rel.LastIndexOf('/'))
    $base = $rel.Substring($rel.LastIndexOf('/') + 1)
  }
  $bare = Strip-EmojiPrefix -Name $base
  if ($dir) { return ($dir + '/' + $bare) }
  return $bare
}

# --- 3) CSS: folder + inherit to files under folder + file overrides ---
$parts = New-Object System.Collections.Generic.List[string]
[void]$parts.Add('/* AUTO-GENERATED from folder_status.yml + file_status.yml */')
[void]$parts.Add('/* Scheme C: indexes keep emoji names; other files use CSS only */')
[void]$parts.Add('/* In-progress = soft BLUE */')
[void]$parts.Add('')
[void]$parts.Add('.nav-folder-title[data-path] { border-left: 3px solid transparent; padding-left: 6px; font-weight: 500; }')
[void]$parts.Add('.nav-file-title[data-path] { border-left: 3px solid transparent; padding-left: 6px; }')
[void]$parts.Add('')

foreach ($f in $folders) {
  $st = $f.status
  if (-not $palette.ContainsKey($st)) { $st = 'gray' }
  $p = $palette[$st]
  $path = $f.path.Replace('\', '/')
  [void]$parts.Add("/* folder: $path = $st */")
  [void]$parts.Add(".nav-folder-title[data-path=`"$path`"] {")
  [void]$parts.Add("  border-left-color: $($p.bar) !important;")
  [void]$parts.Add("  color: $($p.text) !important;")
  [void]$parts.Add('}')
  # inherit: every file whose path starts with folder/
  [void]$parts.Add(".nav-file-title[data-path^=`"$path/`"] {")
  [void]$parts.Add("  border-left-color: $($p.bar) !important;")
  [void]$parts.Add("  color: $($p.text) !important;")
  [void]$parts.Add('}')
  [void]$parts.Add('')
}

# Root-level marked files (no folder prefix) + overrides (more specific, after inherit)
[void]$parts.Add('/* file_status.yml overrides (and root files) */')
foreach ($f in $files) {
  $st = $f.status
  if (-not $palette.ContainsKey($st)) { $st = 'gray' }
  $p = $palette[$st]
  $rel = Normalize-FileRel -Rel $f.path
  if (Test-IsFolderIndexName -Name ([IO.Path]::GetFileName($rel))) { continue }
  [void]$parts.Add(".nav-file-title[data-path=`"$rel`"] {")
  [void]$parts.Add("  border-left-color: $($p.bar) !important;")
  [void]$parts.Add("  color: $($p.text) !important;")
  [void]$parts.Add('}')
  [void]$parts.Add('')
}

# Also color folder index files themselves (path includes emoji in filename)
foreach ($f in $folders) {
  $st = $f.status
  if (-not $emojiOf.ContainsKey($st)) { $st = 'gray' }
  $em = $emojiOf[$st]
  $p = $palette[$st]
  $idx = $f.path.Replace('\', '/') + '/00_' + $em + $suoYin + '.md'
  [void]$parts.Add(".nav-file-title[data-path=`"$idx`"] {")
  [void]$parts.Add("  border-left-color: $($p.bar) !important;")
  [void]$parts.Add("  color: $($p.text) !important;")
  [void]$parts.Add('}')
  [void]$parts.Add('')
}

$dir = Split-Path $cssPath -Parent
if (-not (Test-Path -LiteralPath $dir)) { New-Item -ItemType Directory -Path $dir | Out-Null }
[System.IO.File]::WriteAllText($cssPath, ($parts -join "`n"), $utf8)

Write-Host ("OK folders={0} fileOverrides={1} renames={2}" -f $folders.Count, $files.Count, $renames.Count)
$renames | ForEach-Object {
  Write-Host ("  [{0}] {1} -> {2}" -f $_.kind, $_.from, $_.to)
}
