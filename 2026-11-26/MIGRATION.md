# Migration: System Identification and Controller Design for Hydraulic Actuator

**Paper**: Zainab Nisar and Hammad Munawar. System Identification and Controller Design for Hydraulic Actuator. arXiv:2108.11756v1, 2021.
**Link**: https://arxiv.org/abs/2108.11756
**Proprietary tool**: MATLAB/Simulink with Simscape (nonlinear physical model of Moog MCR-M-1002 electro-hydraulic actuator for flight simulator motion platform).

## Mapping table
| Source element | Modelica equivalent | Notes |
|----------------|---------------------|-------|
| Simscape hydraulic cylinder + valve | Custom equations for QL, der(PL), force balance | Simplified linear flow; full sqrt(DeltaP) and dual chambers not used to avoid duplication |
| Mass + spring + damper + Coulomb | M*der(v) = ... - Fc*tanh(...) | tanh approximation for sign |
| NPID controller | Simple PID equations | Nonlinear gain k(e) not quantified in paper; omitted |
| Bulk modulus, areas, gains | parameters from Table 2 | Converted to SI |

## Assumptions (paper silent or incomplete)
- Supply pressure Ps not numerically given -> not used in simplified model
- Exact PID gains for the reported Table 4 runs not given (only that Ziegler-Nichols used) -> ASSUMPTION values
- Solver: not specified (likely default Simulink) -> dassl, tol=1e-6, StopTime=5 s ASSUMPTION
- Reference step size not explicit for the transient table -> 0.0254 m ASSUMPTION
- Spring stiffness unit "20 N m" interpreted as N/m
- Full nonlinear flow-pressure relationship approximated as linear

## Reference values to reproduce
1. Settling time Ts ~ 2.2 s for Nonlinear Model (Chirp identification case), Table 4.
2. Overshoot OS = 4.8 % for same, Table 4.

Hand calculation: steady-state force balance with v=0, der(PL)=0 implies QL=0 => PL=0, thus cannot balance nonzero Ks*x unless Ks=0. Discrepancy flagged: simplified model cannot fully reproduce nonzero spring holding without additional pressure feedback or chamber modeling. Gains chosen as ASSUMPTION to aim near reported dynamics. See LOG_PASSES.md.

## Run instructions
OpenModelica: omc simulate.mos
Then python3 verify.py
