#!/bin/bash
# 錄製期間跑:Elvira 2 進遊戲序列 + 展示中文與友善化疊層
# (在 capture_av.sh 的 docker 內執行,DISPLAY=:99)
W=$(xdotool search --name Elvira | head -1)
xdotool windowactivate "$W" 2>/dev/null
# 0-82s: credits 自動播(氛圍素材) — 開場「讀取已存檔的遊戲？」中文提示會出現
sleep 82
# 點「否」(No 框 logical 186,177 → 640x400 390,362)開新局
xdotool mousemove --window "$W" 390 362 2>/dev/null; xdotool click --window "$W" 1 2>/dev/null
sleep 4
# 選職業(特技替身區 ~250,336)進入遊戲
xdotool mousemove --window "$W" 250 336 2>/dev/null; xdotool click --window "$W" 1 2>/dev/null
sleep 5
# 進遊戲:滑過場景/道具欄
xdotool mousemove --window "$W" 480 200 2>/dev/null; sleep 2
xdotool mousemove --window "$W" 320 330 2>/dev/null; sleep 2
# 友善化展示:F7 無敵
xdotool key --window "$W" F7 2>/dev/null; sleep 3
# TAB 動態地圖(中文圖例)
xdotool key --window "$W" Tab 2>/dev/null; sleep 4
# F8 除霧
xdotool key --window "$W" F8 2>/dev/null; sleep 3
# 關地圖回遊戲
xdotool key --window "$W" Tab 2>/dev/null; sleep 3
