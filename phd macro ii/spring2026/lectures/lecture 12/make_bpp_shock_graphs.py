from pathlib import Path

import matplotlib.pyplot as plt
from matplotlib.ticker import FormatStrFormatter


FIGURE_DIR = Path(__file__).resolve().parent / "figures"

COLORS = {
    "permanent": "#234A84",
    "transitory": "#D55E00",
    "text": "#444444",
    "grid": "#E2E8F0",
}

DATA = {
    "whole_sample": {
        "title": "Whole sample",
        "output": "bpp_shocks_whole_sample.pdf",
        "permanent": [
            (1980, 0.0102),
            (1982, 0.0207),
            (1983, 0.0301),
            (1984, 0.0274),
            (1985, 0.0293),
            (1986, 0.0222),
            (1987, 0.0289),
            (1988, 0.0157),
            (1989, 0.0185),
            (1991, 0.0134),
        ],
        "transitory": [
            (1979, 0.0415),
            (1980, 0.0318),
            (1981, 0.0372),
            (1982, 0.0286),
            (1983, 0.0286),
            (1984, 0.0351),
            (1985, 0.0380),
            (1986, 0.0544),
            (1987, 0.0480),
            (1988, 0.0383),
            (1989, 0.0369),
            (1991, 0.0506),
        ],
    },
    "college": {
        "title": "College",
        "output": "bpp_shocks_college.pdf",
        "permanent": [
            (1980, 0.0099),
            (1982, 0.0252),
            (1983, 0.0233),
            (1984, 0.0176),
            (1985, 0.0204),
            (1986, 0.0312),
            (1987, 0.0354),
            (1988, 0.0183),
            (1989, 0.0274),
            (1991, 0.0216),
        ],
        "transitory": [
            (1979, 0.0302),
            (1980, 0.0284),
            (1981, 0.0253),
            (1982, 0.0214),
            (1983, 0.0186),
            (1984, 0.0305),
            (1985, 0.0496),
            (1986, 0.0452),
            (1987, 0.0421),
            (1988, 0.0343),
            (1989, 0.0219),
            (1991, 0.0345),
        ],
    },
    "no_college": {
        "title": "No college",
        "output": "bpp_shocks_no_college.pdf",
        "permanent": [
            (1980, 0.0067),
            (1982, 0.0154),
            (1983, 0.0317),
            (1984, 0.0333),
            (1985, 0.0287),
            (1986, 0.0173),
            (1987, 0.0202),
            (1988, 0.0117),
            (1989, 0.0107),
            (1991, 0.0092),
        ],
        "transitory": [
            (1979, 0.0465),
            (1980, 0.0330),
            (1981, 0.0364),
            (1982, 0.0376),
            (1983, 0.0372),
            (1984, 0.0405),
            (1985, 0.0356),
            (1986, 0.0474),
            (1987, 0.0520),
            (1988, 0.0472),
            (1989, 0.0539),
            (1991, 0.0536),
        ],
    },
}


def unpack(points):
    years, values = zip(*points)
    return years, values


def apply_style():
    plt.rcParams.update(
        {
            "figure.facecolor": "white",
            "axes.facecolor": "white",
            "axes.edgecolor": COLORS["text"],
            "axes.labelcolor": COLORS["text"],
            "axes.titlecolor": COLORS["text"],
            "xtick.color": COLORS["text"],
            "ytick.color": COLORS["text"],
            "font.size": 11,
            "axes.titlesize": 13,
            "axes.labelsize": 11,
            "legend.fontsize": 10,
            "pdf.fonttype": 42,
            "ps.fonttype": 42,
        }
    )


def plot_group(group):
    fig, ax = plt.subplots(figsize=(7.6, 4.5))

    permanent_years, permanent_values = unpack(group["permanent"])
    transitory_years, transitory_values = unpack(group["transitory"])

    ax.plot(
        permanent_years,
        permanent_values,
        color=COLORS["permanent"],
        marker="o",
        markersize=4,
        linewidth=2,
        label=r"$Var(\nu)$ permanent shock",
    )
    ax.plot(
        transitory_years,
        transitory_values,
        color=COLORS["transitory"],
        marker="s",
        markersize=3.8,
        linewidth=2,
        linestyle="--",
        label=r"$Var(\epsilon)$ transitory shock",
    )

    ax.set_title(group["title"], loc="left", fontweight="bold")
    ax.set_xlabel("Year")
    ax.set_ylabel("Variance")
    ax.set_xlim(1978.7, 1991.3)
    ax.set_ylim(0, 0.06)
    ax.set_xticks([1979, 1982, 1985, 1988, 1991])
    ax.set_xticklabels(["1979", "1982", "1985", "1988", "1990--92"])
    ax.set_yticks([0, 0.01, 0.02, 0.03, 0.04, 0.05, 0.06])
    ax.yaxis.set_major_formatter(FormatStrFormatter("%.2f"))

    ax.grid(axis="y", color=COLORS["grid"], linewidth=0.8)
    ax.grid(axis="x", visible=False)
    ax.spines["top"].set_visible(False)
    ax.spines["right"].set_visible(False)
    ax.legend(frameon=False, loc="upper left")

    fig.tight_layout(pad=0.7)
    fig.savefig(FIGURE_DIR / group["output"], bbox_inches="tight")
    plt.close(fig)


def main():
    FIGURE_DIR.mkdir(exist_ok=True)
    apply_style()
    for group in DATA.values():
        plot_group(group)


if __name__ == "__main__":
    main()
