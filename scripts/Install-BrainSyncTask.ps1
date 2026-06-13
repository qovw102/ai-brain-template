param(
    [string]$BrainPath,
    [string]$DailyAt = "09:00",
    [switch]$NoLogonTrigger
)

$ErrorActionPreference = "Stop"

if (-not $BrainPath) {
    $BrainPath = Split-Path -Parent $PSScriptRoot
}

$BrainPath = (Resolve-Path -LiteralPath $BrainPath).Path
$syncScript = Join-Path $BrainPath "scripts\Sync-MyAiBrain.ps1"
$taskName = "Sync My AI Brain Updates"
$legacyTaskName = "Check My AI Brain Updates"

if (-not (Test-Path -LiteralPath $syncScript)) {
    throw "Sync script not found: $syncScript"
}

$time = [datetime]::ParseExact($DailyAt, "HH:mm", $null)
$action = New-ScheduledTaskAction `
    -Execute "powershell.exe" `
    -Argument "-NoProfile -NonInteractive -WindowStyle Hidden -ExecutionPolicy Bypass -File `"$syncScript`" -Mode Pull -BrainPath `"$BrainPath`""
$trigger = New-ScheduledTaskTrigger -Daily -At $time
$triggers = @($trigger)
if (-not $NoLogonTrigger) {
    $triggers += New-ScheduledTaskTrigger -AtLogOn -User "$env:USERDOMAIN\$env:USERNAME"
}
$principal = New-ScheduledTaskPrincipal -UserId "$env:USERDOMAIN\$env:USERNAME" -LogonType Interactive -RunLevel Limited
$settings = New-ScheduledTaskSettingsSet `
    -AllowStartIfOnBatteries `
    -DontStopIfGoingOnBatteries `
    -StartWhenAvailable `
    -RestartCount 3 `
    -RestartInterval (New-TimeSpan -Minutes 10) `
    -MultipleInstances IgnoreNew

if (Get-ScheduledTask -TaskName $legacyTaskName -ErrorAction SilentlyContinue) {
    Unregister-ScheduledTask -TaskName $legacyTaskName -Confirm:$false
    Write-Output "Removed legacy task: $legacyTaskName"
}

Register-ScheduledTask `
    -TaskName $taskName `
    -Description "Safely fast-forward the AI brain from GitHub. Runs daily, after a missed schedule, and at user logon." `
    -Action $action `
    -Trigger $triggers `
    -Principal $principal `
    -Settings $settings `
    -Force | Out-Null

if ($NoLogonTrigger) {
    Write-Output "Daily automatic sync task installed for $DailyAt."
} else {
    Write-Output "Automatic sync task installed for $DailyAt and user logon."
}
