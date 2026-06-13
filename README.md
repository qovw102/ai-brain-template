# AI Brain Template

這是一個 AI agent 共用大腦範本。它把 Codex、Antigravity 與其他 agent 會用到的 reusable skills、reference、全域規則範本與同步腳本放在同一個 Git repository。

## 你會得到什麼

- `skills/`：可重複使用的 agent 任務流程。
- `references/`：較長的政策、背景知識與操作說明。
- `scripts/`：Windows 安裝、同步與排程腳本。
- `templates/`：Codex / Antigravity 全域 rule 範本。
- `progress.md`：記錄目前狀態、已完成事項、重要決策、驗證結果、TODO 與 Git checkpoint。

預設內建三個核心 Skills：

- `auto-logging`：維護專案進度、TODO、commit 與 push checkpoint。
- `brain-maintenance`：建立、更新、驗證與同步共用 AI brain。
- `git-project-sync`：檢查任意 Git 專案的本機與遠端差異，安全 pull 或分析 merge。

## 建立自己的 AI brain

1. 在 GitHub 使用此 template 建立你自己的 repository。
2. 將 repository clone 到每台電腦固定存在的位置，例如：

```powershell
$BrainPath = "C:\my_ai_brain"
git clone https://github.com/<your-user>/<your-ai-brain-repo>.git $BrainPath
```

3. 安裝 Codex / Antigravity skills 連結與全域 rule：

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$BrainPath\scripts\Setup-BrainOnWindows.ps1" -BrainPath $BrainPath
```

若該電腦已有 skills 資料夾或連結，腳本會先詢問是否取代。輸入 `YES` 才會處理；一般資料夾會先備份再建立連結。自動化安裝可加上 `-ReplaceExistingSkills`。

## 日常同步

只檢查是否落後，不修改檔案：

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$BrainPath\scripts\Sync-MyAiBrain.ps1" -Mode Check
```

工作區乾淨時安全拉取最新版：

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$BrainPath\scripts\Sync-MyAiBrain.ps1" -Mode Pull
```

安裝 Windows 自動同步排程：

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$BrainPath\scripts\Install-BrainSyncTask.ps1"
```

排程預設會在每天指定時間與 Windows 使用者登入時執行安全 `Pull`。它只在工作區乾淨、歷史未分歧且可 fast-forward 時自動更新；有未提交變更或衝突風險時會停止並寫入 `.sync-status.log`，不會覆蓋本機內容。

若電腦在原訂時間關機，`StartWhenAvailable` 會在之後補跑；預設登入觸發也會在下一次開機並登入時立即同步。若網路暫時不可用，排程每 10 分鐘重試，最多 3 次。

Codex 與 Antigravity 的全域 rule 也會要求 agent 在新 session 開始時執行安全 `Pull`。若腳本因本機變更或分歧而停止，agent 應提醒使用者處理。

## 安全原則

- 不要提交 PAT、API Key、密碼、私鑰或登入檔。
- 修改前先同步；有未提交變更時不要直接 pull。
- 自動拉取使用 `git pull --ff-only`，避免產生難以理解的 merge commit。
