---
name: auto-logging
description: 維護 progress.md、TODO 與 Git checkpoint。Maintain progress, TODO, commit and push after project-changing actions; use after completing work, before handoff, or when asked to record progress.
---

# 自動工作紀錄

執行前先定位本機 AI brain repo 根目錄，並讀取 `<BrainPath>\references\agent-work-policy.md`。若目前工作區就是專案根目錄，直接使用目前工作區。

1. 若專案已有 `progress.md`，先讀取既有內容。
2. 若本次操作會改變檔案或專案狀態，但尚無 `progress.md`，建立該檔案。
3. 記錄已完成內容、重要決策、驗證結果、阻礙與明確下一步。
4. 維護 Markdown TODO checklist，標示已完成與待處理項目。
5. 不得記錄密碼、Token、私鑰或敏感個資。
6. 若檔案有變更且專案是 Git repository：
   - 檢查 diff，不包含無關變更；
   - 只 stage 本次工作相關檔案；
   - 建立簡潔 commit；
   - 已有 tracking remote 且驗證成功時執行 push。
7. 純讀取、純問答或沒有任何變更時，不建立空 commit。
8. 回報 progress 更新、commit SHA、push 結果與剩餘 TODO。
