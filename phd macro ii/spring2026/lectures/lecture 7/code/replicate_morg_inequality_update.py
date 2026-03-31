from __future__ import annotations

from pathlib import Path

import matplotlib
import numpy as np
import pandas as pd

matplotlib.use("Agg")
import matplotlib.pyplot as plt


BASE_DIR = Path(__file__).resolve().parent.parent
DATA_DIR = BASE_DIR / "data" / "morg_update_2024"
FIG_DIR = BASE_DIR / "figures"

YEARS = range(1979, 2025)
PCEPI_URL = "https://fred.stlouisfed.org/graph/fredgraph.csv?id=PCEPI"

OLD_REGION_MAP = {
    11: "Northeast",
    12: "Northeast",
    13: "Northeast",
    14: "Northeast",
    15: "Northeast",
    16: "Northeast",
    21: "Northeast",
    22: "Northeast",
    23: "Northeast",
    31: "Midwest",
    32: "Midwest",
    33: "Midwest",
    34: "Midwest",
    35: "Midwest",
    41: "Midwest",
    42: "Midwest",
    43: "Midwest",
    44: "Midwest",
    45: "Midwest",
    46: "Midwest",
    47: "Midwest",
    51: "South",
    52: "South",
    53: "South",
    54: "South",
    55: "South",
    56: "South",
    57: "South",
    58: "South",
    59: "South",
    61: "South",
    62: "South",
    63: "South",
    64: "South",
    71: "South",
    72: "South",
    73: "South",
    74: "South",
    81: "West",
    82: "West",
    83: "West",
    84: "West",
    85: "West",
    86: "West",
    87: "West",
    88: "West",
    91: "West",
    92: "West",
    93: "West",
    94: "West",
    95: "West",
}

NEW_REGION_MAP = {
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

GRADE92_TO_YEARS = {
    31: 0.0,
    32: 2.5,
    33: 5.5,
    34: 7.5,
    35: 9.0,
    36: 10.0,
    37: 11.0,
    38: 11.5,
    39: 12.0,
    40: 13.0,
    41: 14.0,
    42: 14.0,
    43: 16.0,
    44: 18.0,
    45: 19.0,
    46: 20.0,
}


def weighted_quantile(values: np.ndarray, quantiles: list[float], weights: np.ndarray) -> np.ndarray:
    order = np.argsort(values)
    values = values[order]
    weights = weights[order]
    cumulative = np.cumsum(weights) - 0.5 * weights
    cumulative = cumulative / weights.sum()
    return np.interp(quantiles, cumulative, values)


def fetch_pcepi() -> pd.DataFrame:
    pce = pd.read_csv(PCEPI_URL)
    pce["observation_date"] = pd.to_datetime(pce["observation_date"])
    pce["year"] = pce["observation_date"].dt.year
    pce["intmonth"] = pce["observation_date"].dt.month
    return pce[["year", "intmonth", "PCEPI"]].rename(columns={"PCEPI": "pcepi"})


def selected_cache_path(year: int) -> Path:
    return DATA_DIR / f"morg_selected_{year}.csv.gz"


def annual_url(year: int) -> str:
    return f"https://data.nber.org/morg/annual/morg{year % 100:02d}.dta"


def build_selected_frame(year: int) -> pd.DataFrame:
    cache = selected_cache_path(year)
    if cache.exists():
        return pd.read_csv(cache)

    url = annual_url(year)
    has_stfips = year >= 1992
    has_grade92 = year >= 1992
    has_class94 = year >= 1994
    state_col = "stfips" if has_stfips else "state"
    educ_col = "grade92" if has_grade92 else "gradeat"
    class_col = "class94" if has_class94 else "class"
    extra_cols = [] if has_grade92 else ["gradecp"]

    keep = [
        "year",
        "intmonth",
        "age",
        "sex",
        "race",
        state_col,
        "uhourse",
        "earnwke",
        "earnhre",
        "paidhre",
        "eligible",
        "earnwt",
        educ_col,
        class_col,
        *extra_cols,
    ]

    print(f"Reading MORG {year}...", flush=True)
    df = pd.read_stata(url, columns=keep, convert_categoricals=False)
    df = df.rename(columns={state_col: "state_code", educ_col: "educ_raw", class_col: "class_raw"})
    df["source_year"] = year

    if has_grade92:
        df["educ_years"] = df["educ_raw"].map(GRADE92_TO_YEARS)
        df["region"] = df["state_code"].map(NEW_REGION_MAP if has_stfips else OLD_REGION_MAP)
    else:
        # gradeat is highest grade attended; gradecp indicates whether it was completed.
        completed = np.where(df["gradecp"] == 1, df["educ_raw"], df["educ_raw"] - 1)
        df["educ_years"] = np.clip(completed.astype(float), 0.0, None)
        df["region"] = df["state_code"].map(OLD_REGION_MAP)
    df["wage_salary_worker"] = df["class_raw"] <= (5 if has_class94 else 4)

    df["paid_hourly"] = df["paidhre"] == 1
    # Use weekly earnings divided by usual hours for a single harmonized hourly wage measure.
    df["hourly_wage_nominal"] = df["earnwke"] / df["uhourse"]

    out = df[
        [
            "year",
            "intmonth",
            "age",
            "sex",
            "race",
            "state_code",
            "region",
            "uhourse",
            "earnwke",
            "hourly_wage_nominal",
            "paid_hourly",
            "eligible",
            "earnwt",
            "educ_years",
            "wage_salary_worker",
        ]
    ].copy()
    out.to_csv(cache, index=False, compression="gzip")
    print(f"Cached MORG {year}", flush=True)
    return out


def prepare_sample() -> pd.DataFrame:
    pce = fetch_pcepi()
    frames = []
    for year in YEARS:
        frames.append(build_selected_frame(year))

    df = pd.concat(frames, ignore_index=True)
    df = df.merge(pce, on=["year", "intmonth"], how="left")

    df = df[
        (df["sex"] == 1)
        & (df["race"] == 1)
        & (df["eligible"] == 1)
        & (df["wage_salary_worker"])
        & (df["age"].between(18, 65))
        & (df["uhourse"] >= 35)
        & (df["earnwt"] > 0)
        & df["region"].notna()
        & df["educ_years"].notna()
        & (df["pcepi"] > 0)
    ].copy()

    df["hourly_wage_nominal"] = df["earnwke"] / df["uhourse"]
    df = df[
        (df["hourly_wage_nominal"] > 0)
        & np.isfinite(df["hourly_wage_nominal"])
    ].copy()

    df["hourly_wage_real"] = df["hourly_wage_nominal"] / df["pcepi"] * 100.0
    df["log_hourly_wage"] = np.log(df["hourly_wage_nominal"])
    df["experience"] = (df["age"] - df["educ_years"] - 6.0).clip(lower=0.0, upper=50.0)

    educ_bins = pd.cut(
        df["educ_years"],
        bins=[-0.1, 11.5, 12.5, 15.5, 16.5, 50],
        labels=["lt_hs", "hs", "some_college", "college", "advanced"],
    )
    df["educ_group"] = educ_bins.astype(str)
    return df


def overall_series(df: pd.DataFrame) -> pd.DataFrame:
    rows = []
    for year, grp in df.groupby("year"):
        q10, q50, q90 = weighted_quantile(
            grp["hourly_wage_real"].to_numpy(),
            [0.10, 0.50, 0.90],
            grp["earnwt"].to_numpy(),
        )
        rows.append({"year": year, "p10": q10, "p50": q50, "p90": q90})

    out = pd.DataFrame(rows).sort_values("year").reset_index(drop=True)
    base = out.loc[out["year"] == out["year"].min(), ["p10", "p50", "p90"]].iloc[0]
    out["index_p10"] = 100.0 * out["p10"] / base["p10"]
    out["index_p50"] = 100.0 * out["p50"] / base["p50"]
    out["index_p90"] = 100.0 * out["p90"] / base["p90"]
    out["overall_90_50"] = np.log(out["p90"]) - np.log(out["p50"])
    out["overall_50_10"] = np.log(out["p50"]) - np.log(out["p10"])
    return out


def residual_series(df: pd.DataFrame) -> pd.DataFrame:
    rows = []
    for year, grp in df.groupby("year"):
        work = grp.copy()
        educ = pd.get_dummies(work["educ_group"], prefix="ed")
        region = pd.get_dummies(work["region"], prefix="reg")

        x = pd.DataFrame(index=work.index)
        x["const"] = 1.0
        x = pd.concat([x, educ, region], axis=1)
        x["exp1"] = work["experience"]
        x["exp2"] = work["experience"] ** 2
        x["exp3"] = work["experience"] ** 3
        x["exp4"] = work["experience"] ** 4

        y = work["log_hourly_wage"].to_numpy()
        w = work["earnwt"].to_numpy()
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
        markersize=4.0,
        markerfacecolor="white",
        linewidth=1.3,
        label="index 10th pctile hourly wages",
    )
    ax.plot(
        series["year"],
        series["index_p90"],
        color="black",
        marker="s",
        markersize=4.0,
        markerfacecolor="white",
        linewidth=1.3,
        label="index 90th pctile hourly wages",
    )
    ax.plot(
        series["year"],
        series["index_p50"],
        color="black",
        marker="^",
        markersize=4.2,
        markerfacecolor="white",
        linewidth=1.3,
        label="index 50th pctile hourly wages",
    )
    ax.set_xlim(series["year"].min() - 0.5, series["year"].max() + 0.5)
    ax.set_xlabel("year")
    ax.set_ylabel("index (1979 = 100)")
    ax.set_title("Indexed Hourly Wages for White Male Full-Time Workers 1979-2024")
    ax.spines["top"].set_visible(False)
    ax.spines["right"].set_visible(False)
    ax.legend(loc="upper left", frameon=False, ncol=2, fontsize=9)
    fig.tight_layout()
    fig.savefig(FIG_DIR / "acemoglu_2002_fig2_morg_2024.pdf")
    plt.close(fig)


def plot_residual(series: pd.DataFrame) -> None:
    fig, ax = plt.subplots(figsize=(8.4, 5.4))
    ax.plot(
        series["year"],
        series["resid_90_50"],
        color="black",
        marker="o",
        markersize=4.0,
        markerfacecolor="white",
        linewidth=1.3,
        label="90-50 residual differences",
    )
    ax.plot(
        series["year"],
        series["resid_half_90_10"],
        color="black",
        marker="s",
        markersize=4.0,
        markerfacecolor="white",
        linewidth=1.3,
        label="0.5 times 90-10 residual diffs",
    )
    ax.plot(
        series["year"],
        series["resid_50_10"],
        color="black",
        marker="^",
        markersize=4.2,
        markerfacecolor="white",
        linewidth=1.3,
        label="50-10 residual differences",
    )
    ax.set_xlim(series["year"].min() - 0.5, series["year"].max() + 0.5)
    ax.set_xlabel("year")
    ax.set_ylabel("log points")
    ax.set_title("Residual Hourly Wage Inequality for White Male Full-Time Workers 1979-2024")
    ax.spines["top"].set_visible(False)
    ax.spines["right"].set_visible(False)
    ax.legend(loc="upper left", frameon=False, ncol=2, fontsize=9)
    fig.tight_layout()
    fig.savefig(FIG_DIR / "acemoglu_2002_fig3_morg_2024.pdf")
    plt.close(fig)


def main() -> None:
    DATA_DIR.mkdir(parents=True, exist_ok=True)
    df = prepare_sample()
    overall = overall_series(df)
    residual = residual_series(df)
    merged = overall.merge(residual, on="year", how="inner")
    merged.to_csv(DATA_DIR / "morg_inequality_1979_2024.csv", index=False)

    summary = pd.DataFrame(
        {
            "sample_years": [f"{int(merged['year'].min())}-{int(merged['year'].max())}"],
            "workers_in_2024": [int((df["year"] == 2024).sum())],
        }
    )
    summary.to_csv(DATA_DIR / "summary.csv", index=False)

    plot_overall(overall)
    plot_residual(residual)


if __name__ == "__main__":
    main()
