#!/bin/bash
# 驗 issue 1: 開機後按 Enter 應跳過片頭 cutscene。
set -e
PROJ="/home/anr2/scummvm/elvira_2_cht/workplace"
docker run --rm -v "$PROJ:/work" -w /work agos-build bash -c '
  export XDG_RUNTIME_DIR=/tmp/xdg; mkdir -p /tmp/xdg /work/screenshots
  Xvfb :99 -screen 0 640x400x16 &>/dev/null & sleep 2
  export DISPLAY=:99 SDL_AUDIODRIVER=dummy
  cd /work/run_game
  /work/build/scummvm-src/scummvm -d1 -p /work/run_game --auto-detect --no-aspect-ratio >/work/screenshots/enter.log 2>&1 &
  sleep 5
  W=$(xdotool search --name Elvira | head -1); xdotool windowactivate $W 2>/dev/null; sleep 1
  import -window root /work/screenshots/en_before.png 2>/dev/null    # 片頭中
  # 連按 Enter 數次跳過各段 cutscene
  for i in 1 2 3 4 5 6; do xdotool key --window $W Return 2>/dev/null; sleep 2; done
  import -window root /work/screenshots/en_after.png 2>/dev/null      # 跳過後應到職業選單/遊戲
  pkill -f scummvm 2>/dev/null
  chown -R '"$(id -u):$(id -g)"' /work/screenshots 2>/dev/null
'
