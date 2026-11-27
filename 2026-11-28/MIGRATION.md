# Migration: DC Motor Speed Control with PID

**Paper:** Speed Control of DC Motor Using Fuzzy PID Controller  
**Authors:** Nassim Messaadi, Abdelkader Amroun  
**Year:** 2021  
**Link:** https://arxiv.org/abs/2108.05450  
**Original tool:** MATLAB/Simulink  

## Mapping
See table in analysis. Plain equations used (no MSL components that would duplicate eqs.).

## Assumptions
- Setpoint 2000 rpm → 209.4395 rad/s.
- No actuator saturation.
- Solver dassl / tol 1e-6 / stop 5 s (paper silent).
- SS error of 1.5 interpreted as rpm.

## Hand calculation
Steady-state (der=0, integral → e=0): ω_ss = ω_ref, i_ss = b·ω_ref/Kt. Ideal model therefore predicts zero SS error. Paper reports 1.5 (Table 5); discrepancy flagged — possible unmodeled friction, quantization, or numerical residual in original Simulink run.

## Run instructions
```
cd 2026-11-28
omc simulate.mos
python3 verify.py
```
