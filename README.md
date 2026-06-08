# AI Brain Template

這是一個可 fork / use template 的 AI agent 共用大腦範本。它把 Codex、Antigravity 與其他 agent 會用到的 reusable skills、reference、全域規則範本與同步腳本放在同一個 Git repository。

## 你會得到什麼

- `skills/`：可重複使用的 agent 任務流程。
- `references/`：較長的政策、背景知識與操作說明。
- `scripts/`：Windows 安裝、同步與排程腳本。
- `templates/`：Codex / Antigravity 全域 rule 範本。
- `progress.example.md`：可複製成 `progress.md` 的狀態紀錄範例。

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

4. 建議將 `progress.example.md` 複製成 `progress.md`，用來記錄自己的變更、TODO 與 Git checkpoint。

## 日常同步

只檢查是否落後，不修改檔案：

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$BrainPath\scripts\Sync-MyAiBrain.ps1" -Mode Check
```

工作區乾淨時安全拉取最新版：

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$BrainPath\scripts\Sync-MyAiBrain.ps1" -Mode Pull
```

安裝 Windows 自動檢查排程：

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$BrainPath\scripts\Install-BrainSyncTask.ps1"
```

排程預設會在每天指定時間與 Windows 使用者登入時執行 `Check`。它只會 `fetch` 與記錄狀態，不會自動覆蓋本機變更。

Codex 與 Antigravity 的全域 rule 也會要求 agent 在新 session 開始時先執行 `Check`。如果遠端有更新，agent 應提醒使用者；只有在工作區乾淨且可 fast-forward 時才執行 `Pull`。

## GitHub CLI

GitHub CLI 可用來建立 repository、登入 GitHub 與推送 template：

```powershell
winget install --id GitHub.cli -e --source winget
gh auth login --hostname github.com --git-protocol https --web
gh auth status
```

## 安全原則

- 不要提交 PAT、API Key、密碼、私鑰或登入檔。
- 不要把個人、公司、客戶或專案敏感資訊放進公開 template。
- 先把 template fork 成自己的 private/public repo，再依個人需求修改。
- 修改前先同步；有未提交變更時不要直接 pull。
- 自動拉取使用 `git pull --ff-only`，避免產生難以理解的 merge commit。
