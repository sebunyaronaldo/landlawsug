// 01_constraints.cypher
// Uniqueness constraints for every node label (see docs/data-model.md).
// Safe to re-run: IF NOT EXISTS.

CREATE CONSTRAINT legislation_id IF NOT EXISTS
FOR (n:Legislation) REQUIRE n.id IS UNIQUE;

CREATE CONSTRAINT part_id IF NOT EXISTS
FOR (n:Part) REQUIRE n.id IS UNIQUE;

CREATE CONSTRAINT provision_id IF NOT EXISTS
FOR (n:Provision) REQUIRE n.id IS UNIQUE;

CREATE CONSTRAINT institution_id IF NOT EXISTS
FOR (n:Institution) REQUIRE n.id IS UNIQUE;

CREATE CONSTRAINT tenure_type_id IF NOT EXISTS
FOR (n:TenureType) REQUIRE n.id IS UNIQUE;

CREATE CONSTRAINT legal_concept_id IF NOT EXISTS
FOR (n:LegalConcept) REQUIRE n.id IS UNIQUE;

// Full-text index for searching titles, summaries and definitions.
CREATE FULLTEXT INDEX legal_text IF NOT EXISTS
FOR (n:Legislation|Part|Provision|Institution|LegalConcept)
ON EACH [n.title, n.name, n.summary, n.definition];
