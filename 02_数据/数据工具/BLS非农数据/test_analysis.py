import sys, re
sys.stdout.reconfigure(encoding='utf-8')

SRC = 'F:/AI 金融知识点/02_数据/数据工具/BLS非农数据/news_releases'
DST = 'F:/AI 金融知识点/02_数据/数据工具/BLS非农数据/news_releases_zh'

filepath = SRC + '/empsit_01102025.md'

with open(filepath, 'r', encoding='utf-8') as f:
    content = f.read()

lines = content.split('\n')
print(f'Total lines: {len(lines)}')

# Count translatable text lines
text_lines = []
for i, line in enumerate(lines):
    s = line.strip()
    if not s or s.startswith('|') or s.startswith('---') or s.startswith('```'):
        continue
    # pure numeric lines
    if re.match(r'^[\d\s,.\-;()%\$£€+=*/<>@#&!?\'\"\s]+$', s):
        continue
    alpha = sum(1 for c in s if c.isalpha())
    chinese = sum(1 for c in s if '一' <= c <= '鿿')
    if alpha >= 5 and chinese < alpha:
        text_lines.append(i)

print(f'Lines needing translation: {len(text_lines)}')
print('Sample text lines to translate:')
for idx in text_lines[:5]:
    print(f'  L{idx}: {lines[idx][:80]}')
