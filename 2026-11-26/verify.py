#!/usr/bin/env python3
import csv
import sys

def compute_settling_time(times, values, final, band=0.02):
    if not times:
        return None
    threshold = band * abs(final)
    settling = times[-1]
    for t, v in reversed(list(zip(times, values))):
        if abs(v - final) > threshold:
            settling = t
            break
    return settling

def main():
    try:
        with open('result.csv') as f:
            reader = csv.reader(f)
            header = next(reader)
            try:
                ti = header.index('time')
                xi = header.index('x')
            except:
                ti, xi = 0, 1
            times, xs = [], []
            for row in reader:
                if len(row) > max(ti, xi):
                    times.append(float(row[ti]))
                    xs.append(float(row[xi]))
    except Exception as e:
        print(f'FAIL: cannot read result.csv: {e}')
        sys.exit(1)

    if not times:
        print('FAIL: empty result')
        sys.exit(1)

    final = xs[-1]
    refs = []
    with open('reference/reference_values.csv') as f:
        reader = csv.DictReader(f)
        for row in reader:
            refs.append(row)

    all_pass = True
    for ref in refs:
        qty = ref['quantity']
        exp = float(ref['value'])
        tol = float(ref['tolerance_pct'])
        if 'settling' in qty.lower():
            actual = compute_settling_time(times, xs, final)
            if actual is None:
                print(f'FAIL {qty}: no settling')
                all_pass = False
                continue
            rel = abs(actual - exp) / exp * 100 if exp != 0 else 0
            status = 'PASS' if rel <= tol else 'FAIL'
            print(f'{status} {qty}: computed={actual:.3f} expected={exp} tol={tol}%')
            if status == 'FAIL':
                all_pass = False
        else:
            peak = max(xs) if xs else 0
            overshoot = (peak - final) / abs(final) * 100 if final != 0 else 0
            rel = abs(overshoot - exp) / exp * 100 if exp != 0 else 0
            status = 'PASS' if rel <= tol else 'FAIL'
            print(f'{status} {qty}: computed={overshoot:.2f}% expected={exp}% tol={tol}%')
            if status == 'FAIL':
                all_pass = False

    sys.exit(0 if all_pass else 1)

if __name__ == '__main__':
    main()
