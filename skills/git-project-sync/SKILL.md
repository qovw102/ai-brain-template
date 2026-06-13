---
name: git-project-sync
description: 檢查並同步任意 Git 專案的本機與遠端狀態。Use when asked to check whether a project is up to date, fetch remote changes, safely git pull, compare local and remote branches, resolve ahead/behind/diverged states, or merge remote updates without repeatedly explaining the Git workflow.
---

# Git 專案同步

當使用者希望快速確認目前專案與 remote 是否同步，並在安全範圍內完成 fetch、pull 或 merge 時使用。

## 觸發情境

應使用本 Skill：

- 「檢查本機跟 remote 有沒有同步」
- 「幫我更新到 GitHub 最新版本」
- 「同步目前專案」
- 「檢查 ahead / behind 並 pull」
- 「遠端和本機分歧了，幫我判斷怎麼 merge」

不應使用本 Skill：

- 使用者只想查看單一 commit、diff 或 Git log。
- 使用者要求發布、建立 PR、rebase 整理歷史或 force push。
- 目前資料夾不是 Git repository，且使用者也沒有指定 repository。

## 執行流程

1. 定位 repository 根目錄：
   ```powershell
   git rev-parse --show-toplevel
   ```
2. 在修改 Git 狀態前讀取：
   ```powershell
   git status --short --branch
   git remote -v
   git branch -vv
   ```
3. 執行：
   ```powershell
   git fetch --prune
   ```
4. 取得目前分支、upstream 與 ahead / behind：
   ```powershell
   git branch --show-current
   git rev-parse --abbrev-ref --symbolic-full-name "@{upstream}"
   git rev-list --left-right --count "HEAD...@{upstream}"
   ```
5. 依狀態處理：
   - `0 / 0`：回報已同步，不建立空 commit。
   - `0 / behind`：工作樹乾淨時執行 `git pull --ff-only`。
   - `ahead / 0`：回報本機領先；除非使用者要求或專案政策要求，不自動 push。
   - `ahead / behind`：視為 diverged，先檢查雙方 commit 與檔案差異，不直接 pull。
   - 沒有 upstream：回報缺少 tracking branch，列出可設定的 remote branch。

## 分歧與 Merge

遇到 diverged 時先執行：

```powershell
git log --oneline --left-right --graph "HEAD...@{upstream}"
git diff --stat "HEAD...@{upstream}"
```

接著遵守：

- 工作樹不乾淨時停止，不自動 stash、commit 或丟棄變更。
- 若使用者只要求「檢查或更新」，先說明分歧與建議，不擅自建立 merge commit。
- 若使用者已明確要求「同步並 merge」，且工作樹乾淨，可執行：
  ```powershell
  git merge "@{upstream}"
  ```
- 發生 conflict 時停止，列出衝突檔案與雙方修改脈絡；不得自動選擇 ours/theirs 覆蓋內容。
- merge 完成後檢查 status、diff、log，並執行與變更範圍相稱的測試。
- 不使用 `git reset --hard`、`git clean -fd`、force push 或改寫共享歷史，除非使用者明確要求且已說明風險。

## 工作樹與使用者變更

- 不覆蓋、還原或提交與同步任務無關的使用者變更。
- 若工作樹 dirty，先列出變更；安全 pull 無法進行時，清楚說明需要 commit、stash 或人工處理。
- 未經使用者明確同意，不自動 stash。
- 若 repository 有自己的 `AGENTS.md`、同步腳本或 Git 政策，優先遵守專案規則。

## 完成驗證

同步或 merge 後確認：

```powershell
git status --short --branch
git rev-list --left-right --count "HEAD...@{upstream}"
git log -1 --oneline --decorate
```

回報：

- 原始 ahead / behind 狀態。
- 執行了 fetch、pull 或 merge 中的哪一項。
- 最終是否與 upstream 同步。
- 是否有未提交變更、衝突、測試失敗或需要 push 的本機 commits。

## 測試 Prompt

- 正常案例：幫我檢查目前專案跟 GitHub 是否同步，落後的話安全更新到最新。
- 間接說法：我換了一台電腦，先確認這個 repo 有沒有漏掉遠端更新並幫我處理。
- 分歧案例：本機和 remote 都有 commit，請檢查差異並幫我 merge；不要丟掉任何一邊的修改。
- 邊界案例：只列出最近 10 筆 Git log，不要同步。這種情況不應觸發本 Skill。
