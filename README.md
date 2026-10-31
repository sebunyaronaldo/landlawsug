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

| Legislation | Type |
|---|---|
| Constitution of the Republic of Uganda, 1995 — Chapter 15 (Land and Environment) | Constitution |
| Land Act (and amendments 2004, 2010) | Act |
| Registration of Titles Act | Act |
| Land Acquisition Act | Act |
| Mortgage Act, 2009 | Act |
| Physical Planning Act, 2010 | Act |
| Condominium Property Act | Act |
| Survey Act | Act |
| Uganda Land Commission Act | Act |

**Data source:** all data comes from the [Uganda Legal Information Institute (ULII)](https://ulii.org/) only.

Granularity: **Legislation → Part → Provision (section / article)**. See [docs/data-model.md](docs/data-model.md).

## Quick start

**Prerequisites:** [Docker Desktop] and Git.

```bash
git clone <repo-url>
cd landlawsug
cp .env.example .env          # then set your own password in .env
docker compose up -d          # starts Neo4j
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


