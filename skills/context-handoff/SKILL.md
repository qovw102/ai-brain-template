---
name: context-handoff
description: 產生可交接、可續作的繁體中文上下文精簡摘要。Use when an AI agent lacks built-in compact/context compression, the user wants to continue work in a new chat/thread, or a long conversation needs a concise handoff brief that preserves goals, decisions, current state, files, commands, blockers, and next actions.
---

# 上下文交接摘要

當使用者要求「精簡上下文」、「壓縮對話」、「交接給新對話」、「讓其他 AI agent 繼續」、「整理目前狀態」或長對話即將超出模型上下文時使用。

## 重要邊界

- 這不是任何特定產品內建 compact 的等價替代品；不能真正改寫模型內部上下文視窗。
- 目標是產出一份可貼到新 thread、其他 AI agent 或同一 agent 後續對話的交接摘要。
- 摘要必須保留可續作資訊，刪除閒聊、重複推理、已失效假設與不必要細節。
- 主體預設使用繁體中文；命令、路徑、錯誤訊息、commit SHA、API 名稱保留原文。

## 產出格式

使用下列固定結構，缺少資訊時寫「未確認」或省略該項，不要編造。

```markdown
# Context Handoff

## 目標

- 使用者最終想完成什麼。

## 目前狀態

- 已完成的工作。
- 目前 repo / 分支 / commit / remote 狀態。
- 目前工具、環境或排程狀態。

## 重要決策

- 已定案的設計、流程、限制與原因。

## 相關檔案

- `path/to/file`：用途與目前變更重點。

## 已執行命令與結果

- `command`：關鍵結果。

## 待辦

- [ ] 下一步工作。

## 風險與阻礙

- 未解問題、需要使用者確認的事項、不能自動處理的風險。

## 下一個 agent 應如何接手

1. 第一個動作。
2. 第二個動作。
3. 驗證方式。
```

## 執行流程

1. 先確認使用者要摘要的範圍：目前對話、某個 repo、某次任務、某段工作紀錄或特定檔案。
2. 若在 Git repo 中，讀取 `git status --short --branch`、近期 commit、相關 diff 或 `progress.md`，但不要把完整 diff 貼入摘要。
3. 擷取對後續工作有用的資訊：
   - 使用者目標與最新要求；
   - 已完成事項；
   - 尚未完成事項；
   - 重要決策與原因；
   - 檔案路徑、命令、commit SHA、PR/issue URL；
   - 驗證結果與失敗原因；
   - 需要避免重做或不能覆蓋的使用者變更。
4. 壓縮時保留事實與可執行下一步，刪除：
   - 重複的中間推理；
   - 已被後續訊息修正的舊計畫；
   - 與下一步無關的工具輸出；
   - 可由檔案或 Git 重新查到的大量內容。
5. 若摘要要給另一個 agent，最後加上「下一個 agent 應如何接手」。
6. 若摘要要寫入檔案，優先寫入使用者指定路徑；若沒有指定，不主動建立檔案，只在回覆中輸出摘要。

## 測試 Prompt

- 「幫我把目前這段工作整理成可以貼到新對話的交接摘要。」
- 「這個 thread 太長了，請用 $context-handoff 產生續作摘要，讓下一個 agent 不用重讀全部對話。」
- 「請整理目前 repo 狀態、已完成、未完成、相關檔案和下一步，但不要包含無關工具輸出。」
