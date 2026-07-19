#!/bin/bash
# 用法: capture2.sh <秒數> <輸出前綴>
set -e
PROJ="/home/anr2/scummvm/elvira_2_cht/workplace"
SECS="${1:-90}"; OUT="${2:-play}"
mkdir -p "$PROJ/screenshots"
docker run --rm -v "$PROJ:/work" -w /work agos-build bash -c "
  export XDG_RUNTIME_DIR=/tmp/xdg; mkdir -p /tmp/xdg
  Xvfb :99 -screen 0 640x400x16 &>/dev/null & sleep 2
  export DISPLAY=:99 SDL_AUDIODRIVER=dummy
  cd /work/run_game
  /work/build/scummvm-src/scummvm -p /work/run_game --auto-detect --no-aspect-ratio &>/work/screenshots/${OUT}.log &
  SPID=\$!
  W=''
  for t in \$(seq 1 $((SECS/3))); do
    sleep 3
    W=\$(xdotool search --name ScummVM 2>/dev/null | head -1)
    # 週期性:點左鍵 + Return + Escape 跳過開場/選單
    if [ -n \"\$W\" ]; then
      xdotool key --window \$W Return 2>/dev/null || true
      xdotool mousemove 320 190 click 1 2>/dev/null || true
    fi
    import -window root /work/screenshots/${OUT}_\$t.png 2>/dev/null || true
  done
  kill \$SPID 2>/dev/null || true
  chown -R $(id -u):$(id -g) /work/screenshots 2>/dev/null || true
"
