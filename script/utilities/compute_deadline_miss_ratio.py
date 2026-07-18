#!/usr/bin/env python3
import argparse
import pandas as pd

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--csv", required=True)
    parser.add_argument("--latency-column", default="latency_ms")
    parser.add_argument("--deadline-ms", type=float, required=True)
    parser.add_argument("--out", required=True)
    args = parser.parse_args()

    df = pd.read_csv(args.csv)
    if args.latency_column not in df.columns:
        raise ValueError(f"Missing latency column: {args.latency_column}")

    df["deadline_miss"] = (df[args.latency_column] > args.deadline_ms).astype(int)
    ratio = df["deadline_miss"].mean()

    summary = pd.DataFrame([{
        "input_csv": args.csv,
        "latency_column": args.latency_column,
        "deadline_ms": args.deadline_ms,
        "runs": len(df),
        "deadline_miss_count": int(df["deadline_miss"].sum()),
        "deadline_miss_ratio": ratio
    }])

    summary.to_csv(args.out, index=False)
    print(summary.to_string(index=False))

if __name__ == "__main__":
    main()
