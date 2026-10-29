// Gera o manifesto Flutter do MCP de componentes: tools/mcp_manifest/seedgrid-flutter-components.manifest.json
// (platform: "flutter"). Fontes, todas ja versionadas neste repositorio:
//   - packages/seedgrid_components/lib/src/generated/*.g.dart  nomes e tipos Dart das props (SgPropSpec)
//   - tools/gen_props/props-spec.json                          categoria e descricao do componente
//   - tools/gen_props/excecoes.json                            props que o Flutter nao tem (omitidas)
//   - docs/paridade.json                                       status e ressalvas de cada componente
//   - apps/seedgrid_showcase/lib/pages/*.snippets.g.dart       exemplos (identicos ao que o showcase renderiza)
//   - tools/mcp_manifest/motivos.json                          motivos reescritos em termos do Flutter
// O manifesto fala so de Flutter: o nome da prop no React e o tipo TypeScript NAO entram (ficam so aqui, como
// chave de busca nas fontes). A verificacao no fim falha se algum termo do React vazar.
// Uso: node tools/mcp_manifest/export.mjs [--check]   (--check falha se o manifesto estiver velho)
import fs from "node:fs";
import path from "node:path";

const root = path.resolve(".");
const check = process.argv.includes("--check");
const OUT = path.join(root, "tools", "mcp_manifest", "seedgrid-flutter-components.manifest.json");
const REPO_URL = "https://github.com/SeedGrid/seedgrid-fe-flutter.git";

const read = (...p) => fs.readFileSync(path.join(root, ...p), "utf8");
const json = (...p) => JSON.parse(read(...p));
const slug = (n) =>
  n
    .replace(/([a-z0-9])([A-Z])/g, "$1-$2")
    .replace(/([A-Z]+)([A-Z][a-z])/g, "$1-$2")
    .toLowerCase();
const unq = (s) => s.slice(1, -1).replace(/\\(['\\$])/g, "$1").replace(/\\n/g, "\n");

const generated = path.join(root, "packages", "seedgrid_components", "lib", "src", "generated");
const pagesDir = path.join(root, "apps", "seedgrid_showcase", "lib", "pages");

// --- fontes -----------------------------------------------------------------------------------------------
const spec = json("tools", "gen_props", "props-spec.json");
const excecoes = json("tools", "gen_props", "excecoes.json");
const paridade = json("docs", "paridade.json");
const motivos = json("tools", "mcp_manifest", "motivos.json");
const pubspec = read("packages", "seedgrid_components", "pubspec.yaml");
const packageVersion = /^version:\s*(\S+)/m.exec(pubspec)?.[1];
if (!packageVersion) throw new Error("pubspec.yaml do seedgrid_components sem `version:`");

// Nome do componente -> constante com a lista de SgPropSpec (registry.g.dart).
const registry = read("packages", "seedgrid_components", "lib", "src", "generated", "registry.g.dart");
const constPorComponente = new Map([...registry.matchAll(/^\s*'(\w+)':\s*(\w+),/gm)].map((m) => [m[1], m[2]]));

const dartFiles = fs.readdirSync(generated).filter((f) => f.endsWith(".g.dart") && f !== "registry.g.dart");
const dartTexts = dartFiles.map((f) => fs.readFileSync(path.join(generated, f), "utf8"));
function propsDart(constName) {
  for (const text of dartTexts) {
    const at = text.indexOf(`const List<SgPropSpec> ${constName} =`);
    if (at < 0) continue;
    const end = text.indexOf("\n];", at);
    const body = text.slice(at, end);
    return body.split(/\n  SgPropSpec\(\n/).slice(1).map((blk) => {
      const f = {};
      for (const m of blk.matchAll(/^    (\w+): ('(?:[^'\\]|\\.)*'|true|false|<String>\[[^\]]*\]),$/gm)) f[m[1]] = m[2];
      const prop = { name: unq(f.name), type: unq(f.type), required: f.required === "true" };
      if (f.defaultValue) prop.default = unq(f.defaultValue);
      if (f.description) prop.description = unq(f.description);
      if (f.values) prop.values = [...f.values.matchAll(/'((?:[^'\\]|\\.)*)'/g)].map((v) => v[1]);
      if (f.exact === "false") prop.typeExact = false;
      return prop;
    });
  }
  throw new Error(`lista de props ${constName} nao encontrada em generated/*.g.dart`);
}

// Pagina do showcase de cada componente -> exemplos (regioes), lidos do .snippets.g.dart gerado.
const pagesGen = read("apps", "seedgrid_showcase", "lib", "pages", "pages.g.dart");
const pagina = new Map([...pagesGen.matchAll(/\(name: '(\w+)', file: 'lib\/pages\/(\w+)_page\.dart'/g)].map((m) => [m[1], m[2]]));
function exemplos(base) {
  const f = path.join(pagesDir, `${base}_page.snippets.g.dart`);
  if (!fs.existsSync(f)) return [];
  const text = fs.readFileSync(f, "utf8");
  // Titulo de cada exemplo: o `title:` do ShowcaseExample que contem a regiao.
  const titulos = new Map();
  const page = fs.readFileSync(path.join(pagesDir, `${base}_page.dart`), "utf8");
  for (const bloco of page.split("ShowcaseExample(").slice(1)) {
    const t = /^\s*title:\s*'((?:[^'\\]|\\.)*)'/.exec(bloco);
    const r = /\/\/ #region (\S+)/.exec(bloco);
    if (t && r) titulos.set(r[1], t[1].replace(/\\(['\\$])/g, "$1"));
  }
  return [...text.matchAll(/\/\/\/ Region `([^`]+)`\.\n\s*static const String \w+ = r'''\n([\s\S]*?)\n?''';/g)].map((m) => ({
    id: m[1],
    title: titulos.get(m[1]) ?? m[1],
    file: `apps/seedgrid_showcase/lib/pages/${base}_page.dart`,
    kind: "dart",
    code: m[2],
  }));
}

const omitidasPor = new Map();
for (const o of excecoes.omitidas) {
  if (!omitidasPor.has(o.componente)) omitidasPor.set(o.componente, []);
  omitidasPor.get(o.componente).push(o);
}
const catalogo = new Map(
  [...read("apps", "seedgrid_showcase", "lib", "src", "catalog.g.dart").matchAll(/\(name: '(\w+)', category: '(\w+)'/g)].map((m) => [m[1], m[2]]),
);
const paridadePor = new Map(paridade.componentes.map((c) => [c.componente, c]));

const normaliza = (m) => m.replace(/\d+/g, "N");
const falhas = [];

// --- montagem ---------------------------------------------------------------------------------------------
const components = [];
for (const nome of [...constPorComponente.keys()].sort()) {
  const s = spec.components[nome];
  const par = paridadePor.get(nome);
  if (!s || !par) {
    falhas.push(`${nome}: sem entrada em props-spec.json ou paridade.json`);
    continue;
  }
  const reescreve = (t) => motivos.descricoes[t] ?? t;
  const props = propsDart(constPorComponente.get(nome)).map((p) => (p.description ? { ...p, description: reescreve(p.description) } : p));
  const omittedProps = (omitidasPor.get(nome) ?? []).map((o) => {
    const reason = motivos.omitidas[normaliza(o.motivo)];
    if (!reason) falhas.push(`${nome}.${o.prop}: motivo sem reescrita em motivos.json (omitidas): "${o.motivo}"`);
    return { name: o.prop, reason };
  });
  const parity = { status: par.status, reason: "" };
  if (par.motivo) {
    const reason = motivos.paridade[nome];
    if (!reason) falhas.push(`${nome}: ressalva de paridade sem reescrita em motivos.json (paridade)`);
    parity.reason = reason;
  }
  const base = pagina.get(nome);
  components.push({
    componentId: slug(nome),
    exportName: nome,
    sgMeta: {
      version: packageVersion,
      componentId: slug(nome),
      package: "seedgrid_components",
      exportName: nome,
      slug: slug(nome),
      displayName: nome,
      category: catalogo.get(nome) ?? s.category,
      subcategory: "",
      description: reescreve(s.description ?? ""),
      tags: [],
      props,
      examples: base ? exemplos(base) : [],
      parity,
      omittedProps,
    },
  });
}

const manifest = {
  schemaVersion: "1",
  platform: "flutter",
  package: "seedgrid_components",
  packageVersion,
  source: "git",
  sourceUrl: REPO_URL,
  sourcePath: "packages/seedgrid_components",
  import: "package:seedgrid_components/seedgrid_components.dart",
  generatedBy: "tools/mcp_manifest/export.mjs",
  gaps: ["fieldSemantics", "aiHints", "capabilities", "sdui", "semanticRole", "bindable"],
  components,
};

// --- MC.3: nenhum termo do React no manifesto -------------------------------------------------------------
// Fora da checagem: o `name` das props (a API Dart pode ter `contentClassName`) e das omitidas (o dev precisa saber
// que `className` nao existe no Flutter); tudo o mais (descricoes, motivos, exemplos, tipos) tem que estar limpo.
const proibidos = [/\bReact\b/i, /\bNext(\.js)?\b/, /\bVite\b/i, /\bJSX\b/i, /\bTSX\b/i, /classname/i, /\bADR\b/, /\bTypeScript\b/i, /\bnpm\b/i];
function varre(valor, caminho) {
  if (typeof valor === "string") {
    for (const re of proibidos) if (re.test(valor)) falhas.push(`${caminho}: termo do React (${re}) em "${valor.slice(0, 80)}"`);
  } else if (Array.isArray(valor)) {
    valor.forEach((v, i) => varre(v, `${caminho}[${i}]`));
  } else if (valor && typeof valor === "object") {
    for (const [k, v] of Object.entries(valor)) {
      if (k === "name" && /\.(props|omittedProps)\[\d+\]$/.test(caminho)) continue;
      // O codigo dos exemplos e dado de amostra (ex.: opcoes "React" e "TypeScript" numa lista de linguagens).
      if ((k === "code" || k === "file") && /\.examples\[\d+\]$/.test(caminho)) continue;
      varre(v, `${caminho}.${k}`);
    }
  }
}
varre(manifest, "manifest");

if (falhas.length) {
  console.error(`mcp_manifest: ${falhas.length} problema(s):\n  - ${falhas.slice(0, 40).join("\n  - ")}`);
  process.exit(1);
}

// --- verificacoes de aceite (MC.1) -------------------------------------------------------------------------
const total = components.length;
const parcial = components.filter((c) => c.sgMeta.parity.status === "parcial").length;
const portado = components.filter((c) => c.sgMeta.parity.status === "portado").length;
if (total !== paridade.resumo.total) throw new Error(`${total} componentes no manifesto, paridade.json diz ${paridade.resumo.total}`);
if (portado !== paridade.resumo.portado || parcial !== paridade.resumo.parcial) throw new Error("parity do manifesto nao bate com paridade.json");
const exemplosTotal = components.reduce((n, c) => n + c.sgMeta.examples.length, 0);

const text = JSON.stringify(manifest, null, 2) + "\n";
if (check) {
  const atual = fs.existsSync(OUT) ? fs.readFileSync(OUT, "utf8").replace(/\r\n/g, "\n") : "";
  if (atual !== text) {
    console.error("manifesto do MCP desatualizado: rode node tools/mcp_manifest/export.mjs");
    process.exit(1);
  }
  console.log(`manifesto em dia (${total} componentes, ${exemplosTotal} exemplos)`);
} else {
  fs.writeFileSync(OUT, text);
  console.log(`manifesto gravado: ${total} componentes, ${exemplosTotal} exemplos, ${(text.length / 1024).toFixed(0)} KB`);
}
