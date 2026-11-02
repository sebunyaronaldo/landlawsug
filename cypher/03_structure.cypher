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

// ===========================================================================
// REGISTRATION OF TITLES ACT (Chapter 240) — ULII version as at 31 December 2023
// Rows generated from the PDF table of contents; titles exactly as printed.
// ===========================================================================

// --- Parts -----------------------------------------------------------------
MATCH (l:Legislation {id: 'registration-of-titles-act'})
UNWIND [
  {num: 'I', order: 1, title: 'Preliminary'},
  {num: 'II', order: 2, title: 'Officers'},
  {num: 'III', order: 3, title: 'Bringing land under Act'},
  {num: 'IV', order: 4, title: 'Certificates of title and registration'},
  {num: 'V', order: 5, title: 'Title by possession to land under act'},
  {num: 'VI', order: 6, title: 'Dealings with land'},
  {num: 'VII', order: 7, title: 'Caveats'},
  {num: 'VIII', order: 8, title: 'Power of attorney and attestation of instruments'},
  {num: 'IX', order: 9, title: 'Surveys, plans and boundaries'},
  {num: 'X', order: 10, title: 'Rectification of titles'},
  {num: 'XI', order: 11, title: 'Special powers of high court and registrar'},
  {num: 'XII', order: 12, title: 'Actions and other remedies'},
  {num: 'XIII', order: 13, title: 'Offences and penalties'},
  {num: 'XIV', order: 14, title: 'Miscellaneous'}
] AS row
MERGE (p:Part {id: 'registration-of-titles-act/part-' + toLower(row.num)})
SET p.number = row.num, p.title = row.title
MERGE (l)-[r:HAS_PART]->(p)
SET r.order = row.order;

// --- Sections --------------------------------------------------------------
UNWIND [
  // Part I – Preliminary
  {n: 1, part: 'I', title: 'Interpretation'},
  {n: 2, part: 'I', title: 'Conflicting laws'},

  // Part II – Officers
  {n: 3, part: 'II', title: 'Appointment of officers'},
  {n: 4, part: 'II', title: 'Signature to be judicially noticed'},
  {n: 5, part: 'II', title: 'Seal of office'},
  {n: 6, part: 'II', title: 'Appointment of sworn valuers'},

  // Part III – Bringing land under Act
  {n: 7, part: 'III', title: 'Future grants and final mailo certificates to be registered'},
  {n: 8, part: 'III', title: 'Grants for public purposes'},
  {n: 9, part: 'III', title: 'Lands alienated before Registration of Land Titles Ordinance, 1908'},
  {n: 10, part: 'III', title: 'Application when no dealing has been registered under Cap. 113, 1951 Revision, Ordinance 3 of 1904 or Registration of Documents Act'},
  {n: 11, part: 'III', title: 'Application when dealing has been registered'},
  {n: 12, part: 'III', title: 'Rejection of application for delay'},
  {n: 13, part: 'III', title: 'Notices of application'},
  {n: 14, part: 'III', title: 'Person claiming title by possession to post notice of application land'},
  {n: 15, part: 'III', title: 'Land to be brought under Act unless caveat received'},
  {n: 16, part: 'III', title: 'Land occupied may be brought under Act by different description from that in title'},
  {n: 17, part: 'III', title: 'Application to bring land under Act may be granted as to land occupied under but not described in title deeds'},
  {n: 18, part: 'III', title: 'In case of error in Government survey, title may correspond to actual dimensions'},
  {n: 19, part: 'III', title: 'Excess of land may be apportioned between different owners or proprietors'},
  {n: 20, part: 'III', title: 'Parties interested may lodge caveat'},
  {n: 21, part: 'III', title: 'Proceedings suspended if caveat received'},
  {n: 22, part: 'III', title: 'Caveat to lapse unless proceedings taken within one month'},
  {n: 23, part: 'III', title: 'Production of title deeds in support of application to bring land under Act'},
  {n: 24, part: 'III', title: 'Applicant may withdraw application'},
  {n: 25, part: 'III', title: 'Endorsement of prior title deeds'},
  {n: 26, part: 'III', title: 'Subsisting lease to be endorsed and returned'},
  {n: 27, part: 'III', title: 'Record Book to be kept'},
  {n: 28, part: 'III', title: 'Certificate of title to issue in name of deceased applicant or his or her nominee'},
  {n: 29, part: 'III', title: 'Application to bring under Act land registered under Ordinance 11 of 1908'},
  {n: 30, part: 'III', title: 'Procedure'},
  {n: 31, part: 'III', title: 'Effect of lodgment of instrument affecting land registered under Ordinance 11 of 1908'},
  {n: 32, part: 'III', title: 'Closing of 1908 register'},
  {n: 33, part: 'III', title: 'Fees'},
  {n: 34, part: 'III', title: 'Fee for assurance of title'},
  {n: 35, part: 'III', title: 'Additional assurance fee in case of imperfect title'},
  {n: 36, part: 'III', title: 'Registration of leaseholds'},

  // Part IV – Certificates of title and registration
  {n: 37, part: 'IV', title: 'Register Book'},
  {n: 38, part: 'IV', title: 'Certificates of title'},
  {n: 39, part: 'IV', title: 'Issue of limited certificates'},
  {n: 40, part: 'IV', title: 'Removal of limitation as to parcels'},
  {n: 41, part: 'IV', title: 'Ordinary certificate not to be registered until limitation removed'},
  {n: 42, part: 'IV', title: 'Application of Act to limited certificate'},
  {n: 43, part: 'IV', title: 'No action against Government in certain cases'},
  {n: 44, part: 'IV', title: 'Area of land need not be mentioned in certificate'},
  {n: 45, part: 'IV', title: 'Receipts may be required for duplicate certificates'},
  {n: 46, part: 'IV', title: 'Effective date of registration; duly registered proprietor'},
  {n: 47, part: 'IV', title: 'Registration of transfers of mortgages and transfers or mortgages of leases, etc.'},
  {n: 48, part: 'IV', title: 'Instruments entitled to priority according to date of registration'},
  {n: 49, part: 'IV', title: 'Leases and mortgages may be in triplicate'},
  {n: 50, part: 'IV', title: 'No notice of trusts to be entered in Register Book'},
  {n: 51, part: 'IV', title: 'Memorial defined'},
  {n: 52, part: 'IV', title: 'Memorial to be entered on duplicate instrument'},
  {n: 53, part: 'IV', title: 'Signature of Registrar substituted for seal in certain cases'},
  {n: 54, part: 'IV', title: 'Instruments not effectual until registered'},
  {n: 55, part: 'IV', title: 'Proprietor of land entitled to certificate of title'},
  {n: 56, part: 'IV', title: 'Joint tenants and tenants in common'},
  {n: 57, part: 'IV', title: 'Effect of insertion of words “no survivorship”'},
  {n: 58, part: 'IV', title: 'Notice to be published before making order in respect of land under section 57'},
  {n: 59, part: 'IV', title: 'Certificate to be conclusive evidence of title'},
  {n: 60, part: 'IV', title: 'Certificate conclusive evidence as to title to easements'},
  {n: 61, part: 'IV', title: 'Effect in certificate of words relating to easements'},
  {n: 62, part: 'IV', title: 'Extension of Schedule 2 to easements'},
  {n: 63, part: 'IV', title: 'Certificate to be conclusive evidence in action for specific performance or damages'},
  {n: 64, part: 'IV', title: 'Estate of registered proprietor paramount'},
  {n: 65, part: 'IV', title: 'Easements existing under deed or writing to be noticed as encumbrances'},
  {n: 66, part: 'IV', title: 'Reversions expectant on leases'},
  {n: 67, part: 'IV', title: 'Upon surrender of existing grants or certificates, single certificate may be obtained'},
  {n: 68, part: 'IV', title: 'History of various dealings affecting land to be preserved'},
  {n: 69, part: 'IV', title: 'Lost grant'},
  {n: 70, part: 'IV', title: 'Issue of special certificate'},
  {n: 71, part: 'IV', title: 'Copy of lost or destroyed certificate'},
  {n: 72, part: 'IV', title: 'Registrar may call in duplicate certificate on sale by court or mortgagee or when required for cancellation, etc.'},
  {n: 73, part: 'IV', title: 'Refusal to send duplicate or triplicate certificate'},
  {n: 74, part: 'IV', title: 'Lists of certificates called in for cancellation to be exhibited'},
  {n: 75, part: 'IV', title: 'Words of inheritance or succession to be implied'},
  {n: 76, part: 'IV', title: 'Certificate void for fraud'},

  // Part V – Title by possession to land under act
  {n: 77, part: 'V', title: 'Person claiming title by possession'},
  {n: 78, part: 'V', title: 'Form of application'},
  {n: 79, part: 'V', title: 'Application, how dealt with'},
  {n: 80, part: 'V', title: 'Advertisement and service of notice of application'},
  {n: 81, part: 'V', title: 'Copy to be posted'},
  {n: 82, part: 'V', title: 'Time to be appointed by Registrar after which application may be granted'},
  {n: 83, part: 'V', title: 'Contents of notice'},
  {n: 84, part: 'V', title: 'Power to reject application'},
  {n: 85, part: 'V', title: 'Caveat forbidding grant of application'},
  {n: 86, part: 'V', title: 'Cancellation of existing certificate and issue of new one'},
  {n: 87, part: 'V', title: 'Fee for assurance of title'},
  {n: 88, part: 'V', title: 'Entries to be made by Registrar'},
  {n: 89, part: 'V', title: 'Duty of Registrar as to cancellation'},
  {n: 90, part: 'V', title: 'Effect of new certificate of title'},

  // Part VI – Dealings with land
  {n: 91, part: 'VI', sub: 'Transfers', title: 'Form of transfer'},
  {n: 92, part: 'VI', sub: 'Transfers', title: 'Transfer to include right to sue under it'},
  {n: 93, part: 'VI', sub: 'Transfers', title: 'Proprietor may vest estate jointly in himself or herself and others without limiting any use, etc.'},
  {n: 94, part: 'VI', sub: 'Transfers', title: 'Instruments when signed and registered to have same efficacy as deed acknowledged'},
  {n: 95, part: 'VI', sub: 'Transfers', title: 'Transfer of portion of lands comprised in certificate'},
  {n: 96, part: 'VI', sub: 'Transfers', title: 'Transfer of all land comprised in certificate'},
  {n: 97, part: 'VI', sub: 'Transfers', title: 'Transferee of land subject to mortgage to indemnify transferor'},
  {n: 98, part: 'VI', sub: 'Transfers', title: 'Creation of easements'},
  {n: 99, part: 'VI', sub: 'Transfers', title: 'Memorial of easements to be registered'},
  {n: 100, part: 'VI', sub: 'Leases and subleases', title: 'Leases of land'},
  {n: 101, part: 'VI', sub: 'Leases and subleases', title: 'Covenants to be implied in every lease against lessee'},
  {n: 102, part: 'VI', sub: 'Leases and subleases', title: 'Powers to be implied in lessor'},
  {n: 103, part: 'VI', sub: 'Leases and subleases', title: 'Short forms of covenants by lessees'},
  {n: 104, part: 'VI', sub: 'Leases and subleases', title: 'Covenant to be implied on transfer of lease'},
  {n: 105, part: 'VI', sub: 'Leases and subleases', title: 'Recovery of possession by lessors to be entered in Register Book'},
  {n: 106, part: 'VI', sub: 'Leases and subleases', title: 'Mortgagee of interest of bankrupt lessee may apply to be entered as transferee of lease and on default lessor may apply'},
  {n: 107, part: 'VI', sub: 'Leases and subleases', title: 'Lease may be surrendered by endorsement'},
  {n: 108, part: 'VI', sub: 'Leases and subleases', title: 'Lessee may sublet'},
  {n: 109, part: 'VI', sub: 'Leases and subleases', title: 'Endorsement on sublease'},
  {n: 110, part: 'VI', sub: 'Leases and subleases', title: 'Sublease to be kept in separate register'},
  {n: 111, part: 'VI', sub: 'Leases and subleases', title: 'Provisions as to leases to apply to subleases'},
  {n: 112, part: 'VI', sub: 'Leases and subleases', title: 'Covenants to be implied in sublease'},
  {n: 113, part: 'VI', sub: 'Leases and subleases', title: 'Determination of lease or sublease by re-entry to be entered in Register Book or Sublease Register'},
  {n: 114, part: 'VI', sub: 'Miscellaneous', title: 'Consent under Land Transfer Act'},
  {n: 115, part: 'VI', sub: 'Miscellaneous', title: 'Restriction on dealing with official estates'},
  {n: 116, part: 'VI', sub: 'Miscellaneous', title: 'Seal of corporation substituted for signature'},
  {n: 117, part: 'VI', sub: 'Miscellaneous', title: 'Implied covenants and powers may be modified or negatived'},
  {n: 118, part: 'VI', sub: 'Miscellaneous', title: 'Succession on death'},
  {n: 119, part: 'VI', sub: 'Miscellaneous', title: 'Sale under decree of execution'},
  {n: 120, part: 'VI', sub: 'Miscellaneous', title: 'Purchaser from registered proprietor not to be affected by notice'},
  {n: 121, part: 'VI', sub: 'Miscellaneous', title: 'Powers of lessees under other legislation not extended'},
  {n: 122, part: 'VI', sub: 'Miscellaneous', title: 'Registration of unascertained portions of mailo, etc. land'},

  // Part VII – Caveats
  {n: 123, part: 'VII', title: 'Caveat may be lodged and withdrawn'},
  {n: 124, part: 'VII', title: 'Notice of caveat to be given; lapse of caveat, etc.'},
  {n: 125, part: 'VII', title: 'No entry to be made in Register Book while caveat continues in force'},
  {n: 126, part: 'VII', title: 'Compensation for lodging caveat without reasonable cause'},
  {n: 127, part: 'VII', title: 'Memo of caveat to be entered in Register Book, etc.'},
  {n: 128, part: 'VII', title: 'Caveaton behalf of beneficiary under will, etc. need not be removed to admit registration of certain dealings'},  // "Caveaton" as printed in the ULII text
  {n: 129, part: 'VII', title: 'Removal of caveat no longer affecting lands'},

  // Part VIII – Power of attorney and attestation of instruments
  {n: 130, part: 'VIII', title: 'Power of attorney and revocation of power of attorney'},
  {n: 131, part: 'VIII', title: 'Attestation of instruments and powers of attorney'},
  {n: 132, part: 'VIII', title: 'Signatures to be in Latin character'},

  // Part IX – Surveys, plans and boundaries
  {n: 133, part: 'IX', title: 'Registrar may require survey of land'},
  {n: 134, part: 'IX', title: 'Surveys to be authenticated'},
  {n: 135, part: 'IX', title: 'Registrar may disregard minor errors'},
  {n: 136, part: 'IX', title: 'Proprietor subdividing to deposit plan if required'},
  {n: 137, part: 'IX', title: 'Number of allotment on plan of subdivision sufficient description for purposes of dealing'},
  {n: 138, part: 'IX', title: 'Abuttals may be used in description of land in certificate'},
  {n: 139, part: 'IX', title: 'Objects which may constitute abuttals'},

  // Part X – Rectification of titles
  {n: 140, part: 'X', title: 'Proprietor may apply for amendment to make boundaries coincide with land occupied under title'},
  {n: 141, part: 'X', title: 'Proprietor may apply to have other titles amended where inconsistent'},
  {n: 142, part: 'X', title: 'Form of application'},
  {n: 143, part: 'X', title: 'How application to be dealt with'},
  {n: 144, part: 'X', title: 'Special notice to be given to other proprietors'},
  {n: 145, part: 'X', title: 'Person objecting to application being granted may lodge caveat'},
  {n: 146, part: 'X', title: 'Application may be granted although other titles may be affected'},
  {n: 147, part: 'X', title: 'On granting application other title may be rectified'},
  {n: 148, part: 'X', title: 'Issue of amended or substituted certificate on rectification'},

  // Part XI – Special powers of high court and registrar
  {n: 149, part: 'XI', title: 'Power to require explanation and production of documents'},
  {n: 150, part: 'XI', title: 'Registrar to carry out order vesting trust estate'},
  {n: 151, part: 'XI', title: 'Power of Registrar to make vesting order in cases of completed purchase'},
  {n: 152, part: 'XI', title: 'Removal of encumbrances'},
  {n: 153, part: 'XI', title: 'Satisfaction of judgment may be entered before expiration of period'},
  {n: 154, part: 'XI', title: 'Powers of Registrar'},
  {n: 155, part: 'XI', title: 'Fees'},
  {n: 156, part: 'XI', title: 'Additional fees for assurance of title in certain cases'},
  {n: 157, part: 'XI', title: 'Rejection of defective instrument or document'},
  {n: 158, part: 'XI', title: 'Power to state a case for High Court'},

  // Part XII – Actions and other remedies
  {n: 159, part: 'XII', title: 'Officers not to be liable for acts done bona fide'},
  {n: 160, part: 'XII', title: 'Registered proprietor protected against ejectment except in certain cases'},
  {n: 161, part: 'XII', title: 'Powers of High Court to direct cancellation of certificate or entry in certain cases'},
  {n: 162, part: 'XII', title: 'Compensation of party deprived of land'},
  {n: 163, part: 'XII', title: 'Money paid by Government may be recovered'},
  {n: 164, part: 'XII', title: 'Government not liable in certain cases'},
  {n: 165, part: 'XII', title: 'Purchasers protected'},
  {n: 166, part: 'XII', title: 'Proprietor, etc. may summon Registrar to show cause if dissatisfied'},
  {n: 167, part: 'XII', title: 'Actions for recovery of damages may be brought against Government'},
  {n: 168, part: 'XII', title: 'Persons sustaining loss by inaccuracy in Government survey may recover damages'},
  {n: 169, part: 'XII', title: 'Persons sustaining loss may recover damages'},
  {n: 170, part: 'XII', title: 'Person claiming may before action brought apply to Registrar for compensation'},
  {n: 171, part: 'XII', title: 'Limitation of actions'},
  {n: 172, part: 'XII', title: 'Ordinary rules of procedure and rights of appeal to apply'},
  {n: 173, part: 'XII', title: 'High Court may refer questions to other courts'},

  // Part XIII – Offences and penalties
  {n: 174, part: 'XIII', title: 'Certain fraudulent acts to be offences'},

  // Part XIV – Miscellaneous
  {n: 175, part: 'XIV', title: 'Change of address'},
  {n: 176, part: 'XIV', title: 'Registration of survivor of joint proprietors'},
  {n: 177, part: 'XIV', title: 'Proprietors and transferees to stand in places of previous owners'},
  {n: 178, part: 'XIV', title: 'Proprietor to allow his or her name to be used by person interested'},
  {n: 179, part: 'XIV', title: 'Legal practitioners tendering documents to be practising advocates of Uganda'},
  {n: 180, part: 'XIV', title: 'Registrar to give receipt for documents lodged'},
  {n: 181, part: 'XIV', title: 'Official Receiver or trustee of bankrupt entitled to be registered'},
  {n: 182, part: 'XIV', title: 'Until Official Receiver or trustee registered, bankruptcy of proprietor not to affect dealings'},
  {n: 183, part: 'XIV', title: 'Conditions of sale in Schedule 19 may be adopted by reference'},
  {n: 184, part: 'XIV', title: 'Forms may be modified'},
  {n: 185, part: 'XIV', title: 'Searches and certified copies'},
  {n: 186, part: 'XIV', title: 'Service of notices'},
  {n: 187, part: 'XIV', title: 'Rules'}
] AS row
MATCH (p:Part {id: 'registration-of-titles-act/part-' + toLower(row.part)})
MERGE (s:Provision {id: 'registration-of-titles-act/s' + row.n})
SET s:Section,
    s.number     = toString(row.n),
    s.title      = row.title,
    s.subheading = row.sub
MERGE (p)-[r:HAS_PROVISION]->(s)
SET r.order = row.n;
