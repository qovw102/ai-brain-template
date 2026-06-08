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

if (-not (Test-Path -LiteralPath $syncScript)) {
    throw "Sync script not found: $syncScript"
}

$time = [datetime]::ParseExact($DailyAt, "HH:mm", $null)
$action = New-ScheduledTaskAction `
    -Execute "powershell.exe" `
    -Argument "-NoProfile -ExecutionPolicy Bypass -File `"$syncScript`" -Mode Check -BrainPath `"$BrainPath`""
$trigger = New-ScheduledTaskTrigger -Daily -At $time
$triggers = @($trigger)
if (-not $NoLogonTrigger) {
    $triggers += New-ScheduledTaskTrigger -AtLogOn -User $env:USERNAME
}
$principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType Interactive -RunLevel Limited

Register-ScheduledTask `
    -TaskName "Check My AI Brain Updates" `
    -Description "Read-only check for AI brain GitHub updates. Runs daily and, by default, at user logon." `
    -Action $action `
    -Trigger $triggers `
    -Principal $principal `
    -Force | Out-Null

if ($NoLogonTrigger) {
    Write-Output "Daily sync check task installed for $DailyAt."
} else {
    Write-Output "Sync check task installed for $DailyAt and user logon."
}
