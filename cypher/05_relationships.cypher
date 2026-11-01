// 05_relationships.cypher
// Relationships between provisions, institutions, tenure types and concepts.
// Source: ULII PDF — Land Act (Chapter 236), version as at 31 December 2023.
// Each relationship cites the section whose text supports it.

// ---------------------------------------------------------------------------
// ESTABLISHES — a section creates or provides for an institution
// ---------------------------------------------------------------------------
UNWIND [
  {s: 'land-act/s15', i: 'communal-land-association'},  // "may be formed"
  {s: 'land-act/s47', i: 'uganda-land-commission'},     // "There is established a commission"
  {s: 'land-act/s57', i: 'district-land-board'},        // "There shall be for each district a district land board"
  {s: 'land-act/s65', i: 'land-committee'},             // district council "may ... appoint a land committee"
  {s: 'land-act/s69', i: 'recorder'},                   // "There shall ... be a recorder"
  {s: 'land-act/s75', i: 'district-land-tribunal'},     // "There shall be a tribunal in each district"
  {s: 'land-act/s86', i: 'mediator'}                    // "There shall be one or more mediators in each district"
] AS row
MATCH (s:Provision {id: row.s}), (i:Institution {id: row.i})
MERGE (s)-[:ESTABLISHES]->(i);

// ---------------------------------------------------------------------------
// EMPOWERS — a section gives an institution a function or power
// ---------------------------------------------------------------------------
UNWIND [
  {s: 'land-act/s15', i: 'registrar-of-titles',        power: 'Keep a public register of communal land associations and supervise them'},
  {s: 'land-act/s42', i: 'uganda-land-commission',     power: 'Manage the Land Fund'},
  {s: 'land-act/s69', i: 'recorder',                   power: 'Keep records of certificates of customary ownership and certificates of occupancy'},
  {s: 'land-act/s75', i: 'district-land-tribunal',     power: 'Hear and determine disputes concerning land matters in the district'},
  {s: 'land-act/s83', i: 'chief-registrar-high-court', power: 'General supervision over district land tribunals'},
  {s: 'land-act/s84', i: 'high-court',                 power: 'Hear appeals from district land tribunals'}
] AS row
MATCH (s:Provision {id: row.s}), (i:Institution {id: row.i})
MERGE (s)-[r:EMPOWERS]->(i)
SET r.power = row.power;

// ---------------------------------------------------------------------------
// ACCOUNTABLE_TO — supervisory / reporting lines between institutions
// ---------------------------------------------------------------------------
UNWIND [
  {from: 'recorder',                  to: 'district-land-board',        source: 'land-act/s69'},  // "answerable to the board"
  {from: 'communal-land-association', to: 'registrar-of-titles',        source: 'land-act/s15'},  // "general supervision"
  {from: 'district-land-tribunal',    to: 'chief-registrar-high-court', source: 'land-act/s83'}   // "powers of supervision"
] AS row
MATCH (a:Institution {id: row.from}), (b:Institution {id: row.to})
MERGE (a)-[r:ACCOUNTABLE_TO]->(b)
SET r.source = row.source;

// ---------------------------------------------------------------------------
// APPEALS_TO — where decisions of an institution can be appealed
// ---------------------------------------------------------------------------
MATCH (a:Institution {id: 'district-land-tribunal'}), (b:Institution {id: 'high-court'})
MERGE (a)-[r:APPEALS_TO]->(b)
SET r.source = 'land-act/s84';

// ---------------------------------------------------------------------------
// RECOGNISES — s.2 lists the four land tenure systems; s.3 sets out their incidents
// ---------------------------------------------------------------------------
UNWIND ['land-act/s2', 'land-act/s3'] AS sid
MATCH (s:Provision {id: sid}), (t:TenureType)
WHERE t.id IN ['customary', 'freehold', 'mailo', 'leasehold']
MERGE (s)-[:RECOGNISES]->(t);

// ---------------------------------------------------------------------------
// DEFINES — a section defines or governs a legal concept
// ---------------------------------------------------------------------------
UNWIND [
  {s: 'land-act/s4',  c: 'certificate-of-customary-ownership'},
  {s: 'land-act/s29', c: 'lawful-occupant'},
  {s: 'land-act/s29', c: 'bona-fide-occupant'},
  {s: 'land-act/s31', c: 'tenant-by-occupancy'},
  {s: 'land-act/s34', c: 'certificate-of-occupancy'},
  {s: 'land-act/s40', c: 'family-land'}
] AS row
MATCH (s:Provision {id: row.s}), (c:LegalConcept {id: row.c})
MERGE (s)-[:DEFINES]->(c);

// ---------------------------------------------------------------------------
// REFERENCES — cross-references in the text
// ---------------------------------------------------------------------------
UNWIND [
  {from: 'land-act/s1',  to: 'land-act/s29'},  // "bona fide occupant" ... meanings assigned in section 29
  {from: 'land-act/s1',  to: 'land-act/s15'},  // "association" ... established by section 15
  {from: 'land-act/s14', to: 'land-act/s9'},   // title: "applications under sections 9 and 10"
  {from: 'land-act/s14', to: 'land-act/s10'},
  {from: 'land-act/s69', to: 'land-act/s7'},   // "for the purposes of sections 7 and 34"
  {from: 'land-act/s69', to: 'land-act/s34'}
] AS row
MATCH (a:Provision {id: row.from}), (b:Provision {id: row.to})
MERGE (a)-[:REFERENCES]->(b);

// ===========================================================================
// CONSTITUTION (1995) — Chapter Fifteen and Article 26
// ===========================================================================

// --- ESTABLISHES -----------------------------------------------------------
UNWIND [
  {a: 'constitution-1995/art238', i: 'uganda-land-commission'},  // "There shall be a commission"
  {a: 'constitution-1995/art240', i: 'district-land-board'}      // "There shall be a district land board for each district"
] AS row
MATCH (a:Provision {id: row.a}), (i:Institution {id: row.i})
MERGE (a)-[:ESTABLISHES]->(i);

// --- EMPOWERS --------------------------------------------------------------
UNWIND [
  {a: 'constitution-1995/art239', i: 'uganda-land-commission', power: 'Hold and manage land vested in or acquired by the Government'},
  {a: 'constitution-1995/art241', i: 'district-land-board',    power: 'Hold and allocate land not owned by any person or authority; facilitate registration and transfer of interests in land'},
  {a: 'constitution-1995/art243', i: 'district-land-tribunal', power: 'Determine land disputes, including disputes over compensation for land acquired'}
] AS row
MATCH (a:Provision {id: row.a}), (i:Institution {id: row.i})
MERGE (a)-[r:EMPOWERS]->(i)
SET r.power = row.power;

// --- RECOGNISES — art. 237(3) lists the four land tenure systems ------------
MATCH (a:Provision {id: 'constitution-1995/art237'}), (t:TenureType)
WHERE t.id IN ['customary', 'freehold', 'mailo', 'leasehold']
MERGE (a)-[:RECOGNISES]->(t);

// --- DEFINES ---------------------------------------------------------------
UNWIND [
  {a: 'constitution-1995/art26',  c: 'compulsory-acquisition'},  // art. 26(2)
  {a: 'constitution-1995/art237', c: 'lawful-occupant'},         // art. 237(8) security of occupancy
  {a: 'constitution-1995/art237', c: 'bona-fide-occupant'}       // art. 237(8) security of occupancy
] AS row
MATCH (a:Provision {id: row.a}), (c:LegalConcept {id: row.c})
MERGE (a)-[:DEFINES]->(c);

// --- REFERENCES within the Constitution -------------------------------------
UNWIND [
  {from: 'constitution-1995/art237', to: 'constitution-1995/art26'},  // 237(2)(a) "subject to Article 26"
  {from: 'constitution-1995/art244', to: 'constitution-1995/art26'}   // 244(1) "Subject to Article 26"
] AS row
MATCH (a:Provision {id: row.from}), (b:Provision {id: row.to})
MERGE (a)-[:REFERENCES]->(b);

// ===========================================================================
// LINKS BETWEEN LAWS — Land Act sections that cite constitutional articles
// ===========================================================================
UNWIND [
  {from: 'land-act/s1',  to: 'constitution-1995/art238'},  // "Commission" ... established by Article 238
  {from: 'land-act/s1',  to: 'constitution-1995/art240'},  // "board" ... established by Article 240
  {from: 'land-act/s2',  to: 'constitution-1995/art237'},  // "Subject to Article 237 of the Constitution"
  {from: 'land-act/s41', to: 'constitution-1995/art237'},  // "Subject to Article 237(2)(c)"
  {from: 'land-act/s42', to: 'constitution-1995/art237'},  // "pursuant to Article 237(9)(b)"
  {from: 'land-act/s60', to: 'constitution-1995/art237'},  // "have regard to Article 237(1)"
  {from: 'land-act/s60', to: 'constitution-1995/art241'}   // "functions under Article 241(1)(a)"
] AS row
MATCH (a:Provision {id: row.from}), (b:Provision {id: row.to})
MERGE (a)-[:REFERENCES]->(b);
