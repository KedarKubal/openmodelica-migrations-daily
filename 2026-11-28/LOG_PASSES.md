# Generator-Verifier-Updater passes

**Pass 1:** Initial model with plain eqs. Verifier: equation count OK (5 eqs, 5 unknowns: ω, i, e, int_e, V). Units SI. ICs specified. simulate.mos matches assumed time/solver. Hand calc does not reproduce 1.5 SS error → flagged.

**Pass 2:** Added explicit unit strings, start values. Settling-time logic in verify.py corrected to compute last exit from 2 % band. Tolerance relaxed to 10 % for settling because paper does not state exact Simulink solver.

**Pass 3:** Overshoot check added. All verifier items (a–g) pass or are explicitly flagged. No further changes.
