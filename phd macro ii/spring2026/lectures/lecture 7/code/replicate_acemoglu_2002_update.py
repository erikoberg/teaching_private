from __future__ import annotations

import io
import json
import time
import urllib.parse
import urllib.request
from pathlib import Path

import matplotlib
import numpy as np
import pandas as pd

matplotlib.use("Agg")
import matplotlib.pyplot as plt


BASE_DIR = Path(__file__).resolve().parent.parent
DATA_DIR = BASE_DIR / "data" / "acemoglu_update_2024"
FIG_DIR = BASE_DIR / "figures"

SURVEY_YEARS = range(2001, 2026)
PCEPI_URL = "https://fred.stlouisfed.org/graph/fredgraph.csv?id=PCEPI"

# In practice, the public CPS ASEC microdata API is stable from 2001 onward.
API_BASE = "https://api.census.gov/data/{year}/cps/asec/mar"
COMMON_GET_VARS = [
    "A_AGE",
    "WKSWORK",
    "PTWEEKS",
    "A_USLHRS",
    "PEARNVAL",
    "MARSUPWT",
    "A_HGA",
]

REGION_MAP = {
    9: "Northeast",
    23: "Northeast",
    25: "Northeast",
    33: "Northeast",
    34: "Northeast",
    36: "Northeast",
    42: "Northeast",
    44: "Northeast",
    50: "Northeast",
    17: "Midwest",
    18: "Midwest",
    19: "Midwest",
    20: "Midwest",
    26: "Midwest",
    27: "Midwest",
    29: "Midwest",
    31: "Midwest",
    38: "Midwest",
    39: "Midwest",
    46: "Midwest",
    55: "Midwest",
    1: "South",
    5: "South",
    10: "South",
    11: "South",
    12: "South",
    13: "South",
    21: "South",
    22: "South",
    24: "South",
    28: "South",
    37: "South",
    40: "South",
    45: "South",
    47: "South",
    48: "South",
    51: "South",
    54: "South",
    2: "West",
    4: "West",
    6: "West",
    8: "West",
    15: "West",
    16: "West",
    30: "West",
    32: "West",
    35: "West",
    41: "West",
    49: "West",
    53: "West",
    56: "West",
}

# Coarse schooling-years mapping for potential experience.
EDUCATION_YEARS = {
    31: 0.0,
    32: 2.5,
    33: 5.5,
    34: 7.5,
    35: 9.0,
    36: 10.0,
    37: 11.0,
    38: 12.0,
    39: 12.0,
    40: 13.0,
    41: 14.0,
    42: 14.0,
    43: 16.0,
    44: 18.0,
    45: 19.0,
    46: 20.0,
}

# Nine education groups close to the Acemoglu/Katz-Autor setup.
EDUCATION_GROUPS = {
    31: "lt_9th",
    32: "lt_9th",
    33: "lt_9th",
    34: "lt_9th",
    35: "9th",
    36: "10th",
    37: "11th",
    38: "12th_nodiploma",
    39: "hs_grad",
    40: "some_college",
    41: "assoc",
    42: "assoc",
    43: "college",
    44: "advanced",
    45: "advanced",
    46: "advanced",
}

EXPECTED_ED_GROUPS = [
    "lt_9th",
    "9th",
    "10th",
    "11th",
    "12th_nodiploma",
    "hs_grad",
    "some_college",
    "assoc",
    "college",
    "advanced",
]
EXPECTED_REGIONS = ["Northeast", "Midwest", "South", "West"]


def fetch_text(url: str, retries: int = 4, pause: float = 2.0) -> str:
    for attempt in range(retries):
        try:
            req = urllib.request.Request(url, headers={"User-Agent": "Mozilla/5.0"})
            with urllib.request.urlopen(req, timeout=60) as response:
                return response.read().decode("utf-8")
        except Exception:
            if attempt == retries - 1:
                raise
            time.sleep(pause * (attempt + 1))
    raise RuntimeError(f"Failed to fetch {url}")


def weighted_quantile(values: np.ndarray, quantiles: list[float], weights: np.ndarray) -> np.ndarray:
    order = np.argsort(values)
    values = values[order]
    weights = weights[order]
    cumulative = np.cumsum(weights) - 0.5 * weights
    cumulative = cumulative / weights.sum()
    return np.interp(quantiles, cumulative, values)


def fetch_pcepi() -> pd.Series:
    pce = pd.read_csv(PCEPI_URL)
    pce["observation_date"] = pd.to_datetime(pce["observation_date"])
    pce["year"] = pce["observation_date"].dt.year
    annual = pce.groupby("year", as_index=True)["PCEPI"].mean()
    annual.name = "pcepi"
    return annual


def census_url(year: int) -> str:
    race_var = "PRDTRACE" if year >= 2003 else "A_RACE"
    params = {
        "get": ",".join(COMMON_GET_VARS),
        "for": "state:*",
        "A_SEX": "1",
        race_var: "1",
    }
    return API_BASE.format(year=year) + "?" + urllib.parse.urlencode(params)


def cache_path(year: int) -> Path:
    return DATA_DIR / f"cps_asec_white_male_{year}.csv.gz"


def fetch_year(year: int) -> pd.DataFrame:
    path = cache_path(year)
    if path.exists():
        return pd.read_csv(path)

    raw = json.loads(fetch_text(census_url(year)))
    header, rows = raw[0], raw[1:]
    df = pd.DataFrame(rows, columns=header)

    for column in COMMON_GET_VARS + ["state"]:
        df[column] = pd.to_numeric(df[column], errors="coerce")

    df = df.rename(columns={"state": "state_fips"})
    df["survey_year"] = year
    df["earnings_year"] = year - 1

    # Approximate full-time/full-year sample using harmonized ASEC work-history fields.
    df = df[
        (df["A_AGE"].between(18, 65))
        & (df["WKSWORK"] >= 40)
        & (df["PTWEEKS"] <= 13)
        & (df["A_USLHRS"] >= 35)
        & (df["PEARNVAL"] > 0)
        & (df["MARSUPWT"] > 0)
    ].copy()

    df["weekly_earnings"] = df["PEARNVAL"] / df["WKSWORK"]
    df["region"] = df["state_fips"].map(REGION_MAP)
    df["school_years"] = df["A_HGA"].map(EDUCATION_YEARS)
    df["educ_group"] = df["A_HGA"].map(EDUCATION_GROUPS)

    df = df.dropna(subset=["weekly_earnings", "region", "school_years", "educ_group"])
    df = df[
        [
            "survey_year",
            "earnings_year",
            "state_fips",
            "A_AGE",
            "A_HGA",
            "educ_group",
            "school_years",
            "MARSUPWT",
            "weekly_earnings",
            "region",
        ]
    ].copy()
    df.to_csv(path, index=False, compression="gzip")
    return df


def prepare_sample() -> pd.DataFrame:
    pce = fetch_pcepi()
    pce_1982 = float(pce.loc[1982])
    frames = [fetch_year(year) for year in SURVEY_YEARS]
    df = pd.concat(frames, ignore_index=True)
    df["pcepi"] = df["earnings_year"].map(pce)

    # Katz-Autor / Acemoglu screen translated to weekly earnings using a 40-hour week.
    half_1982_min_wage = 0.5 * 3.35
    df["weekly_floor"] = 40.0 * half_1982_min_wage * (df["pcepi"] / pce_1982)
    df = df[df["weekly_earnings"] >= df["weekly_floor"]].copy()

    df["log_weekly_earnings"] = np.log(df["weekly_earnings"])
    df["experience"] = (df["A_AGE"] - df["school_years"] - 6.0).clip(lower=0.0, upper=50.0)
    return df


def overall_series(df: pd.DataFrame) -> pd.DataFrame:
    rows = []
    for year, grp in df.groupby("earnings_year"):
        q10, q50, q90 = weighted_quantile(
            grp["weekly_earnings"].to_numpy(),
            [0.10, 0.50, 0.90],
            grp["MARSUPWT"].to_numpy(),
        )
        rows.append({"year": year, "p10": q10, "p50": q50, "p90": q90})
    out = pd.DataFrame(rows).sort_values("year").reset_index(drop=True)
    base = out.loc[out["year"] == out["year"].min(), ["p10", "p50", "p90"]].iloc[0]
    out["index_p10"] = 100.0 * out["p10"] / base["p10"]
    out["index_p50"] = 100.0 * out["p50"] / base["p50"]
    out["index_p90"] = 100.0 * out["p90"] / base["p90"]
    return out


def residual_series(df: pd.DataFrame) -> pd.DataFrame:
    rows = []
    for year, grp in df.groupby("earnings_year"):
        work = grp.copy()

        ed = pd.get_dummies(work["educ_group"], prefix="ed").reindex(
            columns=[f"ed_{g}" for g in EXPECTED_ED_GROUPS], fill_value=0
        )
        reg = pd.get_dummies(work["region"], prefix="reg").reindex(
            columns=[f"reg_{g}" for g in EXPECTED_REGIONS], fill_value=0
        )

        x = pd.DataFrame(index=work.index)
        x["const"] = 1.0
        x = pd.concat([x, ed, reg], axis=1)
        x["exp1"] = work["experience"]
        x["exp2"] = work["experience"] ** 2
        x["exp3"] = work["experience"] ** 3
        x["exp4"] = work["experience"] ** 4

        y = work["log_weekly_earnings"].to_numpy()
        w = work["MARSUPWT"].to_numpy()
        x_np = x.to_numpy(dtype=float)
        sqrt_w = np.sqrt(w)
        beta, _, _, _ = np.linalg.lstsq(x_np * sqrt_w[:, None], y * sqrt_w, rcond=None)
        resid = y - x_np @ beta

        q10, q50, q90 = weighted_quantile(resid, [0.10, 0.50, 0.90], w)
        rows.append(
            {
                "year": year,
                "resid_90_50": q90 - q50,
                "resid_50_10": q50 - q10,
                "resid_half_90_10": 0.5 * (q90 - q10),
            }
        )

    return pd.DataFrame(rows).sort_values("year").reset_index(drop=True)


def plot_overall(series: pd.DataFrame) -> None:
    fig, ax = plt.subplots(figsize=(8.4, 5.4))
    ax.plot(
        series["year"],
        series["index_p10"],
        color="black",
        marker="o",
        markersize=4.5,
        markerfacecolor="white",
        linewidth=1.4,
        label="index 10th pctile wages",
    )
    ax.plot(
        series["year"],
        series["index_p90"],
        color="black",
        marker="s",
        markersize=4.5,
        markerfacecolor="white",
        linewidth=1.4,
        label="index 90th pctile wages",
    )
    ax.plot(
        series["year"],
        series["index_p50"],
        color="black",
        marker="^",
        markersize=4.8,
        markerfacecolor="white",
        linewidth=1.4,
        label="index 50th pctile wages",
    )
    ax.set_xlim(series["year"].min() - 0.5, series["year"].max() + 0.5)
    ax.set_xlabel("year")
    ax.set_ylabel("index (2000 = 100)")
    ax.set_title("Indexed Weekly Wages for White Males 2000-2024")
    ax.spines["top"].set_visible(False)
    ax.spines["right"].set_visible(False)
    ax.legend(loc="upper left", frameon=False, ncol=2, handlelength=1.4, handletextpad=0.5)
    fig.tight_layout()
    fig.savefig(FIG_DIR / "acemoglu_2002_fig2_update_2024.pdf")
    plt.close(fig)


def plot_residual(series: pd.DataFrame) -> None:
    fig, ax = plt.subplots(figsize=(8.4, 5.4))
    ax.plot(
        series["year"],
        series["resid_90_50"],
        color="black",
        marker="o",
        markersize=4.5,
        markerfacecolor="white",
        linewidth=1.4,
        label="90-50 residual differences",
    )
    ax.plot(
        series["year"],
        series["resid_half_90_10"],
        color="black",
        marker="s",
        markersize=4.5,
        markerfacecolor="white",
        linewidth=1.4,
        label="0.5 times 90-10 residual diffs",
    )
    ax.plot(
        series["year"],
        series["resid_50_10"],
        color="black",
        marker="^",
        markersize=4.8,
        markerfacecolor="white",
        linewidth=1.4,
        label="50-10 residual differences",
    )
    ax.set_xlim(series["year"].min() - 0.5, series["year"].max() + 0.5)
    ax.set_xlabel("year")
    ax.set_ylabel("log points")
    ax.set_title("Residual Inequality Measures for White Males 2000-2024")
    ax.spines["top"].set_visible(False)
    ax.spines["right"].set_visible(False)
    ax.legend(loc="upper left", frameon=False, ncol=2, handlelength=1.4, handletextpad=0.5)
    fig.tight_layout()
    fig.savefig(FIG_DIR / "acemoglu_2002_fig3_update_2024.pdf")
    plt.close(fig)


def main() -> None:
    DATA_DIR.mkdir(parents=True, exist_ok=True)
    df = prepare_sample()
    overall = overall_series(df)
    residual = residual_series(df)

    merged = overall.merge(residual, on="year", how="inner")
    merged.to_csv(DATA_DIR / "acemoglu_2002_update_2000_2024.csv", index=False)

    summary = pd.DataFrame(
        {
            "sample_years": [f"{int(merged['year'].min())}-{int(merged['year'].max())}"],
            "workers_in_2024": [int((df["earnings_year"] == 2024).sum())],
        }
    )
    summary.to_csv(DATA_DIR / "summary.csv", index=False)

    plot_overall(overall)
    plot_residual(residual)


if __name__ == "__main__":
    main()
