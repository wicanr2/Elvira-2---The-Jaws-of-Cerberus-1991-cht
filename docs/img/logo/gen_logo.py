# -*- coding: utf-8 -*-
"""產生《艾薇拉 II - 恐怖劇場》中文標題 logo SVG(呼應當年軟體世界美術字風格)。"""

CJK_SANS = "Noto Sans CJK TC"     # 黑體最重,poster 感
CJK_SERIF = "Noto Serif CJK TC"   # 哥德襯線,英文副標

def extrusion(text, x, y, size, ls, depth, color):
    """3D 立體擠出:多層往右下偏移的暗色副本。"""
    out = []
    for i in range(depth, 0, -1):
        dx = i * 0.9
        dy = i * 0.9
        out.append(
            f'<text x="{x+dx:.1f}" y="{y+dy:.1f}" font-family="{CJK_SANS}" '
            f'font-weight="900" font-size="{size}" letter-spacing="{ls}" '
            f'text-anchor="middle" fill="{color}">{text}</text>'
        )
    return "\n".join(out)

def build(mode):
    """mode: 'dark' | 'transparent'"""
    W, H = 1200, 620
    main_txt = "恐怖劇場"
    top_txt = "艾薇拉 II"
    eng_txt = "ELVIRA II · THE JAWS OF CERBERUS"

    cx = W / 2
    main_size = 206
    main_ls = 14
    main_y = 360
    skew = -6   # 微微右傾,呼應手繪恐怖片海報動勢

    defs = f'''
  <defs>
    <linearGradient id="magenta" x1="0" y1="0" x2="0" y2="1">
      <stop offset="0"   stop-color="#ff7ad9"/>
      <stop offset="0.32" stop-color="#f43ab6"/>
      <stop offset="0.62" stop-color="#c4148f"/>
      <stop offset="1"   stop-color="#6f1580"/>
    </linearGradient>
    <linearGradient id="gold" x1="0" y1="0" x2="0" y2="1">
      <stop offset="0" stop-color="#ffe9a8"/>
      <stop offset="0.5" stop-color="#e8b020"/>
      <stop offset="1" stop-color="#a86e10"/>
    </linearGradient>
    <linearGradient id="blood" x1="0" y1="0" x2="0" y2="1">
      <stop offset="0" stop-color="#c8121e"/>
      <stop offset="1" stop-color="#63000a"/>
    </linearGradient>
    <radialGradient id="ember" cx="0.5" cy="0.5" r="0.6">
      <stop offset="0"   stop-color="#ff5a12" stop-opacity="0.55"/>
      <stop offset="0.4" stop-color="#c21a10" stop-opacity="0.30"/>
      <stop offset="1"   stop-color="#c21a10" stop-opacity="0"/>
    </radialGradient>
    <radialGradient id="bg" cx="0.5" cy="0.42" r="0.85">
      <stop offset="0" stop-color="#2c0810"/>
      <stop offset="0.6" stop-color="#160309"/>
      <stop offset="1" stop-color="#070206"/>
    </radialGradient>
    <filter id="soft" x="-30%" y="-30%" width="160%" height="160%">
      <feGaussianBlur stdDeviation="6"/>
    </filter>
    <filter id="iceglow" x="-40%" y="-40%" width="180%" height="180%">
      <feGaussianBlur stdDeviation="2"/>
    </filter>
    <clipPath id="mainClip">
      <text x="{cx}" y="{main_y}" font-family="{CJK_SANS}" font-weight="900"
            font-size="{main_size}" letter-spacing="{main_ls}"
            text-anchor="middle" transform="skewX({skew})"
            transform-origin="{cx} {main_y}">{main_txt}</text>
    </clipPath>
  </defs>'''

    # 背景
    bg = ""
    if mode == "dark":
        bg = f'''
  <rect width="{W}" height="{H}" fill="url(#bg)"/>
  <ellipse cx="{cx}" cy="320" rx="520" ry="240" fill="url(#ember)" filter="url(#soft)"/>
  <g stroke="#8a0f10" stroke-linecap="round" fill="none" opacity="0.5">
    <path d="M60 60 C 240 200, 470 350, 560 540" stroke-width="7"/>
    <path d="M120 50 C 300 190, 520 340, 610 530" stroke-width="4"/>
    <path d="M20 110 C 200 240, 420 390, 500 560" stroke-width="3"/>
  </g>
  <g stroke="#8a0f10" stroke-linecap="round" fill="none" opacity="0.4" transform="translate(1200,0) scale(-1,1)">
    <path d="M60 60 C 240 200, 470 350, 560 540" stroke-width="6"/>
    <path d="M120 50 C 300 190, 520 340, 610 530" stroke-width="3.5"/>
  </g>'''
    elif mode == "transparent":
        # 純去背:不加光暈,靠黑描邊在任意底上分離,最泛用
        bg = ""

    # 頂部 艾薇拉 II(金色 + 黑描邊)
    top = f'''
  <text x="{cx}" y="132" font-family="{CJK_SANS}" font-weight="900" font-size="74"
        letter-spacing="26" text-anchor="middle" fill="none" stroke="#1a0206"
        stroke-width="9" paint-order="stroke" stroke-linejoin="round">{top_txt}</text>
  <text x="{cx}" y="132" font-family="{CJK_SANS}" font-weight="900" font-size="74"
        letter-spacing="26" text-anchor="middle" fill="url(#gold)">{top_txt}</text>'''

    # 血滴(貼在主體底緣,結束於英文之上)
    drip_specs = [(378, 430, 15, 62), (556, 432, 12, 50),
                  (742, 428, 11, 44), (900, 430, 14, 58)]
    d = []
    for dx, dy, r, ln in drip_specs:
        d.append(
            f'<path d="M{dx-r} {dy} '
            f'C{dx-r} {dy+ln*0.55}, {dx-r*0.5} {dy+ln}, {dx} {dy+ln} '
            f'C{dx+r*0.5} {dy+ln}, {dx+r} {dy+ln*0.55}, {dx+r} {dy} '
            f'C{dx+r} {dy-r*0.8}, {dx-r} {dy-r*0.8}, {dx-r} {dy} Z" '
            f'fill="url(#blood)" stroke="#2a0004" stroke-width="1.5"/>'
        )
        d.append(f'<circle cx="{dx}" cy="{dy+ln+14}" r="{r*0.4:.1f}" fill="url(#blood)" stroke="#2a0004" stroke-width="1"/>')
    drips = "  <g opacity=\"0.95\">\n    " + "\n    ".join(d) + "\n  </g>"

    # 主體 恐怖劇場:擠出 → 黑描邊+漸層 → 斜向高光 → 細邊
    main = f'''
  <g transform="skewX({skew})" transform-origin="{cx} {main_y}">
    {extrusion(main_txt, cx, main_y, main_size, main_ls, 11, "#3a0210")}
    <text x="{cx}" y="{main_y}" font-family="{CJK_SANS}" font-weight="900"
          font-size="{main_size}" letter-spacing="{main_ls}" text-anchor="middle"
          fill="url(#magenta)" stroke="#0c0206" stroke-width="10"
          paint-order="stroke" stroke-linejoin="round">{main_txt}</text>
    <text x="{cx}" y="{main_y}" font-family="{CJK_SANS}" font-weight="900"
          font-size="{main_size}" letter-spacing="{main_ls}" text-anchor="middle"
          fill="none" stroke="#3a0016" stroke-width="1.2">{main_txt}</text>
  </g>
  <!-- 斜向白色高光條,clip 在主體字內(clip 已含 skew) -->
  <g clip-path="url(#mainClip)">
    <g fill="#ffffff">
      <rect x="0" y="{main_y-150}" width="1200" height="11" opacity="0.5"
            transform="rotate(-30 {cx} {main_y})"/>
      <rect x="0" y="{main_y-186}" width="1200" height="5" opacity="0.35"
            transform="rotate(-30 {cx} {main_y})"/>
    </g>
  </g>'''

    # 英文副標(冰藍哥德襯線斜體,呼應原版 logo)
    eng = f'''
  <g filter="url(#iceglow)">
    <text x="{cx}" y="522" font-family="{CJK_SERIF}" font-style="italic" font-weight="700"
          font-size="35" letter-spacing="7" text-anchor="middle"
          fill="none" stroke="#0a1830" stroke-width="5" paint-order="stroke">{eng_txt}</text>
    <text x="{cx}" y="522" font-family="{CJK_SERIF}" font-style="italic" font-weight="700"
          font-size="35" letter-spacing="7" text-anchor="middle" fill="#d6ecff">{eng_txt}</text>
  </g>'''

    return f'''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {W} {H}" width="{W}" height="{H}">{defs}
{bg}
{top}
{main}
{drips}
{eng}
</svg>'''


def build_ingame():
    """320px 遊戲內疊層版:高對比、粗描邊、去細節。viewBox 640x300。"""
    W, H = 640, 300
    cx = W / 2
    main_size = 132
    main_ls = 8
    main_y = 200
    defs = f'''
  <defs>
    <linearGradient id="magenta2" x1="0" y1="0" x2="0" y2="1">
      <stop offset="0" stop-color="#ff8ce0"/>
      <stop offset="0.45" stop-color="#f43ab6"/>
      <stop offset="1" stop-color="#8a1786"/>
    </linearGradient>
    <linearGradient id="gold2" x1="0" y1="0" x2="0" y2="1">
      <stop offset="0" stop-color="#ffe9a8"/>
      <stop offset="1" stop-color="#c8901e"/>
    </linearGradient>
  </defs>'''
    top = f'''
  <text x="{cx}" y="70" font-family="{CJK_SANS}" font-weight="900" font-size="44"
        letter-spacing="16" text-anchor="middle" fill="none" stroke="#000" stroke-width="8"
        paint-order="stroke" stroke-linejoin="round">艾薇拉 II</text>
  <text x="{cx}" y="70" font-family="{CJK_SANS}" font-weight="900" font-size="44"
        letter-spacing="16" text-anchor="middle" fill="url(#gold2)">艾薇拉 II</text>'''
    ext = extrusion("恐怖劇場", cx, main_y, main_size, main_ls, 6, "#2a0210")
    main = f'''
  <g transform="skewX(-6)" transform-origin="{cx} {main_y}">
    {ext}
    <text x="{cx}" y="{main_y}" font-family="{CJK_SANS}" font-weight="900" font-size="{main_size}"
          letter-spacing="{main_ls}" text-anchor="middle" fill="url(#magenta2)"
          stroke="#000" stroke-width="9" paint-order="stroke" stroke-linejoin="round">恐怖劇場</text>
  </g>'''
    eng = f'''
  <text x="{cx}" y="256" font-family="{CJK_SERIF}" font-style="italic" font-weight="700"
        font-size="21" letter-spacing="2" text-anchor="middle" fill="none" stroke="#06101f"
        stroke-width="4.5" paint-order="stroke">The Jaws of Cerberus</text>
  <text x="{cx}" y="256" font-family="{CJK_SERIF}" font-style="italic" font-weight="700"
        font-size="21" letter-spacing="2" text-anchor="middle" fill="#d6ecff">The Jaws of Cerberus</text>'''
    return f'''<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 {W} {H}" width="{W}" height="{H}">{defs}
{top}
{main}
{eng}
</svg>'''


import os
base = os.path.dirname(os.path.abspath(__file__))
open(os.path.join(base, "logo_dark.svg"), "w").write(build("dark"))
open(os.path.join(base, "logo_transparent.svg"), "w").write(build("transparent"))
open(os.path.join(base, "logo_ingame.svg"), "w").write(build_ingame())
print("SVG written")
