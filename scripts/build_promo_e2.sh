#!/bin/bash
# Elvira 2 推廣片: 用 promo/e2_raw.mp4(實機+原版配樂) 剪成帶中文卡的短片。
# 產物: dist-all/艾薇拉2-恐怖劇場-CHT-promo.mp4
set -e
PROJ="/home/anr2/scummvm/elvira_2_cht/workplace"
[ -f "$PROJ/promo/e2_raw.mp4" ] || { echo "!! 缺 promo/e2_raw.mp4 (先跑 capture_av)"; exit 1; }
docker run --rm -v "$PROJ:/work" -w /work/promo agos-capture bash -c '
set -e
FONT=/usr/share/fonts/opentype/noto/NotoSerifCJK-Bold.ttc
# 標題卡
convert -size 640x400 xc:"#0a0605" \
  -fill "#c01018" -font "$FONT" -pointsize 54 -gravity center -annotate +0-70 "艾薇拉 II" \
  -fill "#e8b020" -font "$FONT" -pointsize 62 -gravity center -annotate +0+0 "恐怖劇場" \
  -fill "#d8d0c0" -font "$FONT" -pointsize 22 -gravity center -annotate +0+70 "Elvira II: The Jaws of Cerberus · 繁體中文版" \
  -fill "#9a9488" -font "$FONT" -pointsize 16 -gravity south -annotate +0+30 "1991 Horror Soft / Accolade · ScummVM AGOS 補丁 · 原版配樂" out_title.png
mk(){ convert -size 640x400 xc:"#0a0605" \
    -fill "#c01018" -font "$FONT" -pointsize 44 -gravity center -annotate +0-30 "$2" \
    -fill "#d8d0c0" -font "$FONT" -pointsize 22 -gravity center -annotate +0+40 "$3" out_$1.png; }
mk cap1 "一個字都沒漏" "2170 條對白·物品·法術·選單 全中文 · 原生點陣清晰"
mk cap2 "替現代玩家馴服的硬核" "TAB 動態地圖 · F7 無敵 · F8 除霧 · F6 一鍵給物"
convert -size 640x400 xc:"#0a0605" \
  -fill "#e8b020" -font "$FONT" -pointsize 30 -gravity center -annotate +0-30 "只散佈補丁 · 尊重原作版權" \
  -fill "#c01018" -font "$FONT" -pointsize 24 -gravity center -annotate +0+30 "讓她第一次說中文" \
  -fill "#8a8478" -font "$FONT" -pointsize 15 -gravity south -annotate +0+25 "敬請「小心」進場" out_end.png

# 從 e2_raw.mp4 取段: 中文提示(80-86) 職業選單(87-93) gameplay對白+地圖(109-119)
# 卡 3s + 各段, 音軌用 gameplay 段原音鋪底
ffmpeg -y -loglevel error \
 -loop 1 -t 3 -i out_title.png \
 -loop 1 -t 3 -i out_cap1.png \
 -ss 80 -t 6 -i e2_raw.mp4 \
 -ss 87 -t 6 -i e2_raw.mp4 \
 -loop 1 -t 3 -i out_cap2.png \
 -ss 108 -t 11 -i e2_raw.mp4 \
 -loop 1 -t 3 -i out_end.png \
 -ss 30 -t 40 -i e2_raw.mp4 \
 -filter_complex "
  [0:v]scale=640:400,fps=15,format=yuv420p,setsar=1[v0];
  [1:v]scale=640:400,fps=15,format=yuv420p,setsar=1[v1];
  [2:v]scale=640:400,fps=15,format=yuv420p,setsar=1[v2];
  [3:v]scale=640:400,fps=15,format=yuv420p,setsar=1[v3];
  [4:v]scale=640:400,fps=15,format=yuv420p,setsar=1[v4];
  [5:v]scale=640:400,fps=15,format=yuv420p,setsar=1[v5];
  [6:v]scale=640:400,fps=15,format=yuv420p,setsar=1[v6];
  [v0][v1][v2][v3][v4][v5][v6]concat=n=7:v=1:a=0[vout];
  [7:a]atrim=0:35,volume=1.6[abed]
 " -map "[vout]" -map "[abed]" -shortest \
 -c:v libx264 -pix_fmt yuv420p -preset veryfast -crf 22 \
 -c:a aac -b:a 192k /work/dist-all/艾薇拉2-恐怖劇場-CHT-promo.mp4
chown -R '"$(id -u):$(id -g)"' /work/dist-all /work/promo 2>/dev/null || true
echo "=== 產物 ==="; ls -lh /work/dist-all/艾薇拉2-恐怖劇場-CHT-promo.mp4
'
