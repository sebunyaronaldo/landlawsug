// 02_legislation.cypher
// Legislation nodes and amendment relationships.
// Sources (ULII PDFs, legislation as at 31 December 2023):
//   Land Act (Chapter 236)                    — FRBR URI /akn/ug/act/1998/16/eng@2023-12-31
//   Constitution of the Republic of Uganda    — FRBR URI /akn/ug/act/statute/1995/constitution/eng@2023-12-31

// ---------------------------------------------------------------------------
// Constitution — facts from page 1 and the opening notes.
// In scope: Chapter Fifteen (Land and environment) and Article 26 only.
// Its amending Acts are not included: they do not concern land.
// ---------------------------------------------------------------------------
MERGE (c:Legislation {id: 'constitution-1995'})
SET c.title            = 'Constitution of the Republic of Uganda',
    c.type             = 'Constitution',
    c.yearEnacted      = 1995,
    c.commencementDate = date('1995-10-08'),
    c.status           = 'InForce',
    c.sourceUrl        = 'https://ulii.org/en/akn/ug/act/statute/1995/constitution/eng@2023-12-31',
    c.sourceVersion    = '2023-12-31';

// ---------------------------------------------------------------------------
// Land Act — facts from page 1 and the heading of the Act (page 5)
// ---------------------------------------------------------------------------
MERGE (l:Legislation {id: 'land-act'})
SET l.title            = 'Land Act',
    l.type             = 'Act',
    l.actNumber        = 'Act 16 of 1998',
    l.yearEnacted      = 1998,
    l.commencementDate = date('1998-07-02'),
    l.chapter          = 'Cap. 236',
    l.chapterEdition   = '2023 Revised Edition',
    l.formerChapter    = 'Cap. 227 (2000 Revised Edition)',
    l.longTitle        = 'An Act to provide for the tenure, ownership and management of land and for related matters.',
    l.status           = 'InForce',
    l.sourceUrl        = 'https://ulii.org/akn/ug/act/1998/16/eng@2023-12-31',
    l.sourceVersion    = '2023-12-31';

// ---------------------------------------------------------------------------
// Amending Acts — from the amendment notes at the start of the Land Act (page 5).
// Their facts come from the Land Act PDF, so sourceUrl points to it.
// ---------------------------------------------------------------------------
UNWIND [
  {id: 'land-amendment-act-2001', title: 'Land (Amendment) Act, 2001', actNumber: 'Act 3 of 2001',  year: 2001, effective: '2000-07-02'},
  {id: 'land-amendment-act-2004', title: 'Land (Amendment) Act, 2004', actNumber: 'Act 1 of 2004',  year: 2004, effective: '2004-03-18'},
  {id: 'land-amendment-act-2010', title: 'Land (Amendment) Act, 2010', actNumber: 'Act 1 of 2010',  year: 2010, effective: '2010-02-12'},
  {id: 'law-revision-misc-amendments-act-2023', title: 'Law Revision (Miscellaneous Amendments) Act, 2023', actNumber: 'Act 17 of 2023', year: 2023, effective: '2023-07-28'}
] AS row
MERGE (a:Legislation {id: row.id})
SET a.title         = row.title,
    a.type          = 'AmendmentAct',
    a.actNumber     = row.actNumber,
    a.yearEnacted   = row.year,
    a.sourceUrl     = 'https://ulii.org/akn/ug/act/1998/16/eng@2023-12-31',
    a.sourceVersion = '2023-12-31'
WITH a, row
MATCH (l:Legislation {id: 'land-act'})
MERGE (a)-[r:AMENDS]->(l)
SET r.effectiveDate = date(row.effective);
