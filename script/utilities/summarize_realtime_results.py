#!/usr/bin/env python3
import argparse
import pandas as pd

def pick_col(df, candidates):
    for c in candidates:
        if c in df.columns:
            return c
    return None

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--csv", required=True)
    parser.add_argument("--out", required=True)
    args = parser.parse_args()

    df = pd.read_csv(args.csv)

    latency_col = pick_col(df, ["latency_ms", "wall_time_ms", "elapsed_ms"])
    throughput_col = pick_col(df, ["tokens_per_second", "throughput_tps", "tps"])
    accuracy_col = pick_col(df, ["accuracy", "exact_match", "correct"])

    row = {
        "input_csv": args.csv,
        "runs": len(df),
    }

    if latency_col:
        row["latency_mean_ms"] = df[latency_col].mean()
        row["latency_std_ms"] = df[latency_col].std()
        row["latency_min_ms"] = df[latency_col].min()
        row["latency_max_ms"] = df[latency_col].max()

    if throughput_col:
        row["throughput_mean"] = df[throughput_col].mean()

    if accuracy_col:
        row["accuracy_mean"] = df[accuracy_col].mean()

    pd.DataFrame([row]).to_csv(args.out, index=False)
    print(pd.DataFrame([row]).to_string(index=False))

if __name__ == "__main__":
    main()
