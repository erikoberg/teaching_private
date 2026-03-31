## ORG/MORG update through 2024

This folder contains a CPS ORG/MORG update of the Acemoglu (JEL 2002) wage-dispersion figures.

- Source: NBER annual CPS MORG extracts, `morg79.dta` through `morg24.dta`
- Coverage: 1979-2024
- Sample: white male full-time wage and salary workers, ages 18-65
- Wage measure: hourly wage constructed as weekly earnings divided by usual weekly hours
- Price deflator for indexed wage levels: monthly PCEPI from FRED
- Residual inequality: yearly weighted Mincer-style regressions with education-group dummies, region dummies, and a quartic in potential experience

Files:

- `morg_inequality_1979_2024.csv`: annual percentile and residual-inequality series
- `summary.csv`: sample coverage summary
- `morg_selected_*.csv.gz`: cached year-by-year extracts used by the script

Code:

- `code/replicate_morg_inequality_update.py`
