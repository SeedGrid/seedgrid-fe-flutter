// Textos traduziveis das paginas do showcase: titulo/descricao dos exemplos (`ShowcaseExample`) e descricao da pagina
// (`SgShowcasePage`). O texto em portugues escrito na pagina e a CHAVE do dicionario; a traducao vem de
// tools/showcase_i18n/traducoes/*.json ({ "texto pt-BR": ["en-US", "pt-PT", "es", "fr"] }).
//
// Uso:
//   node tools/showcase_i18n/extract.mjs            gera apps/seedgrid_showcase/lib/src/showcase_texts.g.dart
//   node tools/showcase_i18n/extract.mjs --check    falha se o gerado estiver velho ou faltar traducao
//   node tools/showcase_i18n/extract.mjs --faltam [N]   lista (JSON) ate N textos ainda sem traducao, com a pagina de origem
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "../..");
const pagesDir = path.join(root, "apps/seedgrid_showcase/lib/pages");
const outFile = path.join(root, "apps/seedgrid_showcase/lib/src/showcase_texts.g.dart");
const transDir = path.join(root, "tools/showcase_i18n/traducoes");
export const LOCALES = ["en-US", "pt-PT", "es", "fr"];

/** Le uma sequencia de literais Dart adjacentes ('a' 'b') a partir de `i`; devolve { value, end } ou null. */
function readLiterals(t, i) {
  let value = "";
  let found = false;
  let dynamic = false;
  for (;;) {
    while (i < t.length && /\s/.test(t[i])) i++;
    const q = t[i];
    if (q !== "'" && q !== '"') break;
    let j = i + 1;
    let s = "";
    while (j < t.length && t[j] !== q) {
      if (t[j] === "\\") {
        const n = t[j + 1];
        s += n === "n" ? "\n" : n;
        j += 2;
      } else {
        if (t[j] === "$") dynamic = true;
        s += t[j++];
      }
    }
    value += s;
    found = true;
    i = j + 1;
  }
  return found ? { value, end: i, dynamic } : null;
}

/** Textos com interpolacao (`$x`): nao tem chave estatica; ficam em pt-BR e sao listados por --faltam. */
export const dinamicos = [];

/** Textos de uma pagina: [{ texto, onde }]. */
export function pageTexts(file) {
  const t = fs.readFileSync(file, "utf8");
  const out = [];
  const grab = (from, stop, keys) => {
    const block = t.slice(from, stop);
    for (const k of keys) {
      const m = new RegExp(`(?:^|[\\s(,])${k}:\\s*`).exec(block);
      if (!m) continue;
      let at = m.index + m[0].length;
      const fn = /^context\.txf\(\s*/.exec(block.slice(at));
      if (fn) at += fn[0].length; // texto com parametros: o modelo `{nome}` e a chave
      const lit = readLiterals(block, at);
      if (lit && lit.dynamic) dinamicos.push(`${path.basename(file)}: ${lit.value.slice(0, 70)}`);
      else if (lit && lit.value.trim()) out.push({ texto: lit.value, onde: path.basename(file) });
    }
  };
  for (const m of t.matchAll(/ShowcaseExample\(/g)) {
    const stop = t.indexOf("preview:", m.index);
    grab(m.index + m[0].length, stop < 0 ? t.length : stop, ["title", "description"]);
  }
  // Descricao das props escritas na pagina (SgPropSpec(...)): bloco ate o parentese que fecha, ignorando strings.
  for (const m of t.matchAll(/SgPropSpec\(/g)) {
    let i = m.index + m[0].length;
    let depth = 1;
    const start = i;
    while (i < t.length && depth > 0) {
      const c = t[i];
      if (c === "'" || c === '"') {
        i++;
        while (i < t.length && t[i] !== c) i += t[i] === "\\" ? 2 : 1;
      } else if (c === "(") depth++;
      else if (c === ")") depth--;
      i++;
    }
    grab(start, i, ["description"]);
  }
  for (const m of t.matchAll(/SgShowcasePage\(/g)) {
    const stop = t.indexOf("examples:", m.index);
    grab(m.index + m[0].length, stop < 0 ? t.length : stop, ["description"]);
  }
  return out;
}

export function allTexts() {
  const map = new Map();
  // Descricoes de props do contrato do React (tabela de props de todas as paginas).
  const spec = JSON.parse(fs.readFileSync(path.join(root, "tools/gen_props/props-spec.json"), "utf8"));
  for (const c of Object.values(spec.components)) {
    for (const p of c.props) if (p.description && !map.has(p.description)) map.set(p.description, "props-spec.json");
  }
  for (const f of fs.readdirSync(pagesDir).filter((x) => x.endsWith("_page.dart")).sort()) {
    for (const { texto, onde } of pageTexts(path.join(pagesDir, f))) if (!map.has(texto)) map.set(texto, onde);
  }
  return map;
}

export function loadTranslations() {
  const all = {};
  if (!fs.existsSync(transDir)) return all;
  for (const f of fs.readdirSync(transDir).filter((x) => x.endsWith(".json")).sort()) {
    const j = JSON.parse(fs.readFileSync(path.join(transDir, f), "utf8"));
    for (const [pt, tr] of Object.entries(j)) {
      if (!Array.isArray(tr) || tr.length !== LOCALES.length || tr.some((x) => typeof x !== "string" || !x.trim())) {
        throw new Error(`${f}: traducao invalida para "${pt.slice(0, 50)}" (esperado ${LOCALES.length} textos)`);
      }
      all[pt] = tr;
    }
  }
  return all;
}

const dq = (s) => "'" + s.replace(/\\/g, "\\\\").replace(/'/g, "\\'").replace(/\$/g, "\\$").replace(/\n/g, "\\n") + "'";

if (process.argv[1] && path.resolve(process.argv[1]) === fileURLToPath(import.meta.url)) {
  const texts = allTexts();
  const trans = loadTranslations();
  const missing = [...texts].filter(([pt]) => !trans[pt]);
  const mode = process.argv[2];
  if (mode === "--faltam") {
    const n = Number(process.argv[3] ?? 80);
    console.log(JSON.stringify(missing.slice(0, n).map(([pt, onde]) => ({ pt, onde })), null, 0));
    console.error(`${missing.length} sem traducao de ${texts.size}`);
    if (dinamicos.length) console.error(`${dinamicos.length} dinamicos (interpolacao), fora do dicionario:`, [...new Set(dinamicos)]);
    process.exit(0);
  }
  const sorted = [...texts.keys()].sort((a, b) => a.localeCompare(b));
  let dart =
    "// dart format off\n// GERADO por tools/showcase_i18n/extract.mjs. NAO EDITE A MAO.\n" +
    "// Textos das paginas do showcase (titulo/descricao de exemplos e descricao da pagina) por idioma.\n" +
    "// A chave e o texto em pt-BR escrito na pagina; os valores seguem a ordem de `kShowcaseTextLocales`.\n\n" +
    `const List<String> kShowcaseTextLocales = <String>[${LOCALES.map(dq).join(", ")}];\n\n` +
    "const Map<String, List<String>> kShowcaseTexts = <String, List<String>>{\n";
  for (const pt of sorted) {
    const tr = trans[pt];
    if (!tr) continue;
    dart += `  ${dq(pt)}: <String>[${tr.map(dq).join(", ")}],\n`;
  }
  dart += "};\n";
  if (mode === "--check") {
    const cur = fs.existsSync(outFile) ? fs.readFileSync(outFile, "utf8") : "";
    if (missing.length) { console.error(`${missing.length} texto(s) sem traducao (rode --faltam)`); process.exit(1); }
    if (cur !== dart) { console.error("showcase_texts.g.dart desatualizado: rode node tools/showcase_i18n/extract.mjs"); process.exit(1); }
    console.log(`textos em dia (${texts.size})`);
  } else {
    fs.writeFileSync(outFile, dart);
    console.log(`${texts.size} textos, ${texts.size - missing.length} traduzidos, ${missing.length} faltam`);
  }
}
