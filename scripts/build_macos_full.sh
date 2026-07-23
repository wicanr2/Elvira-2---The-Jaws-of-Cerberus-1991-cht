#!/bin/bash
# macOS 完整版(含遊戲+ROM，本地保留、不公開)：把 run_game 的遊戲原檔+ROM 注入
# CI 產的 macOS 引擎包(ScummVM.app)。.dmg 需 macOS host,本地只產 .tar.gz。
# 需先有 CI artifact 的引擎 tar.gz(dist-macos-artifact/ 或 dist-all/)。
# 產物: dist-all/Elvira2-CHT-macOS-universal-FULL.tar.gz
set -e
PROJ="/home/anr2/scummvm/elvira_2_cht/workplace"
ENG=$(find "$PROJ/dist-macos-artifact" "$PROJ/dist-all" -name "Elvira2-CHT-macOS-universal.tar.gz" 2>/dev/null | head -1)
[ -n "$ENG" ] || { echo "!! 缺 macOS 引擎 tar.gz(先下載 CI artifact 到 dist-macos-artifact/)"; exit 1; }
echo "使用引擎包: $ENG"
T=/tmp/mac-full; rm -rf "$T"; mkdir -p "$T"
tar xzf "$ENG" -C "$T"
DIR=$(find "$T" -maxdepth 1 -type d -name "*macOS-universal" | head -1)
[ -n "$DIR" ] || { echo "!! tar.gz 內找不到 *macOS-universal 資料夾"; exit 1; }
mkdir -p "$DIR/game"
# 注入完整遊戲原檔 + ROM(run_game 已含遊戲+字型+MT32 ROM)
cp -rL "$PROJ"/run_game/* "$DIR/game/"
cp "$PROJ/docs/如何開始遊玩.txt" "$DIR/README.txt" 2>/dev/null || true
( cd "$T" && tar czf "$PROJ/dist-all/Elvira2-CHT-macOS-universal-FULL.tar.gz" "$(basename "$DIR")" )
rm -rf "$T"
echo "=== 產物(本地保留,不發佈) ==="; ls -lh "$PROJ/dist-all/Elvira2-CHT-macOS-universal-FULL.tar.gz"
