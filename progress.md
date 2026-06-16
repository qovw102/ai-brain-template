# AI Brain Template 進度

## 目前狀態

- Repository：由使用者透過此 template 建立的 AI brain Git repository。
- Windows 排程預設執行安全 fast-forward Pull。

## 已完成

- [x] 將排程由唯讀 Check 改為安全 Pull。
- [x] 加入每日、錯過排程補跑、使用者登入與電池模式支援。
- [x] 加入失敗後每 10 分鐘重試、最多 3 次。
- [x] 將同步結果、跳過原因與失敗狀態寫入 `.sync-status.log`。
- [x] 更新 Codex / Antigravity 全域規則，讓新 session 優先安全同步。
- [x] 移除不再使用的 `progress.example.md`，由 `progress.md` 直接作為狀態、TODO 與 Git checkpoint 紀錄。
- [x] 預設提供 `auto-logging`、`brain-maintenance`、`git-project-sync`、`context-handoff` 四個核心 Skills。
- [x] 將 Skill 長度與 reference 拆分門檻加入 `brain-maintenance`。
- [x] 新增 `context-handoff`，並釐清其與 `progress.md` / TODO 的分工。

## 重要決策

- 自動更新只允許 `git pull --ff-only`。
- 工作區 dirty 或分支 diverged 時停止，不覆蓋本機內容。
- 排程重新安裝時會移除舊的 Check 工作，改用 `Sync My AI Brain Updates`，避免名稱誤導或留下重複工作。
- 背景同步以非互動、隱藏視窗方式執行；Git 認證或網路失敗會留下紀錄並由排程重試。
- Template 直接提供並維護 `progress.md`，不再要求使用者從範例檔複製建立。
- 核心 Skill 組合涵蓋工作紀錄、AI brain 維護與一般 Git 專案同步。
- `progress.md` / TODO 用於長期記錄已落地的 repo 狀態；`context-handoff` 用於讓下一個對話或 agent 接手，不取代專案紀錄。

## 驗證紀錄

- 私人 repo 與 template 的三支 PowerShell 腳本皆通過語法解析。
- 隔離 Git 測試通過：遠端落後 1 commit 時自動 fast-forward；工作樹 dirty 時拒絕 Pull 並寫入 `pull skipped`。
- 排程註冊成功，action 使用 `-Mode Pull`，並確認 `StartWhenAvailable=True`、登入觸發、電池模式及每 10 分鐘重試 3 次。
- 私人 repo 與 template 的 `Sync-MyAiBrain.ps1` SHA-256 完全一致。
- 舊 `Check My AI Brain Updates` 排程可由新版安裝腳本自動移除，並建立名稱與行為一致的 `Sync My AI Brain Updates`。
- 實機手動觸發新排程成功：`LastTaskResult=0`，同步 log 顯示 repository 已是最新。
- 已確認 repository 中除 README 外沒有其他 `progress.example.md` 依賴；移除後所有規則仍直接指向 `progress.md`。
- 三個核心 Skill 均包含有效 frontmatter；`brain-maintenance` 已包含 5,000 words / 500 行上限警戒與 references 分流規則。
- `README.md` 與 `skills/context-handoff/SKILL.md` 已補充 `progress.md` / TODO 與交接摘要的使用情境分工。

## TODO

- [x] 完成同步腳本與排程驗證。

## Git Checkpoint

- 功能 Commit：`883a439`（`feat: automate safe brain updates`）。
- Checkpoint Commit：本次提交（`docs: record automatic sync checkpoint`）。
- Progress 文件簡化：本次提交（`docs: use progress file directly`）。
- 核心 Skills 與長度規則：本次提交（`feat: standardize core brain skills`）。
- Context handoff 分工說明：本次提交（`docs: clarify handoff and progress roles`）。
- Push：成功推送至 `origin/main`。
