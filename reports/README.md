# Reports

Designated location for Associated Partners project briefings, slide decks, and status notes.

```text
reports/
├── README.md                 ← this index
├── status-brief.md           ← full written status (done / next / decisions)
└── slides/
    ├── associated-partners-status.tex
    └── Makefile              ← optional PDF build
```

## Files

| File | Purpose |
| --- | --- |
| [`status-brief.md`](status-brief.md) | Accomplishments, remaining work, outstanding decisions |
| [`slides/associated-partners-status.tex`](slides/associated-partners-status.tex) | Beamer slide deck (LaTeX source) |

## Build the slides (optional)

Requires a LaTeX distribution with Beamer (TeX Live / MacTeX):

```bash
cd reports/slides
make
# or
pdflatex associated-partners-status.tex
```

Output: `associated-partners-status.pdf`
