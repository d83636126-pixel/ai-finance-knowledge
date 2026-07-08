"""
Translate BLS news releases directly to clean BLS-style format.
Reads from news_releases/, writes to news_releases_zh/.
Output: title + metadata + body text + data tables (no frontmatter, no code blocks).
"""
import os
import re
import sys
import time
sys.stdout.reconfigure(encoding='utf-8')

from deep_translator import GoogleTranslator

SRC = "F:/AI 金融知识点/02_数据/数据工具/BLS非农数据/news_releases"
DST = "F:/AI 金融知识点/02_数据/数据工具/BLS非农数据/news_releases_zh"
os.makedirs(DST, exist_ok=True)

t = GoogleTranslator(source='en', target='zh-CN')

URL_RE = re.compile(r'https?://\S+')

def translatable(s):
    """Check if a text line should be translated."""
    if not s or len(s) < 4:
        return False
    if s.startswith('|'):
        return False
    if s.startswith('---') or s.startswith('type:') or s.startswith('tags:') or s.startswith('source_url:') or s.startswith('fetched_at:'):
        return False
    if s.startswith('```'):
        return False
    if URL_RE.fullmatch(s):
        return False
    alpha = sum(1 for c in s if c.isalpha())
    if alpha < 4:
        return False
    chinese = sum(1 for c in s if '一' <= c <= '鿿')
    if chinese > alpha:
        return False
    return True

def translate(text, retries=2):
    for attempt in range(retries + 1):
        try:
            r = t.translate(text)
            time.sleep(0.35)
            return r
        except Exception as e:
            if attempt < retries:
                time.sleep(2)
            else:
                return text

def translate_batch(texts):
    if not texts:
        return texts
    combined = '\n'.join(texts)
    r = translate(combined)
    parts = r.split('\n')
    if len(parts) == len(texts):
        return parts
    # fallback individual
    return [translate(t) for t in texts]

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
    print(f"\n=== {filename} ===", flush=True)

    with open(filepath, 'r', encoding='utf-8') as f:
        lines = f.readlines()
    lines = [l.rstrip('\n') for l in lines]

    # Extract code block content
    cb_start, cb_end = find_code_block(lines)
    if cb_start == -1 or cb_end == -1:
        print("  No code block, skipping", flush=True)
        return

    body = lines[cb_start+1:cb_end]

    # Strip leading blank lines from body
    while body and body[0].strip() == '':
        body.pop(0)

    # Get title from preamble (line 7)
    title_en = lines[7].strip().lstrip('# ') if len(lines) > 7 else ''

    # 1. Translate title
    print(f"  Translating title...", flush=True)
    title_zh = translate(title_en)

    # 2. Build metadata from preamble (source lines 11-14)
    metadata = []
    for i in range(11, 15):
        if i < len(lines):
            s = lines[i].strip()
            if s.startswith('- ') or s.startswith('  - '):
                metadata.append(s)

    # 3. Translate body lines in batches
    translatable_indices = []
    for i, line in enumerate(body):
        if translatable(line):
            translatable_indices.append(i)

    print(f"  Translating {len(translatable_indices)} lines...", flush=True)

    batch_size = 15
    output_body = list(body)

    for start in range(0, len(translatable_indices), batch_size):
        batch = translatable_indices[start:start+batch_size]
        texts = [body[i].strip() for i in batch]
        results = translate_batch(texts)
        if len(results) == len(batch):
            for idx, result in zip(batch, results):
                output_body[idx] = result
        else:
            for idx in batch:
                output_body[idx] = translate(body[idx].strip())

        if (start + batch_size) % 150 == 0:
            print(f"    {min(start+batch_size, len(translatable_indices))}/{len(translatable_indices)}", flush=True)

    # 4. Write output - clean BLS format
    out_path = os.path.join(DST, filename)
    with open(out_path, 'w', encoding='utf-8') as f:
        f.write(f'# {title_zh}\n\n')
        for m in metadata:
            f.write(f'{m}\n')
        f.write('\n---\n\n')
        for line in output_body:
            f.write(line.rstrip() + '\n')

    print(f"  Done! {len(body)} lines", flush=True)

def main():
    files = sorted([f for f in os.listdir(SRC) if f.endswith('.md')])
    print(f"Translating {len(files)} files from {SRC}", flush=True)
    for fn in files:
        process_file(os.path.join(SRC, fn))
        time.sleep(1)
    print(f"\nAll done! Saved to {DST}", flush=True)

if __name__ == '__main__':
    main()
