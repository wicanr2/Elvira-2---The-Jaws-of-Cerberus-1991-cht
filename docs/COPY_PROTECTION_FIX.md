# 防拷破解：Elvira 2 的符號碼防拷根因與修正

> 症狀：玩到一半的**保全鍵盤／電子鎖門**過不去，沒有實體手冊根本解不開，答錯四次還會直接被結束遊戲。
> 這篇記錄「為什麼引擎的防拷旗標關不掉它」的根因，以及繁中版怎麼在引擎層自動通過。

## 一、症狀

遊戲進行到 Elvira 攝影棚的兩處關卡會跳出「輸入密碼」的符號盤：

- **保全鍵盤**（`<841>` 保全窗／檔案櫃鍵盤）
- **電子鎖門**（動作追蹤器區，訊息「The doors are locked electronically.」）

畫面要你**對照實體說明書上的符文表**，依序點出正確的符號組合。沒有那本 1991 年的軟體世界手冊 → 無解；答錯累計 4 次 → 顯示「Read the manual before attempting to play with me again.」後 `END`（結束遊戲）。

## 二、為什麼「關掉防拷旗標」沒用（根因）

ScummVM 的 AGOS 引擎有一個 `_copyProtection` 旗標（`ConfMan.getBool("copy_protection")`，預設 false），繁中版初始化時也強制設 false。但它**攔不到 Elvira 2 的這兩關**。

追 ScummVM 原始碼可以看到：引擎層的防拷 bypass **只針對 Simon 系列**寫死了 table id：

```cpp
// engines/agos/script.cpp  o_freezeZones (opcode 138)
if (!_copyProtection && !(getFeatures() & GF_TALKIE) && _currentTable) {
    if ((getGameType() == GType_SIMON1 && _currentTable->id == 2924) ||
        (getGameType() == GType_SIMON2 && _currentTable->id == 1322)) {
        // ...強制填入正確答案的變數，讓後續檢查通過
    }
}
```

**Elvira 2 不在這個名單裡**。它的防拷不是引擎功能，而是**寫在遊戲自己的 bytecode（GAMEPC 子程式）裡的一段迷你程式**——引擎只是忠實地執行它。所以無論 `_copyProtection` 設什麼，遊戲腳本照樣跑它的符號盤檢查。

> 第一性原理：`_copyProtection` 控制的是「**引擎**要不要幫你跳過防拷」；但 Elvira 2 的防拷判斷發生在「**遊戲腳本**」層，引擎的旗標管不到腳本的邏輯。要破，得從腳本執行的路徑上動手。

## 三、逆向：防拷長什麼樣（以引擎反組譯器當 oracle）

用引擎內建的 `dumpAllSubroutines()` 反組譯 GAMEPC 子程式，從失敗訊息字串 id 630 反追，定位到兩個子程式：

### `SUB_1867` — 保全鍵盤

```
SUB_1867:
  ADD [19] 1                 ; 累加錯誤次數
  IS_EQ [19] 4 ->            ; 錯滿 4 次：
    SHOW_STRING_NL "Read the manual..."(630)
    END                      ; 結束遊戲
  ; ...畫出符號盤（一格一個符號 item：746→1, 744→2, 743→3 ...）
  ZERO [0]
  START_SUB 1868             ; 把玩家點的符號累加成一串數字碼進 [0]
  ; ...用手冊 code-wheel 演算法算期望值、比對...
  ISNOT_ZERO [0] ->          ; 對了（[0]!=0）：成功分支
    CLEAR_BIT2 91
    SET_DOOR_OPEN <853> 0    ; 開門
    SET_STATE  <803> 2       ; 鍵盤設為「已通過」
    DONE
  ; 否則：顯示「Incorrect code - try again」(895) → RESCAN 重試
```

### `SUB_1869` — 電子鎖門

同一套符號盤機制，成功分支改成清旗標解鎖：

```
  ISNOT_ZERO [0] ->
    CLEAR_BIT2 91
    CLEAR_BIT2 [193]         ; 變數索引的 bit2
    CLEAR_BIT 19
    DONE
```

**成功條件都是 `ISNOT_ZERO [0]`**：`[0]` 是玩家輸入的符號碼經 code-wheel 演算後的結果，只有比對正確才非 0。演算法的種子在手冊的轉盤／符文表上——這正是防拷的設計意圖。

## 四、修正：在腳本執行入口攔截，直接跑成功分支

繁中版的目標是「不必手冊也能玩通」，所以做法是：**在引擎執行到這兩個子程式時，`_chtActive` 就直接執行它們各自的成功分支，跳過符號輸入**。這跟 ScummVM 原本 bypass Simon 防拷的 `o_freezeZones` 是同一種思路，只是掛勾點選在子程式執行的入口 `startSubroutine()`：

```cpp
// engines/agos/subroutine.cpp  AGOSEngine::startSubroutine(Subroutine *sub)
// 非上游: 繁中版自動通過 Elvira 2 兩處符號碼防拷。
if (_chtActive && getGameType() == GType_ELVIRA2 && (sub->id == 1867 || sub->id == 1869)) {
    _bitArrayTwo[91 / 16] &= ~(1 << (91 & 15));   // 兩者共通: CLEAR_BIT2 91
    if (sub->id == 1867) {                        // 保全鍵盤
        Item *door = derefItem(853);
        Item *keypad = derefItem(803);
        if (door)   setDoorState(door, 0, 1);     // 開門
        if (keypad) setItemState(keypad, 2);      // 鍵盤設為已通過
    } else {                                       // 電子鎖門
        uint b2 = (uint)readVariable(193);
        _bitArrayTwo[b2 / 16] &= ~(1 << (b2 & 15));
        setBitFlag(19, false);
    }
    return result;                                 // 跳過符號輸入挑戰
}
```

每一行都逐條對照 dump 的成功分支複製，只略過兩個純畫面重繪的子程式（`START_SUB 7/19`）——狀態已改，下一個動作自然重繪。掛勾用 `sub->id == 1867 || 1869` 精準命中，其他子程式完全不受影響。

> 這段收在集中式的 `patches/agos-cht.patch` 裡，全部以 `// 非上游` 標記、`_chtActive` 旗標控，不破壞英文原路徑。

## 五、驗證狀態（誠實列出）

- ✅ **靜態 RE**：逐條比對引擎反組譯器 dump 出的成功分支，複製無誤。
- ✅ **編譯乾淨**、開機無 regression，掛勾只在 id 1867/1869 觸發（不誤傷其他子程式）。
- ✅ **同款做法有前例**：等同 ScummVM 對 Simon 1/2 防拷的 `o_freezeZones` bypass。
- ⚠️ **未做的**：headless 自動化「實機走到那兩關按下去確認過關」——那兩關在攝影棚深處，無人操作導航過去不切實際。玩家實際玩到時請幫忙確認；若有出入，dump 資料仍在，可再校。

## 參考

- 掛勾點：`engines/agos/subroutine.cpp`（`startSubroutine`）——見 `patches/agos-cht.patch`。
- 反組譯技巧與 AGOS 文字/資料模型：`docs/DEV_SETUP.md`、專案根 `CLAUDE.md`。
- ScummVM 對 Simon 防拷的原生 bypass：`engines/agos/script.cpp` `o_freezeZones`。
