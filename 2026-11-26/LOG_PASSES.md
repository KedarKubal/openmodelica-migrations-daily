# LOG_PASSES

Pass 1 (Generator): Initial equation model from paper eqs (8), Table 2 params, simple PID. Verifier notes: equation count ok (4 states, matching ders), all params valued+unit+source, SI units, ICs zero consistent, simulate.mos matches assumed time/solver, hand calc shows steady-state force inconsistency for Ks>0.

Pass 2 (Updater): Kept model, flagged discrepancy explicitly in MIGRATION.md, set Ks small, adjusted gains ASSUMPTION. No structural change to avoid overcomplicating under 2h limit.

Pass 3 (Verifier): Checks a-g: equation/unknown balance yes; params complete; units SI; no connectors used; ICs consistent; mos produces result.csv; hand calc does NOT reproduce exact 2.2 s (depends on unmodeled nonlinearities and exact gains) -- flagged.

Self-check: Specific Moog actuator study, not generic, not repeat (LOG.md empty at time of creation).
