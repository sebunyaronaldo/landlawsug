# Sources

## Single source: ULII

All data in this graph comes from **one source only**: the
**Uganda Legal Information Institute (ULII)** — <https://ulii.org/>.

See [decisions/0002-ulii-as-single-source.md](decisions/0002-ulii-as-single-source.md) for why.

Rules:

- Every `Legislation` node's `sourceUrl` must point to its page on `ulii.org`.
- Titles, years, chapter numbers, part and section numbers and headings are taken from the
  ULII text exactly as published.
- If something is not available on ULII, it is **out of scope** — do not fill gaps from other
  websites, textbooks or memory. Raise a GitHub issue instead.
- Record which version of the text you used (ULII shows the version / "as at" date) in the
  `sourceVersion` property.

## Chapter numbers — important

Uganda's laws were consolidated in the **2000 Revised Edition** and again in the
**2023 Revised Edition**, which renumbered many chapters (for example, the Land Act was
`Cap. 227` in the 2000 edition). Record the chapter number exactly as ULII shows it for the
version you used, and record the edition in the `chapterEdition` property.

## Verification checklist (before opening a pull request)

- [ ] Title, year and chapter checked against the ULII text
- [ ] Part and section numbers and headings checked against the ULII text
- [ ] `sourceUrl` points to ulii.org and the link works
- [ ] `sourceVersion` recorded
- [ ] Summaries written in our own words and accurate

## Licence

ULII's PDFs are published with Laws.Africa under the
**Creative Commons Attribution-NonCommercial-ShareAlike 4.0** licence (CC BY-NC-SA 4.0),
as stated on page 1 of each PDF. For this project that means:

- **Credit** ULII and Laws.Africa — every `Legislation` node links to its ULII page.
- **Non-commercial** use only.
- **Share-alike** — work derived from the text is shared under the same terms.
- The PDFs themselves are **not committed** to this repository (`*.pdf` is in `.gitignore`);
  each team member downloads them from ULII.

## Laws used

| Law | ULII page (version as at 31 December 2023) |
|---|---|
| Constitution of the Republic of Uganda, 1995 | <https://ulii.org/en/akn/ug/act/statute/1995/constitution/eng@2023-12-31> |
| Land Act (Chapter 236) | <https://ulii.org/akn/ug/act/1998/16/eng@2023-12-31> |
| Registration of Titles Act (Chapter 240) | <https://ulii.org/en/akn/ug/act/ord/1922/22/eng@2023-12-31> |
| Land Acquisition Act (Chapter 235) | <https://ulii.org/en/akn/ug/act/1965/14/eng@2023-12-31> |

## Citation format (for reports)

> *Land Act*, Cap. 236 (Laws of Uganda, 2023 Revised Edition), s. 29, available at ULII, https://ulii.org/akn/ug/act/1998/16/eng@2023-12-31
> *Constitution of the Republic of Uganda*, 1995, art. 237, available at ULII, https://ulii.org/en/akn/ug/act/statute/1995/constitution/eng@2023-12-31
