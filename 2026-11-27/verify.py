#!/usr/bin/env python3
"""Verify simulation results against reference values from the paper.
Standard library only. Exit 0 only if all quantities PASS.
"""
import csv
import sys

def read_result(path):
    times, data = [], {}
    with open(path) as f:
        reader = csv.DictReader(f)
        for row in reader:
            t = float(row["time"])
            times.append(t)
            for k, v in row.items():
                if k != "time":
                    data.setdefault(k, []).append(float(v))
    return times, data

def settling_time(times, signal, final, band=0.02):
    thresh = abs(final) * band
    outside = [i for i, s in enumerate(signal) if abs(s - final) > thresh]
    if not outside:
        return 0.0
    return times[outside[-1]]

def overshoot(signal, final):
    peak = max(signal) if final >= 0 else min(signal)
    return 100.0 * (peak - final) / abs(final) if final != 0 else 0.0

def rise_time(times, signal, final):
    t10 = t90 = None
    for t, s in zip(times, signal):
        if t10 is None and s >= 0.1 * final:
            t10 = t
        if t90 is None and s >= 0.9 * final:
            t90 = t
            break
    return (t90 - t10) if (t10 is not None and t90 is not None) else float("inf")

def main():
    times, data = read_result("result.csv")
    refs = []
    with open("reference/reference_values.csv") as f:
        refs = list(csv.DictReader(f))

    all_pass = True
    for ref in refs:
        qty = ref["quantity"]
        var = ref["variable"]
        target = float(ref["value"])
        tol = float(ref["tolerance_pct"])
        src = ref["source"]
        sig = data[var]
        final = sig[-1]

        if "settling" in qty:
            actual = settling_time(times, sig, final)
        elif "overshoot" in qty:
            actual = overshoot(sig, final)
        elif "rise" in qty:
            actual = rise_time(times, sig, final)
        else:
            actual = final

        err_pct = abs(actual - target) / abs(target) * 100 if target != 0 else 0
        status = "PASS" if err_pct <= tol else "FAIL"
        if status == "FAIL":
            all_pass = False
        print(f"{status} {qty}: actual={actual:.4g} target={target} tol={tol}% ({src})")

    sys.exit(0 if all_pass else 1)

if __name__ == "__main__":
    main()
