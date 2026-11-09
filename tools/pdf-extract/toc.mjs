// Parse the "Contents" (table of contents) of a text file made by extract.mjs and print
// the parts, subheadings and sections as Cypher UNWIND rows, ready to paste into
// cypher/03_structure.cypher. Always check the output against the PDF before using it.
// Usage: node toc.mjs <extracted.txt> [--json]
import fs from 'fs';

const [, , input, flag] = process.argv;
if (!input) {
  console.error('Usage: node toc.mjs <extracted.txt> [--json]');
  process.exit(1);
}

const all = fs.readFileSync(input, 'utf8').split('\n');
const start = all.findIndex(l => l.trim() === 'Contents');
const end = all.findIndex((l, i) => i > start && /^Commenced on/.test(l.trim()));
if (start < 0 || end < 0) { console.error('Could not find the Contents section'); process.exit(1); }

const isNoise = l =>
  !l.trim() ||
  /^=== PAGE/.test(l) ||
  /^[ivxlc]+$/i.test(l.trim()) ||            // roman page numbers (i, ii, iii)
  /\(Chapter \d+\)\s*(Uganda)?$/.test(l.trim()) || // running page header
  l.trim() === 'Uganda';

// Join titles that wrap onto a second line: an entry is complete once it ends with "..... <page>".
const entries = [];
let buffer = '';
for (const raw of all.slice(start + 1, end)) {
  if (isNoise(raw)) continue;
  buffer = buffer ? `${buffer} ${raw.trim()}` : raw.trim();
  if (/\.{3,}\s*\d+\s*$/.test(buffer)) {
    entries.push(buffer.replace(/\s*\.{3,}\s*\d+\s*$/, '').trim());
    buffer = '';
  }
}

const parts = [];
const sections = [];
let part = null;
let sub = null;
for (const e of entries) {
  let m;
  if ((m = e.match(/^Part ([IVXLC]+) – (.+)$/))) {
    part = m[1];
    sub = null;
    parts.push({ num: part, order: parts.length + 1, title: m[2] });
  } else if ((m = e.match(/^(\d+[A-Z]?)\. (.+)$/))) {
    sections.push({ n: m[1], part, sub, title: m[2] });
  } else if (/^Schedule/.test(e)) {
    // schedules are not modelled
  } else {
    sub = e; // a heading inside a part, e.g. "Transfers"
  }
}

if (flag === '--json') {
  console.log(JSON.stringify({ parts, sections }, null, 2));
} else {
  // Cypher string literal: escape backslashes and apostrophes (Cypher uses \' not '')
  const q = s => "'" + s.replaceAll('\\', '\\\\').replaceAll("'", "\\'") + "'";
  console.log('// Parts');
  for (const p of parts) console.log(`  {num: ${q(p.num)}, order: ${p.order}, title: ${q(p.title)}},`);
  console.log('\n// Sections');
  for (const s of sections) {
    const n = /^\d+$/.test(s.n) ? s.n : q(s.n);
    const subPart = s.sub ? `, sub: ${q(s.sub)}` : '';
    console.log(`  {n: ${n}, part: ${q(s.part ?? '')}${subPart}, title: ${q(s.title)}},`);
  }
}
console.error(`${parts.length} parts, ${sections.length} sections`);
