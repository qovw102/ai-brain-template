---
name: brain-maintenance
description: 建立、更新、測試與同步共用 AI 第二大腦。Use when creating or revising shared skills, defining skill triggers and descriptions, organizing references/scripts, validating reusable agent workflows, or syncing and committing AI brain changes.
---

# AI 第二大腦維護

當使用者希望新增共用能力、保存跨專案經驗、修改 Skill / reference，或同步 AI brain repo 時使用。

## 執行流程

1. 先定位本機 AI brain repo 根目錄。優先使用此 Skill 所在路徑往上兩層的資料夾；若工具無法解析，改讀目前工作區或使用者提供的 clone 路徑。
2. 讀取：
   - `<BrainPath>\README.md`
   - `<BrainPath>\progress.md`
   - `<BrainPath>\references\brain-sync-policy.md`
3. 執行安全同步：
   ```powershell
   powershell.exe -NoProfile -ExecutionPolicy Bypass -File <BrainPath>\scripts\Sync-MyAiBrain.ps1 -Mode Pull
   ```
4. 若腳本因本機未提交變更或分支分歧而停止，先處理或清楚回報，不強制覆蓋。
5. 判斷內容位置：
   - 可重複執行的任務流程：建立或更新 `skills/<名稱>/SKILL.md`。
   - 長篇政策、說明、背景知識：建立或更新 `references/<名稱>.md`。
   - 可重複且需要精確執行的命令：放在 `scripts/`，並由 Skill 引用。
6. Skill 必須：
   - 位於獨立資料夾；
   - 檔名為 `SKILL.md`；
   - 包含 YAML frontmatter；
   - `description` 清楚說明用途與觸發時機。
7. 建立或大幅修改 Skill 前，先定義：
   - 使用者會在什麼情境下需要它；
   - 哪些具體說法應觸發它；
   - 哪些相似情境不應觸發它。
8. 撰寫 `description` 時，同時包含 Skill 的功能與明確觸發情境；避免只寫抽象功能名稱，降低 under-trigger。
9. 語言與可維護性：
   - `SKILL.md` 主體、`references/` 主體、README 與 progress 紀錄預設使用繁體中文；
   - 必要時只在 frontmatter `description`、命令、API 名稱、錯誤訊息或技術關鍵字保留英文；
   - 若為特定工具相容性必須使用英文，需在 progress 或回報中說明原因。
10. 依內容特性分流：
   - 核心、必要且簡短的執行流程留在 `SKILL.md`；
   - 大型背景知識、政策、規格與範例拆到 `references/`，由 `SKILL.md` 說明何時讀取；
   - 重複性高、需要精確或穩定執行的操作放進 `scripts/`，並實際執行驗證。
11. 控制 Skill 長度與 progressive disclosure：
   - `SKILL.md` 理想約 1,000 至 3,000 字元、30 至 120 行；
   - 3,000 至 8,000 字元仍可接受，但需刪除模型已具備的通用說明與重複範例；
   - 超過約 8,000 至 10,000 字元、接近 300 行，或包含大量選項與領域知識時，應開始拆到 `references/`；
   - 不得超過約 5,000 words 或 500 行；接近上限前必須拆分；
   - API 文件、schema、長篇政策、疑難排解表、超過 3 至 5 個完整範例，以及僅部分任務會使用的進階內容放進 `references/`；
   - 超過 100 行的 reference 在頂部加入目錄，並由 `SKILL.md` 直接說明何時讀取；避免 references 彼此深層連結；
   - 同一內容只存在於 `SKILL.md` 或 reference 其中一處，避免重複與版本漂移。
12. 對複雜或高影響 Skill 設計 2 至 3 個測試 prompt，至少涵蓋：
   - 應正確觸發並完成工作的正常案例；
   - 容易漏觸發的同義或間接說法；
   - 必要時加入不應觸發的邊界案例。
13. 驗證檔案結構、frontmatter、觸發描述、測試 prompt、腳本語法與 Git diff。簡單修改可省略測試 prompt，但需說明風險低的原因。
14. 更新 `<BrainPath>\progress.md` 的狀態與 TODO。
15. 只 stage 本次相關檔案，建立 commit 並 push 至 `origin/main`。
16. 回報變更檔案、驗證結果、commit SHA、push 結果與其他電腦是否需要 pull。

## 安全限制

- 不得提交 Token、API Key、密碼或登入設定。
- 有未提交變更時不得自動 pull。
- 不使用 `reset --hard`、force push 或自動解決衝突。
- 同步衝突時停止，列出衝突與建議處理方式。
