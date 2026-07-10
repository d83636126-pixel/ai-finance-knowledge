"""
Convert BLS translated files to clean readable format.
- Body text: reflowed into proper paragraphs
- Data tables: organized with clear headers in monospace blocks
"""
import os
import re
import sys
sys.stdout.reconfigure(encoding='utf-8')

SRC_DIR = "F:/AI 金融知识点/02_数据/数据工具/BLS非农数据/news_releases_zh"
DST_DIR = "F:/AI 金融知识点/02_数据/数据工具/BLS非农数据/news_releases_zh"

TABLE_HEADER_RE = re.compile(r'^(Table |表 )')
SECTION_RE = re.compile(r'^(HOUSEHOLD DATA|ESTABLISHMENT DATA|家庭数据|企业数据)$')
NOTE_RE = re.compile(r'^(\(p\)|注|NOTE:|Note:)')


def process_file(filepath):
    filename = os.path.basename(filepath)
    print(f"Processing: {filename}", flush=True)

    with open(filepath, 'r', encoding='utf-8') as f:
        lines = f.readlines()

    # Remove trailing newlines
    lines = [l.rstrip('\n') for l in lines]

    # Find preamble boundary: title + metadata (first ~9 lines)
    preamble_end = 0
    for i, line in enumerate(lines):
        if line.strip() == '---' and i > 0:
            preamble_end = i + 1
            break
    if preamble_end == 0:
        preamble_end = 9

    # Extract preamble
    preamble = lines[:preamble_end]

    # Everything after preamble is body + tables
    content = lines[preamble_end:]

    # Remove leading blank lines
    while content and content[0].strip() == '':
        content.pop(0)

    # Build output
    output = []
    output.extend(preamble)
    if output and output[-1].strip() != '':
        output.append('')

    # Process content: separate into blocks
    i = 0
    in_table = False
    table_buffer = []
    paragraph_buffer = []

    def flush_paragraph():
        nonlocal paragraph_buffer
        if not paragraph_buffer:
            return
        # Join lines into clean paragraph
        text = ' '.join(paragraph_buffer)
        # Clean up extra spaces
        text = re.sub(r'\s+', ' ', text).strip()
        if text:
            output.append('')
            output.append(text)
            output.append('')
        paragraph_buffer = []

    def flush_table():
        nonlocal table_buffer
        if not table_buffer:
            return
        # Skip if it's just a section marker
        if len(table_buffer) == 1 and SECTION_RE.match(table_buffer[0].strip()):
            output.append('')
            output.append(f'## {table_buffer[0].strip()}')
            output.append('')
            table_buffer = []
            return

        # Check if it's a standalone note line
        if len(table_buffer) == 1 and NOTE_RE.match(table_buffer[0].strip()):
            output.append(table_buffer[0])
            table_buffer = []
            return

        # Check if entire table is just labels (no numeric data) - output as-is
        has_data = any(re.search(r'\d,\d{3}', l) or re.search(r'\d+\.\d', l) for l in table_buffer)

        output.append('')
        # Use the first line as table title
        title = table_buffer[0].strip() if table_buffer else ''

        if not has_data and len(table_buffer) < 5:
            # Short non-data block: just output lines
            for line in table_buffer:
                if line.strip():
                    output.append(line)
            output.append('')
        else:
            # Data table: wrap in code block for monospace alignment
            output.append(f'**{title}**')
            output.append('')
            output.append('```')
            for line in table_buffer[1:]:
                output.append(line.rstrip())
            output.append('```')
            output.append('')

        table_buffer = []

    while i < len(content):
        line = content[i]
        stripped = line.strip()

        # Section markers
        if SECTION_RE.match(stripped):
            flush_paragraph()
            flush_table()
            output.append(f'## {stripped}')
            output.append('')
            i += 1
            continue

        # Table header
        if TABLE_HEADER_RE.match(stripped):
            flush_paragraph()
            flush_table()
            in_table = True
            table_buffer.append(stripped)
            i += 1
            continue

        # Blank line
        if not stripped:
            if in_table:
                # Keep blank lines within tables sometimes
                table_buffer.append('')
            else:
                flush_paragraph()
            i += 1
            continue

        # Footnote line (single note)
        if NOTE_RE.match(stripped):
            if in_table:
                table_buffer.append(stripped)
            else:
                flush_paragraph()
                output.append(stripped)
                output.append('')
            i += 1
            continue

        # Line with data (numbers + some text)
        has_data = bool(re.search(r'\d', stripped))

        if in_table:
            is_table_title = TABLE_HEADER_RE.match(stripped) or \
                             re.match(r'^\[.*\]$', stripped) or \
                             stripped in ['2023', '2024', '2025', '2026'] or \
                             re.match(r'^[A-Z][a-z]+\.?$', stripped)  # month: Dec., Jan., etc.

            # Check if this line looks like a footnote/continuation
            if stripped.startswith('(') and stripped.endswith(')') and len(stripped) < 20:
                table_buffer.append(stripped)
            elif stripped.startswith('(1)') or stripped.startswith('(2)') or stripped.startswith('(3)'):
                # Table footnotes at end
                table_buffer.append(stripped)
            else:
                # Regular table line
                table_buffer.append(stripped)
        else:
            # Body text line
            if stripped.startswith('> '):
                flush_paragraph()
                output.append(stripped)
            else:
                paragraph_buffer.append(stripped)

        i += 1

    flush_paragraph()
    flush_table()

    # Remove trailing blank lines
    while output and output[-1] == '':
        output.pop()
    output.append('')

    output_path = os.path.join(DST_DIR, filename)
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write('\n'.join(output))

    print(f"  Done: {filename} ({len(output)} lines)", flush=True)


def main():
    files = sorted([f for f in os.listdir(SRC_DIR) if f.endswith('.md')])
    print(f"Reformatting {len(files)} files\n", flush=True)
    for filename in files:
        process_file(os.path.join(SRC_DIR, filename))
    print(f"\nAll done!", flush=True)

if __name__ == '__main__':
    main()
