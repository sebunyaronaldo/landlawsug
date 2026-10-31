# ADR 0001: Use a Neo4j property graph

- **Status:** Accepted
- **Date:** 2026-10-31

## Context

The exercise is to build a graph database of Uganda's land laws. Legislation is naturally
connected: laws amend and repeal each other, sections cross-reference each other, and
provisions create institutions and define concepts. We need a technology that stores these
connections as first-class data and that the whole team can run easily.

## Options considered

1. **Neo4j (labelled property graph, Cypher)** — most widely used graph database, free
   Community edition and Docker image, built-in visual browser.
2. **RDF triple store with SPARQL** (e.g. using the ELI / Akoma Ntoso legal ontologies) —
   strong standards for legal data, but a steeper learning curve and more setup.
3. **Relational database** — rejected: relationships would be join tables, and multi-hop
   questions ("what does this amendment ultimately affect?") become complex.

## Decision

Use **Neo4j 5 (Community Edition)** via Docker, with Cypher scripts kept in version control.
Granularity is **Legislation → Part → Provision**.

## Consequences

- Every team member runs the identical database with `docker compose up`.
- The schema is documented in [data-model.md](../data-model.md) and enforced with constraints.
- If needed later, the graph can be exported to RDF (e.g. via the neosemantics plugin).
