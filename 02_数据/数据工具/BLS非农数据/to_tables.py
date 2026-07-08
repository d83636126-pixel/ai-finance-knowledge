"""Convert BLS data tables from line-by-line to markdown pipe tables."""
import os, re, sys
sys.stdout.reconfigure(encoding='utf-8')

DIR = "F:/AI 金融知识点/02_数据/数据工具/BLS非农数据/news_releases_zh"

MONTHS = ['Jan.', 'Feb.', 'Mar.', 'Apr.', 'May', 'June', 'July', 'Aug.',
          'Sept.', 'Oct.', 'Nov.', 'Dec.', 'Jan', 'Feb', 'Mar', 'Apr',
          'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
MN_CN = {'Jan':'1月','Feb':'2月','Mar':'3月','Apr':'4月','May':'5月',
         'Jun':'6月','Jul':'7月','Aug':'8月','Sep':'9月','Oct':'10月',
         'Nov':'11月','Dec':'12月',
         '一月':'1月','二月':'2月','三月':'3月','四月':'4月','五月':'5月',
         '六月':'6月','七月':'7月','八月':'8月','九月':'9月','十月':'10月',
         '十一月':'11月','十二月':'12月'}

MONTH_CN = ['一月','二月','三月','四月','五月','六月','七月','八月','九月','十月','十一月','十二月']

def is_month(s):
    s = s.strip()
    if s in MONTHS or s in MONTH_CN: return True
    if s.endswith('.') or s.endswith('。'):
        return s[:-1] in MONTHS or s[:-1] in MONTH_CN
    return False

def is_numeric(s):
    s = s.strip().lstrip('$')
    if not s: return False
    return bool(re.match(r'^-?[\d,()]+\.?\d*$', s)) or bool(re.match(r'^\d+\.?\d*$', s))

YEAR_RE = re.compile(r'^\d{4}(\([^)]*\))?$')

def is_label(s):
    s = s.strip()
    if not s or len(s) < 2: return False
    if is_month(s) or is_numeric(s): return False
    if re.match(r'^\[.*\]$', s): return False
    if YEAR_RE.match(s): return False
    return True

def process_file(fp):
    fn = os.path.basename(fp)
    print(f"\n=== {fn} ===", flush=True)

    with open(fp, 'r', encoding='utf-8') as f:
        content = f.read()

    lines = content.split('\n')

    # Find table start lines (must be table headers, not narrative references)
    t_starts = []
    for i, line in enumerate(lines):
        s = line.strip()
        # Match: Table X., Table X-X., 表 X.，表 X-X。 (with period after identifier)
        if re.match(r'^(Table\s+[A-Z][\d-]*[.)]|表\s+[A-Z][\d-]*[.)。])', s):
            t_starts.append(i)
        # Match: Summary table A or 汇总表 A
        elif re.match(r'^(Summary\s+table\s+[A-Z]|汇总表\s+[A-Z])', s):
            t_starts.append(i)

    if not t_starts:
        print("  No tables found", flush=True)
        return

    # Body = lines before first table
    body = lines[:t_starts[0]]
    tables = []
    for idx, s in enumerate(t_starts):
        end = t_starts[idx+1] if idx+1 < len(t_starts) else len(lines)
        tables.append(lines[s:end])

    # Build output: preamble + body + tables
    out = []
    # Title
    out.append(body[0])
    # Metadata (up to ---)
    meta_end = 0
    for i, line in enumerate(body):
        if line.strip() == '---': meta_end = i; break
    if meta_end > 0:
        for line in body[1:meta_end]:
            if line.strip(): out.append(line)
        out.append(''); out.append('---'); out.append('')
    # Rest of body
    for line in body[meta_end+1:]:
        out.append(line)

    # Process each table
    for tbl in tables:
        if not tbl: continue
        title = tbl[0].strip()
        out.append(''); out.append(f'### {title}'); out.append('')
        rest = tbl[1:]
        while rest and not rest[0].strip(): rest.pop(0)

        # Find data start: look for the sequence of subtitle → headers → years → months → data
        data_start = 0
        month_count = 0

        # Phase 1: skip subtitles like [Numbers in thousands]
        pos = 0
        while pos < len(rest):
            s = rest[pos].strip()
            if re.match(r'^\[.*\]$', s) or not s:
                pos += 1
                continue
            break

        # Phase 2: skip year lines (2023, 2024, 2024(p), etc.)
        while pos < len(rest):
            s = rest[pos].strip()
            if YEAR_RE.match(s):
                pos += 1
                continue
            break

        # Phase 3: count months at the end of header
        # The actual month sequence is right before data rows
        # Work backwards from where data should start
        mid_start = pos
        # Find where data labels begin (after the month sequence)
        month_seq_start = None
        for scan in range(mid_start, min(mid_start + 60, len(rest))):
            s = rest[scan].strip()
            if is_month(s):
                month_count += 1
                if month_seq_start is None:
                    month_seq_start = scan
            elif s and not YEAR_RE.match(s):
                # If we've found at least 2 months and this is a label, data starts here
                if month_count >= 2 and is_label(s):
                    data_start = scan
                    break
                month_count = 0
                month_seq_start = None

        if month_count == 0:
            for line in tbl: out.append(line)
            out.append('')
            continue

        # Build month names from header area
        month_names = []
        for line in rest[:data_start]:
            s = line.strip()
            if is_month(s):
                lookup = s.rstrip('.。')
                month_names.append(MN_CN.get(lookup, s))

        # Scan from data_start to find the first data row label
        # (skip sub-header lines like "Change from:", "AVERAGE WEEKLY HOURS")
        data_scan = data_start
        while data_scan < len(rest):
            s = rest[data_scan].strip()
            if not s or is_month(s) or YEAR_RE.match(s):
                data_scan += 1
                continue
            if is_numeric(s):
                break  # reached a stray value, stop
            # Check if next non-blank non-month non-year is numeric → this is a data row label
            next_found = None
            for j in range(data_scan + 1, len(rest)):
                ns = rest[j].strip()
                if ns and not is_month(ns) and not YEAR_RE.match(ns):
                    next_found = ns
                    break
            if next_found and is_numeric(next_found):
                break  # This label starts data rows
            data_scan += 1

        # Count actual data columns from the first data row
        actual_cols = 0
        for j in range(data_scan + 1, min(data_scan + 100, len(rest))):
            s = rest[j].strip()
            if is_numeric(s):
                actual_cols += 1
            elif s:
                break

        # Determine effective column count
        total_cols = actual_cols if actual_cols > 0 else month_count

        # Build header names from months, pad with generics for extra columns
        header_names = list(month_names)
        while len(header_names) < total_cols:
            header_names.append(f'M{len(header_names)+1}')
        headers = ['分类'] + header_names[:total_cols]

        # Group label + N values into rows (use data_scan as actual data start)
        rows = []
        label = None
        vals = []
        for line in rest[data_scan:]:
            s = line.strip()
            if not s: continue
            if is_numeric(s):
                if label is None: continue
                vals.append(s)
                if len(vals) == total_cols:
                    rows.append((label, vals)); label = None; vals = []
            elif is_label(s):
                if label and vals: rows.append((label, vals))
                label = s; vals = []

        if label and vals: rows.append((label, vals))

        if rows:
            out.append(f'| {" | ".join(headers)} |')
            out.append('|' + '|'.join(['---']*len(headers)) + '|')
            for l, vs in rows:
                out.append(f'| {l} | {" | ".join(v.lstrip("$") for v in vs)} |')
        else:
            for line in tbl: out.append(line)
        out.append('')

    with open(fp, 'w', encoding='utf-8') as f:
        f.write('\n'.join(out))
    print(f"  Done: {len(out)} lines, {len(tables)} tables", flush=True)

def main():
    files = sorted([f for f in os.listdir(DIR) if f.endswith('.md')])
    print(f"Processing {len(files)} files", flush=True)
    for fn in files:
        process_file(os.path.join(DIR, fn))
    print(f"\nAll done!", flush=True)

if __name__ == '__main__':
    main()
