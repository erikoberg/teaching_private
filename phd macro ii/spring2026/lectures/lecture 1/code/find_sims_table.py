from __future__ import annotations

from pathlib import Path

import fitz  # PyMuPDF


# This file lives at:
#   teaching_private/phd macro ii/spring2026/lectures/lecture 1/code/find_sims_table.py
# so parents[5] is the repository root (teaching_private).
ROOT = Path(__file__).resolve().parents[5]
MATERIAL = ROOT / "phd macro ii" / "material"

NEEDLES = [
    # Keep this list tight; we primarily care about the moments table.
    "Eric Sims",
    "Sims",
    "Table 1",
    "business cycle",
    "HP-filter",
    "standard deviation",
    "rel. sd",
    "autocorr",
]


def main() -> None:
    pdfs = sorted(MATERIAL.rglob("*.pdf"))
    print(f"Scanning {len(pdfs)} PDFs under: {MATERIAL}")

    hits = 0
    for pdf in pdfs:
        try:
            doc = fitz.open(pdf)
        except Exception:
            continue

        # quick metadata prefilter (cheap)
        meta_blob = " ".join(
            str(doc.metadata.get(k, "") or "") for k in ("title", "author", "subject", "keywords")
        )
        meta_blob_l = meta_blob.lower()
        meta_match = any(n.lower() in meta_blob_l for n in ("sims", "table"))

        for page_i in range(doc.page_count):
            page = doc.load_page(page_i)
            text = page.get_text("text")
            t = text.lower()

            # We only want candidates that look like "Sims, Table 1" for business-cycle moments.
            looks_like_target = (
                ("table 1" in t)
                and (("sims" in t) or ("eric sims" in t) or ("sims" in meta_blob_l))
                and (("hp" in t) or ("hp-filter" in t) or ("standard deviation" in t) or ("rel. sd" in t))
            )

            if looks_like_target:
                matched = [n for n in NEEDLES if n.lower() in t]
                if matched or meta_match:
                    hits += 1
                    print(f"\nHIT: {pdf}")
                    print(f"  page: {page_i + 1}/{doc.page_count}")
                    print(f"  matched: {', '.join(matched[:6])}{' ...' if len(matched) > 6 else ''}")
                    # print a small excerpt around "table 1" if present
                    key = "table 1"
                    if key in t:
                        pos = t.find(key)
                        excerpt = text[max(0, pos - 200) : pos + 200].replace("\n", " ")
                        # Force ASCII-only output to avoid Windows console encoding issues.
                        safe_excerpt = excerpt.encode("ascii", "backslashreplace").decode("ascii")
                        print(f"  excerpt: {safe_excerpt}")
                    break

        doc.close()

    print(f"\nDone. total hits: {hits}")


if __name__ == "__main__":
    main()

