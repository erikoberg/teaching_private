# Acemoglu 2002 Update

This folder contains a reproducible update of the two Acemoglu (JEL 2002) wage-dispersion figures used in `lecture7.tex`.

- Script: `code/replicate_acemoglu_2002_update.py`
- Output series: `acemoglu_2002_update_2000_2024.csv`
- Figures:
  - `figures/acemoglu_2002_fig2_update_2024.pdf`
  - `figures/acemoglu_2002_fig3_update_2024.pdf`

Method summary:

- Data source: CPS ASEC public microdata API
- Coverage used here: survey years 2001-2025, corresponding to earnings years 2000-2024
- Sample: white male full-time full-year workers, ages 18-65
- Wage measure: weekly earnings, computed as annual earnings divided by weeks worked
- Low-wage screen: half of the 1982 federal minimum wage, converted with the PCE price index and scaled to a 40-hour week
- Residual inequality: year-specific Mincer-style regressions with education dummies, a quartic in experience, and region controls

Note:

- The public API is stable and reproducible for the 2000-2024 span used here.
- This is an update in the spirit of Acemoglu's original figures, not an exact full-sample reconstruction back to 1963.
