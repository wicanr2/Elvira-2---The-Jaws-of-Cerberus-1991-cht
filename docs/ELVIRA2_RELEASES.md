# 《Elvira II: The Jaws of Cerberus》(1991) 原始發行版本考

> 開發：Horror Soft Ltd.（＝Adventure Soft / Adventuresoft，英國）｜發行：Accolade（美國）｜引擎：AGOS（ScummVM 內 `GType_ELVIRA2`）
> 本文用於中文化專案背景。凡「查無明確資料」處均已標注，未臆測。

## 媒介與版本

Elvira 2 屬 1991 年的**純軟碟世代**作品，早於 Simon the Sorcerer（1993，AGOS 首款 CD 語音版）。所有可查證的原始發行皆為 floppy，**無 CD-ROM／talkie 語音版**。文字全部以畫面字幕呈現、無配音。

| 平台 | 媒介 | 語音 | 字幕 | 年份 | 備註 |
|---|---|---|---|---|---|
| MS-DOS | 3.5" HD 軟碟 ×3（1440KB）| 無 | 有（完整文字）| 1991 | Adventuresoft/Accolade；archive.org 影像集實測 3 片 |
| MS-DOS | 5.25" 軟碟 | 無 | 有 | 1991 | 當年 5.25" 亦有出貨；確切片數查無明確資料 |
| Amiga | 軟碟 ×7 | 無 | 有 | 1992 | Wikipedia 記「spans seven disks」 |
| Atari ST | 軟碟 | 無 | 有 | 1992 | |
| Commodore 64 | 軟碟（4 片，雙面）| 無 | 有 | 1992 | Flair Software 移植 |

- **無 CD-ROM / 語音版**：ScummVM 的 AGOS detection tables 對 Elvira 2 的**每一筆**條目 Extra 欄都是「Floppy」，沒有任何 CD/talkie 指紋（見下節）。搜尋過程曾出現「Flair 為 Commodore 128d 出 CD-ROM 增強版」的說法，來源不可靠、無第一手佐證，判定為搜尋摘要誤植，不採信。
- 結論：Elvira 2 是 floppy-only、text-only 的遊戲。這一點對中文化涵蓋範圍很關鍵（見末節）。

## 語言在地化版本

當年原生在地化語言（以 ScummVM DOS/Amiga 指紋交叉確認）：**英文(EN)、法文(FR)、德文(DE)、義大利文(IT)、西班牙文(ES)** 五種。

| 語言 | DOS | Amiga | Atari ST | 備註 |
|---|---|---|---|---|
| 英文 EN | ✅ | ✅ | ✅ | 原始母語版 |
| 法文 FR | ✅ | ✅ | ✅ | |
| 德文 DE | ✅ | ✅ | ✅ | Atari ST 德文 md5 與 DOS 不同版 |
| 義大利文 IT | ✅ | ✅ | 查無 | |
| 西班牙文 ES | ✅（另有 Alternate 版）| ✅ | 查無 | |
| 捷克文 CS | （fan patch）| — | — | 非原始發行，是後世玩家修補，ScummVM 標「Czech patch」 |

> Wikipedia 頁面側欄出現的「Italian, Ladin, Dutch, Swedish」是維基條目本身的翻譯語言，非遊戲在地化，已排除。

## 發行商與地區差異

- **開發**：Horror Soft Ltd.（英國，Mike Woodroffe 團隊；即後來的 Adventure Soft，Simon the Sorcerer 原班人馬）。archive.org DOS 影像集把發行者標為「Adventuresoft」，反映英國端品牌。
- **美國發行**：Accolade, Inc.（DOS 1991、Amiga/Atari ST 1992）。北美盒裝掛 Accolade。
- **Commodore 64 移植**：Flair Software Ltd.（1992）。
- **Flair 1995 再版**：archive.org 有一套「Elvira II (1995, Flair Software, DE)」德文 4 片軟碟，Flair 於原版後數年在歐洲/德語區再發行。
- 各語言 DOS 版當年由 Accolade 統籌或各地代理商分別在地化，細節查無明確第一手資料；可確認的是母帶級版本存在 EN/FR/DE/IT/ES 五語。

## ScummVM 支援的版本指紋

取自 ScummVM `engines/agos/detection_tables.h`（`GType_ELVIRA2`，gameid＝`elvira2`），Extra 欄全部是「Floppy」：

| 描述 | MD5 | 語言 | 平台 | Extra |
|---|---|---|---|---|
| Floppy | 3313254722031b22d833a2cf45a91fd7 | EN | DOS | — |
| Floppy | 1282fd5c520861ae2b73bf653afef547 | EN | DOS | Alternate 1 |
| Floppy | 75d814739585b6fa89a025045885e3b9 | EN | DOS | Alternate 2 |
| Floppy | 4bf28ab00f5324fd938e632595742382 | FR | DOS | — |
| Floppy | d1979d2fbc5fb5276563578ca55cbcec | DE | DOS | — |
| Floppy | 09a3f1087f2977ff462ad2417bde0a5c | IT | DOS | — |
| Floppy | bfcd74d704ad481d75eb6ba5b828333a | ES | DOS | — |
| Floppy | e84e1ac84f63d9a39270e517196c5ff9 | ES | DOS | Alternate |
| Floppy | 022536512981f1962276c0813a1351d8 | CS | DOS | Czech patch（fan） |
| Floppy | 4aa163967f5d2bd319f8350d6af03186 | EN | Amiga | — |
| Floppy | 7bb91fd61a135243b18b74b51ebca6bf | FR | Amiga / AtariST | 同 md5 共用 |
| Floppy | 7af80eb9759bcafcd8df21e61c5af200 | DE | Amiga | — |
| Floppy | 3d4e0c8da4ebd222e50de2dffed92955 | IT | Amiga | — |
| Floppy | fddfac048a759c84ecf96e3d0cb368cc | ES | Amiga | — |
| Floppy | 1b1acd637d32bee79859b7cc9de070e7 | EN | AtariST | — |
| Floppy | 43cb10d38af2b4a0c707965c83431f4c | DE | AtariST | — |

重點：**detection 表完全沒有 CD 條目**，佐證 Elvira 2 無語音 CD 版。DOS 英文版有 3 個 md5（主版＋Alternate 1/2），對應當年不同壓片批次。

## 對本中文化專案的意義

- 本專案的遊戲檔對應 **DOS 英文 floppy 版**（最可能為主版 md5 `3313254722031b22d833a2cf45a91fd7`，或 Alternate 1/2 之一；可用 ScummVM 偵測結果核對）。
- **floppy 英文版＝完整文字、零語音**：因為 Elvira 2 根本沒有 talkie/CD 版，所有敘事與對白從一開始就以字幕文字存在於 `GAMEPC` 字串表與 `TEXT*` 分頁。**不存在「talkie 版有語音但缺字幕」那種需跨版本融合補字幕的問題**（那是 Simon the Sorcerer CD 版才有的坑）。
- 因此中文化只要覆蓋 floppy 版的 A/B/C 三類文字（GAMEPC 內建字串、TEXTxx 對白/旁白、物品欄描述）＋硬編碼 UI（動詞列、存讀檔訊息）＋ VGA 美術字，即涵蓋玩家會見到的**全部**文字。以「dump oracle 未翻歸零」驗收時，floppy 英文版就是完整分母，無隱藏語音腳本殘留。
- 選英文版為基底也讓 ScummVM 指紋單純：偵測判為 EN DOS Floppy，patch 的 `GType_ELVIRA2` gate 與語言路徑落回英文分支，正好是中文注入攔截的位置。

## 來源

- ScummVM AGOS detection tables（最權威指紋來源）：https://raw.githubusercontent.com/scummvm/scummvm/master/engines/agos/detection_tables.h
- MobyGames：https://www.mobygames.com/game/1779/elvira-ii-the-jaws-of-cerberus/
- My Abandonware：https://www.myabandonware.com/game/elvira-ii-the-jaws-of-cerberus-2md
- Internet Archive — DOS 版（Horror Soft/Accolade 1991）：https://archive.org/details/msdos_Elvira_2_-_The_Jaws_of_Cerberus_1991
- Internet Archive — IBM PC 3.5" 軟碟影像集（3×3.5" HD）：https://archive.org/details/003481-ElviraIiJawsOfCerberus
- Internet Archive — Flair Software 1995 德文再版：https://archive.org/details/Elvira_II_1995_Flair_Software_de_Disk_1_of_4_Side_A
- Wikipedia：https://en.wikipedia.org/wiki/Elvira_II:_The_Jaws_of_Cerberus
- Lemon Amiga：https://www.lemonamiga.com/games/details.php?id=369

> 查證方式：ScummVM 原始碼 detection 表為主、archive.org 影像集佐證；MobyGames releases 頁與 PCGamingWiki 回 403，細粒度清單以前兩者補齊。未落實兩點已標注：(1) DOS 5.25" 版確切片數；(2) 各語 DOS 版當年統籌方式。
