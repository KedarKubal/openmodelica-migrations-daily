model EHASystem
  // Migrated from: System Identification and Controller Design for Hydraulic Actuator
  // Zainab Nisar, Hammad Munawar, 2021, arXiv:2108.11756
  // Original tool: MATLAB/Simulink + Simscape nonlinear model of Moog MCR-M-1002 EHA
  // Simplified equation-based Modelica version for OpenModelica
  // Note: full nonlinear sqrt flow and dual-chamber not fully replicated; see MIGRATION.md

  parameter Real Ap(unit="m2") = 0.0080645 "Piston area from Table 2: 12.5 in^2";
  parameter Real beta(unit="Pa") = 1.5168e9 "Bulk modulus from Table 2: 22e4 psi";
  parameter Real M(unit="kg") = 500 "Load mass from Table 2";
  parameter Real Bs(unit="N.s/m") = 100 "Viscous damping from Table 2";
  parameter Real Ks(unit="N/m") = 20 "Spring stiffness from Table 2 (unit ASSUMPTION N/m)";
  parameter Real Vt(unit="m3") = 0.0006096 "Total fluid volume ~2*Vd from Table 2";
  parameter Real Ctp(unit="m3/(s.Pa)") = 1e-12 "Leakage coefficient ASSUMPTION";
  parameter Real Kq(unit="m3/(s.V)") = 1.8e-6 "Flow gain coefficient from Table 2";
  parameter Real Kv(unit="m/V") = 2.2e-6 "Servo valve gain from Table 2";
  parameter Real Fc(unit="N") = 450 "Coulomb friction from paper description";
  parameter Real xref(unit="m") = 0.0254 "Step reference 1 inch ASSUMPTION";
  // PID gains ASSUMPTION (paper uses Ziegler-Nichols but numerical values not reported for the nonlinear runs)
  parameter Real Kp = 80;
  parameter Real Ki = 10;
  parameter Real Kd = 5;

  Real x(unit="m", start=0) "Position";
  Real v(unit="m/s", start=0) "Velocity";
  Real PL(unit="Pa", start=0) "Load pressure";
  Real ei(start=0);
  Real e;
  Real u;
  Real QL;

equation
  e = xref - x;
  der(ei) = e;
  u = Kp * e + Ki * ei - Kd * v;

  // Simplified flow (linear approximation; paper uses pressure-dependent sqrt)
  QL = Kq * u;  // Kv absorbed or approx

  // Pressure dynamics following paper eq. (8)
  der(PL) = (4 * beta / Vt) * (QL - Ctp * PL - Ap * v);

  // Mechanics with Coulomb approx
  M * der(v) = Ap * PL - Bs * v - Ks * x - Fc * tanh(50 * v);
  der(x) = v;

annotation(experiment(StartTime=0, StopTime=5, Tolerance=1e-6));
end EHASystem;
