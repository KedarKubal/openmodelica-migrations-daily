model EHASystem
  // Electro-Hydrostatic Actuator (EHA) plant + simple PID position control
  // Migrated from Chen & Chen, World Electr. Veh. J. 2025, 16, 586
  // Parameters from Tables 1 and 2; controller gains = ASSUMPTION

  parameter Real D(unit="m3/rad") = 1.5e-6 / (2 * 3.141592653589793) "Pump displacement, Table 1";
  parameter Real Ctot(unit="m3/(s.Pa)") = 1.58 "Total leakage coeff, Table 1";
  parameter Real A(unit="m2") = 71e-4 "Effective piston area, Table 1";
  parameter Real V0(unit="m3") = 0.45e-3 "Initial volume, Table 1";
  parameter Real beta(unit="Pa") = 650e6 "Bulk modulus, Table 1";
  parameter Real M(unit="kg") = 2000 "Load equivalent mass, Table 1";
  parameter Real B(unit="N.s/m") = 150 "Piston damping, Table 1";
  parameter Real R(unit="Ohm") = 1.5 "Stator resistance, Table 2";
  parameter Real L(unit="H") = 2.3e-3 "Stator inductance, Table 2";
  parameter Real Ke(unit="V/(rad/s)") = 0.2 "Back-EMF coeff, Table 2";
  parameter Real Kt(unit="N.m/A") = 0.2 "Torque coeff, Table 2";
  parameter Real J(unit="kg.m2") = 1.2e-3 "Moment of inertia (baseline), Table 2";
  parameter Real Bm(unit="N.m.s/rad") = 4.2e-4 "Motor damping, Table 2";

  // ASSUMPTION controller gains (paper does not publish the exact gains used for Table 3)
  parameter Real Kp = 8000;
  parameter Real Ki = 50;
  parameter Real Kd = 0;
  parameter Real Vmax = 48 "ASSUMPTION voltage saturation";

  parameter Real xref = 0.020 "20 mm step reference, Table 3";

  Real x(start=0, unit="m") "Piston position";
  Real v(start=0, unit="m/s") "Piston velocity";
  Real P(start=0, unit="Pa") "System pressure";
  Real omega(start=0, unit="rad/s") "Motor angular velocity";
  Real I(start=0, unit="A") "Armature current";
  Real Vcmd(unit="V") "Commanded voltage";
  Real err(unit="m") "Position error";
  Real integ(start=0, unit="m.s") "Integral of error";

equation
  der(x) = v;
  der(v) = (A * P - B * v) / M;  // F_ext = 0

  // Continuity (single effective chamber)
  A * v + (V0 / beta) * der(P) + Ctot * P = D * omega;

  // Motor electrical
  Vcmd = R * I + L * der(I) + Ke * omega;

  // Motor mechanical (pump load torque = D * P)
  Kt * I = J * der(omega) + Bm * omega + D * P;

  // Simple PID (ASSUMPTION)
  err = xref - x;
  der(integ) = err;
  Vcmd = max(-Vmax, min(Vmax, Kp * err + Ki * integ + Kd * der(err)));

end EHASystem;
