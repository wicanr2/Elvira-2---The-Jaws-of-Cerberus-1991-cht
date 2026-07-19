#!/bin/bash
set -e
PROJ="/home/anr2/scummvm/elvira_2_cht/workplace"
docker run --rm -v "$PROJ:/work" -w /work agos-build bash -c '
  export XDG_RUNTIME_DIR=/tmp/xdg; mkdir -p /tmp/xdg
  Xvfb :99 -screen 0 640x400x16 &>/dev/null & sleep 2
  export DISPLAY=:99 SDL_AUDIODRIVER=dummy
  cd /work/run_game
  /work/build/scummvm-src/scummvm -p /work/run_game --auto-detect --no-aspect-ratio &>/work/screenshots/g.log &
  sleep 4
  W=$(xdotool search --name Elvira | head -1); echo "win=$W"
  xdotool windowactivate $W 2>/dev/null; xdotool windowfocus $W 2>/dev/null
  # 跳過 credits(~85s):對準視窗按 Return+點畫面
  for t in $(seq 1 28); do sleep 3; xdotool key --window $W Return 2>/dev/null; xdotool mousemove --window $W 320 150 2>/dev/null; xdotool click --window $W 1 2>/dev/null; done
  import -window root /work/screenshots/g5_prompt.png 2>/dev/null
  # 點「否」(新局): 視窗座標
  xdotool mousemove --window $W 365 352 2>/dev/null; xdotool click --window $W 1 2>/dev/null; sleep 3
  import -window root /work/screenshots/g5_new1.png 2>/dev/null
  xdotool key --window $W Return 2>/dev/null; xdotool mousemove --window $W 320 180 2>/dev/null; xdotool click --window $W 1 2>/dev/null; sleep 3
  import -window root /work/screenshots/g5_new2.png 2>/dev/null
  # 進遊戲後滑過道具欄/場景觸發物品名
  for t in $(seq 1 8); do xdotool mousemove --window $W $((150+t*35)) 330 2>/dev/null; sleep 1; import -window root /work/screenshots/g5_h$t.png 2>/dev/null; done
  pkill -f scummvm 2>/dev/null || true
  chown -R '"$(id -u):$(id -g)"' /work/screenshots 2>/dev/null || true
'
