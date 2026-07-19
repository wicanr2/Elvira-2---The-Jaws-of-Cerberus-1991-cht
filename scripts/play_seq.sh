#!/bin/bash
# 已知可用序列:進遊戲並互動/測友善化,存 ScummVM state 到 slot 0
set -e
PROJ="/home/anr2/scummvm/elvira_2_cht/workplace"
docker run --rm -v "$PROJ:/work" -w /work agos-build bash -c '
  export XDG_RUNTIME_DIR=/tmp/xdg; mkdir -p /tmp/xdg
  Xvfb :99 -screen 0 640x400x16 &>/dev/null & sleep 2
  export DISPLAY=:99 SDL_AUDIODRIVER=dummy
  cd /work/run_game
  /work/build/scummvm-src/scummvm -d1 -p /work/run_game --auto-detect --no-aspect-ratio >/work/screenshots/play.log 2>&1 &
  sleep 4
  W=$(xdotool search --name Elvira | head -1); xdotool windowactivate $W 2>/dev/null
  sleep 85
  xdotool mousemove --window $W 390 362 click 1 2>/dev/null; sleep 4    # No→職業選單
  xdotool mousemove --window $W 250 336 click 1 2>/dev/null; sleep 4    # 選職業→進遊戲
  import -window root /work/screenshots/pl_ingame.png 2>/dev/null
  # 互動:滑過場景物件(門/招牌)觸發物品名到頂端名稱窗
  xdotool mousemove --window $W 480 200 2>/dev/null; sleep 1; import -window root /work/screenshots/pl_hover1.png 2>/dev/null
  xdotool mousemove --window $W 300 120 2>/dev/null; sleep 1; import -window root /work/screenshots/pl_hover2.png 2>/dev/null
  # 點場景物件看描述(look verb 預設)
  xdotool mousemove --window $W 480 200 click 1 2>/dev/null; sleep 2; import -window root /work/screenshots/pl_look.png 2>/dev/null
  # 友善化:F7 無敵
  xdotool key --window $W F7 2>/dev/null; sleep 2; import -window root /work/screenshots/pl_f7.png 2>/dev/null
  # 友善化:TAB 地圖
  xdotool key --window $W Tab 2>/dev/null; sleep 2; import -window root /work/screenshots/pl_tab.png 2>/dev/null
  pkill -f scummvm 2>/dev/null
  chown -R '"$(id -u):$(id -g)"' /work/screenshots 2>/dev/null
  echo "=== log tail ==="; grep -iE "CHTCLICK|godmode|無敵|map" /work/screenshots/play.log | tail -8
'
