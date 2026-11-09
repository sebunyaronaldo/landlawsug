# Methodology

How we turned Uganda's land laws into a graph — the process, the tools, the rules we
followed for interpretation, how we checked the result, and its known limitations.
The last section is the checklist for **adding a new law**.

## 1. Overview

```
 ULII website           PDF                 Text file            Cypher scripts          Neo4j
┌────────────┐     ┌───────────┐       ┌──────────────┐      ┌──────────────────┐     ┌─────────┐
│ ulii.org   │────▶│ 1965-14   │──────▶│ 1965-14.txt  │─────▶│ cypher/01 … 05   │────▶│  graph  │
│ (official  │ (1) │  .pdf     │  (2)  │              │ (3)  │  .cypher         │ (4) │         │
│  revised   │     └───────────┘ extract└──────────────┘ read │ (in git, reviewed│     └────┬────┘
│  laws)     │      download      .mjs         │       + toc  │  in pull request)│          │ (5)
└────────────┘                                 │       .mjs   └──────────────────┘   verify queries
                                               ▼
                                     a person reads the text and
                                     records institutions, concepts
                                     and relationships
```

| Step | What | Who / tool |
|---|---|---|
| 1 | Download the law's PDF from ULII, version "as at 31 December 2023" | Person, web browser |
| 2 | Extract the PDF text | `tools/pdf-extract/extract.mjs` |
| 3a | **Structure**: parts, subheadings and section titles from the table of contents | `tools/pdf-extract/toc.mjs` |
| 3b | **Meaning**: institutions, concepts and relationships from the section text | Person, reading the text |
| 4 | Load into Neo4j | `scripts/load.ps1` / `scripts/load.sh` |
| 5 | Verify against the PDF | Queries in [§5](#5-verification) |

The **Cypher files are the source of truth** — the database can be deleted and rebuilt from
them at any time (`docker compose down -v`, `docker compose up -d`, load). Nothing is typed
into the database by hand.

## 2. Source

- **One source only:** the Uganda Legal Information Institute (ULII) — see
  [sources.md](sources.md) and [ADR 0002](decisions/0002-ulii-as-single-source.md).
- **One version:** every law uses the ULII text **as at 31 December 2023** (2023 Revised
  Edition of the Laws of Uganda). It is recorded on each `Legislation` node as `sourceVersion`.
- **What the PDF gives us** (page 1 and the heading of the Act): title, chapter number,
  Act number, commencement date, long title, amendment notes and the FRBR URI.
- PDFs are **not** committed to the repository (licence — see [sources.md](sources.md)).

## 3. Scope decisions

| Decision | Reason |
|---|---|
| Four core laws: Constitution, Land Act, Registration of Titles Act, Land Acquisition Act | The laws most directly about who owns land, how it is registered and how the State can take it |
| Constitution: **Chapter 15 + Article 26 only** | The rest of the Constitution is not about land. Article 26 (protection of property, compulsory acquisition) is in Chapter 4, which is added as a `Part` containing only that article |
| Constitutional amendment Acts left out | They do not change the land provisions |
| Amending Acts are **minimal nodes** (title, number, date) | Needed so `AMENDS` can be recorded; their text is not loaded |
| Granularity: **Act → Part → Section** | Enough to answer "where in the law is X?"; subsections are not modelled (see [§6](#6-known-limitations)) |
| Neo4j property graph | See [ADR 0001](decisions/0001-use-neo4j-property-graph.md) |

## 4. Turning the text into a graph

The schema is in [data-model.md](data-model.md). This section explains *how* each kind of data was made.

### 4.1 Legislation (`02_legislation.cypher`)

Copied from page 1 and the heading of the Act. Example — Land Acquisition Act, page 3 of the PDF:

```
Land Acquisition Act
Chapter 235
Commenced on 2 July 1965
[Amended by Law Revision (Miscellaneous Amendments) Act, 2023 (Act 17 of 2023) on 28 July 2023]
An Act to provide for the compulsory acquisition of land for public purposes and for related matters.
[Act 14/1965; S.I. 135/1968; Act 13/1970, s. 241; Cap. 226 (Revised Edition, 2000); Act 17/2023]
```

becomes `chapter: 'Cap. 235'`, `commencementDate: date('1965-07-02')`, `actNumber: 'Act 14 of 1965'`,
`formerChapter: 'Cap. 226 (2000 Revised Edition)'`, `longTitle: …`, and an
`AMENDS {effectiveDate: date('2023-07-28')}` relationship from the 2023 Law Revision Act.

### 4.2 Structure (`03_structure.cypher`)

Generated from the PDF's **Contents** page with `toc.mjs`, then pasted into the Cypher file.
Titles are kept **exactly as printed**, including typos in the official text (RTA s.128
"Caveaton", Land Acquisition Act s.4 "eta"), with a comment. See
[tools/pdf-extract/README.md](../tools/pdf-extract/README.md).

### 4.3 Entities (`04_entities.cypher`)

Found by reading the sections. Descriptions and definitions are **our own plain-language
summaries**, each citing the section it comes from, e.g. *"(LAA s.6)"*. We do not paste the
official text.

| Kind | Added when the text… | Example |
|---|---|---|
| `Institution` | creates or appoints a body or office that has duties under the law | Assessment Officer (LAA s.1) |
| `LegalConcept` | defines a term, or a section is the main rule on a legal idea | Bona fide occupant (Land Act s.29) |
| `TenureType` | — fixed list of the four tenures in Land Act s.2 | Customary, freehold, mailo, leasehold |

Each entity is created **once** and reused across laws — e.g. `high-court` is used by both the
Land Act (s.84) and the Land Acquisition Act (s.13).

### 4.4 Relationships (`05_relationships.cypher`)

Each relationship is recorded with a comment quoting or citing the words in the text that justify it.

| Relationship | Rule we followed | Example (text → graph) |
|---|---|---|
| `ESTABLISHES` | The section creates the body, **or** says it "shall/may be appointed/formed" | LAA s.10 "he or she may appoint a public officer…" → `(s10)-[:ESTABLISHES]->(appointed-officer)` |
| `EMPOWERS {power}` | The section gives the body a power or duty; `power` is a short summary | LAA s.3 Minister "may, by statutory instrument, make a declaration" |
| `ACCOUNTABLE_TO {source}` | The text says one body supervises / controls the other | Land Act s.83: Chief Registrar supervises district land tribunals |
| `APPEALS_TO {source}` | The text gives a right of appeal from one body to another | LAA s.13: appeal against an award to the High Court |
| `DEFINES` | The section defines the concept, or is the main rule about it | LAA s.3 → compulsory acquisition |
| `RECOGNISES` | The section recognises a tenure system | Land Act s.2 → all four tenures |
| `REFERENCES` | The text cites another section → `Provision`; cites an Act but **no section** → the whole `Legislation` | Land Act s.43 "Articles 26 and 237(2) of the Constitution" → art26, art237 |
| `AMENDS {effectiveDate}` | Taken from the amendment notes at the top of the Act | 2023 Law Revision Act → Land Acquisition Act |

**Judgement calls** (open to team review):

- "May appoint / may be formed" is treated as `ESTABLISHES` (Recorder, Mediator, Communal Land
  Association, Assessment Officer, Appointed Officer).
- LAA s.7 says acquired land "vests in the Uganda Land Commission". There is no `VESTS_IN`
  relationship, so it is recorded as `EMPOWERS` with the vesting explained in `power`.
- RTA s.100 (leases) is recorded as `RECOGNISES` leasehold, as well as freehold and mailo.

### 4.5 Writing the Cypher

- **Always `MERGE` on `id`, never `CREATE`**, so every file can be loaded again without
  duplicates. Uniqueness constraints (`01_constraints.cypher`) enforce this.
- Data is written as `UNWIND [ {…}, {…} ] AS row` lists — one row per fact, easy to review in a diff.
- Strings use single quotes; an apostrophe inside is written `\'` (Cypher does **not** accept SQL's `''`).
- Files load in numeric order: constraints → legislation → structure → entities → relationships,
  because each file `MATCH`es nodes made by the files before it.

## 5. Verification

Every law was checked after loading:

| Check | How | Result |
|---|---|---|
| Section count per part = the PDF table of contents | Query 1 below | Land Act 92, RTA 187, LAA 21 — all match |
| Titles match the PDF | `toc.mjs` output compared with `03_structure.cypher` | All 300 section titles identical |
| No duplicates after loading twice | Load twice, compare totals | 381 nodes / 464 relationships both times |
| No duplicate ids | Query 2 below | 0 |
| Facts on `Legislation` nodes | Compared by hand with page 1 of each PDF | ✅ |
| Change history | Every change went through a pull request on GitHub | ✅ |

```cypher
// 1. Sections per part, for one law
MATCH (:Legislation {id: 'land-acquisition-act'})-[:HAS_PART]->(p)-[:HAS_PROVISION]->(s)
RETURN p.number AS part, count(s) AS sections ORDER BY part;

// 2. Duplicate ids (should return 0)
MATCH (n) WITH n.id AS id, count(*) AS c WHERE c > 1 RETURN count(*) AS duplicateIds;

// 3. Totals by label and by relationship type
MATCH (n) RETURN labels(n)[0] AS label, count(*) AS n ORDER BY label;
MATCH ()-[r]->() RETURN type(r) AS rel, count(*) AS n ORDER BY rel;
```

## 6. Known limitations

- **Not the official text.** The graph holds titles and our summaries; the authority is always the ULII text.
- **Summaries and relationships are interpretations.** They were made by reading the text and
  are open to review (see the judgement calls in §4.4). This is not legal advice.
- **No subsections.** A relationship found in s.7(3) is recorded on s.7.
- **Amendments are at Act level.** We record *that* an Act amended another and *when*, not *which
  sections* it changed.
- **`IMPLEMENTS` is defined but not yet used.** Links to the Constitution are recorded as `REFERENCES`,
  only where the text cites an article.
- **One point in time.** Laws as at 31 December 2023; later amendments are not included.
- **Relationships are selective.** We recorded the main institutions, powers and concepts, not every
  duty in every section.

## 7. Adding a new law

Follow these steps for each law marked ❌ in the [README](../README.md#scope).

1. **Branch** from an up-to-date `main`:
   `git switch main && git pull && git switch -c data/<law-name>`
2. **Download** the PDF from ulii.org (version "as at 31 December 2023"). Keep it outside the repo.
   Note the page URL — it becomes `sourceUrl`.
3. **Extract** the text: `node tools/pdf-extract/extract.mjs <law>.pdf <law>.txt`
4. **Legislation node** — add it to `02_legislation.cypher` from page 1 of the PDF (§4.1), plus
   `AMENDS` from the amendment notes. Reuse existing amending-Act nodes where they exist
   (e.g. `law-revision-misc-amendments-act-2023`).
5. **Structure** — `node tools/pdf-extract/toc.mjs <law>.txt`, paste the rows into
   `03_structure.cypher` following the existing pattern, and compare the counts with the PDF.
6. **Read the sections** and list the institutions, concepts and relationships (§4.3–4.4).
   Check the existing nodes first — reuse `high-court`, `registrar-of-titles`, etc. rather than
   creating duplicates. Write summaries in your own words, citing the section.
7. **Links to other laws** — search the text for the names of the other laws in the graph and
   add `REFERENCES`. Also search the *existing* laws for the new law's name (that is how
   Land Act s.42 → Land Acquisition Act was found).
8. **Schema** — if you need a new label, relationship or property, update
   [data-model.md](data-model.md) first, in the same pull request.
9. **Load and verify** — run the load script twice and the queries in §5.
10. **README** — change the law's ❌ to ✅ in the scope table.
11. **Pull request** — fill in the template, including the
    [verification checklist](sources.md#verification-checklist-before-opening-a-pull-request),
    and ask a team member to review before merging.
