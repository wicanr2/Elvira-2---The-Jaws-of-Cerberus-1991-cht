#!/bin/bash
# 聚焦 smoke: 直接載入 slot 4 (電梯存檔 elvira2-pc.004),截圖驗 issue 2/6/7。
set -e
PROJ="/home/anr2/scummvm/elvira_2_cht/workplace"
docker run --rm -v "$PROJ:/work" -w /work agos-build bash -c '
  export XDG_RUNTIME_DIR=/tmp/xdg; mkdir -p /tmp/xdg /work/screenshots
  Xvfb :99 -screen 0 640x400x16 &>/dev/null & sleep 2
  export DISPLAY=:99 SDL_AUDIODRIVER=dummy
  cd /work/run_game
  # 直接開機載入 slot 4
  /work/build/scummvm-src/scummvm -d1 -p /work/run_game --auto-detect --no-aspect-ratio \
    --save-slot=4 >/work/screenshots/smoke.log 2>&1 &
  sleep 8
  W=$(xdotool search --name Elvira | head -1)
  if [ -z "$W" ]; then echo "!! 視窗找不到"; grep -iE "error|abort|save" /work/screenshots/smoke.log | tail; exit 0; fi
  xdotool windowactivate $W 2>/dev/null; sleep 2
  import -window root /work/screenshots/sm_loaded.png 2>/dev/null   # 電梯場景 (issue 2/7 殘留?)
  # 開角色/能力值面板: 點右上磁片/人物 icon 區。先試點畫面右側 icon 列
  xdotool mousemove --window $W 620 40 click 1 2>/dev/null; sleep 2
  import -window root /work/screenshots/sm_panel.png 2>/dev/null
  pkill -f scummvm 2>/dev/null
  chown -R '"$(id -u):$(id -g)"' /work/screenshots 2>/dev/null
  echo "=== log tail ==="; grep -iE "load|save|slot|error|CHT" /work/screenshots/smoke.log | tail -15
'
