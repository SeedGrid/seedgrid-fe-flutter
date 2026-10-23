// Extrai o codigo dos exemplos do showcase. O trecho entre `// #region <id>` e `// #endregion` e
// EXATAMENTE o que a pagina renderiza (esta no mesmo arquivo, dentro da expressao do preview);
// aqui ele vira constante em lib/snippets.g.dart para ser exibido no bloco de codigo.
// Uso: node tools/showcase_snippets/extract.mjs [--check]   (--check falha se o arquivo gerado estiver velho)
import fs from "node:fs";
import path from "node:path";

const app = path.resolve("apps/seedgrid_showcase");
const pagesDir = path.join(app, "lib", "pages");
const outFile = path.join(app, "lib", "snippets.g.dart");

const camel = (id) => id.replace(/-+(.)/g, (_, c) => c.toUpperCase()).replace(/[^A-Za-z0-9_]/g, "");
const files = fs.readdirSync(pagesDir).filter((f) => f.endsWith(".dart")).sort();
const found = new Map();
for (const f of files) {
  const lines = fs.readFileSync(path.join(pagesDir, f), "utf8").split(/\r?\n/);
  let cur = null;
  for (const line of lines) {
    const start = /^\s*\/\/ #region (\S+)\s*$/.exec(line);
    if (start) { cur = { id: start[1], file: f, body: [] }; continue; }
    if (/^\s*\/\/ #endregion\s*$/.test(line)) {
      if (!cur) throw new Error(f + ": #endregion sem #region");
      if (found.has(cur.id)) throw new Error("region duplicada: " + cur.id);
      // remove a indentacao comum
      const nonEmpty = cur.body.filter((l) => l.trim());
      const indent = Math.min(...nonEmpty.map((l) => /^\s*/.exec(l)[0].length));
      // `dart format` deixa a virgula (ou ponto e virgula) que fecha a expressao DEPOIS do marcador: nao faz parte do exemplo.
      const code = cur.body.map((l) => l.slice(indent)).join("\n").replace(/\s+$/, "").replace(/[,;]$/, "");
      if (code.includes("'''")) throw new Error(cur.id + ": codigo contem ''' (nao suportado)");
      found.set(cur.id, { code, file: cur.file });
      cur = null;
      continue;
    }
    if (cur) cur.body.push(line);
  }
  if (cur) throw new Error(f + ": #region " + cur.id + " sem #endregion");
}

let out = "// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.\n// Cada constante e o trecho entre `// #region` e `// #endregion` de lib/pages/*.dart: o mesmo codigo que a pagina renderiza.\n\nabstract final class Snippets {\n";
for (const [id, v] of [...found].sort((a, b) => a[0].localeCompare(b[0]))) {
  out += `  /// ${v.file}, region \`${id}\`.\n  static const String ${camel(id)} = r'''\n${v.code}\n''';\n\n`;
}
out = out.replace(/\n\n$/, "\n") + "}\n";

if (process.argv.includes("--check")) {
  const cur = fs.existsSync(outFile) ? fs.readFileSync(outFile, "utf8") : "";
  if (cur !== out) { console.error("snippets.g.dart desatualizado: rode node tools/showcase_snippets/extract.mjs"); process.exit(1); }
  console.log(`snippets em dia (${found.size} regioes)`);
} else {
  fs.writeFileSync(outFile, out);
  console.log(`snippets: ${found.size} regioes -> ${path.relative(process.cwd(), outFile)}`);
}
