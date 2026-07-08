import sys
sys.stdout.reconfigure(encoding='utf-8')

filepath = 'F:/AI 金融知识点/02_数据/数据工具/BLS非农数据/news_releases_zh/empsit_01102025.md'
with open(filepath, 'r', encoding='utf-8') as f:
    lines = f.readlines()

cb_start = 48
print('=== First lines inside code block ===')
for i in range(cb_start+1, min(cb_start+16, len(lines))):
    print(f'L{i}: {lines[i].rstrip()}')

print()
print('=== Preamble (lines 6-48) ===')
for i in range(6, cb_start):
    print(f'L{i}: {lines[i].rstrip()}')
