# Migration: Analysis and Improvement of the Dynamic Characteristics of an Electro-Hydrostatic Actuator Based on a Vehicle’s Active Suspension

**Paper**: Peng Chen, Xing Chen. Analysis and Improvement of the Dynamic Characteristics of an Electro-Hydrostatic Actuator Based on a Vehicle’s Active Suspension. World Electr. Veh. J. 2025, 16, 586.
**Link**: https://doi.org/10.3390/wevj16100586
**Proprietary tool**: MATLAB/Simulink

## Mapping table
| Source element | Modelica equivalent | Notes |
|----------------|---------------------|-------|
| Pump flow Q = D*ω - C_leak*P | Custom equations | Total leakage from Table 1 |
| Continuity equation | Custom equations | V0, β from Table 1 |
| Force balance | Custom equations | M, B from Table 1; F_ext=0 |
| Motor voltage & torque equations | Custom equations | Table 2 |
| Position PID | Simple PID equations | Gains ASSUMPTION |

## Assumptions
- Exact controller gains for the Table 3 step responses are not published → ASSUMPTION Kp=8000, Ki=50, Kd=0, Vsat=±48 V.
- Solver not specified → dassl, tol=1e-6, StopTime=2 s.
- Single effective chamber approximation; leakage equivalence as described in the paper.
- No external force for the no-load step.

## Reference values to reproduce
1. Settling time 0.82 s (2 % band) for baseline 20 mm step — Table 3.
2. Overshoot 2.3 % for the same case — Table 3.
3. Rise time ~0.46 s — Table 3.

Hand calculation: steady-state force balance with zero velocity and zero pressure derivative implies P=0, ω=0, I=0. The reported transient metrics require the closed-loop controller; the simplified plant + assumed PID does not automatically match 0.82 s / 2.3 % exactly. Discrepancy flagged.

## Run instructions
OpenModelica: omc simulate.mos
Then: python3 verify.py
