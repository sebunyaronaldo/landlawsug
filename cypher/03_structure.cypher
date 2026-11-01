// 03_structure.cypher
// Parts and sections (provisions) of each piece of legislation.
// Titles are copied exactly from the table of contents of the ULII PDF.

// ===========================================================================
// CONSTITUTION (1995) — ULII version as at 31 December 2023
// Chapters are modelled as Part nodes; articles as Provision:Article nodes.
// ===========================================================================

// --- Chapters in scope -----------------------------------------------------
MATCH (c:Legislation {id: 'constitution-1995'})
UNWIND [
  {num: '4',  title: 'Protection and promotion of fundamental and other human rights and freedoms'},
  {num: '15', title: 'Land and environment'}
] AS row
MERGE (p:Part {id: 'constitution-1995/chapter-' + row.num})
SET p.number = row.num, p.title = row.title
MERGE (c)-[r:HAS_PART]->(p)
SET r.order = toInteger(row.num);

// --- Articles in scope -----------------------------------------------------
UNWIND [
  // Chapter Four
  {n: 26,  ch: '4',  sub: 'General',                 title: 'Protection from deprivation of property'},
  // Chapter Fifteen
  {n: 237, ch: '15', sub: 'Land',                    title: 'Land ownership'},
  {n: 238, ch: '15', sub: 'Uganda Land Commission',  title: 'Uganda Land Commission'},
  {n: 239, ch: '15', sub: 'Uganda Land Commission',  title: 'Functions of the Uganda Land Commission'},
  {n: 240, ch: '15', sub: 'District land boards',    title: 'District land boards'},
  {n: 241, ch: '15', sub: 'District land boards',    title: 'Functions of district land boards'},
  {n: 242, ch: '15', sub: 'District land boards',    title: 'Land use'},
  {n: 243, ch: '15', sub: 'District land boards',    title: 'Land tribunals'},
  {n: 244, ch: '15', sub: 'District land boards',    title: 'Minerals and petroleum'},
  {n: 245, ch: '15', sub: 'Environment',             title: 'Protection and preservation of the environment'}
] AS row
MATCH (p:Part {id: 'constitution-1995/chapter-' + row.ch})
MERGE (a:Provision {id: 'constitution-1995/art' + row.n})
SET a:Article,
    a.number     = toString(row.n),
    a.title      = row.title,
    a.subheading = row.sub
MERGE (p)-[r:HAS_PROVISION]->(a)
SET r.order = row.n;

// ===========================================================================
// LAND ACT (Chapter 236) — ULII version as at 31 December 2023
// ===========================================================================

// --- Parts -----------------------------------------------------------------
MATCH (l:Legislation {id: 'land-act'})
UNWIND [
  {num: 'I',   order: 1, title: 'Interpretation'},
  {num: 'II',  order: 2, title: 'Land holding'},
  {num: 'III', order: 3, title: 'Control of land use'},
  {num: 'IV',  order: 4, title: 'Land management'},
  {num: 'V',   order: 5, title: 'Land tribunals'},
  {num: 'VI',  order: 6, title: 'Miscellaneous'}
] AS row
MERGE (p:Part {id: 'land-act/part-' + toLower(row.num)})
SET p.number = row.num, p.title = row.title
MERGE (l)-[r:HAS_PART]->(p)
SET r.order = row.order;

// --- Sections --------------------------------------------------------------
// part: the Part the section belongs to; sub: subheading within the Part (if any)
UNWIND [
  // Part I – Interpretation
  {n: 1,  part: 'I', title: 'Interpretation'},

  // Part II – Land holding
  {n: 2,  part: 'II', title: 'Land ownership'},
  {n: 3,  part: 'II', title: 'Incidents of forms of tenure'},
  {n: 4,  part: 'II', title: 'Certificate of customary ownership'},
  {n: 5,  part: 'II', title: 'Functions of committee on application for certificate of customary ownership'},
  {n: 6,  part: 'II', title: 'Procedures for application for certificate of customary ownership'},
  {n: 7,  part: 'II', title: 'Functions and procedure of board on application for certificate of customary ownership'},
  {n: 8,  part: 'II', title: 'Incidents of certificate of customary ownership'},
  {n: 9,  part: 'II', title: 'Conversion of customary tenure to freehold tenure'},
  {n: 10, part: 'II', title: 'Application for grant of land in freehold'},
  {n: 11, part: 'II', title: 'Functions of committee on application for freehold tenure'},
  {n: 12, part: 'II', title: 'Procedures for application for freehold tenure'},
  {n: 13, part: 'II', title: 'Functions of board on application for freehold tenure'},
  {n: 14, part: 'II', title: 'Duties of Registrar of Titles in respect of applications under sections 9 and 10'},
  {n: 15, part: 'II', title: 'Communal land associations'},
  {n: 16, part: 'II', title: 'Meeting to form association and elect managing committee'},
  {n: 17, part: 'II', title: 'Constitution of association'},
  {n: 18, part: 'II', title: 'Incorporation of officers as managing committee'},
  {n: 19, part: 'II', title: 'Powers of managing committee'},
  {n: 20, part: 'II', title: 'Disputes'},
  {n: 21, part: 'II', title: 'Dissolution and decertification of association'},
  {n: 22, part: 'II', title: 'Individual holding of land created out of communal land'},
  {n: 23, part: 'II', title: 'Establishment of areas of common land use in communally owned land'},
  {n: 24, part: 'II', title: 'Management of areas of common land use'},
  {n: 25, part: 'II', title: 'Content of common land management scheme'},
  {n: 26, part: 'II', title: 'Basic rights and duties of members of community using common land'},
  {n: 27, part: 'II', title: 'Rights of women, children and persons with disability regarding customary land'},
  {n: 28, part: 'II', title: 'Conversion of leasehold into freehold'},
  {n: 29, part: 'II', title: 'Meaning of “lawful occupant” and “bona fide occupant”'},
  {n: 30, part: 'II', title: 'Mediator to assist persons not qualified to be bona fide occupants'},
  {n: 31, part: 'II', title: 'Tenant by occupancy'},
  {n: 32, part: 'II', title: 'Jurisdiction of district land tribunal in respect of non-payment of ground rent'},
  {n: 33, part: 'II', title: 'Lawful or bona fide occupants to be evicted only for non-payment of ground rent'},
  {n: 34, part: 'II', title: 'Certificate of occupancy'},
  {n: 35, part: 'II', title: 'Transactions with tenancy by occupancy'},
  {n: 36, part: 'II', title: 'Option to purchase'},
  {n: 37, part: 'II', title: 'Mutual agreement between tenant by occupancy and registered owner'},
  {n: 38, part: 'II', title: 'Abandonment and termination of occupancy'},
  {n: 39, part: 'II', title: 'Security of occupancy'},
  {n: 40, part: 'II', title: 'Restrictions on transfer of family land'},
  {n: 41, part: 'II', title: 'Acquisition of land by non-citizen'},
  {n: 42, part: 'II', title: 'Land Fund'},

  // Part III – Control of land use
  {n: 43, part: 'III', title: 'Acquisition of land by Government'},
  {n: 44, part: 'III', title: 'Utilisation of land according to various laws'},
  {n: 45, part: 'III', title: 'Control of environmentally sensitive areas'},
  {n: 46, part: 'III', title: 'Land use planning and zoning'},

  // Part IV – Land management
  {n: 47, part: 'IV', sub: 'Uganda Land Commission', title: 'Establishment of Commission'},
  {n: 48, part: 'IV', sub: 'Uganda Land Commission', title: 'Membership of Commission'},
  {n: 49, part: 'IV', sub: 'Uganda Land Commission', title: 'Tenure of office'},
  {n: 50, part: 'IV', sub: 'Uganda Land Commission', title: 'Functions of Commission'},
  {n: 51, part: 'IV', sub: 'Uganda Land Commission', title: 'Secretary and other officers of Commission'},
  {n: 52, part: 'IV', sub: 'Uganda Land Commission', title: 'Meetings of Commission'},
  {n: 53, part: 'IV', sub: 'Uganda Land Commission', title: 'Authentication of common seal, etc.'},
  {n: 54, part: 'IV', sub: 'Uganda Land Commission', title: 'Powers of Commission'},
  {n: 55, part: 'IV', sub: 'Uganda Land Commission', title: 'Salaries and expenses of Commission'},
  {n: 56, part: 'IV', sub: 'Uganda Land Commission', title: 'Commission to conform to Government policy'},
  {n: 57, part: 'IV', sub: 'District land boards', title: 'Establishment of district land boards'},
  {n: 58, part: 'IV', sub: 'District land boards', title: 'Membership of board'},
  {n: 59, part: 'IV', sub: 'District land boards', title: 'Tenure of office of members of board'},
  {n: 60, part: 'IV', sub: 'District land boards', title: 'Functions of board'},
  {n: 61, part: 'IV', sub: 'District land boards', title: 'Powers of board'},
  {n: 62, part: 'IV', sub: 'District land boards', title: 'Secretary to board, etc.'},
  {n: 63, part: 'IV', sub: 'District land boards', title: 'Meetings of board'},
  {n: 64, part: 'IV', sub: 'District land boards', title: 'Expenses of board, remuneration of members and audit'},
  {n: 65, part: 'IV', sub: 'Land committees', title: 'Establishment of land committees'},
  {n: 66, part: 'IV', sub: 'Land committees', title: 'Qualification for appointment as member of committee'},
  {n: 67, part: 'IV', sub: 'Land committees', title: 'Remuneration of members of committees'},
  {n: 68, part: 'IV', sub: 'Land committees', title: 'Meetings of committee'},
  {n: 69, part: 'IV', sub: 'Land committees', title: 'Recorder'},
  {n: 70, part: 'IV', sub: 'General powers of disposal and rights', title: 'General powers of disposal'},
  {n: 71, part: 'IV', sub: 'General powers of disposal and rights', title: 'Water rights'},
  {n: 72, part: 'IV', sub: 'General powers of disposal and rights', title: 'Rights of way'},
  {n: 73, part: 'IV', sub: 'General powers of disposal and rights', title: 'Rights of officials to encamp'},
  {n: 74, part: 'IV', sub: 'General powers of disposal and rights', title: 'Execution of public works'},

  // Part V – Land tribunals
  {n: 75, part: 'V', title: 'District land tribunals'},
  {n: 76, part: 'V', title: 'Tenure of office of members of district land tribunals'},
  {n: 77, part: 'V', title: 'Jurisdiction of district land tribunals'},
  {n: 78, part: 'V', title: 'Computation of compensation'},
  {n: 79, part: 'V', title: 'Rules of procedure'},
  {n: 80, part: 'V', title: 'Registrar of district land tribunals'},
  {n: 81, part: 'V', title: 'Assistant registrar of district land tribunal'},
  {n: 82, part: 'V', title: 'Management of administrative affairs of district land tribunal'},
  {n: 83, part: 'V', title: 'Supervisory powers over district land tribunals'},
  {n: 84, part: 'V', title: 'Right of appeal'},
  {n: 85, part: 'V', title: 'Customary dispute settlement and mediation'},
  {n: 86, part: 'V', title: 'Appointment and functions of mediator'},

  // Part VI – Miscellaneous
  {n: 87, part: 'VI', title: 'Disposal of fees, etc.'},
  {n: 88, part: 'VI', title: 'Special powers of Registrar of Titles'},
  {n: 89, part: 'VI', title: 'Offences and penalties'},
  {n: 90, part: 'VI', title: 'Regulations'},
  {n: 91, part: 'VI', title: 'Existing rights'},
  {n: 92, part: 'VI', title: 'Power to amend Schedule'}
] AS row
MATCH (p:Part {id: 'land-act/part-' + toLower(row.part)})
MERGE (s:Provision {id: 'land-act/s' + row.n})
SET s:Section,
    s.number     = toString(row.n),
    s.title      = row.title,
    s.subheading = row.sub
MERGE (p)-[r:HAS_PROVISION]->(s)
SET r.order = row.n;
