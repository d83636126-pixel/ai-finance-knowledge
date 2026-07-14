param(
    [string]$TaskName = 'FinancialAlert-Harness-Obsidian-Sync',
    [string]$CredentialTarget = 'FinancialAlertSystem/HarnessAutoSync'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'
$scriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
. (Join-Path $scriptRoot 'windows_credential.ps1')

Unregister-ScheduledTask -TaskName $TaskName -Confirm:$false -ErrorAction SilentlyContinue
Remove-HarnessStoredCredential -Target $CredentialTarget
Write-Host 'Scheduled sync task and stored Harness credential were removed.' -ForegroundColor Green

