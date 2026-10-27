// Gera, a partir de lib/pages/*_page.dart do showcase:
//   1. <pagina>.snippets.g.dart: o codigo dos exemplos. O trecho entre `// #region <id>` e
//      `// #endregion` e EXATAMENTE o que a pagina renderiza (esta no mesmo arquivo, dentro da
//      expressao do preview); aqui vira constante da classe <Pagina>Snippets.
//   2. pages.g.dart: registro de paginas (`kShowcasePages`) para o menu do app e para os testes
//      automaticos (ancoras, codigo 1:1, tabela de props). Pagina nova = arquivo novo + rodar este script.
// Convencao: arquivo `<nome>_page.dart` com `class <Nome>Page extends ...` de construtor `const` sem argumentos.
// Uso: node tools/showcase_snippets/extract.mjs [--check]   (--check falha se algum gerado estiver velho)
import fs from "node:fs";
import path from "node:path";

const app = path.resolve("apps/seedgrid_showcase");
const pagesDir = path.join(app, "lib", "pages");
const check = process.argv.includes("--check");

const camel = (id) => id.replace(/-+(.)/g, (_, c) => c.toUpperCase()).replace(/[^A-Za-z0-9_]/g, "");
const pascal = (s) => s.split("_").map((p) => p.charAt(0).toUpperCase() + p.slice(1)).join("");

const outputs = new Map(); // caminho -> conteudo
const registry = [];
let regions = 0;

const files = fs.readdirSync(pagesDir).filter((f) => f.endsWith("_page.dart")).sort();
for (const f of files) {
  const text = fs.readFileSync(path.join(pagesDir, f), "utf8");
  const classMatch = /^class (\w+)Page\s+extends\s/m.exec(text);
  if (!classMatch) throw new Error(f + ": nenhuma `class XPage extends`");
  const base = f.replace(/_page\.dart$/, "");
  const snippetsClass = pascal(base) + "PageSnippets";

  const found = new Map();
  let cur = null;
  for (const line of text.split(/\r?\n/)) {
    const start = /^\s*\/\/ #region (\S+)\s*$/.exec(line);
    if (start) { cur = { id: start[1], body: [] }; continue; }
    if (/^\s*\/\/ #endregion\s*$/.test(line)) {
      if (!cur) throw new Error(f + ": #endregion sem #region");
      if (found.has(cur.id)) throw new Error(f + ": region duplicada " + cur.id);
      const nonEmpty = cur.body.filter((l) => l.trim());
      const indent = nonEmpty.length ? Math.min(...nonEmpty.map((l) => /^\s*/.exec(l)[0].length)) : 0;
      // `dart format` deixa a virgula (ou ponto e virgula) que fecha a expressao DEPOIS do marcador: nao faz parte do exemplo.
      const code = cur.body.map((l) => l.slice(indent)).join("\n").replace(/\s+$/, "").replace(/[,;]$/, "");
      if (code.includes("'''")) throw new Error(f + ": " + cur.id + " contem ''' (nao suportado)");
      found.set(cur.id, code);
      cur = null;
      continue;
    }
    if (cur) cur.body.push(line);
  }
  if (cur) throw new Error(f + ": #region " + cur.id + " sem #endregion");
  regions += found.size;

  let out = `// dart format off\n// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.\n// Cada constante e o trecho entre \`// #region\` e \`// #endregion\` de ${f}: o mesmo codigo que a pagina renderiza.\n\nabstract final class ${snippetsClass} {\n`;
  for (const [id, code] of [...found].sort((a, b) => a[0].localeCompare(b[0]))) {
    out += `  /// Region \`${id}\`.\n  static const String ${camel(id)} = r'''\n${code}\n''';\n\n`;
  }
  out = out.replace(/\n\n$/, "\n") + "}\n";
  outputs.set(path.join(pagesDir, base + "_page.snippets.g.dart"), out);

  // Colisao de nome (ex.: SgWizardPage e o widget da etapa): `// showcase-name: SgWizard` no topo do arquivo
  // define o nome da pagina no menu/URL sem mudar o nome da classe.
  const override = /^\/\/ showcase-name: (\w+)\s*$/m.exec(text);
  // Descricao curta do cabecalho da pagina (literal Dart, possivelmente em varias strings adjacentes): vai para os cards da home.
  const descMatch = /SgShowcasePage\(\s*name:\s*'[^']*',\s*description:\s*('[^']*'(?:\s*'[^']*')*)\s*,/.exec(text);
  registry.push({ name: override ? override[1] : classMatch[1], cls: classMatch[1] + "Page", file: `lib/pages/${f}`, importPath: f, examples: found.size, description: descMatch ? descMatch[1].replace(/\s+/g, " ") : "''" });
}

registry.sort((a, b) => {
  const sa = a.name.startsWith("Sg") ? 0 : 1;
  const sb = b.name.startsWith("Sg") ? 0 : 1;
  return sa - sb || a.name.localeCompare(b.name);
});
let reg = "// dart format off\n// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.\n// Registro das paginas do showcase (menu do app e testes automaticos).\n\nimport 'package:flutter/widgets.dart';\n\n";
for (const r of registry) reg += `import '${r.importPath}';\n`;
reg += "\n/// Uma pagina do showcase. `examples` = numero de regioes `// #region` do arquivo (links esperados).\ntypedef ShowcasePageEntry = ({String name, String file, int examples, String description, WidgetBuilder builder});\n\nfinal List<ShowcasePageEntry> kShowcasePages = <ShowcasePageEntry>[\n";
for (const r of registry) reg += `  (name: '${r.name}', file: '${r.file}', examples: ${r.examples}, description: ${r.description}, builder: (_) => const ${r.cls}()),\n`;
reg += "];\n";
outputs.set(path.join(pagesDir, "pages.g.dart"), reg);

// remove snippets de paginas que nao existem mais
const wanted = new Set([...outputs.keys()].map((p) => path.basename(p)));
for (const f of fs.readdirSync(pagesDir)) {
  if (f.endsWith(".snippets.g.dart") && !wanted.has(f)) {
    if (check) { console.error("sobrando: " + f); process.exit(1); }
    fs.unlinkSync(path.join(pagesDir, f));
  }
}

let stale = 0;
for (const [file, content] of outputs) {
  const cur = fs.existsSync(file) ? fs.readFileSync(file, "utf8") : null;
  if (cur === content) continue;
  stale++;
  if (!check) fs.writeFileSync(file, content);
}
if (check) {
  if (stale) { console.error(`${stale} arquivo(s) gerado(s) desatualizado(s): rode node tools/showcase_snippets/extract.mjs`); process.exit(1); }
  console.log(`snippets em dia (${registry.length} paginas, ${regions} regioes)`);
} else {
  console.log(`snippets: ${registry.length} paginas, ${regions} regioes (${stale} arquivo(s) escrito(s))`);
}
