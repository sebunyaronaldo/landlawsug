// 04_entities.cypher
// Institutions, tenure types and legal concepts.
// Sources: ULII PDFs, version as at 31 December 2023 — Land Act (Chapter 236), Constitution,
// Registration of Titles Act (Chapter 240, "RTA"), Land Acquisition Act (Chapter 235, "LAA").
// Descriptions and definitions are the team's own plain-language summaries of the cited sections.

// ---------------------------------------------------------------------------
// Institutions
// ---------------------------------------------------------------------------
UNWIND [
  {id: 'uganda-land-commission', name: 'Uganda Land Commission', level: 'National',
   description: 'Body corporate established by the Land Act (s.47); manages the Land Fund (s.42).'},
  {id: 'district-land-board', name: 'District Land Board', level: 'District',
   description: 'One board for each district; a body corporate (s.57), appointed by the district council (s.58).'},
  {id: 'land-committee', name: 'Land Committee', level: 'SubCounty',
   description: 'Appointed by the district council at subcounty or division level; a chairperson and four part-time members (s.65).'},
  {id: 'district-land-tribunal', name: 'District Land Tribunal', level: 'District',
   description: 'One in each district; a chairperson and two members who hear and determine land disputes in the district (s.75).'},
  {id: 'recorder', name: 'Recorder', level: 'SubCounty',
   description: 'One for each subcounty, gazetted area and city division; keeps records of certificates of customary ownership and certificates of occupancy (s.69).'},
  {id: 'mediator', name: 'Mediator', level: 'District',
   description: 'Appointed ad hoc by a district land tribunal to help parties settle land disputes (s.86).'},
  {id: 'communal-land-association', name: 'Communal Land Association', level: 'Community',
   description: 'May be formed by any group of persons for communal ownership and management of land (s.15).'},
  {id: 'registrar-of-titles', name: 'Registrar of Titles', level: 'National',
   description: 'Appointed under the Registration of Titles Act (s.3) to run the Office of Titles; keeps the Register Book (RTA s.37). Under the Land Act, also registers and supervises communal land associations (s.15).'},
  {id: 'office-of-titles', name: 'Office of Titles', level: 'National',
   description: 'The office in the charge and control of the Registrar of Titles (RTA s.3); its seal is inscribed "Office of Titles, Uganda" (RTA s.5).'},
  {id: 'chief-registrar-high-court', name: 'Chief Registrar of the High Court', level: 'National',
   description: 'Exercises general supervision over district land tribunals (s.83).'},
  {id: 'high-court', name: 'High Court', level: 'National',
   description: 'Hears appeals from decisions of district land tribunals (s.84).'},
  // --- Land Acquisition Act ---
  {id: 'minister-responsible-for-lands', name: 'Minister responsible for lands', level: 'National',
   description: 'Under the Land Acquisition Act, declares land needed for a public purpose (LAA s.3), may revoke the declaration (LAA s.8) and makes regulations on compensation (LAA s.20).'},
  {id: 'attorney-general', name: 'Attorney General', level: 'National',
   description: 'Refers disputes about compensation under the Land Acquisition Act to court for decision (LAA s.2, s.8, s.10, s.11, s.14).'},
  {id: 'assessment-officer', name: 'Assessment Officer', level: 'National',
   description: 'A public officer or other person appointed by the Minister (LAA s.1); holds the inquiry into claims, makes the compensation award and takes possession of the land (LAA s.6, s.7).'},
  {id: 'appointed-officer', name: 'Appointed Officer', level: 'National',
   description: 'Appointed by the Minister to arrange the temporary occupation and use of land for a public purpose, for up to three years (LAA s.10).'},
  {id: 'magistrates-court', name: 'Magistrate\'s Court', level: 'District',
   description: 'Decides compulsory-acquisition disputes referred by the Attorney General for the area where the land is (LAA s.14) and enforces the right to take possession (LAA s.15).'}
] AS row
MERGE (i:Institution {id: row.id})
SET i.name = row.name, i.level = row.level, i.description = row.description;

// ---------------------------------------------------------------------------
// Tenure types — the four systems in s.2, described from the definitions in s.1
// ---------------------------------------------------------------------------
UNWIND [
  {id: 'customary', name: 'Customary',
   description: 'Land held under customary rules that apply to a particular class of persons in a specific area.'},
  {id: 'freehold', name: 'Freehold',
   description: 'Registered land held forever, subject to statutory and common law qualifications.'},
  {id: 'mailo', name: 'Mailo',
   description: 'Registered land held forever, with its roots in the land allotments of the Uganda Agreement, 1900.'},
  {id: 'leasehold', name: 'Leasehold',
   description: 'Land held for a set period from a set start date, on terms agreed between lessor and lessee; includes subleases.'}
] AS row
MERGE (t:TenureType {id: row.id})
SET t.name = row.name, t.description = row.description;

// ---------------------------------------------------------------------------
// Legal concepts
// ---------------------------------------------------------------------------
UNWIND [
  {id: 'lawful-occupant', name: 'Lawful occupant',
   definition: 'A person occupying land under certain repealed landlord and tenant laws (e.g. Busuulu and Envujjo Law of 1928), who entered with the registered owner\'s consent, or a customary tenant not disclosed or compensated when a leasehold title was acquired (s.29(1)).'},
  {id: 'bona-fide-occupant', name: 'Bona fide occupant',
   definition: 'A person who, before the 1995 Constitution came into force, had occupied and used or developed land unchallenged by the registered owner for twelve years or more, or had been settled on the land by the Government (s.29(2)).'},
  {id: 'tenant-by-occupancy', name: 'Tenant by occupancy',
   definition: 'A lawful or bona fide occupant of registered land, treated as a tenant of the registered owner, with security of occupancy, paying an annual nominal ground rent (s.31).'},
  {id: 'certificate-of-customary-ownership', name: 'Certificate of customary ownership',
   definition: 'A certificate issued under s.4 recording a person\'s customary ownership of land.'},
  {id: 'certificate-of-occupancy', name: 'Certificate of occupancy',
   definition: 'A certificate a tenant by occupancy may apply for from the registered owner for the land he or she occupies (s.34).'},
  {id: 'family-land', name: 'Family land',
   definition: 'Land that may not be sold, mortgaged, leased, given away or otherwise transacted without the prior consent of the owner\'s spouse (s.40).'},
  {id: 'compulsory-acquisition', name: 'Compulsory acquisition',
   definition: 'Taking a person\'s property without consent. Allowed only for public use or interests such as defence, public safety or public health, under a law that provides prompt, fair and adequate compensation in advance and a right of access to court (Constitution art. 26(2)).'},
  // --- Registration of Titles Act ---
  {id: 'certificate-of-title', name: 'Certificate of title',
   definition: 'A certificate issued by the Registrar under the Registration of Titles Act, made in duplicate: one registered in the Register Book, the other given to the owner (RTA s.1, s.38). It is conclusive evidence of the owner\'s title (RTA s.59).'},
  {id: 'register-book', name: 'Register Book',
   definition: 'The book kept by the Registrar in which certificates of title are registered and all dealings affecting the land are entered in order of priority (RTA s.37).'},
  {id: 'caveat', name: 'Caveat',
   definition: 'A notice lodged with the Registrar by a person claiming an interest in land, stopping registration of dealings affecting that interest until the person has been notified (RTA s.123).'},
  {id: 'title-by-possession', name: 'Title by possession',
   definition: 'Ownership claimed through possession of registered land; the claimant may apply to the Registrar for an order vesting the land in him or her (RTA s.77).'},
  {id: 'lease', name: 'Lease',
   definition: 'The owner of freehold or mailo land under the Registration of Titles Act may lease it for more than three years by signing a lease in the prescribed form; a lease of mortgaged land needs the mortgagee\'s written consent (RTA s.100).'},
  // --- Land Acquisition Act ---
  {id: 'public-purpose-declaration', name: 'Declaration (public purpose)',
   definition: 'A statutory instrument by which the Minister declares that land is required by the Government for a public purpose, stating its location and approximate area (LAA s.3). It can be revoked until possession is taken (LAA s.8).'},
  {id: 'person-having-an-interest', name: 'Person having an interest',
   definition: 'Anyone claiming an interest in the compensation payable for land under the Land Acquisition Act, including anyone with an interest in an easement affecting the land (LAA s.1).'},
  {id: 'compensation-award', name: 'Compensation award',
   definition: 'The assessment officer\'s decision after an inquiry, stating the true area of the land, the compensation and how it is shared among those with an interest (LAA s.6). It can be appealed to the High Court within sixty days (LAA s.13).'},
  {id: 'temporary-occupation', name: 'Temporary occupation',
   definition: 'Government occupation and use of waste or arable land for a public purpose for up to three years, with compensation agreed in writing (LAA s.10).'}
] AS row
MERGE (c:LegalConcept {id: row.id})
SET c.name = row.name, c.definition = row.definition;
