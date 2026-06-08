# Agent 工作政策

## 適用範圍

這份政策適用於 Codex 與 Antigravity 的所有專案。

## 每次操作結束時的 checkpoint

每次使用者要求的操作若造成檔案或專案狀態變更：

1. 更新專案根目錄的 `progress.md`。
2. 記錄：
   - 已完成內容；
   - 重要決策；
   - 測試或驗證結果；
   - 阻礙與風險；
   - 剩餘工作的 Markdown TODO checklist。
3. 檢查 Git status 與 diff。
4. 只 stage 本次操作相關檔案。
5. 建立簡潔 commit。
6. 已設定 tracking remote 時自動 push。
7. 回報 commit SHA 與 push 結果。

純讀取、純問答或沒有專案變更時，不建立空 commit。

## 安全規則

- 不得將密碼、PAT、API Key、私鑰或認證檔寫入 `progress.md` 或 Git。
- 不覆蓋與本次任務無關的使用者變更。
- 未經明確要求，不 force push 或改寫共享歷史。
- push 失敗時保留本機 commit，並把失敗原因寫入 `progress.md`。
- 沒有 remote 時保留本機 commit，並將 remote 設定加入 TODO。

## 建議的 progress.md 結構

```markdown
# 專案進度

## 目前狀態

## 已完成

## 重要決策

## 驗證紀錄

## TODO

- [ ] 下一個工作

## Git Checkpoint

- Commit：
- Push：
```
