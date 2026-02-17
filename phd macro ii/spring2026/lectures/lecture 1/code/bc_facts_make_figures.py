from __future__ import annotations

import argparse
import os
import pickle
from pathlib import Path

import numpy as np
import pandas as pd
import matplotlib.dates as mdates
import matplotlib.pyplot as plt
import seaborn as sns
import statsmodels.api as sm

try:
    from fredapi import Fred  # optional (only needed if re-downloading)
except Exception:  # pragma: no cover
    Fred = None


HERE = Path(__file__).resolve().parent
DATA_DIR = HERE / "data"
FIG_DIR = HERE.parent / "Figures"


VAR_SPECS: list[tuple[str, str]] = [
    ("u", "UNRATE"),
    ("GDP_qtr", "GDP"),
    ("i_qtr", "GPDI"),
    ("c", "PCE"),
    ("c_dur", "PCEDG"),
    ("c_nondur", "PCEND"),
    ("c_services", "PCES"),
    ("deflator_qtr", "GDPDEF"),
    ("pop", "CNP16OV"),
    ("emp", "CE16OV"),
    ("productivity_nonfarm_qtr", "PRS85006163"),
    ("unemp", "UNEMPLOY"),
    ("unemp_short", "UEMPLT5"),
    ("wage_tot_qtr", "A132RC1Q027SBEA"),
    ("hours", "B4701C0A222NBEA"),
    ("R_qtr", "BOGZ1FL072052006Q"),
    ("CPI", "CPIAUCSL"),
    ("IP", "INDPRO"),
    ("CP", "PPIACO"),
]

VARNAMES: list[str] = [
    "y_qtr",
    "i_qtr",
    "c_qtr",
    "c_dur_qtr",
    "c_nondur_qtr",
    "c_services_qtr",
    "w_qtr",
    "a_qtr",
    "Pi_qtr",
    "Pi_CPI_qtr",
    "R_qtr",
    "u_qtr",
    "hours_qtr",
]


def set_plot_style() -> None:
    sns.set_theme(style="whitegrid", context="talk")
    plt.rcParams.update(
        {
            "figure.figsize": (10.5, 4.8),
            "figure.dpi": 120,
            "savefig.dpi": 300,
            "savefig.bbox": "tight",
            "savefig.pad_inches": 0.04,
            "axes.spines.top": False,
            "axes.spines.right": False,
            "axes.titleweight": "bold",
            "axes.labelpad": 6,
            "legend.frameon": False,
            "grid.alpha": 0.25,
            "grid.linewidth": 0.8,
            "lines.linewidth": 2.4,
            # Embed TrueType fonts in PDFs (nicer in Beamer)
            "pdf.fonttype": 42,
            "ps.fonttype": 42,
        }
    )


def _format_time_axis(ax: plt.Axes) -> None:
    ax.xaxis.set_major_locator(mdates.YearLocator(10))
    ax.xaxis.set_minor_locator(mdates.YearLocator(5))
    ax.xaxis.set_major_formatter(mdates.DateFormatter("%Y"))
    ax.tick_params(axis="x", which="major", labelrotation=0)


def load_or_download_fred(cache_path: Path, refresh: bool = False) -> dict[str, pd.Series]:
    if cache_path.exists() and not refresh:
        with cache_path.open("rb") as f:
            return pickle.load(f)

    api_key = os.environ.get("FRED_API_KEY")
    if not api_key:
        raise RuntimeError(
            "Missing FRED data cache and no FRED_API_KEY provided. "
            f"Expected cache at: {cache_path}"
        )
    if Fred is None:
        raise RuntimeError("fredapi is not installed, but refresh was requested.")

    fred = Fred(api_key=api_key)
    data_fred: dict[str, pd.Series] = {}
    for varname, varname_fred in VAR_SPECS:
        print(f"Loading {varname_fred}...")
        data_fred[varname] = fred.get_series(varname_fred)

    cache_path.parent.mkdir(parents=True, exist_ok=True)
    with cache_path.open("wb") as f:
        pickle.dump(data_fred, f)
    return data_fred


def build_quarterly_dataset(data_fred: dict[str, pd.Series]) -> dict[str, pd.Series]:
    data: dict[str, pd.Series] = {}

    # Convert selected monthly series to quarterly with left labels (matches notebook logic)
    for varname in ["u", "pop", "CPI", "c", "c_dur", "c_nondur", "c_services"]:
        # Pandas 3.0 dropped the "Q" alias; use quarter-end ("QE") instead.
        q = data_fred[varname].resample("QE", label="left").mean()
        q.index = q.index + pd.tseries.frequencies.to_offset("1D")
        data[f"{varname}_qtr"] = q

    # Construct quarterly wage rate data
    hours_qtr = data_fred["hours"].resample("QE", label="left").ffill()
    hours_qtr.index = hours_qtr.index - pd.offsets.QuarterEnd(1)
    hours_qtr.index = hours_qtr.index + pd.tseries.frequencies.to_offset("1D")
    data["hours_qtr"] = hours_qtr
    data["w_rate_qtr"] = data_fred["wage_tot_qtr"] / (data["hours_qtr"] / 4)

    # Align interest rate to GDP quarterly index and compute real quantities
    ix = pd.DatetimeIndex(list(data_fred["GDP_qtr"].index)).unique().sort_values()
    data["R_qtr"] = data_fred["R_qtr"].reindex(ix)

    data["w_qtr"] = data["w_rate_qtr"] / data_fred["deflator_qtr"]
    data["y_qtr"] = data_fred["GDP_qtr"] / data_fred["deflator_qtr"]
    data["i_qtr"] = data_fred["i_qtr"] / data_fred["deflator_qtr"]
    data["c_qtr"] = data["c_qtr"] / data_fred["deflator_qtr"]
    data["c_dur_qtr"] = data["c_dur_qtr"] / data_fred["deflator_qtr"]
    data["c_nondur_qtr"] = data["c_nondur_qtr"] / data_fred["deflator_qtr"]
    data["c_services_qtr"] = data["c_services_qtr"] / data_fred["deflator_qtr"]
    data["a_qtr"] = data_fred["productivity_nonfarm_qtr"]

    # Annualized quarterly inflation
    data["Pi_qtr"] = (data_fred["deflator_qtr"] / data_fred["deflator_qtr"].shift(1)) ** 4 - 1
    data["Pi_CPI_qtr"] = (data["CPI_qtr"] / data["CPI_qtr"].shift(1)) ** 4 - 1

    return data


def moms(data: dict[str, np.ndarray], vars: list[str], corr_span: int = 12, hp_lambda: float = 1e5):
    """Calculate moments (and store HP cycle/trend back into `data`)."""
    out_moms: dict[tuple, object] = {}

    for var in vars:
        out_moms[("mean", f"{var}")] = np.nanmean(data[f"{var}"])

        I = ~np.isnan(data[f"{var}"])
        I[I] &= data[f"{var}"][I] > 0
        if np.any(I):
            cycle, trend = sm.tsa.filters.hpfilter(np.log(data[f"{var}"][I]), lamb=hp_lambda)
        else:
            cycle = np.nan * np.ones(np.sum(I))
            trend = np.nan * np.ones(np.sum(I))

        data[f"{var}_hp_cycle"] = np.nan * np.ones(data[f"{var}"].size)
        data[f"{var}_hp_cycle"][I] = cycle
        data[f"{var}_hp_trend"] = np.nan * np.ones(data[f"{var}"].size)
        data[f"{var}_hp_trend"][I] = trend

        cyc = data[f"{var}_hp_cycle"]
        I2 = ~np.isnan(cyc)
        out_moms[("std", f"{var}")] = np.std(cyc[I2])

    for var in vars:
        out_moms[("std_rel", f"{var}")] = out_moms[("std", f"{var}")] / out_moms[("std", "y_qtr")]

    # Correlations
    for var in vars:
        cycle = data[f"{var}_hp_cycle"]
        I = ~np.isnan(cycle)
        for comparevar in vars:
            comparecycle = data[f"{comparevar}_hp_cycle"]
            I2 = I & ~np.isnan(comparecycle)
            ycorr = np.nan * np.ones(2 * corr_span + 1)
            ycov = np.nan * np.ones(2 * corr_span + 1)
            for k in range(-corr_span, corr_span + 1):
                if k == 0:
                    ycorr[k + corr_span] = np.corrcoef(cycle[I2], comparecycle[I2])[0, 1]
                    ycov[k + corr_span] = np.cov(cycle[I2], comparecycle[I2])[0, 1]
                elif k < 0:
                    ycorr[k + corr_span] = np.corrcoef(cycle[I2][-k:], comparecycle[I2][:k])[0, 1]
                    ycov[k + corr_span] = np.cov(cycle[I2][-k:], comparecycle[I2][:k])[0, 1]
                else:
                    ycorr[k + corr_span] = np.corrcoef(cycle[I2][:-k], comparecycle[I2][k:])[0, 1]
                    ycov[k + corr_span] = np.cov(cycle[I2][:-k], comparecycle[I2][k:])[0, 1]

            out_moms[("corr", f"{var}", f"{comparevar}")] = ycorr
            out_moms[("corr0", f"{var}", f"{comparevar}")] = ycorr[corr_span]
            out_moms[("cov", f"{var}", f"{comparevar}")] = ycov

            if var == comparevar:
                out_moms[("autocorr1", f"{var}")] = ycorr[corr_span + 1]
                out_moms[("autocorr", f"{var}")] = ycorr[corr_span + 1 :]
                out_moms[("autocov", f"{var}")] = ycov[corr_span:]

    return out_moms


def _save(fig: plt.Figure, path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    fig.savefig(path)
    plt.close(fig)


def make_figures(sample_start_year: int = 1951, sample_end_year: int = 2024, refresh_fred: bool = False) -> None:
    set_plot_style()

    data_fred = load_or_download_fred(DATA_DIR / "data_fred.pickle", refresh=refresh_fred)
    data = build_quarterly_dataset(data_fred)

    # Save the processed data (mirrors the notebook outputs)
    DATA_DIR.mkdir(parents=True, exist_ok=True)
    with (DATA_DIR / "data.pickle").open("wb") as f:
        pickle.dump(data, f)

    # Use GDP's quarterly index as the common timeline, and reindex everything onto it.
    # This avoids off-by-one sample length differences across series.
    idx = data["y_qtr"].index
    Iidx = (idx.year >= sample_start_year) & (idx.year <= sample_end_year)
    qtrs = idx[Iidx]

    data_selected: dict[str, np.ndarray] = {}
    for varname in VARNAMES:
        s = data[varname].reindex(qtrs)
        data_selected[varname] = s.to_numpy()

    datamoms = moms(data_selected, VARNAMES)
    with (DATA_DIR / "datamoms.pickle").open("wb") as f:
        pickle.dump(datamoms, f)

    # --- Figures used in the LaTeX lecture ---
    # 1) Output: raw + HP trend (plot level by exponentiating log-trend)
    fig, ax = plt.subplots()
    ax.plot(qtrs, data_selected["y_qtr"], label="Real GDP (raw)", color=sns.color_palette()[0])
    ax.plot(
        qtrs,
        np.exp(data_selected["y_qtr_hp_trend"]),
        label="HP trend",
        color=sns.color_palette()[2],
    )
    ax.set_ylabel("Index / level")
    _format_time_axis(ax)
    ax.legend(ncols=2, loc="upper left")
    _save(fig, FIG_DIR / "gdp_raw_trend.pdf")

    # 2) Output cycle
    fig, ax = plt.subplots()
    ax.plot(qtrs, data_selected["y_qtr_hp_cycle"], label="Output cycle", color=sns.color_palette()[0])
    ax.axhline(y=0.0, color="black", linestyle="--", linewidth=1.2, alpha=0.7)
    ax.set_ylabel("Log-deviation")
    _format_time_axis(ax)
    ax.legend(loc="upper left")
    _save(fig, FIG_DIR / "gdp_cycle.pdf")

    # 3) GDP, hours, productivity cycles
    fig, ax = plt.subplots()
    pal = sns.color_palette()
    ax.plot(qtrs, data_selected["y_qtr_hp_cycle"], label="Output", color=pal[0])
    ax.plot(qtrs, data_selected["hours_qtr_hp_cycle"], label="Hours", color=pal[1])
    ax.plot(qtrs, data_selected["a_qtr_hp_cycle"], label="Productivity", color=pal[2])
    ax.axhline(y=0.0, color="black", linestyle="--", linewidth=1.2, alpha=0.7)
    ax.set_ylabel("Log-deviation")
    _format_time_axis(ax)
    ax.legend(ncols=3, loc="upper left")
    _save(fig, FIG_DIR / "gdp_na_cycle.pdf")

    # 4) GDP, consumption, investment cycles
    fig, ax = plt.subplots()
    pal = sns.color_palette()
    ax.plot(qtrs, data_selected["y_qtr_hp_cycle"], label="Output", color=pal[0])
    ax.plot(qtrs, data_selected["c_qtr_hp_cycle"], label="Consumption", color=pal[2])
    ax.plot(qtrs, data_selected["i_qtr_hp_cycle"], label="Investment", color=pal[3])
    ax.axhline(y=0.0, color="black", linestyle="--", linewidth=1.2, alpha=0.7)
    ax.set_ylabel("Log-deviation")
    _format_time_axis(ax)
    ax.legend(ncols=3, loc="upper left")
    _save(fig, FIG_DIR / "gdp_ci_cycle.pdf")

    # 5) Consumption components (cycles)
    fig, ax = plt.subplots()
    pal = sns.color_palette()
    ax.plot(qtrs, data_selected["c_qtr_hp_cycle"], label="Total", color=pal[0])
    ax.plot(qtrs, data_selected["c_dur_qtr_hp_cycle"], label="Durables", color=pal[1])
    ax.plot(qtrs, data_selected["c_nondur_qtr_hp_cycle"], label="Nondurables", color=pal[2])
    ax.plot(qtrs, data_selected["c_services_qtr_hp_cycle"], label="Services", color=pal[3])
    ax.axhline(y=0.0, color="black", linestyle="--", linewidth=1.2, alpha=0.7)
    ax.set_ylabel("Log-deviation")
    _format_time_axis(ax)
    ax.legend(ncols=2, loc="upper left")
    _save(fig, FIG_DIR / "c_components_cycle.pdf")

    # 6) Pandemic zoom (levels)
    c_dur = data["c_dur_qtr"]
    c_nondur = data["c_nondur_qtr"]
    c_serv = data["c_services_qtr"]
    Ipan = (c_dur.index.year >= 2018) & (c_dur.index.year <= sample_end_year)
    fig, ax = plt.subplots()
    pal = sns.color_palette()
    ax.plot(c_dur.index[Ipan], c_dur[Ipan], label="Durables", color=pal[1])
    ax.plot(c_nondur.index[Ipan], c_nondur[Ipan], label="Nondurables", color=pal[2])
    ax.plot(c_serv.index[Ipan], c_serv[Ipan], label="Services", color=pal[3])
    ax.set_ylabel("Index / level")
    ax.xaxis.set_major_locator(mdates.YearLocator(1))
    ax.xaxis.set_major_formatter(mdates.DateFormatter("%Y"))
    ax.tick_params(axis="x", labelrotation=0)
    ax.legend(ncols=3, loc="upper left")
    _save(fig, FIG_DIR / "c_pandemic.pdf")

    print(f"Wrote figures to: {FIG_DIR}")


def main() -> None:
    parser = argparse.ArgumentParser(description="Generate lecture-1 business cycle facts figures.")
    parser.add_argument("--refresh-fred", action="store_true", help="Redownload data from FRED (requires FRED_API_KEY).")
    parser.add_argument("--start", type=int, default=1951, help="Start year (inclusive).")
    parser.add_argument("--end", type=int, default=2024, help="End year (inclusive).")
    args = parser.parse_args()
    make_figures(sample_start_year=args.start, sample_end_year=args.end, refresh_fred=args.refresh_fred)


if __name__ == "__main__":
    main()

