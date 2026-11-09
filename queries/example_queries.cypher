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
MATCH (:Legislation {id: 'land-act'})-[:HAS_PART]->(:Part)-[:HAS_PROVISION]->(s:Section)-[:ESTABLISHES]->(i:Institution)
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
MATCH (l:Legislation)-[:HAS_PART]->(:Part)-[:HAS_PROVISION]->(s:Section)-[:RECOGNISES]->(t:TenureType)
RETURN t.name AS tenure, collect(l.title + ' s.' + s.number) AS sections, t.description AS description
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

// ---------------------------------------------------------------------------
// Q11. The Government wants my land — what are the steps? (Land Acquisition Act, Part II)
// ---------------------------------------------------------------------------
MATCH (:Legislation {id: 'land-acquisition-act'})-[:HAS_PART]->(:Part {number: 'II'})-[r:HAS_PROVISION]->(s:Section)
OPTIONAL MATCH (s)-[e:EMPOWERS]->(i:Institution)
WITH r.order AS ord, s, collect(i.name + ': ' + e.power) AS whoDoesWhat
RETURN 's.' + s.number AS section, s.title AS title, whoDoesWhat
ORDER BY ord;

// ---------------------------------------------------------------------------
// Q12. Compulsory acquisition across the laws — which provisions deal with it?
// ---------------------------------------------------------------------------
MATCH (l:Legislation)-[:HAS_PART]->(:Part)-[:HAS_PROVISION]->(p:Provision)-[:DEFINES]->(:LegalConcept {id: 'compulsory-acquisition'})
RETURN l.title AS law, p.number AS provision, p.title AS title;

// ---------------------------------------------------------------------------
// Q13. How do the laws cite each other? (cross-law references)
// ---------------------------------------------------------------------------
MATCH (la:Legislation)-[:HAS_PART]->(:Part)-[:HAS_PROVISION]->(a:Provision)-[:REFERENCES]->(b)
OPTIONAL MATCH (lb:Legislation)-[:HAS_PART]->(:Part)-[:HAS_PROVISION]->(b)
WITH la, a, b, coalesce(lb, b) AS targetLaw
WHERE targetLaw <> la
RETURN la.title AS fromLaw, a.number AS section, targetLaw.title AS toLaw,
       CASE WHEN b:Provision THEN b.number ELSE '(whole Act)' END AS target
ORDER BY fromLaw, toInteger(section);

// ---------------------------------------------------------------------------
// Q14. What does the Registrar of Titles do, under every law?
// ---------------------------------------------------------------------------
MATCH (l:Legislation)-[:HAS_PART]->(:Part)-[:HAS_PROVISION]->(s:Provision)-[e:EMPOWERS]->(i:Institution {id: 'registrar-of-titles'})
RETURN l.title AS law, 's.' + s.number AS section, e.power AS power
ORDER BY law, toInteger(s.number);

// ---------------------------------------------------------------------------
// Q15. From the Constitution down: Article 26 and everything that cites it
// ---------------------------------------------------------------------------
MATCH path = (p:Provision)-[:REFERENCES]->(:Article {id: 'constitution-1995/art26'})
RETURN path;
