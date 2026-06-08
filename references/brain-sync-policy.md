# AI Brain Cross-Device Sync Policy

## 核心原則

GitHub repository 是交換中心。每台電腦各有一份本機 clone，Codex 與 Antigravity 只讀取該電腦的本機資料夾，不直接從 GitHub 即時讀取 Skill。

## 開始工作前

1. 執行 `Sync-MyAiBrain.ps1 -Mode Check`。
2. 若顯示落後且本機工作區乾淨，執行 `-Mode Pull`。
3. 若有本機未提交變更，先檢查、commit 或處理後再 pull。

Codex 與 Antigravity 的全域 rule 會要求 Agent 在新 session 開始時先執行 Check。這是開工前的安全提醒，避免使用舊版 Skill。

## 完成大腦更新後

1. 驗證 Skill / reference / script。
2. 更新 `progress.md` 與 TODO。
3. commit 並 push 至自己的 remote。
4. 其他電腦在下次使用前執行 Pull。

## 三個同步腳本何時使用

- `Setup-BrainOnWindows.ps1`：每台電腦初次安裝或要重建 Codex/Antigravity skills 連結時執行。
- `Sync-MyAiBrain.ps1`：日常同步主腳本。`-Mode Check` 只檢查遠端狀態並寫入 `.sync-status.log`；`-Mode Pull` 只在工作區乾淨且可 fast-forward 時拉取更新。
- `Install-BrainSyncTask.ps1`：每台電腦安裝一次即可。它會建立 Windows Task Scheduler 工作，預設每天固定時間與使用者登入時執行 `Sync-MyAiBrain.ps1 -Mode Check`。

## 定期檢查

Windows Task Scheduler 執行 Check 模式：

- 只執行 `git fetch` 和比較 commit。
- 不自動 pull，不改工作檔。
- 結果寫入 `.sync-status.log`。
- 預設每日執行一次，並在使用者登入 Windows 時執行一次。

## 衝突處理

- Pull 僅允許 `--ff-only`。
- 若兩台電腦都修改同一內容，停止自動同步。
- 先 commit 各自變更，再由 Agent 或人類檢查差異並合併。
- 不使用 `reset --hard` 或 force push 逃避衝突。

## 路徑原則

- 不假設電腦一定有 D 槽。
- 文件中的 `<BrainPath>` 代表實際 clone 位置。
- PowerShell 腳本若未指定 `-BrainPath`，會自動使用腳本所在位置往上一層的 repo 根目錄。
- 若從排程、捷徑或其他工具呼叫腳本，建議明確帶入 `-BrainPath "<實際路徑>"`。
