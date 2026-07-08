"""
Translate BLS Employment Situation news releases from English to Chinese.
Optimized with paragraph-level batching for efficiency.
"""
import os
import re
import time
import sys
sys.stdout.reconfigure(encoding='utf-8')

from deep_translator import GoogleTranslator

SRC_DIR = "F:/AI 金融知识点/02_数据/数据工具/BLS非农数据/news_releases"
DST_DIR = "F:/AI 金融知识点/02_数据/数据工具/BLS非农数据/news_releases_zh"
os.makedirs(DST_DIR, exist_ok=True)

translator = GoogleTranslator(source='en', target='zh-CN')

URL_RE = re.compile(r'https?://\S+')

def is_translatable_line(s):
    """Check if a line is primarily English text that should be translated."""
    if not s or len(s) < 3:
        return False
    # Table rows
    if s.startswith('|'):
        return False
    # Frontmatter
    if s == '---':
        return False
    if s.startswith('type:') or s.startswith('tags:') or s.startswith('source_url:') or s.startswith('fetched_at:'):
        return False
    # Code block markers
    if s.startswith('```'):
        return False
    # URLs
    if URL_RE.fullmatch(s):
        return False
    # Mostly numbers/symbols
    alpha = sum(1 for c in s if c.isalpha())
    if alpha < 5:
        return False
    # Already Chinese
    chinese = sum(1 for c in s if '一' <= c <= '鿿')
    if chinese > alpha:
        return False
    return True

def translate_batch(texts):
    """Translate a batch of texts with retries."""
    if not texts:
        return texts
    combined = '\n'.join(texts)
    for attempt in range(3):
        try:
            result = translator.translate(combined)
            time.sleep(0.5)
            # Split back
            translated = result.split('\n')
            # If lengths mismatch, return as single item
            if len(translated) != len(texts):
                return [result]
            return translated
        except Exception as e:
            print(f"  Retry {attempt+1}: {e}", flush=True)
            time.sleep(3)
    return texts  # fallback

def translate_line(s):
    """Translate a single line."""
    if not is_translatable_line(s):
        return s
    for attempt in range(3):
        try:
            result = translator.translate(s)
            time.sleep(0.3)
            return result
        except Exception as e:
            print(f"  Retry {attempt+1}: {e}", flush=True)
            time.sleep(2)
    return s

def process_file(filepath):
    filename = os.path.basename(filepath)
    print(f"\n=== Processing: {filename} ===", flush=True)

    with open(filepath, 'r', encoding='utf-8') as f:
        lines = f.readlines()

    output_lines = list(lines)  # start with copy
    translatable_indices = []

    for i, line in enumerate(lines):
        s = line.strip()
        if is_translatable_line(s) and not s.startswith('#'):
            translatable_indices.append(i)

    print(f"  Lines to translate: {len(translatable_indices)}", flush=True)

    # Batch translate in groups of 20 for efficiency
    batch_size = 20
    translated_count = 0
    for batch_start in range(0, len(translatable_indices), batch_size):
        batch_indices = translatable_indices[batch_start:batch_start + batch_size]
        batch_texts = [lines[i].strip() for i in batch_indices]

        results = translate_batch(batch_texts)

        if len(results) == len(batch_indices):
            for idx, result in zip(batch_indices, results):
                indent = lines[idx][:len(lines[idx]) - len(lines[idx].lstrip())]
                output_lines[idx] = indent + result + '\n'
            translated_count += len(batch_indices)
        else:
            # Fallback to line-by-line
            for idx in batch_indices:
                output_lines[idx] = translate_line(lines[idx].strip()) + '\n'
            translated_count += len(batch_indices)

        if translated_count % 100 == 0:
            print(f"  Progress: {translated_count}/{len(translatable_indices)}", flush=True)

    # Translate headers separately
    header_indices = [i for i, line in enumerate(lines)
                      if is_translatable_line(line.strip()) and line.strip().startswith('#')]
    for i in header_indices:
        s = lines[i].strip()
        hashes = re.match(r'^#+', s).group()
        content = s[len(hashes):].strip()
        translated = translate_line(content)
        output_lines[i] = hashes + ' ' + translated + '\n'

    output_path = os.path.join(DST_DIR, filename)
    with open(output_path, 'w', encoding='utf-8') as f:
        f.writelines(output_lines)

    print(f"  Completed: {filename}", flush=True)
    return True

def main():
    files = sorted([f for f in os.listdir(SRC_DIR) if f.endswith('.md')])
    print(f"Found {len(files)} .md files to translate", flush=True)

    for filename in files:
        filepath = os.path.join(SRC_DIR, filename)
        process_file(filepath)
        time.sleep(2)

    print(f"\nAll done! Files saved to: {DST_DIR}", flush=True)

if __name__ == '__main__':
    main()
