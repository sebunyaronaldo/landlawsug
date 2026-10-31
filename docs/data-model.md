# Data Model

This document is the **single source of truth** for the graph schema. Any change to labels,
relationships or properties must be made here first, in the same pull request as the Cypher change.

## Naming conventions (Neo4j standard)

| Element | Convention | Example |
|---|---|---|
| Node label | `PascalCase`, singular | `Legislation`, `TenureType` |
| Relationship type | `UPPER_SNAKE_CASE`, verb | `HAS_PART`, `ESTABLISHES` |
| Property key | `camelCase` | `shortTitle`, `yearEnacted` |
| `id` values | lowercase kebab-case, hierarchical | `land-act`, `land-act/s29` |

## Overview

```
                         ┌──────────────┐
            AMENDS/      │ Legislation  │──IMPLEMENTS──┐
            REPEALS ┌───▶│              │              │
                    └────│              │              ▼
                         └──────┬───────┘        ┌───────────┐
                                │ HAS_PART       │ Provision │ (e.g. Constitution Art. 237)
                                ▼                └───────────┘
                         ┌──────────────┐
                         │     Part     │
                         └──────┬───────┘
                                │ HAS_PROVISION
                                ▼
   ┌─────────────┐  ESTABLISHES ┌──────────────┐  DEFINES   ┌──────────────┐
   │ Institution │◀─────────────│  Provision   │───────────▶│ LegalConcept │
   └──────┬──────┘              │              │            └──────────────┘
          │ ACCOUNTABLE_TO      │              │ RECOGNISES ┌──────────────┐
          ▼                     │              │───────────▶│  TenureType  │
   ┌─────────────┐              └──────┬───────┘            └──────────────┘
   │ Institution │                     │ REFERENCES
   └─────────────┘                     ▼
                                 ┌──────────────┐
                                 │  Provision   │
                                 └──────────────┘
```

Provisions may also attach directly to `Legislation` via `HAS_PROVISION` when a law has no
parts (e.g. short Acts, or the Constitution chapter).

## Node labels

### `Legislation`
A law, constitution or policy document.

| Property | Type | Required | Description |
|---|---|---|---|
| `id` | String | ✅ | Unique slug, e.g. `land-act` |
| `title` | String | ✅ | Full official title |
| `shortTitle` | String | | Common short name |
| `type` | String | ✅ | `Constitution` \| `Act` \| `AmendmentAct` \| `StatutoryInstrument` \| `Policy` |
| `yearEnacted` | Integer | ✅ | Year first enacted |
| `chapter` | String | | Chapter number in the Revised Laws of Uganda, e.g. `Cap. 227` |
| `chapterEdition` | String | | Edition the chapter number refers to, e.g. `2000 Revised Edition` |
| `status` | String | ✅ | `InForce` \| `Repealed` \| `PartiallyInForce` |
| `sourceUrl` | String | ✅ | Link to the text on ulii.org (see [sources.md](sources.md)) |
| `sourceVersion` | String | ✅ | Version / "as at" date of the ULII text used |

### `Part`
A major division of a piece of legislation.

| Property | Type | Required | Description |
|---|---|---|---|
| `id` | String | ✅ | `<legislation-id>/part-<number>`, e.g. `land-act/part-iv` |
| `number` | String | ✅ | As printed, e.g. `IV` |
| `title` | String | ✅ | e.g. `Land Management` |

### `Provision`
A section of an Act or an article of the Constitution. Carries an extra label
`:Section` or `:Article` to distinguish the two.

| Property | Type | Required | Description |
|---|---|---|---|
| `id` | String | ✅ | `<legislation-id>/s<number>` or `/art<number>`, e.g. `land-act/s29`, `constitution-1995/art237` |
| `number` | String | ✅ | As printed, e.g. `29`, `237` |
| `title` | String | ✅ | Marginal note / heading |
| `summary` | String | | Plain-language summary written by the team (not the official text) |
| `sourceUrl` | String | | Deep link to the provision on ulii.org, if available |

### `Institution`
A body established, empowered or regulated by the legislation.

| Property | Type | Required | Description |
|---|---|---|---|
| `id` | String | ✅ | e.g. `uganda-land-commission` |
| `name` | String | ✅ | Official name |
| `level` | String | ✅ | `National` \| `District` \| `SubCounty` \| `Parish` |
| `description` | String | | Role in one or two sentences |

### `TenureType`
A form of land tenure recognised in Uganda.

| Property | Type | Required | Description |
|---|---|---|---|
| `id` | String | ✅ | `customary` \| `freehold` \| `mailo` \| `leasehold` |
| `name` | String | ✅ | Display name |
| `description` | String | | Short description |

### `LegalConcept`
A defined legal term or idea.

| Property | Type | Required | Description |
|---|---|---|---|
| `id` | String | ✅ | e.g. `bona-fide-occupant` |
| `name` | String | ✅ | e.g. `Bona fide occupant` |
| `definition` | String | | Team's plain-language definition |

## Relationship types

| Type | From → To | Properties | Meaning |
|---|---|---|---|
| `HAS_PART` | `Legislation` → `Part` | `order` (Integer) | Legislation contains this part |
| `HAS_PROVISION` | `Part` \| `Legislation` → `Provision` | `order` (Integer) | Part/legislation contains this provision |
| `AMENDS` | `Legislation` \| `Provision` → `Legislation` \| `Provision` | `year` (Integer), `note` (String) | Source amends target |
| `REPEALS` | `Legislation` \| `Provision` → `Legislation` \| `Provision` | `year` (Integer) | Source repeals target |
| `IMPLEMENTS` | `Legislation` \| `Provision` → `Provision` | | Gives effect to a constitutional provision |
| `REFERENCES` | `Provision` → `Provision` | | Cross-reference in the text |
| `ESTABLISHES` | `Provision` → `Institution` | | Provision creates the institution |
| `EMPOWERS` | `Provision` → `Institution` | `power` (String) | Provision gives the institution a function/power |
| `ACCOUNTABLE_TO` | `Institution` → `Institution` | | Reporting / supervisory line |
| `RECOGNISES` | `Provision` → `TenureType` | | Provision recognises the tenure |
| `DEFINES` | `Provision` → `LegalConcept` | | Provision defines or governs the concept |

## Rules

1. Every node has a unique `id`; constraints in `cypher/01_constraints.cypher` enforce this.
2. Always use `MERGE` on `id` (never `CREATE`) so scripts can be re-run safely.
3. Every `Legislation` must have a `sourceUrl` on ulii.org. ULII is the **only** data source;
   facts (numbers, titles, dates) must be checked against it before merging — see [sources.md](sources.md).
4. `summary` and `definition` are **our** words. Do not paste long passages of official text.
