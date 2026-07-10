"""FRED 多指标宏观数据抓取工具"""
import pandas as pd
from fredapi import Fred

fred = Fred(api_key="13ed18db40445b1c0207670598d71ba1")

SERIES = {
    "PAYEMS": "nonfarm",
    "UNRATE": "unemployment",
    "CPIAUCSL": "cpi",
}

OUTPUT = "F:/AI 金融知识点/02_数据/数据工具/macro_data.csv"

all_data = []
for series_id, name in SERIES.items():
    print(f"Fetching {name} ({series_id})...")
    data = fred.get_series(series_id)
    for date, value in data.items():
        all_data.append({"date": date, "value": round(value, 3), "indicator": name})
    print(f"  -> {len(data)} rows")

df = pd.DataFrame(all_data)
df.to_csv(OUTPUT, index=False)
print(f"\nSaved to {OUTPUT}")
print(df.head(10))
