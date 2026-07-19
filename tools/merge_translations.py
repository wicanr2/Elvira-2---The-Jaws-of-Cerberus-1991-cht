#!/usr/bin/env python3
# 合併 batches/batch_*.out.tsv → zh.tsv，並驗證:
#   - 每條 id 對齊原始 batch 輸入(id/順序)
#   - Big5 可編碼(逐字檢查,列出非 Big5)
#   - 涵蓋率:抽字 tsv 的每條非空 id 是否都有譯文
# 用法: python3 merge_translations.py <batches_dir> <src_extract.tsv> <out zh.tsv>
import sys, os, glob, re

def load_tsv(path):
    rows = []
    for line in open(path, encoding='utf-8'):
        line = line.rstrip('\n')
        if not line or line.startswith('#'):
            continue
        if '\t' in line:
            sid, txt = line.split('\t', 1)
        else:
            sid, txt = line, ''
        try:
            sid = int(sid)
        except ValueError:
            continue
        rows.append((sid, txt))
    return rows

def main():
    bdir, src, out = sys.argv[1], sys.argv[2], sys.argv[3]
    # 原始抽字(id→英文),判涵蓋率與空字串
    src_rows = load_tsv(src)
    src_map = dict(src_rows)
    need = {sid for sid, t in src_rows if t.strip() != ''}

    merged = {}
    problems = []
    nonbig5 = []
    # 逐 batch 對齊輸入
    for outf in sorted(glob.glob(os.path.join(bdir, 'batch_*.out.tsv')),
                       key=lambda p: int(re.search(r'batch_(\d+)', p).group(1))):
        inf = outf.replace('.out.tsv', '.tsv')
        bnum = re.search(r'batch_(\d+)', outf).group(1)
        oin = load_tsv(inf)
        oout = load_tsv(outf)
        if len(oin) != len(oout):
            problems.append(f"batch_{bnum}: 行數不符 輸入{len(oin)} 輸出{len(oout)}")
        for i, (isid, _) in enumerate(oin):
            if i >= len(oout):
                break
            osid, otxt = oout[i]
            if isid != osid:
                problems.append(f"batch_{bnum} 第{i+1}行 id 錯位: 期望{isid} 得到{osid}")
                continue
            # Big5 檢查
            for ch in otxt:
                try:
                    ch.encode('big5')
                except UnicodeEncodeError:
                    nonbig5.append((osid, ch, otxt))
            merged[osid] = otxt

    # 寫 zh.tsv (依 id 排序)
    with open(out, 'w', encoding='utf-8') as f:
        for sid in sorted(merged):
            f.write(f"{sid}\t{merged[sid]}\n")

    # 涵蓋率
    missing = sorted(need - set(merged))
    print(f"=== 合併結果 ===")
    print(f"合併譯文: {len(merged)} 條 → {out}")
    print(f"需翻(非空原文): {len(need)} 條")
    print(f"缺漏(需翻但無譯文): {len(missing)} 條")
    if missing[:20]:
        print("  缺漏 id 樣本:", missing[:20])
    print(f"對齊問題: {len(problems)}")
    for p in problems[:20]:
        print("  ", p)
    print(f"非 Big5 字元: {len(nonbig5)}")
    seen = set()
    for sid, ch, txt in nonbig5:
        if ch not in seen:
            seen.add(ch)
            print(f"   id {sid}: '{ch}' (U+{ord(ch):04X}) in: {txt[:40]}")

if __name__ == '__main__':
    main()
