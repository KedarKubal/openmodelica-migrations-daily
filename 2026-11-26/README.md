# 2026-11-26 Migration: Hydraulic Actuator System ID & Control

Migrated the nonlinear Simscape model of a Moog electro-hydraulic actuator from Nisar & Munawar (arXiv:2108.11756) to OpenModelica.

See MIGRATION.md for mapping, assumptions, and reference values (settling time, overshoot from Table 4).

## Files
- model/EHASystem.mo
- simulate.mos
- reference/reference_values.csv
- verify.py
- MIGRATION.md
- LOG_PASSES.md

Run via GitHub Actions or locally with omc + python.
Spot-check reference_values.csv against the paper before relying on CI.
