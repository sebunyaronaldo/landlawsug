# Uganda Land Laws Graph Database

A graph database of Uganda's land laws, built with Neo4j and queried with Cypher.

Instead of storing laws as flat documents or tables, this project models them as a **network**:
laws, their parts and sections, the institutions they create, the land tenure systems they
recognise, and the legal concepts they define, all connected by meaningful relationships
such as `AMENDS`, `ESTABLISHES`, `DEFINES` and `REFERENCES`.

This makes it possible to answer questions like:

- Which institutions does the Land Act establish, and who are they accountable to?
- Which provisions implement Article 237 of the Constitution?
- What has the Land (Amendment) Act 2010 changed?
- Which laws deal with compulsory acquisition and compensation?

## Scope

### Core legislation

The four laws most directly about land ownership and rights:

| Legislation | Coverage | Status |
|---|---|---|
| Constitution of the Republic of Uganda, 1995 | Chapter 15 (Land and environment) and Article 26 (Protection from deprivation of property) | ✅ Done |
| Land Act (Chapter 236) | All parts and sections, plus its amending Acts (2001, 2004, 2010, 2023) | ✅ Done |
| Registration of Titles Act | To be decided | ⏳ Planned |
| Land Acquisition Act | To be decided | ⏳ Planned |

### Possible later additions

Related laws that may be added if time allows:

- Mortgage Act
- Physical Planning Act
- Condominium Property Act
- Survey Act
- Uganda Land Commission Act

Titles and chapter numbers will be confirmed from ULII when each law is added.

**Data source:** all data comes from the [Uganda Legal Information Institute (ULII)](https://ulii.org/) only.

Granularity: **Legislation → Part → Provision (section / article)**. See [docs/data-model.md](docs/data-model.md).

## Quick start

**Prerequisites:** [Docker Desktop] and Git.

1. Clone the repository:

   ```bash
   git clone https://github.com/sebunyaronaldo/landlawsug.git
   cd landlawsug
   ```

2. Create a file named `.env` in the project folder containing this one line, with your own
   password (at least 8 characters):

   ```
   NEO4J_PASSWORD=your-own-password
   ```

   `.env` is ignored by git, so your password is never uploaded. Each team member creates their own.

3. Start Neo4j:

   ```bash
   docker compose up -d
   ```

Open the Neo4j Browser at <http://localhost:7474> and log in with `neo4j` / the password from `.env`.

Load the data (scripts run in numeric order):

```bash
./scripts/load.sh             # macOS / Linux / Git Bash
./scripts/load.ps1            # Windows PowerShell
```

## Repository structure

```
landlawsug/
├── cypher/                 Cypher scripts that build the graph (run in order)
│   ├── 01_constraints.cypher
│   ├── 02_legislation.cypher
│   ├── 03_structure.cypher
│   ├── 04_entities.cypher
│   └── 05_relationships.cypher
├── queries/                Example and analysis queries
├── docs/
│   ├── data-model.md       Graph schema: node labels, relationships, properties
│   ├── sources.md          Where the legal text comes from, and how to cite it
│   └── decisions/          Architecture Decision Records (why we chose X)
├── scripts/                Helper scripts to load the data
└── docker-compose.yml      Reproducible Neo4j setup for every team member
```

## Documentation

- [Data model](docs/data-model.md) — the schema to follow
- [Sources](docs/sources.md) — authoritative sources and citation rules
- [Decision records](docs/decisions/) — design decisions and their reasons


