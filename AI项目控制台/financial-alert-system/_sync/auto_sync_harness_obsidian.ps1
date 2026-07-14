param(
    [string]$CodeRoot = 'F:\financial-alert-system',
    [string]$VaultRoot = 'F:\AI 金融知识点',
    [string]$HarnessBaseUrl = 'http://127.0.0.1:3000',
    [string]$HarnessRepoRef = 'financial-alert-system/financial-alert-system',
    [string]$HarnessPipeline = 'research-quality',
    [string]$CredentialTarget = 'FinancialAlertSystem/HarnessAutoSync'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
. (Join-Path $scriptRoot 'windows_credential.ps1')

$runtimeRoot = Join-Path $env:LOCALAPPDATA 'FinancialAlertSync'
$logPath = Join-Path $runtimeRoot 'auto_sync.log'
$statePath = Join-Path $runtimeRoot 'auto_sync_state.json'
$vaultSyncScript = Join-Path $VaultRoot 'AI项目控制台\financial-alert-system\_sync\sync_vault_status.ps1'

New-Item -ItemType Directory -Path $runtimeRoot -Force | Out-Null
if ((Test-Path $logPath) -and (Get-Item $logPath).Length -gt 1MB) {
    Move-Item -LiteralPath $logPath -Destination "$logPath.1" -Force
}

function Write-SyncLog {
    param([string]$Level, [string]$Message)
    $safe = $Message -replace '[\r\n]+', ' '
    Add-Content -LiteralPath $logPath -Encoding utf8 -Value "$(Get-Date -Format o) [$Level] $safe"
}

function Invoke-Git {
    param(
        [Parameter(Mandatory)][string[]]$Arguments,
        [switch]$HarnessAuth,
        [switch]$AllowFailure
    )

    $start = [Diagnostics.ProcessStartInfo]::new()
    $start.FileName = 'git.exe'
    $start.WorkingDirectory = $CodeRoot
    $start.UseShellExecute = $false
    $start.RedirectStandardOutput = $true
    $start.RedirectStandardError = $true
    $start.CreateNoWindow = $true
    foreach ($argument in $Arguments) { $null = $start.ArgumentList.Add($argument) }

    if ($HarnessAuth) {
        $pair = '{0}:{1}' -f $credential.Username, $credential.Token
        $basic = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($pair))
        $start.Environment['GIT_CONFIG_COUNT'] = '1'
        $start.Environment['GIT_CONFIG_KEY_0'] = 'http.extraHeader'
        $start.Environment['GIT_CONFIG_VALUE_0'] = "Authorization: Basic $basic"
        $pair = $null
        $basic = $null
    }

    $process = [Diagnostics.Process]::new()
    $process.StartInfo = $start
    $null = $process.Start()
    $stdout = $process.StandardOutput.ReadToEnd().Trim()
    $stderr = $process.StandardError.ReadToEnd().Trim()
    $process.WaitForExit()
    if ($process.ExitCode -ne 0 -and -not $AllowFailure) {
        throw "git $($Arguments[0]) failed ($($process.ExitCode)): $stderr"
    }
    [pscustomobject]@{ ExitCode = $process.ExitCode; StdOut = $stdout; StdErr = $stderr }
}

function Get-GitValue([string[]]$Arguments) {
    (Invoke-Git -Arguments $Arguments).StdOut
}

function Test-Ancestor([string]$Older, [string]$Newer) {
    (Invoke-Git -Arguments @('merge-base', '--is-ancestor', $Older, $Newer) -AllowFailure).ExitCode -eq 0
}

function Get-ArtifactFingerprint {
    $relativeFiles = @(
        'project_status.json',
        'artifacts\last_check.json',
        'artifacts\last_smoke.json',
        'artifacts\last_acceptance.json',
        'artifacts\micro_s3_acceptance.json',
        'artifacts\research_quality_gate.json'
    )
    $parts = foreach ($relative in $relativeFiles) {
        $file = Join-Path $CodeRoot $relative
        if (Test-Path -LiteralPath $file) {
            "$relative=$((Get-FileHash -LiteralPath $file -Algorithm SHA256).Hash)"
        } else {
            "$relative=missing"
        }
    }
    $bytes = [Text.Encoding]::UTF8.GetBytes(($parts -join "`n"))
    $sha = [Security.Cryptography.SHA256]::Create()
    try { ([BitConverter]::ToString($sha.ComputeHash($bytes))).Replace('-', '') }
    finally { $sha.Dispose() }
}

$mutex = [Threading.Mutex]::new($false, 'Local\FinancialAlertHarnessObsidianSync')
if (-not $mutex.WaitOne(0)) {
    Write-SyncLog 'INFO' 'Skipped because another sync instance is running.'
    exit 0
}

$credential = $null
try {
    Write-SyncLog 'INFO' 'Sync started.'
    if (-not (Test-Path -LiteralPath $CodeRoot)) { throw "Code root not found: $CodeRoot" }
    if (-not (Test-Path -LiteralPath $VaultRoot)) { throw "Vault root not found: $VaultRoot" }

    $credential = Get-HarnessStoredCredential -Target $CredentialTarget
    if ([string]::IsNullOrWhiteSpace($credential.Token)) { throw 'Stored Harness token is empty.' }

    $headers = @{ Authorization = "Bearer $($credential.Token)" }
    $null = Invoke-RestMethod -Method Get -Uri "$HarnessBaseUrl/api/v1/user" -Headers $headers -TimeoutSec 8

    Invoke-Git -Arguments @('fetch', 'origin', 'master', '--quiet') | Out-Null
    $localCommit = Get-GitValue @('rev-parse', 'HEAD')
    $githubCommit = Get-GitValue @('rev-parse', 'origin/master')

    if ($localCommit -ne $githubCommit) {
        if (Test-Ancestor $githubCommit $localCommit) {
            Invoke-Git -Arguments @('push', 'origin', 'HEAD:master', '--quiet') | Out-Null
            $githubCommit = $localCommit
            Write-SyncLog 'INFO' "Pushed committed baseline to GitHub: $localCommit"
        } else {
            throw 'GitHub master is ahead or diverged; automatic merge is disabled.'
        }
    }

    $harnessRemote = Invoke-Git -Arguments @('remote', 'get-url', 'harness') -AllowFailure
    if ($harnessRemote.ExitCode -ne 0) {
        Invoke-Git -Arguments @('remote', 'add', 'harness', "$HarnessBaseUrl/git/$HarnessRepoRef.git") | Out-Null
    }

    $harnessFetch = Invoke-Git -Arguments @('fetch', 'harness', 'master:refs/remotes/harness/master', '--force', '--quiet') -HarnessAuth -AllowFailure
    if ($harnessFetch.ExitCode -ne 0) { throw "Harness fetch failed: $($harnessFetch.StdErr)" }
    $harnessCommit = Get-GitValue @('rev-parse', 'refs/remotes/harness/master')
    $harnessChanged = $false
    if ($harnessCommit -ne $localCommit) {
        if (Test-Ancestor $harnessCommit $localCommit) {
            Invoke-Git -Arguments @('push', 'harness', 'HEAD:master', '--quiet') -HarnessAuth | Out-Null
            $harnessCommit = $localCommit
            $harnessChanged = $true
            Write-SyncLog 'INFO' "Pushed committed baseline to Harness: $localCommit"
        } else {
            throw 'Harness master is ahead or diverged; force push is disabled.'
        }
    }

    $repoEscaped = [Uri]::EscapeDataString($HarnessRepoRef)
    $pipelineUri = "$HarnessBaseUrl/api/v1/repos/$repoEscaped/pipelines/$HarnessPipeline"
    $pipeline = Invoke-RestMethod -Method Get -Uri $pipelineUri -Headers $headers -TimeoutSec 8

    $runnerAvailable = $false
    try {
        $binds = & docker inspect harness --format '{{json .HostConfig.Binds}}' 2>$null
        $runnerAvailable = ($LASTEXITCODE -eq 0 -and $binds -match 'docker\.sock')
    } catch { $runnerAvailable = $false }

    $previous = $null
    if (Test-Path -LiteralPath $statePath) {
        try { $previous = Get-Content -LiteralPath $statePath -Raw | ConvertFrom-Json } catch { $previous = $null }
    }

    $triggered = $false
    $execution = $null
    if ($runnerAvailable -and ($harnessChanged -or $null -eq $previous -or $previous.last_triggered_commit -ne $localCommit)) {
        $executionUri = "$pipelineUri/executions?branch=master"
        $execution = Invoke-RestMethod -Method Post -Uri $executionUri -Headers $headers -TimeoutSec 15
        $triggered = $true
        Write-SyncLog 'INFO' "Triggered Harness pipeline for commit: $localCommit"
    } elseif (-not $runnerAvailable) {
        Write-SyncLog 'WARN' 'Harness repository synchronized, but pipeline trigger skipped because no isolated runner is available.'
    }

    $artifactFingerprint = Get-ArtifactFingerprint
    $pipelineStatusProperty = $pipeline.PSObject.Properties['status']
    $pipelineStatus = if ($pipelineStatusProperty -and $pipelineStatusProperty.Value) { [string]$pipelineStatusProperty.Value } else { 'registered' }
    $material = [ordered]@{
        local_commit = $localCommit
        github_commit = $githubCommit
        harness_commit = $harnessCommit
        pipeline_identifier = $HarnessPipeline
        pipeline_status = $pipelineStatus
        runner_available = $runnerAvailable
        artifact_fingerprint = $artifactFingerprint
    }
    $materialJson = $material | ConvertTo-Json -Compress
    $materialBytes = [Text.Encoding]::UTF8.GetBytes($materialJson)
    $materialSha = [Security.Cryptography.SHA256]::Create()
    try { $materialFingerprint = ([BitConverter]::ToString($materialSha.ComputeHash($materialBytes))).Replace('-', '') }
    finally { $materialSha.Dispose() }

    $state = [ordered]@{
        schema_version = 1
        checked_at = (Get-Date).ToString('o')
        status = 'ok'
        material_fingerprint = $materialFingerprint
        local_commit = $localCommit
        github_commit = $githubCommit
        harness_commit = $harnessCommit
        runner_available = $runnerAvailable
        pipeline_identifier = $HarnessPipeline
        last_triggered_commit = if ($triggered) { $localCommit } elseif ($previous) { $previous.last_triggered_commit } else { $null }
        last_execution_number = if ($execution -and $execution.number) { $execution.number } elseif ($previous) { $previous.last_execution_number } else { $null }
        artifact_fingerprint = $artifactFingerprint
    }

    $materialChanged = ($null -eq $previous -or $previous.material_fingerprint -ne $materialFingerprint)
    $state | ConvertTo-Json -Depth 6 | Set-Content -LiteralPath $statePath -Encoding utf8

    if ($materialChanged) {
        if (-not (Test-Path -LiteralPath $vaultSyncScript)) { throw "Vault sync script not found: $vaultSyncScript" }
        & $vaultSyncScript -CodeRoot $CodeRoot -VaultRoot $VaultRoot | Out-Null
        if ($LASTEXITCODE -notin @($null, 0)) { throw "Vault sync script exited with code $LASTEXITCODE" }
        Write-SyncLog 'INFO' 'Material state changed; Obsidian project status was refreshed.'
    }

    Write-SyncLog 'INFO' "Sync completed. commit=$localCommit runner=$runnerAvailable vault_refresh=$materialChanged"
}
catch {
    Write-SyncLog 'ERROR' $_.Exception.Message
    exit 1
}
finally {
    if ($credential) { $credential.Token = $null; $credential = $null }
    $mutex.ReleaseMutex()
    $mutex.Dispose()
}
