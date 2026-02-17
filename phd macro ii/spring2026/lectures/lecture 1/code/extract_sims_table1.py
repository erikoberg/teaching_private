from __future__ import annotations

from pathlib import Path

import fitz  # PyMuPDF


ROOT = Path(__file__).resolve().parents[5]  # teaching_private
SIMS_PDF = ROOT / "phd macro ii" / "material" / "sims" / "notes_rbc_quant_sp2024.pdf"
OUT_PDF = ROOT / "phd macro ii" / "spring2026" / "lectures" / "lecture 1" / "Figures" / "sims_bc_table.pdf"

# Table 1 is on this page (1-indexed) in the Sims notes PDF.
TABLE1_PAGE = 5

TABLE_KEYWORDS = [
    "Table 1",
    "HP-Filtered Business Cycle Moments",
    "Series",
    "Std. Dev.",
    "Rel. Std. Dev.",
    "Corr w/ yt",
    "Autocorr",
    "Corr w/ Yt",
    "Output",
    "Consumption",
    "Investment",
    "Hours",
    "Avg. Labor Productivity",
    "Wage",
    "Real Rate",
    "Price Level",
    "TFP",
]


def union_rect(rects: list[fitz.Rect]) -> fitz.Rect:
    r = rects[0]
    for rr in rects[1:]:
        r |= rr
    return r


def main() -> None:
    if not SIMS_PDF.exists():
        raise FileNotFoundError(f"Missing Sims PDF: {SIMS_PDF}")

    doc = fitz.open(SIMS_PDF)
    page = doc.load_page(TABLE1_PAGE - 1)

    # Collect bounding boxes for text spans that look like part of the table.
    d = page.get_text("dict")
    rects: list[fitz.Rect] = []
    for block in d.get("blocks", []):
        for line in block.get("lines", []):
            for span in line.get("spans", []):
                txt = (span.get("text") or "").strip()
                if not txt:
                    continue
                if any(k.lower() in txt.lower() for k in TABLE_KEYWORDS):
                    rects.append(fitz.Rect(span["bbox"]))

    if not rects:
        raise RuntimeError("Could not detect table text bounding boxes on the target page.")

    # Crop region: union of detected table text, with a bit of padding.
    crop = union_rect(rects)
    pad_x = 12
    pad_y_top = 10
    pad_y_bottom = 14
    crop = fitz.Rect(
        max(0, crop.x0 - pad_x),
        max(0, crop.y0 - pad_y_top),
        min(page.rect.x1, crop.x1 + pad_x),
        min(page.rect.y1, crop.y1 + pad_y_bottom),
    )

    out = fitz.open()
    out.insert_pdf(doc, from_page=TABLE1_PAGE - 1, to_page=TABLE1_PAGE - 1)
    out_page = out.load_page(0)
    out_page.set_cropbox(crop)

    OUT_PDF.parent.mkdir(parents=True, exist_ok=True)
    # Disable object streams to keep PDF version <= 1.6 (pdfTeX warns on 1.7).
    out.save(
        OUT_PDF,
        garbage=4,
        clean=1,
        deflate=1,
        use_objstms=0,
    )
    out.close()
    doc.close()

    print(f"Wrote cropped Table 1 to: {OUT_PDF}")


if __name__ == "__main__":
    main()

