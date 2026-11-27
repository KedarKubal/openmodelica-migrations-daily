model DCMotorPID
  // Parameters from Messaadi & Amroun 2021, Table 1 and text
  parameter Real J(unit="kg.m2") = 0.1 "Moment of inertia of the rotor, Table 1";
  parameter Real b(unit="N.m.s/rad") = 0.008 "Viscous friction constant, Table 1";
  parameter Real Kt(unit="N.m/A") = 0.5 "Torque constant, Table 1";
  parameter Real Kb(unit="V.s/rad") = 1.25 "Back-EMF constant, Table 1";
  parameter Real Ra(unit="Ohm") = 5 "Armature resistance, Table 1";
  parameter Real La(unit="H") = 0.2 "Armature inductance, Table 1";
  parameter Real Kp = 30 "Proportional gain, text after manual tuning";
  parameter Real Ki = 12 "Integral gain, text";
  parameter Real Kd = 1 "Derivative gain, text";
  // 2000 rpm converted to rad/s (ASSUMPTION)
  parameter Real omega_ref(unit="rad/s") = 209.43951023931953 "Speed setpoint, text (2000 rpm)";

  Real omega(unit="rad/s", start=0) "Angular velocity";
  Real i(unit="A", start=0) "Armature current";
  Real e(unit="rad/s") "Speed error";
  Real int_e(unit="rad", start=0) "Integral of error";
  Real V(unit="V") "Armature voltage (controller output)";

equation
  e = omega_ref - omega;
  der(int_e) = e;
  V = Kp * e + Ki * int_e + Kd * der(e);
  // Mechanical
  J * der(omega) + b * omega = Kt * i;
  // Electrical
  La * der(i) + Ra * i = V - Kb * omega;
end DCMotorPID;
