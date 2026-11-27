#!/usr/bin/env python3
"""Verify simulation results against reference values. Standard library only."""
import csv
import sys

def read_result(path):
    times, data = [], {}
    with open(path) as f:
        reader = csv.DictReader(f)
        for row in reader:
            t = float(row['time'])
            times.append(t)
            for k, v in row.items():
                if k != 'time':
                    data.setdefault(k, []).append(float(v))
    return times, data

def settling_time(times, signal, final, band=0.02):
    """Last time the signal leaves the 2% band of final value."""
    if not times:
        return None
    thresh = abs(final) * band
    outside = [t for t, s in zip(times, signal) if abs(s - final) > thresh]
    return max(outside) if outside else times[0]

def main():
    times, data = read_result('result.csv')
    refs = []
    with open('reference/reference_values.csv') as f:
        refs = list(csv.DictReader(f))
    all_pass = True
    for r in refs:
        qty = r['quantity']
        var = r['variable']
        exp = float(r['value'])
        tol = float(r['tolerance_pct']) / 100.0
        src = r['source']
        if 'settling' in qty:
            # compute actual settling
            final = data[var][-1]
            act = settling_time(times, data[var], final)
            ok = abs(act - exp) <= tol * abs(exp)
            status = 'PASS' if ok else 'FAIL'
            print(f"{status} {qty}: computed={act:.4f} expected={exp} tol=±{tol*100}% ({src})")
        else:
            # value at end or peak
            if 'overshoot' in qty:
                peak = max(data[var])
                final = data[var][-1]
                act = 100 * (peak - final) / abs(final) if final != 0 else 0
            else:
                act = abs(data[var][-1] - float(r.get('time_s') or data[var][-1]))  # simplified
                # for SS error use last value vs ref
                act = abs(data[var][-1] - 209.43951023931953)
            ok = abs(act - exp) <= tol * max(abs(exp), 1e-6)
            status = 'PASS' if ok else 'FAIL'
            print(f"{status} {qty}: actual={act:.4f} expected={exp} ({src})")
        if not ok:
            all_pass = False
    sys.exit(0 if all_pass else 1)

if __name__ == '__main__':
    main()
