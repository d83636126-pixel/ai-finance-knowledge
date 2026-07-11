# sync_vault_status.ps1
# Probe code repo evidence and rewrite Obsidian AUTO status blocks.
$ErrorActionPreference = "Stop"
$SyncDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RegistryPath = Join-Path $SyncDir "acceptance_registry.json"
$Registry = Get-Content -LiteralPath $RegistryPath -Raw -Encoding UTF8 | ConvertFrom-Json

function First-Existing([string[]]$candidates) {
  foreach ($p in $candidates) {
    if ($p -and (Test-Path -LiteralPath $p)) { return (Resolve-Path -LiteralPath $p).Path }
  }
  return $null
}

$CodeRoot = First-Existing @($Registry.code_root_candidates)
$VaultRoot = First-Existing @($Registry.vault_root_candidates)
if (-not $CodeRoot) { throw "No code root found" }
if (-not $VaultRoot) { throw "No vault root found" }

function Invoke-Git([string[]]$GitArgs) {
  try {
    Push-Location -LiteralPath $CodeRoot
    return (& git @GitArgs 2>$null | Out-String).Trim()
  } catch { return $null }
  finally { Pop-Location }
}

function Get-LineCount([string]$file) {
  if (-not (Test-Path -LiteralPath $file)) { return $null }
  return @(Get-Content -LiteralPath $file -ErrorAction SilentlyContinue).Count
}

function Get-Evidence($evidence) {
  $results = @()
  foreach ($rule in $evidence) {
    if ($rule.type -eq "file_exists") {
      $full = Join-Path $CodeRoot $rule.path
      $ok = Test-Path -LiteralPath $full
      $detail = if ($ok) { "exists ($(Get-LineCount $full) lines)" } else { "MISSING" }
      $results += [pscustomobject]@{ path = $rule.path; ok = [bool]$ok; detail = $detail }
    }
  }
  return $results
}

$commit = Invoke-Git @("rev-parse","HEAD")
$short = Invoke-Git @("rev-parse","--short","HEAD")
$branch = Invoke-Git @("rev-parse","--abbrev-ref","HEAD")
$porcelain = Invoke-Git @("status","--porcelain")
$dirty = [bool]$porcelain

$acceptance = @()
foreach ($item in $Registry.items) {
  $ev = @(Get-Evidence $item.evidence)
  $failed = @($ev | Where-Object { -not $_.ok })
  $passed = ($failed.Count -eq 0)
  $acceptance += [pscustomobject]@{
    id = $item.id
    title = $item.title
    passed = $passed
    status = $(if ($passed) { "accepted" } else { "not_accepted" })
    evidence = $ev
    notes = @($item.notes)
    frontmatter_status_on_pass = $item.frontmatter_status_on_pass
    frontmatter_status_on_fail = $item.frontmatter_status_on_fail
  }
}

$watched = @(
  "static/propagation_app.js",
  "static/research_workbench.js",
  "static/propagation_engine.js",
  "static/data.js",
  "index.html",
  "package.json"
)
$fileMap = [ordered]@{}
foreach ($rel in $watched) {
  $full = Join-Path $CodeRoot $rel
  if (Test-Path -LiteralPath $full) { $fileMap[$rel] = Get-LineCount $full }
}

$generatedAt = (Get-Date).ToUniversalTime().ToString("o")
$liveObj = [ordered]@{
  version = "project-status-v1"
  generated_at = $generatedAt
  product = "financial-alert-system"
  source_of_truth = "acceptance_registry.json + live code probes"
  git = [ordered]@{
    commit = $commit
    short = $short
    branch = $branch
    dirty = $dirty
    remote = "https://github.com/d83636126-pixel/financial-alert-system.git"
  }
  paths = [ordered]@{ code_root = $CodeRoot; vault_root = $VaultRoot }
  files = $fileMap
  acceptance = $acceptance
  meta = [ordered]@{
    run_at = $generatedAt
    suite = "sync_vault_status.ps1"
    platform = "win32"
  }
}

$utf8 = New-Object System.Text.UTF8Encoding $true
$mirrorPath = Join-Path $VaultRoot $Registry.mirror_relpath
$json = ($liveObj | ConvertTo-Json -Depth 8)
[System.IO.File]::WriteAllText($mirrorPath, $json + "`n", $utf8)
[System.IO.File]::WriteAllText((Join-Path $SyncDir "last_sync_report.json"), $json + "`n", $utf8)

$MARK_BEGIN = "<!-- AUTO:STATUS:BEGIN -->"
$MARK_END = "<!-- AUTO:STATUS:END -->"

function New-AutoBlock($items) {
  $dirtyText = ""
  if ($dirty) { $dirtyText = " (dirty)" }
  $sb = New-Object System.Text.StringBuilder
  [void]$sb.AppendLine($MARK_BEGIN)
  [void]$sb.AppendLine("")
  [void]$sb.AppendLine("> [!important] AUTO STATUS (do not hand-edit this block)")
  [void]$sb.AppendLine("> generated_at: $generatedAt")
  [void]$sb.AppendLine("> code_root: ``$CodeRoot``")
  [void]$sb.AppendLine("> git: ``$short`` / ``$branch``$dirtyText")
  [void]$sb.AppendLine("> source: code probes + ``_sync/acceptance_registry.json``")
  [void]$sb.AppendLine("")
  [void]$sb.AppendLine("| item | status | evidence |")
  [void]$sb.AppendLine("|---|---|---|")
  foreach ($item in $items) {
    $badge = if ($item.passed) { "ACCEPTED" } else { "NOT_ACCEPTED" }
    $summaryParts = @()
    foreach ($e in $item.evidence) {
      $mark = if ($e.ok) { "OK" } else { "MISS" }
      $summaryParts += ("{0}:{1}" -f $mark, $e.path)
    }
    $summary = [string]::Join(" / ", $summaryParts)
    [void]$sb.AppendLine("| $($item.title) | $badge | $summary |")
  }
  [void]$sb.AppendLine("")
  $syncCmd = 'powershell -NoProfile -ExecutionPolicy Bypass -File "' + (Join-Path $SyncDir 'sync_vault_status.ps1') + '"'
  [void]$sb.AppendLine("sync:")
  [void]$sb.AppendLine('```bat')
  [void]$sb.AppendLine($syncCmd)
  [void]$sb.AppendLine('```')
  [void]$sb.AppendLine("")
  [void]$sb.AppendLine($MARK_END)
  return $sb.ToString().TrimEnd() + "`n"
}

function Update-AutoBlock([string]$md, [string]$block) {
  $b = $md.IndexOf($MARK_BEGIN)
  $e = $md.IndexOf($MARK_END)
  if ($b -ge 0 -and $e -gt $b) {
    $after = $md.Substring($e + $MARK_END.Length)
    if ($after.StartsWith("`r`n")) { $after = $after.Substring(2) }
    elseif ($after.StartsWith("`n")) { $after = $after.Substring(1) }
    return $md.Substring(0, $b) + $block + $after
  }
  if ($md.StartsWith("---")) {
    $close = $md.IndexOf("`n---", 3)
    if ($close -ge 0) {
      $insertAt = $close + 4
      $rest = $md.Substring($insertAt)
      if ($rest.StartsWith("`r`n")) { $rest = $rest.Substring(2) }
      elseif ($rest.StartsWith("`n")) { $rest = $rest.Substring(1) }
      return $md.Substring(0, $insertAt) + "`n`n" + $block + "`n" + $rest
    }
  }
  return $block + "`n`n" + $md
}

function Set-StatusField([string]$md, [string]$status) {
  if (-not $md.StartsWith("---")) { return $md }
  $close = $md.IndexOf("`n---", 3)
  if ($close -lt 0) { return $md }
  $fm = $md.Substring(0, $close + 4)
  $body = $md.Substring($close + 4)
  if ($fm -match '(?m)^status:\s*.+$') {
    $fm = [regex]::Replace($fm, '(?m)^status:\s*.+$', "status: $status")
  } else {
    $fm = $fm -replace "`n---\s*$", "`nstatus: $status`n---"
  }
  $today = (Get-Date).ToString("yyyy-MM-dd")
  if ($fm -match '(?m)^updated:\s*.+$') {
    $fm = [regex]::Replace($fm, '(?m)^updated:\s*.+$', "updated: $today")
  }
  return $fm + $body
}

$noteSet = New-Object 'System.Collections.Generic.HashSet[string]'
foreach ($item in $Registry.items) {
  foreach ($n in $item.notes) { [void]$noteSet.Add([string]$n) }
}

foreach ($noteRel in $noteSet) {
  $notePath = Join-Path $VaultRoot $noteRel
  if (-not (Test-Path -LiteralPath $notePath)) {
    Write-Warning "missing note: $noteRel"
    continue
  }
  $related = @($acceptance | Where-Object { $_.notes -contains $noteRel })
  $block = New-AutoBlock $related
  $md = [System.IO.File]::ReadAllText($notePath, [System.Text.Encoding]::UTF8)
  $md = Update-AutoBlock $md $block
  if ($related.Count -eq 1) {
    $one = $related[0]
    $st = if ($one.passed) { $one.frontmatter_status_on_pass } else { $one.frontmatter_status_on_fail }
    if (-not $st) { $st = if ($one.passed) { "done" } else { "acceptance_failed" } }
    $md = Set-StatusField $md $st
  }
  [System.IO.File]::WriteAllText($notePath, $md, $utf8)
  Write-Output "[ok] $noteRel"
}

Write-Output ""
Write-Output "code_root=$CodeRoot"
Write-Output "vault_root=$VaultRoot"
foreach ($a in $acceptance) {
  $label = if ($a.passed) { "ACCEPTED" } else { "NOT_ACCEPTED" }
  Write-Output ("- {0}: {1}" -f $a.id, $label)
}
Write-Output "SYNC DONE"
