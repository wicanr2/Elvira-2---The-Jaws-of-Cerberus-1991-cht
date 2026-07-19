#!/bin/bash
# 完整版 AppImage: patched ScummVM(AGOS+CHT) + 內含遊戲(floppy + CHT 資產)
# 雙擊直接進《艾薇拉II 恐怖劇場》繁中版。產物: dist-all/Elvira2-CHT-FULL-x86_64.AppImage (含版權資料, 不入 git)
set -e
PROJ="/home/anr2/scummvm/elvira_2_cht/workplace"
GAME="$PROJ/run_game"
[ -f "$GAME/gamepc" ] || { echo "!! run_game 缺遊戲檔"; exit 1; }
[ -f "$GAME/elvira2_zh16.dcjk" ] || { echo "!! 缺 CHT 字型"; exit 1; }
docker run --rm -v "$PROJ:/w" -w /w agos-build bash -c '
  set -e
  export APPIMAGE_EXTRACT_AND_RUN=1
  APP=/tmp/AppDir; rm -rf $APP
  mkdir -p $APP/usr/bin $APP/usr/lib $APP/usr/share/elvira2-game $APP/usr/share/scummvm
  cp build/scummvm-src/scummvm $APP/usr/bin/scummvm
  ldd $APP/usr/bin/scummvm | awk "{print \$3}" | grep -E "^/" | while read lib; do
    case "$lib" in
      *ld-linux*|*libc.so*|*libm.so*|*libpthread*|*libdl.so*|*librt.so*|*libstdc++*|*libgcc_s*) ;;
      *) cp -L "$lib" $APP/usr/lib/ 2>/dev/null || true ;;
    esac
  done
  cp -rL run_game/* $APP/usr/share/elvira2-game/
  cp build/scummvm-src/gui/themes/scummmodern.zip build/scummvm-src/gui/themes/scummclassic.zip \
     build/scummvm-src/gui/themes/scummremastered.zip build/scummvm-src/gui/themes/gui-icons.dat \
     build/scummvm-src/gui/themes/shaders.dat build/scummvm-src/gui/themes/translations.dat \
     build/scummvm-src/dists/engine-data/fonts.dat build/scummvm-src/dists/engine-data/fonts-cjk.dat \
     $APP/usr/share/scummvm/ 2>/dev/null || true
  cat > $APP/AppRun <<"EOF"
#!/bin/bash
HERE="$(dirname "$(readlink -f "${0}")")"
export LD_LIBRARY_PATH="${HERE}/usr/lib:${LD_LIBRARY_PATH}"
SAVE="${XDG_DATA_HOME:-$HOME/.local/share}/elvira2-cht/saves"; mkdir -p "$SAVE"
DATA="${HERE}/usr/share/scummvm"
GAME="${HERE}/usr/share/elvira2-game"
exec "${HERE}/usr/bin/scummvm" -p "$GAME" \
     --themepath="$DATA" --extrapath="$GAME" --savepath="$SAVE" \
     --music-driver=mt32 --auto-detect "$@"
EOF
  chmod +x $APP/AppRun
  cat > $APP/scummvm.desktop <<"EOF"
[Desktop Entry]
Type=Application
Name=Elvira2 CHT
Exec=AppRun
Icon=scummvm
Categories=Game;
EOF
  convert -size 256x256 "radial-gradient:#4a1c1c-#0c0808" -font /usr/share/fonts/opentype/noto/NotoSerifCJK-Bold.ttc \
    -gravity center -fill "#c9a227" -pointsize 52 -annotate +0-18 "艾薇拉" \
    -fill "#f2ead2" -pointsize 24 -annotate +0+55 "恐怖劇場" $APP/scummvm.png 2>/dev/null || convert -size 256x256 xc:black $APP/scummvm.png
  cd /tmp
  ARCH=x86_64 /w/.toolcache/appimagetool --appimage-extract-and-run /tmp/AppDir /w/dist-all/Elvira2-CHT-FULL-x86_64.AppImage 2>&1 | tail -3
  chown -R '"$(id -u):$(id -g)"' /w/dist-all 2>/dev/null || true
'
