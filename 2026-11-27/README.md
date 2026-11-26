# 2026-11-27 — EHA Active Suspension Migration

OpenModelica migration of the electro-hydrostatic actuator (EHA) model from Chen & Chen, *World Electr. Veh. J.* 2025, 16, 586 (MATLAB/Simulink).

## Contents
- `model/EHASystem.mo` — plant + ASSUMPTION PID
- `simulate.mos` — OpenModelica script
- `reference/reference_values.csv` — Table 3 targets
- `verify.py` — settling / overshoot / rise-time checker
- `MIGRATION.md` — mapping, assumptions, discrepancies

## Run
```bash
omc simulate.mos
python3 verify.py
```

Spot-check `reference_values.csv` against Table 3 of the paper before trusting CI results.
