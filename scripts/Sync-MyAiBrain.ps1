param(
    [ValidateSet("Check", "Pull")]
    [string]$Mode = "Check",
    [string]$BrainPath
)

$ErrorActionPreference = "Stop"
$env:GIT_TERMINAL_PROMPT = "0"

if (-not $BrainPath) {
    $BrainPath = Split-Path -Parent $PSScriptRoot
}

$BrainPath = (Resolve-Path -LiteralPath $BrainPath).Path
$logPath = Join-Path $BrainPath ".sync-status.log"

if (-not (Test-Path -LiteralPath (Join-Path $BrainPath ".git"))) {
    throw "Git repository not found: $BrainPath"
}

function Write-SyncLog {
    param([string]$Message)

    "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') | $Message" |
        Tee-Object -FilePath $logPath -Append
}

Push-Location $BrainPath
try {
    $status = git status --porcelain
    git fetch --prune origin
    if ($LASTEXITCODE -ne 0) {
        Write-SyncLog "fetch failed | branch=unknown"
        throw "git fetch failed. Check the network and GitHub authentication."
    }

    $branch = git branch --show-current
    $upstream = git rev-parse --abbrev-ref --symbolic-full-name "@{upstream}" 2>$null
    if (-not $upstream) {
        throw "Branch $branch has no tracking remote."
    }

    $counts = (git rev-list --left-right --count "HEAD...$upstream").Trim() -split "\s+"
    $ahead = [int]$counts[0]
    $behind = [int]$counts[1]
    $state = "up-to-date"
    if ($ahead -gt 0 -and $behind -gt 0) { $state = "diverged" }
    elseif ($ahead -gt 0) { $state = "ahead by $ahead commit(s)" }
    elseif ($behind -gt 0) { $state = "behind by $behind commit(s)" }

    Write-SyncLog "$state | branch=$branch | dirty=$([bool]$status)"

    if ($Mode -eq "Pull") {
        if ($status) {
            Write-SyncLog "pull skipped | reason=dirty worktree | branch=$branch"
            throw "The worktree has uncommitted changes. Commit or resolve them before Pull."
        }
        if ($ahead -gt 0 -and $behind -gt 0) {
            Write-SyncLog "pull skipped | reason=diverged | branch=$branch"
            throw "Local and remote branches diverged. Manual review is required."
        }
        if ($behind -gt 0) {
            git pull --ff-only
            if ($LASTEXITCODE -ne 0) {
                Write-SyncLog "pull failed | reason=fast-forward error | branch=$branch"
                throw "Fast-forward Pull failed."
            }
            Write-SyncLog "pull complete | pulled=$behind commit(s) | branch=$branch"
            Write-Output "Sync complete. Pulled $behind commit(s)."
        } else {
            Write-SyncLog "pull not required | $state | branch=$branch"
            Write-Output "No pull required: $state."
        }
    } else {
        Write-Output "Sync check: $state."
    }
} finally {
    Pop-Location
}
