# Uganda Land Laws Graph Database

A graph database of Uganda's land laws, built with Neo4j and queried with Cypher.

Instead of storing laws as flat documents or tables, this project models them as a **network**:
laws, their parts and sections, the institutions they create, the land tenure systems they
recognise, and the legal concepts they define, all connected by meaningful relationships
such as `AMENDS`, `ESTABLISHES`, `DEFINES` and `REFERENCES`.

This makes it possible to answer questions like:

- Which institutions does the Land Act establish, and who are they accountable to?
- I disagree with a District Land Tribunal decision — where can I appeal?
- The Government wants my land — what are the steps, and who does what?
- Which provisions, across all the laws, deal with compulsory acquisition?
- How do the laws cite each other?

See [queries/example_queries.cypher](queries/example_queries.cypher) for these and more.

## Scope

### Core legislation

The four laws most directly about land ownership and rights:

| Legislation | Coverage | Status |
|---|---|---|
| Constitution of the Republic of Uganda, 1995 | Chapter 15 (Land and environment) and Article 26 (Protection from deprivation of property) | ✅ |
| Land Act (Chapter 236) | All parts and sections, plus its amending Acts (2001, 2004, 2010, 2023) | ✅ |
| Registration of Titles Act (Chapter 240) | All parts and sections, plus its amending Acts (Mortgage Act, 2023 Law Revision Act) | ✅ |
| Land Acquisition Act (Chapter 235) | All parts and sections, plus its 2023 amending Act | ✅ |

### Other land laws

| Legislation | Status |
|---|---|
| Mortgage Act | ❌ |
| Physical Planning Act | ❌ |
| Condominium Property Act | ❌ |
| Survey Act | ❌ |
| Uganda Land Commission Act | ❌ |

Titles and chapter numbers will be confirmed from ULII when each law is added.
To add one, follow [Adding a new law](docs/methodology.md#7-adding-a-new-law).

**Data source:** all data comes from the [Uganda Legal Information Institute (ULII)](https://ulii.org/) only,
version as at 31 December 2023.

Granularity: **Legislation → Part → Provision (section / article)**. See [docs/data-model.md](docs/data-model.md).

### What is in the graph

| Nodes | Count | | Relationships | Count |
|---|---|---|---|---|
| Legislation | 9 (4 core laws + 5 amending Acts) | | HAS_PART / HAS_PROVISION | 26 / 310 |
| Part | 26 | | REFERENCES | 39 |
| Provision (sections + articles) | 310 | | EMPOWERS | 25 |
| Institution | 16 | | DEFINES | 22 |
| LegalConcept | 16 | | RECOGNISES / ESTABLISHES | 15 / 13 |
| TenureType | 4 | | AMENDS / ACCOUNTABLE_TO / APPEALS_TO | 7 / 4 / 3 |

## Quick start

**Prerequisites:** [Docker Desktop](https://www.docker.com/products/docker-desktop/) (open and running) and [Git](https://git-scm.com/).

1. **Clone** the repository:

   ```bash
   git clone https://github.com/sebunyaronaldo/landlawsug.git
   cd landlawsug
   ```

2. **Create a `.env` file** in the project folder containing this one line, with your own
   password (at least 8 characters):

   ```
   NEO4J_PASSWORD=your-own-password
   ```

   `.env` is ignored by git, so your password is never uploaded. Each team member creates their own.

3. **Start Neo4j:**

   ```bash
   docker compose up -d
   ```

   Wait about 30 seconds the first time while Neo4j starts.

4. **Load the data** (the scripts load `cypher/01` … `05` in order):

   ```bash
   ./scripts/load.sh             # macOS / Linux / Git Bash
   .\scripts\load.ps1            # Windows PowerShell
   ```

   You should see `Loading 01_constraints.cypher ...` through `05_relationships.cypher` and then `Done.`
   It is safe to run again at any time — it never creates duplicates.

5. **Check it worked:** open the Neo4j Browser at <http://localhost:7474>, log in with user
   `neo4j` and the password from your `.env`, and run:

   ```cypher
   MATCH (n) RETURN labels(n)[0] AS label, count(*) AS n ORDER BY label;
   ```

   You should see the counts in [What is in the graph](#what-is-in-the-graph). Then try the
   queries in [queries/example_queries.cypher](queries/example_queries.cypher).

To stop Neo4j: `docker compose down` (your data is kept). To delete the data and start fresh:
`docker compose down -v`, then steps 3–4 again.

## Troubleshooting

| Problem | Fix |
|---|---|
| `failed to connect to the docker API` / `daemon is not running` | Open Docker Desktop and wait until it says it is running |
| `container ... is not running` when loading | Run `docker compose up -d` first (step 3) |
| Neo4j Browser says `Unauthorized` | The browser may have filled in an old password. Copy the password from `.env` and paste it. If you changed `.env` after the first start, run `docker compose down -v` and start again — the password is set only once |
| Windows: `running scripts is disabled on this system` | Run `powershell -ExecutionPolicy Bypass -File .\scripts\load.ps1` |
| Git Bash: path like `C:/Program Files/Git/import/...` not found | Use `./scripts/load.sh` (it already sets `MSYS_NO_PATHCONV=1`) |
| Port 7474 or 7687 already in use | Another Neo4j is running — stop it, or change the ports in `docker-compose.yml` |

## How it was built

In short: **ULII PDF → text → Cypher scripts (reviewed in git) → Neo4j → checked against the PDF.**
The structure (parts and section titles) is generated from each PDF's table of contents with
[tools/pdf-extract](tools/pdf-extract/); institutions, concepts and relationships come from
reading the sections. The full process, interpretation rules, verification and known
limitations are in [docs/methodology.md](docs/methodology.md).

## Repository structure

```
landlawsug/
├── cypher/                 Cypher scripts that build the graph (run in order)
│   ├── 01_constraints.cypher    uniqueness constraints and full-text index
│   ├── 02_legislation.cypher    the laws and their amendments
│   ├── 03_structure.cypher      parts and sections
│   ├── 04_entities.cypher       institutions, tenure types, legal concepts
│   └── 05_relationships.cypher  who establishes / empowers / defines / references what
├── queries/                Example questions the graph can answer
├── docs/
│   ├── methodology.md      How we built it: process, rules, verification, adding a law
│   ├── data-model.md       Graph schema: node labels, relationships, properties
│   ├── sources.md          ULII as the source, licence, citation format
│   └── decisions/          Architecture Decision Records (why we chose X)
├── tools/pdf-extract/      Node.js scripts: PDF -> text -> Cypher rows
├── scripts/                Load scripts (PowerShell and Bash)
└── docker-compose.yml      Reproducible Neo4j setup for every team member
```

## Documentation

- [Methodology](docs/methodology.md) — how the PDFs were turned into the graph, and how to add a law
- [Data model](docs/data-model.md) — the schema to follow
- [Sources](docs/sources.md) — authoritative source, licence and citation rules
- [Decision records](docs/decisions/) — design decisions and their reasons
- [PDF extract tool](tools/pdf-extract/README.md) — how to run the extraction scripts

## Licence of the legal text

The legal texts come from ULII / Laws.Africa under
[CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/). Summaries in the graph
are the team's own words and are not legal advice. See [docs/sources.md](docs/sources.md#licence).
