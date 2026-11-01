// example_queries.cypher
// Example questions the Uganda land laws graph can answer.
// Run them one at a time in the Neo4j Browser (http://localhost:7474).

// ---------------------------------------------------------------------------
// Q1. What is the structure of the Land Act? (parts and how many sections each)
// ---------------------------------------------------------------------------
MATCH (:Legislation {id: 'land-act'})-[hp:HAS_PART]->(p:Part)-[:HAS_PROVISION]->(s:Section)
WITH hp.order AS ord, p, count(s) AS sections
RETURN p.number AS part, p.title AS title, sections
ORDER BY ord;

// ---------------------------------------------------------------------------
// Q2. Which laws have amended the Land Act, and when?
// ---------------------------------------------------------------------------
MATCH (a:Legislation)-[r:AMENDS]->(:Legislation {id: 'land-act'})
RETURN a.title AS amendingAct, a.actNumber AS actNumber, r.effectiveDate AS effective
ORDER BY r.effectiveDate;

// ---------------------------------------------------------------------------
// Q3. Which institutions does the Land Act establish, and in which section?
// ---------------------------------------------------------------------------
MATCH (s:Section)-[:ESTABLISHES]->(i:Institution)
RETURN 's.' + s.number AS section, i.name AS institution, i.level AS level
ORDER BY toInteger(s.number);

// ---------------------------------------------------------------------------
// Q4. I disagree with a District Land Tribunal decision — where can I appeal?
// ---------------------------------------------------------------------------
MATCH (:Institution {id: 'district-land-tribunal'})-[r:APPEALS_TO]->(court:Institution)
RETURN court.name AS appealTo, r.source AS basedOn;

// ---------------------------------------------------------------------------
// Q5. Who supervises whom? (the full accountability chain)
// ---------------------------------------------------------------------------
MATCH (a:Institution)-[r:ACCOUNTABLE_TO]->(b:Institution)
RETURN a.name AS institution, b.name AS accountableTo, r.source AS basedOn;

// ---------------------------------------------------------------------------
// Q6. What is a bona fide occupant, and where is it defined?
// ---------------------------------------------------------------------------
MATCH (s:Section)-[:DEFINES]->(c:LegalConcept {id: 'bona-fide-occupant'})
RETURN c.name AS concept, 's.' + s.number + ' – ' + s.title AS definedIn, c.definition AS definition;

// ---------------------------------------------------------------------------
// Q7. Which land tenure systems are recognised, and by which sections?
// ---------------------------------------------------------------------------
MATCH (s:Section)-[:RECOGNISES]->(t:TenureType)
RETURN t.name AS tenure, collect('s.' + s.number) AS sections, t.description AS description
ORDER BY tenure;

// ---------------------------------------------------------------------------
// Q8. Everything connected to the Uganda Land Commission (graph view)
// ---------------------------------------------------------------------------
MATCH (i:Institution {id: 'uganda-land-commission'})-[r]-(x)
RETURN i, r, x;

// ---------------------------------------------------------------------------
// Q9. Which sections refer to section 34 (certificate of occupancy)?
// ---------------------------------------------------------------------------
MATCH (s:Section)-[:REFERENCES]->(:Section {id: 'land-act/s34'})
RETURN 's.' + s.number AS section, s.title AS title;

// ---------------------------------------------------------------------------
// Q10. Full-text search: find anything mentioning "occupancy"
// ---------------------------------------------------------------------------
CALL db.index.fulltext.queryNodes('legal_text', 'occupancy') YIELD node, score
RETURN labels(node)[0] AS type, coalesce(node.title, node.name) AS match, round(score, 2) AS score
ORDER BY score DESC
LIMIT 10;
