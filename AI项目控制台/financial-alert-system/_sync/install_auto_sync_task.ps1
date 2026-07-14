param(
    [string]$TaskName = 'FinancialAlert-Harness-Obsidian-Sync',
    [string]$CredentialTarget = 'FinancialAlertSystem/HarnessAutoSync'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
. (Join-Path $scriptRoot 'windows_credential.ps1')
$syncScript = Join-Path $scriptRoot 'auto_sync_harness_obsidian.ps1'

if (-not (Test-Path -LiteralPath $syncScript)) { throw "Sync script not found: $syncScript" }

Write-Host 'Harness 长期凭据只会保存到当前 Windows 用户的凭据管理器。' -ForegroundColor Cyan
$username = Read-Host 'Harness User ID'
$token = Read-Host 'Harness long-term token' -AsSecureString
Set-HarnessStoredCredential -Target $CredentialTarget -Username $username -Token $token

$stored = Get-HarnessStoredCredential -Target $CredentialTarget
try {
    $headers = @{ Authorization = "Bearer $($stored.Token)" }
    $user = Invoke-RestMethod -Method Get -Uri 'http://127.0.0.1:3000/api/v1/user' -Headers $headers -TimeoutSec 8
    Write-Host "Harness token validated for: $($user.uid)" -ForegroundColor Green
}
catch {
    Remove-HarnessStoredCredential -Target $CredentialTarget
    throw 'Harness token validation failed; the credential was removed.'
}
finally {
    if ($stored) { $stored.Token = $null; $stored = $null }
}

$pwsh = (Get-Command pwsh.exe -ErrorAction Stop).Source
$arguments = "-NoLogo -NoProfile -NonInteractive -ExecutionPolicy Bypass -File `"$syncScript`""
$action = New-ScheduledTaskAction -Execute $pwsh -Argument $arguments
$trigger = New-ScheduledTaskTrigger -Once -At (Get-Date).AddMinutes(1) -RepetitionInterval (New-TimeSpan -Minutes 10) -RepetitionDuration (New-TimeSpan -Days 3650)
$principal = New-ScheduledTaskPrincipal -UserId ([Security.Principal.WindowsIdentity]::GetCurrent().Name) -LogonType Interactive -RunLevel Limited
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -MultipleInstances IgnoreNew -ExecutionTimeLimit (New-TimeSpan -Minutes 8)

Register-ScheduledTask -TaskName $TaskName -Action $action -Trigger $trigger -Principal $principal -Settings $settings -Description 'Every 10 minutes: committed code to GitHub/Harness; changed acceptance status to local Obsidian. No auto-commit and no Obsidian publish.' -Force | Out-Null
Start-ScheduledTask -TaskName $TaskName

Write-Host "Scheduled task installed: $TaskName" -ForegroundColor Green
Write-Host 'Runs every 10 minutes while this Windows user is signed in.'
Write-Host 'The first run has been started.'

