# OpenModelica Migrations (Daily)

Each dated folder migrates one published study from a proprietary system-modeling tool (MATLAB/Simulink, Simscape, Dymola, AMESim, LabVIEW) to OpenModelica, and checks the result against the paper's published values.

## Status key
- `UNVALIDATED`: generated, not yet run
- `VALIDATED`: CI simulated the model and all quantities are within tolerance
- `MISMATCH`: simulated, but at least one quantity is out of tolerance
- `RUN_FAILED`: translation or simulation error, or timeout

See `LOG.md` for the daily index.

## Folder layout
Each `YYYY-MM-DD/` folder contains:
- `model/*.mo`: the Modelica model(s)
- `simulate.mos`: simulation script (start/stop time, solver, tolerance)
- `reference/reference_values.csv`: values from the paper plus tolerances
- `verify.py`: compares `result.csv` to the reference values (PASS/FAIL per quantity)
- `MIGRATION.md`: source paper, mapping table, assumptions, run instructions
- `LOG_PASSES.md`: what changed in each Generator-Verifier-Updater pass
- `ci_result.txt`: CI output (added after a CI run)
