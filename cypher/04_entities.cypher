// 04_entities.cypher
// Institutions, tenure types and legal concepts.
// Source: ULII PDF — Land Act (Chapter 236), version as at 31 December 2023.
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
   description: 'Appointed under the Registration of Titles Act; keeps the public register of communal land associations and supervises them (s.15).'},
  {id: 'chief-registrar-high-court', name: 'Chief Registrar of the High Court', level: 'National',
   description: 'Exercises general supervision over district land tribunals (s.83).'},
  {id: 'high-court', name: 'High Court', level: 'National',
   description: 'Hears appeals from decisions of district land tribunals (s.84).'}
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
   definition: 'Taking a person\'s property without consent. Allowed only for public use or interests such as defence, public safety or public health, under a law that provides prompt, fair and adequate compensation in advance and a right of access to court (Constitution art. 26(2)).'}
] AS row
MERGE (c:LegalConcept {id: row.id})
SET c.name = row.name, c.definition = row.definition;
