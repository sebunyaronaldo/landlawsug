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

// ===========================================================================
// REGISTRATION OF TITLES ACT (Chapter 240)
// ===========================================================================

// --- ESTABLISHES — s.3 "A Registrar of Titles shall be appointed to have the charge and control of the Office of Titles"
UNWIND ['registrar-of-titles', 'office-of-titles'] AS iid
MATCH (s:Provision {id: 'registration-of-titles-act/s3'}), (i:Institution {id: iid})
MERGE (s)-[:ESTABLISHES]->(i);

// --- EMPOWERS --------------------------------------------------------------
UNWIND [
  {s: 'registration-of-titles-act/s37',  power: 'Keep the Register Book and register certificates of title and dealings affecting land'},
  {s: 'registration-of-titles-act/s77',  power: 'Receive applications for title by possession'},
  {s: 'registration-of-titles-act/s123', power: 'Receive caveats forbidding registration of dealings'}
] AS row
MATCH (s:Provision {id: row.s}), (i:Institution {id: 'registrar-of-titles'})
MERGE (s)-[r:EMPOWERS]->(i)
SET r.power = row.power;

// --- ACCOUNTABLE_TO — the Office of Titles is in the charge and control of the Registrar (s.3)
MATCH (a:Institution {id: 'office-of-titles'}), (b:Institution {id: 'registrar-of-titles'})
MERGE (a)-[r:ACCOUNTABLE_TO]->(b)
SET r.source = 'registration-of-titles-act/s3';

// --- DEFINES ---------------------------------------------------------------
UNWIND [
  {s: 'registration-of-titles-act/s37',  c: 'register-book'},
  {s: 'registration-of-titles-act/s38',  c: 'certificate-of-title'},
  {s: 'registration-of-titles-act/s59',  c: 'certificate-of-title'},
  {s: 'registration-of-titles-act/s77',  c: 'title-by-possession'},
  {s: 'registration-of-titles-act/s100', c: 'lease'},
  {s: 'registration-of-titles-act/s123', c: 'caveat'}
] AS row
MATCH (s:Provision {id: row.s}), (c:LegalConcept {id: row.c})
MERGE (s)-[:DEFINES]->(c);

// --- RECOGNISES — s.100: leases of freehold or mailo land under the Act
UNWIND ['freehold', 'mailo', 'leasehold'] AS tid
MATCH (s:Provision {id: 'registration-of-titles-act/s100'}), (t:TenureType {id: tid})
MERGE (s)-[:RECOGNISES]->(t);

// ===========================================================================
// LINKS BETWEEN LAWS — Land Act citing the Registration of Titles Act
// ===========================================================================

// Section-to-section
UNWIND [
  {from: 'land-act/s14', to: 'registration-of-titles-act/s39'},   // "in accordance with section 39 of the Registration of Titles Act"
  {from: 'land-act/s40', to: 'registration-of-titles-act/s124'}   // "Notwithstanding section 124(2) of the Registration of Titles Act"
] AS row
MATCH (a:Provision {id: row.from}), (b:Provision {id: row.to})
MERGE (a)-[:REFERENCES]->(b);

// Section-to-whole-Act (no section number given in the citing text)
UNWIND [
  'land-act/s1',   // "alienated", "registrable interest", "Registrar of Titles" definitions
  'land-act/s13',  // "a limited certificate under the Registration of Titles Act"
  'land-act/s41',  // (2) non-citizen leases of five years or more registered under the Act
  'land-act/s74',  // public works rights, "whether or not ... registered under the Registration of Titles Act"
  'land-act/s88'   // "Subject to the Registration of Titles Act, the Registrar of Titles shall ..."
] AS sid
MATCH (a:Provision {id: sid}), (b:Legislation {id: 'registration-of-titles-act'})
MERGE (a)-[:REFERENCES]->(b);

// ===========================================================================
// LAND ACQUISITION ACT (Chapter 235)
// ===========================================================================

// --- ESTABLISHES — offices the Minister appoints (same rule as Recorder / Mediator)
UNWIND [
  {s: 'land-acquisition-act/s1',  i: 'assessment-officer'},   // "appointed by the Minister to be an assessment officer"
  {s: 'land-acquisition-act/s10', i: 'appointed-officer'}     // "he or she may appoint a public officer or other person"
] AS row
MATCH (s:Provision {id: row.s}), (i:Institution {id: row.i})
MERGE (s)-[:ESTABLISHES]->(i);

// --- EMPOWERS --------------------------------------------------------------
UNWIND [
  {s: 'land-acquisition-act/s3',  i: 'minister-responsible-for-lands', power: 'Declare by statutory instrument that land is required for a public purpose'},
  {s: 'land-acquisition-act/s8',  i: 'minister-responsible-for-lands', power: 'Revoke a declaration before possession is taken'},
  {s: 'land-acquisition-act/s10', i: 'minister-responsible-for-lands', power: 'Appoint an officer to procure temporary occupation of land for up to three years'},
  {s: 'land-acquisition-act/s20', i: 'minister-responsible-for-lands', power: 'Make regulations for the assessment and payment of compensation'},
  {s: 'land-acquisition-act/s5',  i: 'assessment-officer',             power: 'Publish notice calling for claims to compensation'},
  {s: 'land-acquisition-act/s6',  i: 'assessment-officer',             power: 'Hold an inquiry into claims and make the compensation award'},
  {s: 'land-acquisition-act/s7',  i: 'assessment-officer',             power: 'Take possession of the land'},
  {s: 'land-acquisition-act/s7',  i: 'registrar-of-titles',            power: 'Give effect in the Register Book to the vesting of acquired land'},
  {s: 'land-acquisition-act/s7',  i: 'uganda-land-commission',         power: 'Acquired land vests in the Commission free from all incumbrances'},
  {s: 'land-acquisition-act/s10', i: 'appointed-officer',              power: 'Agree compensation and take possession for temporary occupation'},
  {s: 'land-acquisition-act/s14', i: 'attorney-general',               power: 'Refer compensation disputes to the magistrate\'s court by motion'},
  {s: 'land-acquisition-act/s14', i: 'magistrates-court',              power: 'Decide references regardless of the value of the subject matter'},
  {s: 'land-acquisition-act/s15', i: 'magistrates-court',              power: 'Declare and enforce the right to take possession of land'}
] AS row
MATCH (s:Provision {id: row.s}), (i:Institution {id: row.i})
MERGE (s)-[r:EMPOWERS]->(i)
SET r.power = row.power;

// --- APPEALS_TO ------------------------------------------------------------
UNWIND [
  {from: 'assessment-officer', to: 'high-court', source: 'land-acquisition-act/s13'},  // appeal against an award within sixty days
  {from: 'magistrates-court',  to: 'high-court', source: 'land-acquisition-act/s14'}   // appeal against a decision on a reference
] AS row
MATCH (a:Institution {id: row.from}), (b:Institution {id: row.to})
MERGE (a)-[r:APPEALS_TO]->(b)
SET r.source = row.source;

// --- DEFINES ---------------------------------------------------------------
UNWIND [
  {s: 'land-acquisition-act/s1',  c: 'person-having-an-interest'},
  {s: 'land-acquisition-act/s3',  c: 'public-purpose-declaration'},
  {s: 'land-acquisition-act/s3',  c: 'compulsory-acquisition'},
  {s: 'land-acquisition-act/s7',  c: 'compulsory-acquisition'},
  {s: 'land-acquisition-act/s6',  c: 'compensation-award'},
  {s: 'land-acquisition-act/s13', c: 'compensation-award'},
  {s: 'land-acquisition-act/s10', c: 'temporary-occupation'}
] AS row
MATCH (s:Provision {id: row.s}), (c:LegalConcept {id: row.c})
MERGE (s)-[:DEFINES]->(c);

// --- REFERENCES within the Act ---------------------------------------------
UNWIND [
  {from: 1,  to: 3},  {from: 1,  to: 10},   // definitions of "declaration" and "appointed officer"
  {from: 4,  to: 3},  {from: 5,  to: 4},  {from: 6,  to: 5},
  {from: 7,  to: 6},  {from: 8,  to: 3},  {from: 8,  to: 7},
  {from: 9,  to: 6},  {from: 11, to: 10}, {from: 13, to: 6},
  {from: 17, to: 2}
] AS row
MATCH (a:Provision {id: 'land-acquisition-act/s' + row.from}), (b:Provision {id: 'land-acquisition-act/s' + row.to})
MERGE (a)-[:REFERENCES]->(b);

// --- REFERENCES to the Registration of Titles Act (whole Act) ---------------
UNWIND [
  'land-acquisition-act/s1',  // "registered proprietor" and "Register Book" defined by the RTA
  'land-acquisition-act/s7'   // Registrar acts "notwithstanding any inconsistency with the Registration of Titles Act"
] AS sid
MATCH (a:Provision {id: sid}), (b:Legislation {id: 'registration-of-titles-act'})
MERGE (a)-[:REFERENCES]->(b);

// ===========================================================================
// LINKS BETWEEN LAWS — compulsory acquisition
// ===========================================================================

// Land Act s.42(6): "Notwithstanding any provisions to the contrary in the Land Acquisition Act"
MATCH (a:Provision {id: 'land-act/s42'}), (b:Legislation {id: 'land-acquisition-act'})
MERGE (a)-[:REFERENCES]->(b);

// Land Act s.43: Government may acquire land "in accordance with Articles 26 and 237(2) of the Constitution"
UNWIND ['constitution-1995/art26', 'constitution-1995/art237'] AS aid
MATCH (a:Provision {id: 'land-act/s43'}), (b:Provision {id: aid})
MERGE (a)-[:REFERENCES]->(b);

// ===========================================================================
// MORTGAGE ACT (Chapter 239)
// No institutions are established by this Act; it gives duties to existing ones.
// "court" (s.1) means any court from a grade I magistrates court upwards, including a
// land tribunal, so court powers are not linked to one Institution node.
// ===========================================================================

// --- EMPOWERS --------------------------------------------------------------
UNWIND [
  {s: 'mortgage-act/s6',  i: 'mediator',                       power: 'Mediate between mortgagor and mortgagee before a court is asked to act on a mortgage of customary land'},  // 6(2), 6(3) "after using the services of the mediator"
  {s: 'mortgage-act/s8',  i: 'recorder',                       power: 'Register mortgages of land held under a certificate of customary ownership in the order they are presented'},  // 8(2)
  {s: 'mortgage-act/s14', i: 'registrar-of-titles',            power: 'Enter releases of mortgages on the certificate of title'},                    // 14(1)
  {s: 'mortgage-act/s14', i: 'recorder',                       power: 'Enter releases of mortgages on the certificate of customary ownership'},     // 14(1) "Registrar of Titles or recorder as the case may be"
  {s: 'mortgage-act/s15', i: 'secretary-to-the-treasury',      power: 'Receive mortgage money where the mortgagee cannot be found and hold it in trust in the Consolidated Fund'},  // 15(1), 15(4)
  {s: 'mortgage-act/s15', i: 'registrar-of-titles',            power: 'Enter a discharge on production of the Treasury receipt'},                   // 15(3)
  {s: 'mortgage-act/s15', i: 'recorder',                       power: 'Enter a discharge on production of the Treasury receipt'},                   // 15(3)
  {s: 'mortgage-act/s27', i: 'registrar-of-titles',            power: 'Register the transfer by a mortgagee exercising the power of sale'},          // 27(3), 27(4)
  {s: 'mortgage-act/s27', i: 'recorder',                       power: 'Register the transfer by a mortgagee exercising the power of sale'},          // 27(3), 27(4)
  {s: 'mortgage-act/s36', i: 'registrar-of-titles',            power: 'Remove from the title a mortgage whose recovery is barred by the Limitation Act'},  // 36(1)
  {s: 'mortgage-act/s37', i: 'registrar-of-titles',            power: 'Issue a special certificate of title to the mortgagor'},                     // 37(3)
  {s: 'mortgage-act/s5',  i: 'minister-responsible-for-lands', power: 'Authorise further classes of independent person by statutory instrument'},  // 5(2); "Minister" = Minister responsible for lands (s.1)
  {s: 'mortgage-act/s40', i: 'minister-responsible-for-lands', power: 'Make regulations under the Mortgage Act in consultation with the Bank of Uganda'},  // 40(1)
  {s: 'mortgage-act/s41', i: 'minister-responsible-for-lands', power: 'Amend Schedule 1 (currency point) by statutory instrument with Cabinet approval'}   // s.41
] AS row
MATCH (s:Provision {id: row.s}), (i:Institution {id: row.i})
MERGE (s)-[r:EMPOWERS]->(i)
SET r.power = row.power;

// --- RECOGNISES ------------------------------------------------------------
// s.1 "land tenure" includes customary, freehold, leasehold and mailo; s.2(1) land under "any form of land tenure" may be mortgaged
UNWIND ['mortgage-act/s1', 'mortgage-act/s2'] AS sid
MATCH (s:Provision {id: sid}), (t:TenureType)
WHERE t.id IN ['customary', 'freehold', 'mailo', 'leasehold']
MERGE (s)-[:RECOGNISES]->(t);

// s.6 mortgages on customary land
MATCH (s:Provision {id: 'mortgage-act/s6'}), (t:TenureType {id: 'customary'})
MERGE (s)-[:RECOGNISES]->(t);

// --- DEFINES ---------------------------------------------------------------
UNWIND [
  {s: 'mortgage-act/s1',  c: 'mortgage'},
  {s: 'mortgage-act/s2',  c: 'mortgage'},
  {s: 'mortgage-act/s7',  c: 'mortgage'},                         // security only
  {s: 'mortgage-act/s1',  c: 'informal-mortgage'},
  {s: 'mortgage-act/s2',  c: 'informal-mortgage'},                // 2(8)(a)
  {s: 'mortgage-act/s1',  c: 'matrimonial-home'},
  {s: 'mortgage-act/s4',  c: 'matrimonial-home'},
  {s: 'mortgage-act/s5',  c: 'matrimonial-home'},
  {s: 'mortgage-act/s6',  c: 'mortgage-on-customary-land'},
  {s: 'mortgage-act/s8',  c: 'priority-of-mortgages'},
  {s: 'mortgage-act/s9',  c: 'tacking'},
  {s: 'mortgage-act/s10', c: 'consolidation'},                    // 10(4) defines "consolidation"
  {s: 'mortgage-act/s13', c: 'right-to-discharge'},
  {s: 'mortgage-act/s31', c: 'right-to-discharge'},
  {s: 'mortgage-act/s17', c: 'implied-covenants-by-mortgagor'},
  {s: 'mortgage-act/s18', c: 'notice-of-default'},
  {s: 'mortgage-act/s19', c: 'mortgagee-remedies'},
  {s: 'mortgage-act/s1',  c: 'receiver'},
  {s: 'mortgage-act/s21', c: 'receiver'},
  {s: 'mortgage-act/s25', c: 'power-of-sale'},
  {s: 'mortgage-act/s26', c: 'power-of-sale'},
  {s: 'mortgage-act/s27', c: 'power-of-sale'},
  {s: 'mortgage-act/s32', c: 'relief-for-mortgagor'},
  {s: 'mortgage-act/s33', c: 'relief-for-mortgagor'}
] AS row
MATCH (s:Provision {id: row.s}), (c:LegalConcept {id: row.c})
MERGE (s)-[:DEFINES]->(c);

// --- REFERENCES within the Act ---------------------------------------------
UNWIND [
  {from: 1,  to: 2},                                    // "lien by deposit of documents" ... section 2(8)(b)
  {from: 5,  to: 4},                                    // "consent of a spouse referred to in section 4"
  {from: 6,  to: 32},                                   // "be guided by the provisions of section 32"
  {from: 11, to: 17},                                   // "than those set out in section 17"
  {from: 13, to: 14},                                   // "Subject to this section and section 14"
  {from: 16, to: 13},                                   // "if the discharge ... had been made under section 13"
  {from: 18, to: 19},                                   // "remedies referred to in section 19"
  {from: 19, to: 18},                                   // "notice served on him or her under section 18"
  {from: 20, to: 18},
  {from: 22, to: 21},                                   // "appointed a receiver under section 21"
  {from: 23, to: 18}, {from: 23, to: 21},               // "period specified in section 18"; "section 21(9)"
  {from: 24, to: 21}, {from: 24, to: 25}, {from: 24, to: 13}, {from: 24, to: 23},
  {from: 25, to: 18},                                   // "notice served ... under section 18(3)"
  {from: 27, to: 26},                                   // "duty imposed by section 26(1)"
  {from: 29, to: 26},
  {from: 32, to: 19}, {from: 32, to: 18}, {from: 32, to: 21},
  {from: 32, to: 22}, {from: 32, to: 23}, {from: 32, to: 25},   // "notice under section 18, 21(2), 22(2), 23(1) or 25(2)"
  {from: 33, to: 34},                                   // "persons mentioned in section 34"
  {from: 34, to: 33},
  {from: 35, to: 33},
  {from: 37, to: 36},                                   // "time specified under subsection 36(2)"
  {from: 38, to: 13}, {from: 38, to: 26}, {from: 38, to: 29}
] AS row
MATCH (a:Provision {id: 'mortgage-act/s' + row.from}), (b:Provision {id: 'mortgage-act/s' + row.to})
MERGE (a)-[:REFERENCES]->(b);

// ===========================================================================
// LINKS BETWEEN LAWS — Mortgage Act citing the Land Act and the RTA
// ===========================================================================

// Section-to-section
UNWIND [
  {from: 'mortgage-act/s1',  to: 'land-act/s86'},                    // "mediator" has the meaning assigned to it by section 86 of the Land Act
  {from: 'mortgage-act/s4',  to: 'land-act/s40'},                    // "Notwithstanding section 40 of the Land Act"
  {from: 'mortgage-act/s8',  to: 'registration-of-titles-act/s48'},  // "registered in accordance with section 48 of that Act"
  {from: 'mortgage-act/s37', to: 'registration-of-titles-act/s70'}   // "the provisions of section 70 of the Registration of Titles Act"
] AS row
MATCH (a:Provision {id: row.from}), (b:Provision {id: row.to})
MERGE (a)-[:REFERENCES]->(b);

// Section-to-whole-Act (no section number given in the citing text)
UNWIND [
  {from: 'mortgage-act/s1',  to: 'land-act'},                    // tenure definitions "given to it by the Land Act"; "recorder" appointed under the Land Act
  {from: 'mortgage-act/s1',  to: 'registration-of-titles-act'},  // "Registrar of Titles" appointed under the RTA
  {from: 'mortgage-act/s2',  to: 'registration-of-titles-act'},  // 2(6) title "registered under the Registration of Titles Act"; 2(8)(b)(ii)
  {from: 'mortgage-act/s14', to: 'registration-of-titles-act'},  // "a mortgage registered under the Registration of Titles Act or the Land Act"
  {from: 'mortgage-act/s14', to: 'land-act'}
] AS row
MATCH (a:Provision {id: row.from}), (b:Legislation {id: row.to})
MERGE (a)-[:REFERENCES]->(b);
