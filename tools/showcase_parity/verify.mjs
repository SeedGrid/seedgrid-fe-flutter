// Verificador de paridade dos showcases React x Flutter (P148.F1.T1). React e a fonte da verdade.
// Por componente compara a lista de exemplos (contagem, ordem e titulos em pt-BR) e acusa
// `rules: <Classe>(` (objeto de regras) nas paginas do Flutter (regra 4 do P148: usar as props diretas, como no React).
//
// Uso (da raiz do seedgrid-fe-flutter):
//   node tools/showcase_parity/verify.mjs                 relatorio; sai 1 se houver divergencia fora da linha de base
//   node tools/showcase_parity/verify.mjs --strict        ignora a linha de base: reprova toda divergencia (estado real)
//   node tools/showcase_parity/verify.mjs --json          saida em JSON (por componente)
//   node tools/showcase_parity/verify.mjs --componente SgInputText   so um componente
//   node tools/showcase_parity/verify.mjs --atualizar-base           regrava baseline.json com o estado de hoje
//   node tools/showcase_parity/verify.mjs --react <caminho do seedgrid-fe-components>
//
// Linha de base (baseline.json): divergencias conhecidas de hoje. Ela so pode ENCOLHER: o modo normal reprova
// divergencia nova, componente que piorou e entrada da base que ja ficou limpa (para remover da base).
// Excecoes (excecoes.json): diferencas de linguagem/plataforma aceitas (regras 2 e 3 do P148), com o motivo.
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

const here = path.dirname(fileURLToPath(import.meta.url));
const flutterRoot = path.resolve(here, "..", "..");
const args = process.argv.slice(2);
const flag = (n) => args.includes(n);
const opt = (n) => { const i = args.indexOf(n); return i >= 0 ? args[i + 1] : undefined; };

const reactRoot = path.resolve(opt("--react") ?? path.join(flutterRoot, "..", "seedgrid-fe-components"));
const reactComponents = path.join(reactRoot, "apps", "showcase", "src", "app", "components");
const reactI18n = path.join(reactRoot, "apps", "showcase", "src", "i18n", "pt-BR.json");
const flutterPages = path.join(flutterRoot, "apps", "seedgrid_showcase", "lib", "pages");

const readJson = (p, fallback) => {
  if (!fs.existsSync(p)) return fallback;
  return JSON.parse(fs.readFileSync(p, "utf8").replace(/^﻿/, ""));
};
const baselinePath = path.join(here, "baseline.json");
const excecoes = readJson(path.join(here, "excecoes.json"), { componentes: {} });
const baseline = readJson(baselinePath, { componentes: {} });

const norm = (s) =>
  s.normalize("NFD").replace(/[̀-ͯ]/g, "").toLowerCase().replace(/[^a-z0-9]+/g, " ").trim();

function pascalFromDir(d) {
  return d.split("-").map((p) => p.charAt(0).toUpperCase() + p.slice(1)).join("");
}
function pascalFromSnake(d) {
  return d.split("_").map((p) => p.charAt(0).toUpperCase() + p.slice(1)).join("");
}
// SgInputCpf -> SgInputCPF etc: compara sem caixa.
const key = (s) => s.toLowerCase();

if (!fs.existsSync(reactComponents)) {
  console.error("Showcase React nao encontrado em " + reactComponents + " (use --react).");
  process.exit(2);
}

const ptBR = readJson(reactI18n, {});
const resolveLabel = (raw) => {
  // `1) ${t(i18n, "chave")}` | "1) Texto" | `1) Texto`
  let s = raw.trim();
  s = s.replace(/^[`"']/, "").replace(/[`"']$/, "");
  s = s.replace(/\$\{t\(i18n,\s*"([^"]+)"[^}]*\)\}/g, (_, k) => (ptBR[k] ?? `<<${k}>>`));
  s = s.replace(/^\d+\)\s*/, "");
  return s.trim();
};

// ---- React: titulos dos exemplos (links do cabecalho, sem o Playground)
const isPlayground = (t) => /playground/i.test(t);
const isProps = (t) => /refer[eê]ncia de props|props reference/i.test(t);

// Constantes de string do arquivo (`const K = "..."`), usadas em `${K}.x`.
function stringConsts(text) {
  const c = {};
  for (const m of text.matchAll(/const\s+(\w+)\s*=\s*"([^"]*)"\s*;/g)) c[m[1]] = m[2];
  return c;
}
// Lista de titulos "sectionTitles": array de chaves (SECTION_TITLE_KEYS), array de literais ou de t(i18n, ...).
function sectionTitleList(text, consts) {
  const k = /SECTION_TITLE_KEYS\s*(?::[^=]+)?=\s*\[([\s\S]*?)\]/.exec(text);
  if (k) return [...k[1].matchAll(/"([^"]+)"/g)].map((m) => ptBR[m[1]] ?? `<<${m[1]}>>`);
  const l = /[sS]ectionTitles\s*(?::|=|\()(?:[^\[]|\[\])*?\[\s*((?:t\(|")[\s\S]*?)\n\s*\]/.exec(text);
  if (l) {
    const items = [];
    for (const m of l[1].matchAll(/t\(i18n,\s*(?:"([^"]+)"|`([^`]+)`)[^)]*\)|"((?:[^"\\]|\\.)*)"/g)) {
      if (m[3] !== undefined) items.push(m[3]);
      else {
        const key = m[1] ?? m[2].replace(/\$\{(\w+)\}/g, (_x, n) => consts[n] ?? `<<${n}>>`);
        items.push(ptBR[key] ?? `<<${key}>>`);
      }
    }
    return items;
  }
  return null;
}
function resolveTitleExpr(expr, consts, list) {
  let e = expr.trim();
  e = e.replace(/^\{/, "").replace(/\}$/, "").trim().replace(/!$/, "").replace(/\s*\?\?\s*""$/, "");
  if (/laygroundTitle|sectionPlayground/.test(e)) return "Playground";
  if (/^(texts\.)?sectionTitles\[(\d+)\]/.test(e)) {
    const i = Number(/\[(\d+)\]/.exec(e)[1]);
    return list ? stripNum(String(list[i] ?? "")) : null;
  }
  const fc = /^sectionTitle\((\d+)\)$/.exec(e);
  if (fc) return list ? stripNum(String(list[Number(fc[1]) - 1] ?? "")) : null;
  // string literal ou template
  const lit = /^"((?:[^"\\]|\\.)*)"$/.exec(e) ?? /^'((?:[^'\\]|\\.)*)'$/.exec(e);
  if (lit) return stripNum(lit[1]);
  if (e.startsWith("`") && e.endsWith("`")) {
    let s = e.slice(1, -1);
    let bad = false;
    s = s.replace(/\$\{t\(i18n,\s*(?:"([^"]+)"|`([^`]+)`)[^}]*\)\}/g, (_, k1, k2) => {
      let k = k1 ?? k2.replace(/\$\{(\w+)\}/g, (_m, n) => consts[n] ?? `<<${n}>>`);
      if (ptBR[k] === undefined) bad = true;
      return ptBR[k] ?? `<<${k}>>`;
    });
    if (/\$\{/.test(s)) return null;
    return bad ? null : stripNum(s);
  }
  const tcall = /^t\(i18n,\s*(?:"([^"]+)"|`([^`]+)`)/.exec(e);
  if (tcall) {
    const k = tcall[1] ?? tcall[2].replace(/\$\{(\w+)\}/g, (_m, n) => consts[n] ?? `<<${n}>>`);
    return ptBR[k] === undefined ? null : stripNum(ptBR[k]);
  }
  return null;
}
const stripNum = (s) => s.replace(/^\s*\d+\)\s*/, "").trim();

function reactExamples(dir) {
  const f = path.join(reactComponents, dir, "page.tsx");
  if (!fs.existsSync(f)) return null;
  let text = fs.readFileSync(f, "utf8");
  // pagina que so delega a um componente cliente (ex.: SgClock): le os arquivos irmaos com `<Section`
  if (!/<Section\b/.test(text)) {
    const dirAbs = path.join(reactComponents, dir);
    for (const n of fs.readdirSync(dirAbs)) {
      if (!n.endsWith(".tsx") || n === "page.tsx") continue;
      const t2 = fs.readFileSync(path.join(dirAbs, n), "utf8");
      if (/<Section\b/.test(t2)) text += "\n" + t2;
    }
  }
  const consts = stringConsts(text);
  const list = sectionTitleList(text, consts);

  // 1) secoes renderizadas: <Section ... title=...> na ordem do arquivo
  const titles = [];
  let unresolved = 0;
  const secRe = /<Section\b([\s\S]*?)>\s*(?=[\r\n<{])/g;
  for (const m of text.matchAll(/<Section\b/g)) {
    // pega o bloco de atributos ate o '>' que fecha a tag de abertura (considerando {} aninhados)
    let i = m.index + "<Section".length, depth = 0, inStr = null;
    for (; i < text.length; i++) {
      const c = text[i];
      if (inStr) { if (c === "\\") i++; else if (c === inStr) inStr = null; continue; }
      if (c === '"' || c === "'" || c === "`") { inStr = c; continue; }
      if (c === "{") depth++;
      else if (c === "}") depth--;
      else if (c === ">" && depth === 0) break;
    }
    const attrs = text.slice(m.index + "<Section".length, i);
    if (/id="props-reference"/.test(attrs)) continue;
    if (attrs.trim() === "") continue; // `<Section>` citado em comentario
    const tm = /\btitle=(\{(?:[^{}]|\{[^{}]*\})*\}|"[^"]*")/.exec(attrs);
    if (!tm) { unresolved++; continue; }
    // secao gerada por `ARRAY.map((item) => <Section title={item.title}>)`: expande os titulos do array
    if (/^\{\s*\w+\.title\s*\}$/.test(tm[1])) {
      const mm = /(\w+)\.map\(\s*\(?\s*\w+\s*\)?\s*=>\s*\(?\s*$/.exec(text.slice(0, m.index));
      const decl = mm && new RegExp("const\\s+" + mm[1] + "\\b[^=]*=\\s*\\[([\\s\\S]*?)\\n\\];").exec(text);
      const arr = decl ? [...decl[1].matchAll(/title:\s*"([^"]*)"/g)].map((x) => x[1]) : [];
      if (arr.length) { titles.push(...arr); continue; }
    }
    const t = resolveTitleExpr(tm[1], consts, list);
    if (t === null) { unresolved++; continue; }
    if (isPlayground(t) || isProps(t)) continue;
    titles.push(t);
  }
  if (titles.length && unresolved === 0) return { unparsed: false, titles, via: "secoes" };

  // 2) links do cabecalho (`{ id: "exemplo-N", label: ... }`)
  const out = [];
  const re = /\{\s*id:\s*"exemplo-(\d+)"\s*,\s*label:\s*((?:`[^`]*`)|(?:"[^"]*"))\s*\}/g;
  let m;
  while ((m = re.exec(text))) out.push({ n: Number(m[1]), title: resolveLabel(m[2]) });
  if (out.length) {
    out.sort((a, b) => a.n - b.n);
    return { unparsed: false, titles: out.map((o) => o.title).filter((t) => !isPlayground(t)), via: "links" };
  }
  return { unparsed: true, titles: titles, via: "nenhuma" };
}

// ---- Flutter: titulos dos ShowcaseExample(title: '...') e usos de `rules: <Classe>(`
// ADR 63 (P155.F3.T2): exemplos do Flutter nao usam `setState` na CLASSE DA PAGINA (`...Page` / `..._PageState`).
// `setState` dentro de um widget pequeno do proprio exemplo (outra classe) e aceito. Retorna a contagem de usos nas classes de pagina.
function setStateNaPagina(text) {
  const src = text.replace(/\/\*[\s\S]*?\*\//g, "").replace(/^\s*\/\/.*$/gm, "");
  let total = 0;
  const re = /\bclass\s+(\w+)\b[^{]*\{/g;
  let m;
  while ((m = re.exec(src))) {
    if (!/Page(State)?$/.test(m[1])) continue;
    let depth = 1;
    let i = re.lastIndex;
    while (i < src.length && depth > 0) {
      const c = src[i++];
      if (c === "{") depth++;
      else if (c === "}") depth--;
    }
    total += (src.slice(re.lastIndex, i).match(/\bsetState\s*\(/g) ?? []).length;
    re.lastIndex = i;
  }
  return total;
}

function flutterExamples(file) {
  const text = fs.readFileSync(file, "utf8");
  const titles = [];
  const re = /ShowcaseExample\(\s*title:\s*('(?:[^'\\]|\\.)*'|"(?:[^"\\]|\\.)*")/g;
  let m;
  while ((m = re.exec(text))) {
    let t = m[1].slice(1, -1).replace(/\\(.)/g, "$1");
    titles.push(t.trim());
  }
  const rules = (text.match(/rules:\s*(?:const\s+)?[A-Z]\w*\(/g) ?? []).length;
  return { titles: titles.filter((t) => !/^playground$/i.test(t)), rules, setStatePagina: setStateNaPagina(text) };
}

// ---- pareamento por componente
// pastas com page.tsx, ate 2 niveis (ex.: gadgets/sg-calendar); o nome do componente e' o da ultima pasta
const reactDirsRel = [];
for (const d of fs.readdirSync(reactComponents, { withFileTypes: true })) {
  if (!d.isDirectory()) continue;
  if (fs.existsSync(path.join(reactComponents, d.name, "page.tsx"))) reactDirsRel.push(d.name);
  else {
    for (const d2 of fs.readdirSync(path.join(reactComponents, d.name), { withFileTypes: true })) {
      if (d2.isDirectory() && fs.existsSync(path.join(reactComponents, d.name, d2.name, "page.tsx"))) reactDirsRel.push(d.name + "/" + d2.name);
    }
  }
}
const reactDirs = reactDirsRel;
const flutterFiles = fs.readdirSync(flutterPages).filter((f) => f.endsWith("_page.dart"));
const flutterByKey = new Map(
  flutterFiles.map((f) => {
    const head = fs.readFileSync(path.join(flutterPages, f), "utf8").slice(0, 300);
    const named = /\/\/ showcase-name:\s*(\w+)/.exec(head);
    return [key(named ? named[1] : pascalFromSnake(f.replace(/_page\.dart$/, ""))), f];
  })
);

const only = opt("--componente");
const results = [];
for (const dir of reactDirs) {
  const comp = pascalFromDir(dir.split("/").pop());
  if (only && key(only) !== key(comp)) continue;
  const react = reactExamples(dir);
  if (!react) continue; // pasta sem page.tsx
  const ff = flutterByKey.get(key(comp));
  const exc = excecoes.componentes?.[comp] ?? {};
  const r = { componente: comp, reactCount: react.titles.length, problemas: [], rules: 0, flutterCount: null };
  if (react.unparsed) {
    r.problemas.push({ tipo: "react-nao-lido", detalhe: "page.tsx sem links exemplo-N reconhecidos" });
  }
  if (!ff) {
    if (!exc.semPaginaFlutter) r.problemas.push({ tipo: "sem-pagina-flutter", detalhe: `React tem ${react.titles.length} exemplos; o Flutter nao tem a pagina` });
    results.push(r);
    continue;
  }
  const fl = flutterExamples(path.join(flutterPages, ff));
  r.flutterCount = fl.titles.length;
  r.rules = fl.rules;
  if (fl.rules > 0) r.problemas.push({ tipo: "rules-sgrules", detalhe: `${fl.rules} uso(s) de \`rules: <Classe>(\` (regra 4: use as props diretas)` });

  if (fl.setStatePagina > 0) r.problemas.push({ tipo: "setstate-pagina", detalhe: `${fl.setStatePagina} uso(s) de setState na classe da pagina (ADR 63: use ValueNotifier/ListenableBuilder ou um widget pequeno do exemplo)` });

  // exemplos que so existem de um lado e diferencas de linguagem aceitas (excecoes)
  const ignRN = new Set((exc.ignorarReact ?? []).map(norm));
  const ignFL = new Set((exc.ignorarFlutter ?? []).map(norm));
  const rt = react.titles.filter((t) => !ignRN.has(norm(t)));
  const ft = fl.titles.filter((t) => !ignFL.has(norm(t)));
  if (!react.unparsed) {
    if (rt.length !== ft.length) {
      r.problemas.push({ tipo: "quantidade", detalhe: `React ${rt.length} x Flutter ${ft.length}` });
    }
    const fset = new Set(ft.map(norm));
    const rset = new Set(rt.map(norm));
    const faltamNoFlutter = rt.filter((t) => !fset.has(norm(t)));
    const soNoFlutter = ft.filter((t) => !rset.has(norm(t)));
    if (faltamNoFlutter.length) r.problemas.push({ tipo: "falta-no-flutter", detalhe: faltamNoFlutter.join(" | ") });
    if (soNoFlutter.length) r.problemas.push({ tipo: "so-no-flutter", detalhe: soNoFlutter.join(" | ") });
    // ordem: so quando os conjuntos coincidem
    if (!faltamNoFlutter.length && !soNoFlutter.length && rt.length === ft.length) {
      for (let i = 0; i < rt.length; i++) {
        if (norm(rt[i]) !== norm(ft[i])) {
          r.problemas.push({ tipo: "ordem", detalhe: `posicao ${i + 1}: React "${rt[i]}" x Flutter "${ft[i]}"` });
          break;
        }
      }
    }
  }
  results.push(r);
}
// paginas do Flutter sem par no React (so informativo, nao reprova)
const reactKeys = new Set(reactDirs.map((d) => key(pascalFromDir(d.split("/").pop()))));
const soFlutter = [...flutterByKey.keys()].filter((k) => !reactKeys.has(k));

// ---- decisao
const strict = flag("--strict");
const problemasPorComp = (r) => new Set(r.problemas.map((p) => p.tipo));
const ruim = results.filter((r) => r.problemas.length);

if (flag("--atualizar-base")) {
  const base = { _aviso: "Divergencias conhecidas de hoje; so pode encolher (P148.F1.T1). Gerado por verify.mjs --atualizar-base.", componentes: {} };
  for (const r of ruim) base.componentes[r.componente] = [...problemasPorComp(r)].sort();
  fs.writeFileSync(baselinePath, JSON.stringify(base, null, 1) + "\n", "utf8");
  console.log(`baseline.json regravado: ${ruim.length} componente(s) com divergencia.`);
  process.exit(0);
}

if (flag("--json")) {
  console.log(JSON.stringify({ total: results.length, divergentes: ruim.length, results, soFlutter }, null, 1));
} else {
  const linhas = [];
  for (const r of ruim) {
    linhas.push(`${r.componente} (React ${r.reactCount} x Flutter ${r.flutterCount ?? "sem pagina"})`);
    for (const p of r.problemas) linhas.push(`   - ${p.tipo}: ${p.detalhe}`);
  }
  console.log(linhas.join("\n"));
  const menos = results.filter((r) => r.flutterCount !== null && r.flutterCount < r.reactCount).length;
  const mais = results.filter((r) => r.flutterCount !== null && r.flutterCount > r.reactCount).length;
  const comRules = results.filter((r) => r.rules > 0).length;
  console.log(`\n${results.length} componentes comparados; ${ruim.length} com divergencia; ` +
    `Flutter com menos exemplos: ${menos}; com mais: ${mais}; paginas com rules: <Classe>(: ${comRules}.`);
  if (soFlutter.length) console.log(`Paginas so no Flutter (informativo): ${soFlutter.join(", ")}`);
}

// Modo normal: compara com a linha de base (so pode encolher).
let falhou = false;
// ADR 63: paginas so-Flutter (fora da comparacao por componente) tambem nao usam setState na classe da pagina.
const jaAcusadas = new Set(results.filter((r) => r.problemas.some((p) => p.tipo === "setstate-pagina")).map((r) => key(r.componente)));
const soltos = fs.readdirSync(flutterPages)
  .filter((f) => /_page\.dart$/.test(f))
  .map((f) => [f, setStateNaPagina(fs.readFileSync(path.join(flutterPages, f), "utf8"))])
  .filter(([f, n]) => n > 0 && !jaAcusadas.has(key(pascalFromSnake(f.replace(/_page\.dart$/, "")))));
if (soltos.length) {
  console.log("\nsetState na classe da pagina (ADR 63) em paginas fora da comparacao:");
  for (const [f, n] of soltos) console.log(`   - ${f}: ${n} uso(s)`);
}
if (strict) {
  falhou = ruim.length > 0 || soltos.length > 0;
} else {
  const erros = [];
  const baseComp = baseline.componentes ?? {};
  for (const r of ruim) {
    const permitido = new Set(baseComp[r.componente] ?? []);
    const novos = [...problemasPorComp(r)].filter((t) => !permitido.has(t));
    if (novos.length) erros.push(`${r.componente}: divergencia nova fora da linha de base (${novos.join(", ")})`);
  }
  const ruimNomes = new Set(ruim.map((r) => r.componente));
  for (const nome of Object.keys(baseComp)) {
    if (only && key(only) !== key(nome)) continue;
    if (!ruimNomes.has(nome)) erros.push(`${nome}: ficou em dia; remova da linha de base (node tools/showcase_parity/verify.mjs --atualizar-base)`);
  }
  if (erros.length) {
    console.error("\nPARIDADE REPROVADA (modo linha de base):\n - " + erros.join("\n - "));
    falhou = true;
  } else if (!flag("--json")) {
    console.log("\nSem divergencia alem da linha de base (use --strict para ver tudo como reprovacao).");
  }
}
process.exit(falhou ? 1 : 0);
