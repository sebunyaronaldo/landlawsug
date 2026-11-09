// Extract the text of a ULII PDF into a plain-text file, one PDF line per text line.
// Usage: node extract.mjs <input.pdf> <output.txt>
import { getDocument } from 'pdfjs-dist/legacy/build/pdf.mjs';
import fs from 'fs';

const [, , input, output] = process.argv;
if (!input || !output) {
  console.error('Usage: node extract.mjs <input.pdf> <output.txt>');
  process.exit(1);
}

const doc = await getDocument({ data: new Uint8Array(fs.readFileSync(input)) }).promise;
let text = '';
for (let p = 1; p <= doc.numPages; p++) {
  const page = await doc.getPage(p);
  const content = await page.getTextContent();
  // pdf.js returns text in small pieces; join pieces that share the same vertical position.
  const lines = [];
  let line = '';
  let lastY = null;
  for (const item of content.items) {
    const y = Math.round(item.transform[5]);
    if (lastY !== null && Math.abs(y - lastY) > 2) { lines.push(line); line = ''; }
    line += item.str;
    lastY = y;
  }
  lines.push(line);
  text += `\n=== PAGE ${p} ===\n` + lines.join('\n');
}
fs.writeFileSync(output, text);
console.log(`${doc.numPages} pages, ${text.length} characters -> ${output}`);
