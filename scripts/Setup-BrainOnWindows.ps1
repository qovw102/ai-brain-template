param(
    [string]$BrainPath,
    [switch]$ReplaceExistingSkills
)

$ErrorActionPreference = "Stop"

if (-not $BrainPath) {
    $BrainPath = Split-Path -Parent $PSScriptRoot
}

$BrainPath = (Resolve-Path -LiteralPath $BrainPath).Path
$skillTarget = Join-Path $BrainPath "skills"

if (-not (Test-Path -LiteralPath $skillTarget)) {
    throw "Skill folder not found: $skillTarget. Clone your AI brain repository first."
}

$links = @(
    @{ Path = "$HOME\.agents\skills"; Type = "SymbolicLink" },
    @{ Path = "$HOME\.gemini\config\skills"; Type = "Junction" },
    @{ Path = "$HOME\.gemini\antigravity-cli\skills"; Type = "Junction" }
)

function Backup-OrRemoveExistingSkillPath {
    param(
        [string]$Path,
        [string]$ExpectedTarget
    )

    $item = Get-Item -LiteralPath $Path -Force
    $target = [string]$item.Target

    if ($item.LinkType -and $target -eq $ExpectedTarget) {
        Write-Output "Already linked: $Path -> $ExpectedTarget"
        return $false
    }

    Write-Warning "Existing skills path found: $Path"
    if ($item.LinkType) {
        Write-Warning "Current link target: $target"
    } else {
        Write-Warning "Current path is a regular folder, not a link. It will be renamed as a backup before creating the shared link."
    }

    $shouldReplace = $ReplaceExistingSkills
    if (-not $shouldReplace) {
        $answer = Read-Host "Replace this skills path with a link to $ExpectedTarget? Type YES to replace"
        $shouldReplace = ($answer -eq "YES")
    }

    if (-not $shouldReplace) {
        Write-Output "Skipped existing path: $Path"
        return $false
    }

    if ($item.LinkType) {
        Remove-Item -LiteralPath $Path -Force
        Write-Output "Removed existing link: $Path"
    } else {
        $backupPath = "$Path.backup-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
        Rename-Item -LiteralPath $Path -NewName (Split-Path -Leaf $backupPath)
        Write-Output "Backed up existing folder: $Path -> $backupPath"
    }

    return $true
}

foreach ($link in $links) {
    $parent = Split-Path $link.Path
    New-Item -ItemType Directory -Force -Path $parent | Out-Null

    if (Test-Path -LiteralPath $link.Path) {
        $removed = Backup-OrRemoveExistingSkillPath -Path $link.Path -ExpectedTarget $skillTarget
        if (-not $removed) {
            continue
        }
    }

    try {
        New-Item -ItemType $link.Type -Path $link.Path -Target $skillTarget | Out-Null
        Write-Output "Created: $($link.Path) -> $skillTarget"
    } catch {
        if ($link.Type -eq "SymbolicLink") {
            Write-Warning "SymbolicLink failed. Falling back to a Junction for this directory link."
            New-Item -ItemType Junction -Path $link.Path -Target $skillTarget | Out-Null
            Write-Output "Created Junction: $($link.Path) -> $skillTarget"
            continue
        }
        throw
    }
}

function Install-GlobalRule {
    param(
        [string]$TemplatePath,
        [string]$DestinationPath
    )

    $beginMarker = "<!-- my-ai-brain-global-policy:start -->"
    $endMarker = "<!-- my-ai-brain-global-policy:end -->"
    $legacyMarker = "<!-- my-ai-brain-global-policy -->"
    $parent = Split-Path $DestinationPath
    $template = (Get-Content -Raw -LiteralPath $TemplatePath).Replace("{{BRAIN_PATH}}", $BrainPath)
    New-Item -ItemType Directory -Force -Path $parent | Out-Null

    if (-not (Test-Path -LiteralPath $DestinationPath)) {
        Set-Content -LiteralPath $DestinationPath -Value $template -Encoding UTF8
        Write-Output "Installed global rule: $DestinationPath"
        return
    }

    $existing = Get-Content -Raw -LiteralPath $DestinationPath
    if ([string]::IsNullOrWhiteSpace($existing)) {
        Set-Content -LiteralPath $DestinationPath -Value $template -Encoding UTF8
        Write-Output "Installed global rule into empty file: $DestinationPath"
    } elseif ($existing -match [regex]::Escape($beginMarker) -and $existing -match [regex]::Escape($endMarker)) {
        $pattern = "(?s)" + [regex]::Escape($beginMarker) + ".*?" + [regex]::Escape($endMarker)
        $updated = [regex]::Replace($existing, $pattern, [System.Text.RegularExpressions.MatchEvaluator]{ param($m) $template })
        if ($updated -ne $existing) {
            Set-Content -LiteralPath $DestinationPath -Value $updated -Encoding UTF8
            Write-Output "Updated global rule: $DestinationPath"
        } else {
            Write-Output "Global rule already installed: $DestinationPath"
        }
    } elseif ($existing -notmatch [regex]::Escape($legacyMarker)) {
        Add-Content -LiteralPath $DestinationPath -Value "`r`n"
        Add-Content -LiteralPath $DestinationPath -Value $template
        Write-Output "Appended global rule: $DestinationPath"
    } else {
        Set-Content -LiteralPath $DestinationPath -Value $template -Encoding UTF8
        Write-Output "Replaced legacy global rule: $DestinationPath"
    }
}

Install-GlobalRule `
    -TemplatePath (Join-Path $BrainPath "templates\codex-AGENTS.md") `
    -DestinationPath "$HOME\.codex\AGENTS.md"
Install-GlobalRule `
    -TemplatePath (Join-Path $BrainPath "templates\antigravity-GEMINI.md") `
    -DestinationPath "$HOME\.gemini\GEMINI.md"

Write-Output "Setup complete. Fully restart Codex and Antigravity."
