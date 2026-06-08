---
name: brain-maintenance
description: 建立、更新與同步共用 AI 第二大腦。Create or update shared skills and references, sync the AI brain repository, validate structure, and commit/push changes when requirements or reusable agent knowledge change.
---

# AI 第二大腦維護

當使用者希望新增共用能力、保存跨專案經驗、修改 Skill / reference，或同步 AI brain repo 時使用。

## 執行流程

1. 先定位本機 AI brain repo 根目錄。優先使用此 Skill 所在路徑往上兩層的資料夾；若工具無法解析，改讀目前工作區或使用者提供的 clone 路徑。
2. 讀取：
   - `<BrainPath>\README.md`
   - `<BrainPath>\progress.md`
   - `<BrainPath>\references\brain-sync-policy.md`
3. 執行同步檢查：
   ```powershell
   powershell.exe -NoProfile -ExecutionPolicy Bypass -File <BrainPath>\scripts\Sync-MyAiBrain.ps1 -Mode Check
   ```
4. 若本機乾淨且遠端有更新，使用 `-Mode Pull` 以 fast-forward 方式同步。
5. 判斷內容位置：
   - 可重複執行的任務流程：建立或更新 `skills/<名稱>/SKILL.md`。
   - 長篇政策、說明、背景知識：建立或更新 `references/<名稱>.md`。
   - 可重複且需要精確執行的命令：放在 `scripts/`，並由 Skill 引用。
6. Skill 必須：
   - 位於獨立資料夾；
   - 檔名為 `SKILL.md`；
   - 包含 YAML frontmatter；
   - `description` 清楚說明用途與觸發時機。
7. 使用繁體中文撰寫主體；必要時在 `description` 保留英文技術關鍵字，增加不同模型的辨識穩定性。
8. 驗證檔案結構、frontmatter、腳本語法與 Git diff。
9. 更新 `<BrainPath>\progress.md` 的狀態與 TODO。
10. 只 stage 本次相關檔案，建立 commit 並 push 至 `origin/main`。
11. 回報變更檔案、commit SHA、push 結果與其他電腦是否需要 pull。

## 安全限制

- 不得提交 Token、API Key、密碼或登入設定。
- 有未提交變更時不得自動 pull。
- 不使用 `reset --hard`、force push 或自動解決衝突。
- 同步衝突時停止，列出衝突與建議處理方式。
