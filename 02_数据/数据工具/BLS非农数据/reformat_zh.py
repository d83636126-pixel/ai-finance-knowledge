"""
Reformat translated BLS news releases to match BLS web page display format.
Removes frontmatter, TOC tables list, and code block wrappers.
Outputs clean BLS-style format: title + metadata + full release text + data tables.
"""
import os
import sys
sys.stdout.reconfigure(encoding='utf-8')

SRC_DIR = "F:/AI 金融知识点/02_数据/数据工具/BLS非农数据/news_releases_zh"
DST_DIR = SRC_DIR  # overwrite in-place

def find_code_block(lines):
    start = end = -1
    for i, line in enumerate(lines):
        if line.strip().startswith('```'):
            if start == -1:
                start = i
            else:
                end = i
                break
    return start, end

def process_file(filepath):
    filename = os.path.basename(filepath)
    print(f"Processing: {filename}", flush=True)

    with open(filepath, 'r', encoding='utf-8') as f:
        lines = f.readlines()

    cb_start, cb_end = find_code_block(lines)
    if cb_start == -1 or cb_end == -1:
        print(f"  Skipped: no code block", flush=True)
        return

    # ---- Build preamble: title + source metadata only ----
    preamble_out = []

    # Title: line 7 (# 就业形势——...)
    if len(lines) > 7 and lines[7].startswith('# '):
        preamble_out.append(lines[7].rstrip() + '\n\n')

    # Source metadata (lines 11-14): 机构, 网址, USDL, 禁运
    for i in range(11, 15):
        if i < len(lines):
            s = lines[i].rstrip()
            if s.startswith('- '):
                preamble_out.append(s + '\n')
    preamble_out.append('\n---\n\n')

    # ---- Body: everything inside code block ----
    body = lines[cb_start+1:cb_end]

    # Strip leading/trailing blank lines
    while body and body[0].strip() == '':
        body.pop(0)
    while body and body[-1].strip() == '':
        body.pop()

    # Write output
    output_path = os.path.join(DST_DIR, filename)
    with open(output_path, 'w', encoding='utf-8') as f:
        f.writelines(preamble_out)
        for line in body:
            f.write(line)
        f.write('\n')

    print(f"  Done: {filename}  ({len(preamble_out)+len(body)} lines, was {len(lines)})", flush=True)

def main():
    files = sorted([f for f in os.listdir(SRC_DIR) if f.endswith('.md')])
    print(f"Reformatting {len(files)} files\n", flush=True)
    for filename in files:
        process_file(os.path.join(SRC_DIR, filename))
    print(f"\nAll done!", flush=True)

if __name__ == '__main__':
    main()
