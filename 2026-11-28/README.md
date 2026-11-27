# 2026-11-28 — DC Motor PID Speed Control

Migration of Messaadi & Amroun (2021) conventional PID case from MATLAB/Simulink to OpenModelica.

- `model/DCMotorPID.mo` — plant + PID
- `simulate.mos` — runs 0–5 s, dassl, csv
- `reference/reference_values.csv` — Table 5 targets
- `verify.py` — settling-time computation + PASS/FAIL

Status will be set by CI. Spot-check reference values against the arXiv paper before trusting results.
