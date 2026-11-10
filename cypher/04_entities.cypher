// 04_entities.cypher
// Institutions, tenure types and legal concepts.
// Sources: ULII PDFs, version as at 31 December 2023 — Land Act (Chapter 236), Constitution,
// Registration of Titles Act (Chapter 240, "RTA"), Land Acquisition Act (Chapter 235, "LAA"),
// Mortgage Act (Chapter 239, "MA").
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
   description: 'One for each subcounty, gazetted area and city division; keeps records of certificates of customary ownership and certificates of occupancy (s.69). Under the Mortgage Act, registers mortgages of land held under a certificate of customary ownership, in the order they are presented, and their releases (MA s.8, s.14).'},
  {id: 'mediator', name: 'Mediator', level: 'District',
   description: 'Appointed ad hoc by a district land tribunal to help parties settle land disputes (s.86). Under the Mortgage Act, mediates between mortgagor and mortgagee before a court is asked to act on a mortgage of customary land (MA s.6).'},
  {id: 'communal-land-association', name: 'Communal Land Association', level: 'Community',
   description: 'May be formed by any group of persons for communal ownership and management of land (s.15).'},
  {id: 'registrar-of-titles', name: 'Registrar of Titles', level: 'National',
   description: 'Appointed under the Registration of Titles Act (s.3) to run the Office of Titles; keeps the Register Book (RTA s.37). Under the Land Act, also registers and supervises communal land associations (s.15). Under the Mortgage Act, registers releases of mortgages and transfers by a mortgagee selling the land, removes time-barred mortgages and may issue a special certificate of title to the mortgagor (MA s.14, s.27, s.36, s.37).'},
  {id: 'office-of-titles', name: 'Office of Titles', level: 'National',
   description: 'The office in the charge and control of the Registrar of Titles (RTA s.3); its seal is inscribed "Office of Titles, Uganda" (RTA s.5).'},
  {id: 'chief-registrar-high-court', name: 'Chief Registrar of the High Court', level: 'National',
   description: 'Exercises general supervision over district land tribunals (s.83).'},
  {id: 'high-court', name: 'High Court', level: 'National',
   description: 'Hears appeals from decisions of district land tribunals (s.84).'},
  // --- Land Acquisition Act ---
  {id: 'minister-responsible-for-lands', name: 'Minister responsible for lands', level: 'National',
   description: 'Under the Land Acquisition Act, declares land needed for a public purpose (LAA s.3), may revoke the declaration (LAA s.8) and makes regulations on compensation (LAA s.20). Under the Mortgage Act, makes regulations in consultation with the Bank of Uganda (MA s.40).'},
  {id: 'attorney-general', name: 'Attorney General', level: 'National',
   description: 'Refers disputes about compensation under the Land Acquisition Act to court for decision (LAA s.2, s.8, s.10, s.11, s.14).'},
  {id: 'assessment-officer', name: 'Assessment Officer', level: 'National',
   description: 'A public officer or other person appointed by the Minister (LAA s.1); holds the inquiry into claims, makes the compensation award and takes possession of the land (LAA s.6, s.7).'},
  {id: 'appointed-officer', name: 'Appointed Officer', level: 'National',
   description: 'Appointed by the Minister to arrange the temporary occupation and use of land for a public purpose, for up to three years (LAA s.10).'},
  {id: 'magistrates-court', name: 'Magistrate\'s Court', level: 'District',
   description: 'Decides compulsory-acquisition disputes referred by the Attorney General for the area where the land is (LAA s.14) and enforces the right to take possession (LAA s.15).'},
  // --- Mortgage Act ---
  {id: 'secretary-to-the-treasury', name: 'Secretary to the Treasury', level: 'National',
   description: 'Receives mortgage money when the mortgagee cannot be found and holds it in trust in the Consolidated Fund for the person entitled, paying it out on the request of the Registrar of Titles or recorder (MA s.15).'}
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
   definition: 'Government occupation and use of waste or arable land for a public purpose for up to three years, with compensation agreed in writing (LAA s.10).'},
  // --- Mortgage Act ---
  {id: 'mortgage', name: 'Mortgage',
   definition: 'A charge or lien over land, or an interest in land, that secures a debt or the performance of an obligation; includes second and later mortgages, third party mortgages and submortgages (MA s.1). It can be created over land under any tenure and takes effect on registration, though an unregistered mortgage binds the parties (MA s.2). It is security only and does not transfer the land to the lender (MA s.7).'},
  {id: 'informal-mortgage', name: 'Informal mortgage',
   definition: 'A written and witnessed undertaking clearly meant to charge the borrower\'s land with repaying money; includes an equitable mortgage and a mortgage on unregistered customary land (MA s.1). Lenders may accept one (MA s.2(8)), and informal mortgages rank by the date and time they are made (MA s.8).'},
  {id: 'matrimonial-home', name: 'Matrimonial home',
   definition: 'The building where spouses and their children ordinarily live, with its curtilage and, on farm land, land one spouse has given the other for exclusive use (MA s.1). A mortgage of it is valid only with the informed and genuine consent of the spouse or spouses living there (MA s.4, s.5).'},
  {id: 'mortgage-on-customary-land', name: 'Mortgage on customary land',
   definition: 'A mortgage of customary land, governed by the applicable customary law subject to the Mortgage Act. A remedy that would dispossess the mortgagor needs mediation and then a court order, and family-owned customary land may be mortgaged only with the consent of the spouses and children (MA s.6).'},
  {id: 'priority-of-mortgages', name: 'Priority of mortgages',
   definition: 'The order in which mortgages rank: by registration for land under the Registration of Titles Act, by registration with the recorder for land under a certificate of customary ownership, and by date and time for informal mortgages. A prior lender\'s fraud postpones its rights to a later lender it misled (MA s.8).'},
  {id: 'tacking', name: 'Tacking',
   definition: 'Lending further money under an existing mortgage. A further advance ranks ahead of a later mortgage only if it is noted in the register or the later lender agrees in writing; otherwise there is no right to tack (MA s.9).'},
  {id: 'consolidation', name: 'Consolidation',
   definition: 'Combining two or more mortgages or securities (MA s.10(4)). Unless the mortgage clearly says otherwise, a borrower with several mortgages to one lender may pay off some without redeeming all (MA s.10).'},
  {id: 'right-to-discharge', name: 'Right to discharge',
   definition: 'The mortgagor\'s right to have the mortgage released once everything it secures has been paid or performed; any term that removes or fetters this right is void (MA s.13). The mortgagor may also pay off the mortgage at any time before a sale of the land is agreed (MA s.31).'},
  {id: 'implied-covenants-by-mortgagor', name: 'Implied covenants by mortgagor',
   definition: 'Promises the law reads into every mortgage: to pay the money due, pay outgoings, keep buildings in repair, insure against fire, use farm land sustainably, and not lease or transfer the land without the lender\'s consent (MA s.17).'},
  {id: 'notice-of-default', name: 'Notice of default',
   definition: 'Written notice, in the prescribed form, from the mortgagee stating the default, what must be done to put it right and by when (MA s.18). The mortgagee may use its remedies only if the default is not put right within that time (MA s.19).'},
  {id: 'mortgagee-remedies', name: 'Remedies of mortgagee',
   definition: 'After an unremedied notice of default, the mortgagee may demand all money owing, appoint a receiver of the income, lease the land, take possession or sell the land (MA s.19). Most of these need a further notice to the mortgagor first (MA s.21–s.25).'},
  {id: 'receiver', name: 'Receiver',
   definition: 'A person appointed in writing by the mortgagee, or by the court, to collect the income of the mortgaged land. The receiver acts as the mortgagor\'s agent and must apply the money in a fixed order (MA s.1, s.21).'},
  {id: 'power-of-sale', name: 'Power of sale',
   definition: 'The mortgagee\'s power to sell the mortgaged land after an unremedied default and a notice to sell of twenty-one working days (MA s.25), usually by public auction, taking reasonable steps to get the best price (MA s.26, s.27). The buyer gets good title unless aware of fraud (MA s.28); the proceeds are paid out in a fixed order (MA s.30).'},
  {id: 'relief-for-mortgagor', name: 'Relief for mortgagor',
   definition: 'A court application by the mortgagor, a spouse or the trustee in bankruptcy to stop or limit a mortgagee\'s remedy, made at any time after a notice is served (MA s.32). The court may also review, change or void a mortgage obtained by fraud or containing unlawful terms (MA s.33–s.35).'}
] AS row
MERGE (c:LegalConcept {id: row.id})
SET c.name = row.name, c.definition = row.definition;
