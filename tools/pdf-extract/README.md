# PDF extract tool

Two small Node.js scripts used to turn a ULII legislation PDF into graph data.

| Script | Input | Output |
|---|---|---|
| `extract.mjs` | ULII PDF | Plain-text file of the whole PDF, one line per printed line, with `=== PAGE n ===` markers |
| `toc.mjs` | Text file from `extract.mjs` | The Act's parts, subheadings and sections as Cypher rows for `cypher/03_structure.cypher` |

Text extraction uses [pdf.js](https://mozilla.github.io/pdf.js/) (`pdfjs-dist`, pinned to `4.10.38`).

## Setup

Requires [Node.js](https://nodejs.org/) 18 or newer.

```bash
cd tools/pdf-extract
npm install
```

## Usage

Keep PDFs and extracted text **outside the repository** (for example in your Downloads folder).
They are licensed by ULII and are not committed — see [docs/sources.md](../../docs/sources.md).

```bash
# 1. PDF -> text
node extract.mjs ~/Downloads/1965-14.pdf ~/Downloads/1965-14.txt

# 2. Text -> Cypher rows (prints to the screen; the counts are printed last)
node toc.mjs ~/Downloads/1965-14.txt
#   4 parts, 21 sections

# Or as JSON
node toc.mjs ~/Downloads/1965-14.txt --json
```

Example output of step 2:

```
// Parts
  {num: 'I', order: 1, title: 'Interpretation'},
  {num: 'II', order: 2, title: 'Acquisitions, etc.'},
  ...
// Sections
  {n: 1, part: 'I', title: 'Interpretation'},
  {n: 2, part: 'II', title: 'Power to enter on and examine land'},
  ...
```

## How `toc.mjs` works

ULII PDFs start with a **Contents** page in a fixed format:

```
Part II – Acquisitions, etc. .......................... 1
2. Power to enter on and examine land ................. 1
Transfers ............................................. 19     <- subheading inside a part
```

The script reads from `Contents` to the line `Commenced on …`, skips page headers and
roman page numbers, joins titles that wrap onto two lines, removes the dot leaders and page
numbers, and classifies each entry as a **Part**, a **section** or a **subheading**. Schedules are skipped.

## Always check the output

The tool copies titles exactly as printed, including typos in the official text
(e.g. "Caveaton" in RTA s.128, "eta" in Land Acquisition Act s.4) — keep them, and add a
comment in the Cypher. Before using the rows, compare the part and section counts with the PDF.

Re-checked on 9 November 2026: the output matches all 300 section titles in
`cypher/03_structure.cypher` exactly (Land Act 92, Registration of Titles Act 187,
Land Acquisition Act 21).
