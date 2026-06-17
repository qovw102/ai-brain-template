---
name: project-brief-html
description: 將專案文件與 Git Log 轉成 Notion-style HTML 簡報網站；預設單一 HTML，長期維護時可改多檔案模式。Use when asked to transform README, Architecture docs, development logs, Git history, bug notes, or issue records into a polished HTML project briefing, interactive timeline, single-file deliverable, or maintainable static report.
---

# 專案簡報 HTML 產生器

當使用者想把專案文件、架構說明、Git Log、開發紀錄或 Issue 紀錄整理成 HTML 簡報網站時使用。目標是產出一份具備 Notion 式易讀性、可導覽、可展示給他人的專案介紹頁。

預設輸出為「可直接雙擊開啟的單一 HTML」。若使用者需要長期維護、多次改版、多人協作或持續擴充 UI，改用多檔案模式，或先建立多檔案 source，再提供單一 HTML build 產物。

## 觸發情境

應使用本 Skill 的說法包含：

- 「把 README / Architecture / Git log 做成單頁 HTML」
- 「做一個 Notion-style 專案介紹頁」
- 「把開發紀錄整理成互動時間軸」
- 「未來簡報想用網頁導覽」
- 「把 bug / issue / milestone 做成展示頁」
- 「幫我產生可以寄給別人的單一 HTML」
- 「幫我做一份之後還會維護的專案報告網站」

不應使用本 Skill 的情境：

- 只是在現有前端專案中修一個 UI bug。
- 只需要純文字摘要、簡報大綱或 Markdown 文件。
- 使用者明確要求 PowerPoint、Word、PDF 或多頁網站。

## 輸入資料處理

1. 讀取使用者提供或專案內可取得的資料：
   - `README.md`
   - `Architecture.md`、`ARCHITECTURE.md` 或其他架構文件
   - Git log、commit history、開發紀錄、Issue 紀錄
   - `progress.md` 或其他任務紀錄
2. 若使用者未貼內容但目前工作區是 Git repo，優先用本機資料補齊：
   - `rg --files` 尋找 README、Architecture、progress、docs。
   - `git log --oneline --decorate --graph --max-count=<合理數量>` 取得近期脈絡。
   - 必要時用 `git show` 或 `git log --stat` 追出關鍵修正。
3. 將資料整理為故事線，而不是逐字堆疊：
   - 專案是什麼、解決什麼問題。
   - 架構如何組成。
   - 開發歷程的主要里程碑。
   - 遇到的問題、根因、解法與學到的決策。

## 輸出模式判斷

除非使用者明確指定，先依情境選擇輸出模式。

### 預設：單一 HTML 交付版

適用於：

- 使用者要寄給別人、上傳 LMS、放雲端硬碟或離線雙擊開啟。
- 任務描述偏向簡報、展示、交付、一次性報告。
- 頁面互動需求有限，主要是導覽、篩選、accordion、時間軸。

做法：

- 產出一個 `.html` 檔。
- CSS 與 JavaScript 可內嵌在同一檔。
- 小型或必要圖片可轉成 base64 data URI 內嵌；大型圖片優先避免內嵌，除非使用者要求單檔離線交付。

### 多檔案維護版

適用於：

- 使用者說之後會長期維護、反覆改 UI、多人協作或接續開發。
- 預期有多張圖片、大量互動、複雜 CSS/JS，或需要清楚 Git diff。
- 使用者明確要求保留 source 結構。

做法：

- 建立資料夾，例如 `project-brief/`。
- 至少包含 `index.html`、`style.css`、`script.js`；圖片放 `assets/`。
- 若需要分享單檔，可另外提供 build script，把多檔案 source 打包成 `dist/*.html`。

### 何時先問使用者

若使用者沒有明確說交付或維護，但任務看起來可能長期演進，先問一句：

```text
這份 HTML 報告你要「單一 HTML 交付版」，還是「多檔案維護版」？如果只是分享給人看，我會用單一 HTML；如果之後會反覆修改，我會用多檔案。
```

如果使用者沒有回覆且任務目標是展示或分享，採用單一 HTML。

## 必備輸出

產出 HTML 報告，且不得依賴後端。可使用 CDN 引入 Tailwind CSS 與原生 JavaScript；若互動需求簡單，優先使用原生 JavaScript。

HTML 必須包含：

- 固定或可收合的導覽目錄。
- Scrollspy：滾動到哪個 section，目錄對應項目自動高亮。
- 手機版漢堡選單。
- 專案概覽與摘要。
- 架構區塊，可使用簡潔卡片、表格或 Mermaid-free 的 HTML/CSS 結構圖。
- 開發時間軸或里程碑區。
- 問題追蹤區，將 Bug、Issue、Debug、卡關、技術挑戰獨立成卡片。
- 問題卡片需包含：
  - 遭遇現象 Problem
  - 根因分析 Root Cause
  - 解決方案 Solution
  - 分類標籤，例如 `Hardware`、`Software`、`Timing-Issue`、`Solved`
- 篩選按鈕，至少支援：
  - 全部
  - 已解決的問題
  - 重大里程碑
- Accordion：環境架設、大篇幅原始 log、基礎指令或低優先細節預設收合。

## 視覺規範

採用 Notion-style Minimalist，避免過度裝飾：

- 背景：`#FFFFFF`
- 主要文字：`#2F3437`
- 次要背景：`#F7F7F5` 或 `#F1F1EF`
- 字體：`system-ui`、`Inter`、`-apple-system`、`BlinkMacSystemFont`
- 行高：正文約 `1.65`
- 內容主軸：桌機限制在舒適閱讀寬度，約 `max-width: 960px` 至 `1120px`
- 狀態 badge 可使用柔和莫蘭迪色系；避免大面積高飽和色。
- 不使用全黑文字，不使用厚重陰影，不使用炫技漸層。

## 響應式要求

- 桌機：側邊導覽固定於左側，內容居中。
- 平板與手機：導覽改為頂部漢堡選單，展開後可點擊跳轉。
- 長表格或程式碼區塊需可水平捲動，不得撐破版面。
- 標題、卡片與按鈕文字不得溢出或重疊。

## 資訊降噪

- 不逐字貼滿原始 log；只保留能說明決策與問題解法的片段。
- Git commit 應群組成里程碑、修正、重構、文件化等類型。
- 若原始紀錄缺少 Root Cause 或 Solution，可根據 commit 訊息、diff 與上下文合理推導，但需避免假裝有不存在的精確事實。
- 推導內容用保守語氣，例如「從 commit 脈絡推測」或「可合理整理為」。

## 實作流程

1. 先盤點資料來源，列出會使用的文件與 Git 範圍。
2. 整理資訊架構，決定 section id 與目錄順序。
3. 依「輸出模式判斷」決定單一 HTML 或多檔案維護版；若使用者沒有指定檔名，預設可用 `project-brief.html`、`project-overview.html` 或依專案名稱命名。
4. 實作互動：
   - sidebar / mobile menu toggle
   - scrollspy
   - issue / milestone filter
   - accordion
5. 用瀏覽器或可用工具檢查：
   - 桌機與手機寬度可讀性
   - 目錄高亮是否正確
   - 篩選與 accordion 是否可用
   - 沒有 console error
   - 文字沒有明顯重疊或溢出
6. 若專案規則要求 checkpoint，更新 `progress.md`、commit 並 push。

## 測試 Prompt

- 正常案例：請把這個專案的 README.md、Architecture.md 和最近 30 筆 git log 整理成 Notion-style 單一 HTML 簡報頁。
- 間接說法：我想之後用網頁導覽介紹專案，幫我把文件和開發卡關整理成一頁可以展示的網站。
- 維護模式：請把這個專案做成之後會持續維護的 HTML 報告網站，保留 HTML/CSS/JS 分檔。
- 需要詢問：我想做一份專案報告網站，但還沒決定要怎麼分享。這種情況應先詢問單一 HTML 或多檔案維護版。
- 邊界案例：只幫我摘要 README 的重點，不要做成網頁。這種情況不應觸發本 Skill。
