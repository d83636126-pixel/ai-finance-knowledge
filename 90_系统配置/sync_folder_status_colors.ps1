# Sync folder/file status colors — Scheme D (workflow + attention)
# Color is COMPUTED from structured fields; sidebar still shows one color.
#
# Modes:
#   -Check      validate only (default if no switch given)
#   -Preview    show planned renames / CSS / dashboard changes, no writes
#   -Sync       apply index renames, link patches, CSS
#   -Dashboard  with -Sync: also rebuild 00_状态总览.md
#
# Examples:
#   powershell -NoProfile -ExecutionPolicy Bypass -File "90_系统配置\sync_folder_status_colors.ps1" -Check
#   powershell -NoProfile -ExecutionPolicy Bypass -File "90_系统配置\sync_folder_status_colors.ps1" -Preview
#   powershell -NoProfile -ExecutionPolicy Bypass -File "90_系统配置\sync_folder_status_colors.ps1" -Sync -Dashboard

[CmdletBinding()]
param(
  [switch]$Check,
  [switch]$Preview,
  [switch]$Sync,
  [switch]$Dashboard
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

if (-not $Check -and -not $Preview -and -not $Sync) { $Check = $true }
if ($Dashboard -and -not $Sync -and -not $Preview) {
  throw 'Use -Dashboard together with -Sync (or -Preview to inspect dashboard text).'
}

$vault = Split-Path -Parent $PSScriptRoot
$folderYml = Join-Path $PSScriptRoot 'folder_status.yml'
$fileYml = Join-Path $PSScriptRoot 'file_status.yml'
$cssPath = Join-Path $vault '.obsidian\snippets\vault-folder-status-colors.css'
$dashboardPath = Join-Path $vault '00_状态总览.md'
$today = Get-Date
$todayDate = $today.Date
$todayStr = $today.ToString('yyyy-MM-dd')

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
$validWorkflow = @('backlog', 'scheduled', 'active', 'waiting', 'paused', 'done', 'archived')
$validAttention = @('normal', 'watch', 'blocked', 'overdue')
$validLegacyStatus = @('green', 'blue', 'orange', 'red', 'gray')
$utf8 = New-Object System.Text.UTF8Encoding $false
$suoYin = ([char]0x7D22).ToString() + ([char]0x5F15).ToString()

$script:Errors = New-Object System.Collections.Generic.List[string]
$script:Warnings = New-Object System.Collections.Generic.List[string]
$script:Changes = New-Object System.Collections.Generic.List[string]

function Add-Err([string]$m) { [void]$script:Errors.Add($m) }
function Add-Warn([string]$m) { [void]$script:Warnings.Add($m) }
function Add-Change([string]$m) { [void]$script:Changes.Add($m) }

function Parse-StatusRecords {
  param([string]$Path, [string]$KeyName)
  if (-not (Test-Path -LiteralPath $Path)) { return @() }
  $lines = Get-Content -LiteralPath $Path -Encoding UTF8
  $items = New-Object System.Collections.Generic.List[hashtable]
  $cur = $null
  foreach ($line in $lines) {
    if ($line -match ("^\s*-\s*" + [regex]::Escape($KeyName) + ":\s*(.+)\s*$")) {
      if ($null -ne $cur) { [void]$items.Add($cur) }
      $cur = @{
        path       = $Matches[1].Trim()
        status     = $null
        workflow   = $null
        attention  = $null
        owner      = $null
        updated    = $null
        review_by  = $null
        next_action = $null
        reason     = $null
        inherit    = $true
        note       = $null
      }
      continue
    }
    if ($null -eq $cur) { continue }
    if ($line -match '^\s*status:\s*(\w+)\s*$') { $cur.status = $Matches[1].Trim().ToLowerInvariant(); continue }
    if ($line -match '^\s*workflow:\s*(\w+)\s*$') { $cur.workflow = $Matches[1].Trim().ToLowerInvariant(); continue }
    if ($line -match '^\s*attention:\s*(\w+)\s*$') { $cur.attention = $Matches[1].Trim().ToLowerInvariant(); continue }
    if ($line -match '^\s*owner:\s*(.+)\s*$') { $cur.owner = $Matches[1].Trim(); continue }
    if ($line -match '^\s*updated:\s*(.+)\s*$') { $cur.updated = $Matches[1].Trim(); continue }
    if ($line -match '^\s*review_by:\s*(.+)\s*$') { $cur.review_by = $Matches[1].Trim(); continue }
    if ($line -match '^\s*next_action:\s*(.+)\s*$') { $cur.next_action = $Matches[1].Trim(); continue }
    if ($line -match '^\s*reason:\s*(.+)\s*$') { $cur.reason = $Matches[1].Trim(); continue }
    if ($line -match '^\s*note:\s*(.+)\s*$') { $cur.note = $Matches[1].Trim(); continue }
    if ($line -match '^\s*inherit:\s*(true|false)\s*$') {
      $cur.inherit = ($Matches[1].Trim().ToLowerInvariant() -eq 'true')
      continue
    }
  }
  if ($null -ne $cur) { [void]$items.Add($cur) }
  return @($items)
}

function ConvertFrom-LegacyStatus {
  param([string]$Status)
  switch ($Status) {
    'green'  { return @{ workflow = 'done'; attention = 'normal' } }
    'blue'   { return @{ workflow = 'active'; attention = 'normal' } }
    'orange' { return @{ workflow = 'scheduled'; attention = 'watch' } }
    'red'    { return @{ workflow = 'active'; attention = 'blocked' } }
    'gray'   { return @{ workflow = 'paused'; attention = 'normal' } }
    default  { return @{ workflow = 'backlog'; attention = 'normal' } }
  }
}

function Normalize-Record {
  param([hashtable]$Rec, [string]$Kind)
  $r = @{}
  foreach ($k in $Rec.Keys) { $r[$k] = $Rec[$k] }
  $r.kind = $Kind
  $r.path = ([string]$r.path).Replace('\', '/').Trim()

  $legacyOnly = (-not $r.workflow -and -not $r.attention -and $r.status)
  if ($legacyOnly) {
    $mapped = ConvertFrom-LegacyStatus -Status $r.status
    $r.workflow = $mapped.workflow
    $r.attention = $mapped.attention
    $r._from_legacy = $true
  }

  if (-not $r.workflow) { $r.workflow = 'backlog'; Add-Warn ("{0} '{1}' missing workflow → backlog" -f $Kind, $r.path) }
  if (-not $r.attention) { $r.attention = 'normal' }
  if (-not $r.reason -and $r.note) { $r.reason = $r.note }

  $r.workflow = ([string]$r.workflow).ToLowerInvariant()
  $r.attention = ([string]$r.attention).ToLowerInvariant()
  return $r
}

function Test-DateYmd {
  param([string]$s)
  if ([string]::IsNullOrWhiteSpace($s)) { return $null }
  $dt = [datetime]::MinValue
  if ([datetime]::TryParseExact($s.Trim(), 'yyyy-MM-dd', [Globalization.CultureInfo]::InvariantCulture,
      [Globalization.DateTimeStyles]::None, [ref]$dt)) {
    return $dt.Date
  }
  return $null
}

function Get-ComputedColor {
  param([hashtable]$Rec)
  $wf = $Rec.workflow
  $att = $Rec.attention
  $review = Test-DateYmd -s $Rec.review_by
  $overdue = $false
  if ($null -ne $review -and $review -lt $todayDate) {
    $overdue = $true
    $Rec.attention = 'overdue'
    $att = 'overdue'
  }

  if ($att -eq 'blocked') { return @{ color = 'red'; why = 'attention:blocked' } }
  if ($overdue -or $att -eq 'overdue') { return @{ color = 'red'; why = 'past review_by / overdue' } }
  if ($att -eq 'watch') { return @{ color = 'orange'; why = 'attention:watch' } }
  if ($wf -eq 'scheduled' -or $wf -eq 'waiting') { return @{ color = 'orange'; why = ("workflow:{0}" -f $wf) } }
  if ($wf -eq 'active') { return @{ color = 'blue'; why = 'workflow:active' } }
  if ($wf -eq 'done') { return @{ color = 'green'; why = 'workflow:done' } }
  if ($wf -eq 'paused' -or $wf -eq 'archived' -or $wf -eq 'backlog') {
    return @{ color = 'gray'; why = ("workflow:{0}" -f $wf) }
  }
  return @{ color = 'gray'; why = 'invalid/fallback' }
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

function Get-FsPathFromRel {
  param([string]$Rel)
  $rel = $Rel.Replace('/', [IO.Path]::DirectorySeparatorChar)
  return (Join-Path $vault $rel)
}

function Validate-Record {
  param([hashtable]$Rec, [string]$Kind, [hashtable]$PathSeen)
  $path = $Rec.path
  if ([string]::IsNullOrWhiteSpace($path)) {
    Add-Err ("{0} entry missing path" -f $Kind)
    return
  }
  if ($PathSeen.ContainsKey($path)) {
    Add-Err ("Duplicate {0} path: {1}" -f $Kind, $path)
  } else {
    $PathSeen[$path] = $true
  }

  if ($validWorkflow -notcontains $Rec.workflow) {
    Add-Err ("{0} '{1}' invalid workflow '{2}'" -f $Kind, $path, $Rec.workflow)
  }
  if ($validAttention -notcontains $Rec.attention -and $Rec.attention -ne 'overdue') {
    Add-Err ("{0} '{1}' invalid attention '{2}'" -f $Kind, $path, $Rec.attention)
  }
  if ($Rec.status -and ($validLegacyStatus -notcontains $Rec.status)) {
    Add-Warn ("{0} '{1}' legacy status '{2}' ignored for validation" -f $Kind, $path, $Rec.status)
  }

  $fs = Get-FsPathFromRel -Rel $path
  if ($Kind -eq 'folder') {
    if (-not (Test-Path -LiteralPath $fs -PathType Container)) {
      Add-Err ("Folder path does not exist: {0}" -f $path)
    }
  } else {
    if (-not (Test-Path -LiteralPath $fs -PathType Leaf)) {
      Add-Err ("File path does not exist: {0}" -f $path)
    }
  }

  $activeLike = @('active', 'scheduled', 'waiting') -contains $Rec.workflow
  if ($activeLike) {
    if ([string]::IsNullOrWhiteSpace($Rec.next_action)) {
      Add-Err ("Active-like {0} '{1}' missing next_action" -f $Kind, $path)
    }
    if ([string]::IsNullOrWhiteSpace($Rec.review_by)) {
      Add-Err ("Active-like {0} '{1}' missing review_by" -f $Kind, $path)
    } elseif ($null -eq (Test-DateYmd -s $Rec.review_by)) {
      Add-Err ("{0} '{1}' review_by not yyyy-MM-dd: {2}" -f $Kind, $path, $Rec.review_by)
    }
  }

  $comp = Get-ComputedColor -Rec $Rec
  $Rec.color = $comp.color
  $Rec.color_why = $comp.why
  if ($comp.color -in @('orange', 'red') -and [string]::IsNullOrWhiteSpace($Rec.reason)) {
    Add-Err ("{0} '{1}' is {2} but missing reason" -f $Kind, $path, $comp.color)
  }
  if ($Kind -eq 'folder' -and $path -match 'AI项目|项目' -and [string]::IsNullOrWhiteSpace($Rec.owner)) {
    Add-Warn ("Project folder '{0}' missing owner" -f $path)
  }
  if ([string]::IsNullOrWhiteSpace($Rec.updated)) {
    Add-Warn ("{0} '{1}' missing updated" -f $Kind, $path)
  }
}

function Patch-WikiLinkExact {
  param([string]$OldLink, [string]$NewLink, [switch]$Apply)
  if ($OldLink -eq $NewLink) { return 0 }
  $count = 0
  $esc = [regex]::Escape($OldLink)
  $mdFiles = Get-ChildItem -LiteralPath $vault -Recurse -Filter '*.md' -File |
    Where-Object { $_.FullName -notmatch '\\\.trash\\|\\\.obsidian\\' }
  foreach ($md in $mdFiles) {
    $text = [System.IO.File]::ReadAllText($md.FullName, [System.Text.Encoding]::UTF8)
    $newText = [regex]::Replace($text, '\[\[' + $esc + '(?=\]|\|)', '[[' + $NewLink)
    if ($newText -ne $text) {
      if ($Apply) {
        [System.IO.File]::WriteAllText($md.FullName, $newText, $utf8)
      }
      $count++
    }
  }
  return $count
}

function Build-Css {
  param([object[]]$Folders, [object[]]$Files)
  $parts = New-Object System.Collections.Generic.List[string]
  [void]$parts.Add('/* AUTO-GENERATED from folder_status.yml + file_status.yml */')
  [void]$parts.Add('/* Scheme D: color computed from workflow + attention */')
  [void]$parts.Add('/* Indexes keep emoji names; other files use CSS only */')
  [void]$parts.Add('')
  [void]$parts.Add('.nav-folder-title[data-path] { border-left: 3px solid transparent; padding-left: 6px; font-weight: 500; }')
  [void]$parts.Add('.nav-file-title[data-path] { border-left: 3px solid transparent; padding-left: 6px; }')
  [void]$parts.Add('')

  foreach ($f in $Folders) {
    $st = $f.color
    if (-not $palette.ContainsKey($st)) { $st = 'gray' }
    $p = $palette[$st]
    $path = $f.path
    [void]$parts.Add("/* folder: $path = $st ($($f.workflow)/$($f.attention); $($f.color_why)) */")
    [void]$parts.Add(".nav-folder-title[data-path=`"$path`"] {")
    [void]$parts.Add("  border-left-color: $($p.bar) !important;")
    [void]$parts.Add("  color: $($p.text) !important;")
    [void]$parts.Add('}')
    if ($f.inherit -ne $false) {
      [void]$parts.Add(".nav-file-title[data-path^=`"$path/`"] {")
      [void]$parts.Add("  border-left-color: $($p.bar) !important;")
      [void]$parts.Add("  color: $($p.text) !important;")
      [void]$parts.Add('}')
    }
    [void]$parts.Add('')
  }

  [void]$parts.Add('/* file_status.yml overrides (and root files) */')
  foreach ($f in $Files) {
    $st = $f.color
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

  foreach ($f in $Folders) {
    $st = $f.color
    if (-not $emojiOf.ContainsKey($st)) { $st = 'gray' }
    $em = $emojiOf[$st]
    $p = $palette[$st]
    $idx = $f.path + '/00_' + $em + $suoYin + '.md'
    [void]$parts.Add(".nav-file-title[data-path=`"$idx`"] {")
    [void]$parts.Add("  border-left-color: $($p.bar) !important;")
    [void]$parts.Add("  color: $($p.text) !important;")
    [void]$parts.Add('}')
    [void]$parts.Add('')
  }

  return ($parts -join "`n")
}

function Build-Dashboard {
  param([object[]]$Folders)
  $imm = New-Object System.Collections.Generic.List[hashtable]
  $watch = New-Object System.Collections.Generic.List[hashtable]
  $active = New-Object System.Collections.Generic.List[hashtable]
  $steady = New-Object System.Collections.Generic.List[hashtable]

  foreach ($f in $Folders) {
    $row = @{
      color = $f.color
      emoji = $emojiOf[$f.color]
      path = $f.path
      name = ($f.path -split '/')[-1]
      next = $f.next_action
      review = $f.review_by
      reason = $f.reason
      owner = $f.owner
      workflow = $f.workflow
      attention = $f.attention
    }
    $reviewDt = Test-DateYmd -s $f.review_by
    $dueSoon = $false
    if ($null -ne $reviewDt) {
      $delta = ($reviewDt - $todayDate).TotalDays
      if ($delta -ge 0 -and $delta -le 7) { $dueSoon = $true }
    }

    $isImmediate = ($f.color -eq 'red') -or
      ($f.attention -eq 'blocked') -or
      ($f.attention -eq 'overdue') -or
      (($f.workflow -eq 'active') -and [string]::IsNullOrWhiteSpace($f.next_action))

    if ($isImmediate) {
      [void]$imm.Add($row)
    } elseif ($f.color -eq 'orange' -or $dueSoon -or $f.workflow -eq 'waiting') {
      [void]$watch.Add($row)
    } elseif ($f.workflow -eq 'active' -and $f.color -eq 'blue') {
      [void]$active.Add($row)
    } else {
      [void]$steady.Add($row)
    }
  }

  function Rows([object[]]$list) {
    if (-not $list -or $list.Count -eq 0) { return "_（无）_`n" }
    $sb = "| 状态 | 项目 | 下一步 | 复核日期 | 原因 |`n|---|---|---|---|---|`n"
    foreach ($r in $list) {
      $sb += ("| {0} | `{1}` | {2} | {3} | {4} |`n" -f $r.emoji, $r.path,
        $(if ($r.next) { $r.next } else { '—' }),
        $(if ($r.review) { $r.review } else { '—' }),
        $(if ($r.reason) { $r.reason } else { '—' }))
    }
    return $sb
  }

  $md = @"
---
type: 状态总览
status: auto
tags: [状态色标, 自动生成]
updated: $todayStr
---

# 00_状态总览

> [!warning] 自动生成
> 本文件由 ``90_系统配置/sync_folder_status_colors.ps1 -Sync -Dashboard`` 重建。
> 请勿手改正文；改状态请编辑 [[90_系统配置/folder_status.yml|folder_status.yml]] / [[90_系统配置/file_status.yml|file_status.yml]]。
> 说明见 [[00_状态色标说明]]。

生成时间：$todayStr  
库路径：``$vault``

## 1. 需要立即处理

$(Rows $imm)

## 2. 近期关注

$(Rows $watch)

## 3. 当前进行中

$(Rows $active)

## 4. 稳态与归档

<details>
<summary>展开绿色 / 灰色项目（$($steady.Count)）</summary>

$(Rows $steady)

</details>

---

颜色由 ``workflow`` + ``attention``（及 ``review_by``）计算，优先级：阻塞/过期 🔴 → 关注/等待/排期 🟠 → 进行中 🔵 → 完成 🟢 → 暂停/归档 ⚪
"@
  return $md
}

# -------------------- load & normalize --------------------
if (-not (Test-Path -LiteralPath $folderYml)) { throw 'Missing folder_status.yml' }
$rawFolders = @(Parse-StatusRecords -Path $folderYml -KeyName 'path')
$rawFiles = @(Parse-StatusRecords -Path $fileYml -KeyName 'path')

$folders = @()
foreach ($r in $rawFolders) {
  $n = Normalize-Record -Rec $r -Kind 'folder'
  $n.path = $n.path.TrimEnd('/')
  $folders += $n
}
$files = @()
foreach ($r in $rawFiles) {
  $n = Normalize-Record -Rec $r -Kind 'file'
  $n.path = Normalize-FileRel -Rel $n.path
  $files += $n
}

$pathSeenFolder = @{}
$pathSeenFile = @{}
foreach ($f in $folders) { Validate-Record -Rec $f -Kind 'folder' -PathSeen $pathSeenFolder }
foreach ($f in $files) { Validate-Record -Rec $f -Kind 'file' -PathSeen $pathSeenFile }

# Too many file overrides warning
if ($files.Count -gt 40) {
  Add-Warn ("file_status.yml has {0} overrides; prefer folder inherit for ordinary notes" -f $files.Count)
}

# Index filename vs computed color (informational for Check)
foreach ($f in $folders) {
  $folderFs = Get-FsPathFromRel -Rel $f.path
  if (-not (Test-Path -LiteralPath $folderFs)) { continue }
  $em = $emojiOf[$f.color]
  $want = '00_' + $em + $suoYin + '.md'
  $candidates = @(Get-ChildItem -LiteralPath $folderFs -File -Filter '00*.md' -ErrorAction SilentlyContinue |
    Where-Object { Test-IsFolderIndexName -Name $_.Name })
  if ($candidates.Count -eq 0) {
    Add-Warn ("Folder '{0}' has no 00_*索引.md" -f $f.path)
    continue
  }
  $src = $candidates | Select-Object -First 1
  if ($src.Name -ne $want) {
    Add-Change ("index rename: {0}/{1} → {2}" -f $f.path, $src.Name, $want)
  }
}

$cssNew = Build-Css -Folders $folders -Files $files
$cssOld = ''
if (Test-Path -LiteralPath $cssPath) {
  $cssOld = [System.IO.File]::ReadAllText($cssPath, [System.Text.Encoding]::UTF8)
}
if ($cssNew -ne $cssOld) { Add-Change 'CSS snippet vault-folder-status-colors.css will update' }

$dashNew = Build-Dashboard -Folders $folders
$dashOld = ''
if (Test-Path -LiteralPath $dashboardPath) {
  $dashOld = [System.IO.File]::ReadAllText($dashboardPath, [System.Text.Encoding]::UTF8)
}
if ($Dashboard -or $Preview) {
  if ($dashNew -ne $dashOld) { Add-Change '00_状态总览.md will rebuild' }
}

# -------------------- modes --------------------
Write-Host ("Mode: Check={0} Preview={1} Sync={2} Dashboard={3}" -f $Check, $Preview, $Sync, $Dashboard)
Write-Host ("Vault: {0}" -f $vault)
Write-Host ("Folders={0} FileOverrides={1}" -f $folders.Count, $files.Count)
Write-Host ''

Write-Host '=== Computed folder colors ==='
foreach ($f in $folders) {
  Write-Host ("  {0} {1}  [{2}/{3}]  {4}" -f $emojiOf[$f.color], $f.path, $f.workflow, $f.attention, $f.color_why)
}
Write-Host ''

if ($Preview -or $Check) {
  Write-Host ("=== Changes ({0}) ===" -f $script:Changes.Count)
  if ($script:Changes.Count -eq 0) { Write-Host '  (none)' }
  else { $script:Changes | ForEach-Object { Write-Host ("  - {0}" -f $_) } }
  Write-Host ''
}

if ($Preview -and $Dashboard) {
  Write-Host '=== Dashboard preview (first 40 lines) ==='
  ($dashNew -split "`n" | Select-Object -First 40) | ForEach-Object { Write-Host $_ }
  Write-Host ''
}

if ($script:Errors.Count -gt 0) {
  Write-Host ("=== Errors ({0}) ===" -f $script:Errors.Count)
  $script:Errors | ForEach-Object { Write-Host ("  ERROR: {0}" -f $_) }
  Write-Host ("=== Warnings ({0}) ===" -f $script:Warnings.Count)
  if ($script:Warnings.Count -eq 0) { Write-Host '  (none)' }
  else { $script:Warnings | ForEach-Object { Write-Host ("  WARN: {0}" -f $_) } }
  Write-Host ''
  Write-Host 'FAILED validation — fix YAML before Sync.'
  exit 1
}

if ($Sync) {
  $renames = @()

  # 1) Revert non-index emoji_ prefixes
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
    $relDir = $f.DirectoryName.Substring($vault.Length).TrimStart('\', '/').Replace('\', '/')
    $oldNoExt = [IO.Path]::GetFileNameWithoutExtension($f.Name)
    $newNoExt = [IO.Path]::GetFileNameWithoutExtension($bare)
    if ($relDir) {
      [void](Patch-WikiLinkExact -OldLink ($relDir + '/' + $oldNoExt) -NewLink ($relDir + '/' + $newNoExt) -Apply)
    } else {
      [void](Patch-WikiLinkExact -OldLink $oldNoExt -NewLink $newNoExt -Apply)
    }
  }

  # 2) Rename folder indexes to match computed color
  foreach ($f in $folders) {
    $st = $f.color
    if (-not $emojiOf.ContainsKey($st)) { $st = 'gray' }
    $em = $emojiOf[$st]
    $folderFs = Get-FsPathFromRel -Rel $f.path
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

    $folderWiki = $f.path
    $oldIndexes = @($folderWiki + '/00_' + $suoYin)
    foreach ($e in $allEmoji) { $oldIndexes += ($folderWiki + '/00_' + $e + $suoYin) }
    $newIndex = $folderWiki + '/00_' + $em + $suoYin
    foreach ($op in ($oldIndexes | Sort-Object Length -Descending)) {
      if ($op -eq $newIndex) { continue }
      [void](Patch-WikiLinkExact -OldLink $op -NewLink $newIndex -Apply)
    }
  }

  # 3) Write CSS
  $dir = Split-Path $cssPath -Parent
  if (-not (Test-Path -LiteralPath $dir)) { New-Item -ItemType Directory -Path $dir | Out-Null }
  [System.IO.File]::WriteAllText($cssPath, $cssNew, $utf8)

  # 4) Dashboard
  if ($Dashboard) {
    [System.IO.File]::WriteAllText($dashboardPath, $dashNew, $utf8)
  }

  Write-Host ("SYNC OK renames={0}" -f $renames.Count)
  $renames | ForEach-Object {
    Write-Host ("  [{0}] {1} -> {2}" -f $_.kind, $_.from, $_.to)
  }
}

Write-Host ''
Write-Host ("=== Errors ({0}) ===" -f $script:Errors.Count)
if ($script:Errors.Count -eq 0) { Write-Host '  (none)' }
else { $script:Errors | ForEach-Object { Write-Host ("  ERROR: {0}" -f $_) } }

Write-Host ("=== Warnings ({0}) ===" -f $script:Warnings.Count)
if ($script:Warnings.Count -eq 0) { Write-Host '  (none)' }
else { $script:Warnings | ForEach-Object { Write-Host ("  WARN: {0}" -f $_) } }

if ($script:Errors.Count -gt 0) {
  Write-Host ''
  Write-Host 'FAILED validation — fix YAML before relying on colors.'
  exit 1
}

if ($Check -and -not $Sync -and -not $Preview) {
  Write-Host ''
  Write-Host 'CHECK OK'
}
exit 0
