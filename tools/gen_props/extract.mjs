// Extrai a especificacao de props de cada componente Sg* do React com o compilador do TypeScript.
// Uso: node tools/gen_props/extract.mjs <pasta do pacote react> [saida.json]
// Fontes combinadas:
//   1. checker do TypeScript: nomes, opcionalidade, tipo e literais dos enums (so props declaradas em src/, sem as herdadas de HTML/React);
//   2. src/ai-meta/generated-props.json: conferencia de nomes (diferencas vao para o relatorio);
//   3. *.meta.ts: descricao, default e papel semantico quando existirem (o meta e parcial).
// Deterministico: mesma entrada, mesmo JSON (ordem alfabetica).
import fs from "node:fs";
import path from "node:path";
import os from "node:os";
import { createRequire } from "node:module";
import { pathToFileURL } from "node:url";

const pkg = path.resolve(process.argv[2] ?? "");
const outFile = path.resolve(process.argv[3] ?? "tools/gen_props/props-spec.json");
const src = path.join(pkg, "src");

function findInPnpm(start, prefix, rel) {
  let dir = start;
  for (let i = 0; i < 8; i++) {
    const pnpm = path.join(dir, "node_modules", ".pnpm");
    if (fs.existsSync(pnpm)) {
      const hit = fs.readdirSync(pnpm).filter((n) => n.startsWith(prefix)).sort().pop();
      if (hit) return path.join(pnpm, hit, "node_modules", ...rel);
    }
    dir = path.dirname(dir);
  }
  throw new Error(prefix + " nao encontrado a partir de " + start);
}
const ts = createRequire(import.meta.url)(findInPnpm(pkg, "typescript@", ["typescript", "lib", "typescript.js"]));

// ---------------------------------------------------------------- programa TS
const cfgPath = path.join(pkg, "tsconfig.json");
const cfg = ts.readConfigFile(cfgPath, ts.sys.readFile);
const parsed = ts.parseJsonConfigFileContent(cfg.config, ts.sys, pkg);
const program = ts.createProgram({ rootNames: [path.join(src, "index.ts")], options: { ...parsed.options, noEmit: true, declaration: false, declarationMap: false } });
const checker = program.getTypeChecker();
const indexSf = program.getSourceFile(path.join(src, "index.ts"));
const indexSym = checker.getSymbolAtLocation(indexSf);
const exportsOfIndex = checker.getExportsOfModule(indexSym);

const isOurs = (decl) => {
  const f = path.resolve(decl.getSourceFile().fileName);
  return f.startsWith(src + path.sep) && !f.endsWith(".d.ts");
};

const flags = ts.TypeFormatFlags.NoTruncation | ts.TypeFormatFlags.UseAliasDefinedOutsideCurrentScope;
function describeType(t, decl) {
  const text = checker.typeToString(t, decl, flags);
  const literals = [];
  let bool = false;
  const parts = t.isUnion() ? t.types : [t];
  let nullable = false;
  const rest = [];
  for (const p of parts) {
    if (p.flags & ts.TypeFlags.Undefined) continue;
    if (p.flags & ts.TypeFlags.Null) { nullable = true; continue; }
    if (p.isStringLiteral()) literals.push(p.value);
    else if (p.flags & ts.TypeFlags.BooleanLiteral) bool = true;
    else rest.push(checker.typeToString(p, decl, flags));
  }
  const onlyLiterals = literals.length > 0 && rest.length === 0 && !bool;
  const aliasName = t.aliasSymbol ? t.aliasSymbol.getName() : null;
  const callSigs = t.getNonNullableType().getCallSignatures();
  return { text, literals: onlyLiterals ? literals : [], enumLike: onlyLiterals, aliasName, isFunction: callSigs.length > 0, nullable, rest };
}

// ---------------------------------------------------------------- metas
const metaFiles = [];
(function walk(d) { for (const f of fs.readdirSync(d, { withFileTypes: true })) { const p = path.join(d, f.name); if (f.isDirectory()) { if (f.name !== "node_modules") walk(p); } else if (f.name.endsWith(".meta.ts")) metaFiles.push(p); } })(src);
const metas = new Map();
for (const f of metaFiles) {
  try { const m = await import(pathToFileURL(f).href); const o = m.sgMeta ?? m.default; if (o?.exportName) metas.set(o.exportName, o); } catch { /* arquivo sem sgMeta */ }
}
const gen = JSON.parse(fs.readFileSync(path.join(src, "ai-meta", "generated-props.json"), "utf8"));

// ---------------------------------------------------------------- defaults lidos do codigo
// Valor padrao = inicializador na desestruturacao de props: `function X({ a = 1 })` ou `const { a = 1 } = props`.
// So vale se TODAS as ocorrencias do nome no arquivo concordam; senao fica sem default (ambiguo).
function defaultsFromCode(sf, propNames) {
  const found = new Map(); // nome -> Set(texto)
  const visit = (node) => {
    if (ts.isObjectBindingPattern(node)) {
      const parent = node.parent;
      const fromProps =
        (ts.isParameter(parent) && parent === parent.parent.parameters?.[0]) ||
        (ts.isVariableDeclaration(parent) && parent.initializer && /^(props|rest|p)$/.test(parent.initializer.getText()));
      if (fromProps) {
        for (const el of node.elements) {
          if (el.dotDotDotToken || !el.initializer) continue;
          const name = (el.propertyName ?? el.name).getText();
          if (!propNames.has(name)) continue;
          if (!found.has(name)) found.set(name, new Set());
          found.get(name).add(el.initializer.getText());
        }
      }
    }
    ts.forEachChild(node, visit);
  };
  visit(sf);
  const out = {};
  for (const [n, set] of found) if (set.size === 1) out[n] = [...set][0].replace(/^["']|["']$/g, "");
  return out;
}

// ---------------------------------------------------------------- componentes
const valueExports = new Set();
for (const m of fs.readFileSync(path.join(src, "index.ts"), "utf8").matchAll(/export\s+\{([^}]*)\}\s+from\s+"([^"]+)"/g)) {
  for (let n of m[1].split(",")) { n = n.trim().split(/\s+as\s+/).pop(); if (/^Sg[A-Z]/.test(n)) valueExports.add(n); }
}

const components = {};
const report = { semProps: [], diffNomes: [], semGenerated: [] };
for (const name of [...valueExports].sort()) {
  const sym = exportsOfIndex.find((s) => s.getName() === name);
  if (!sym) continue;
  const real = sym.flags & ts.SymbolFlags.Alias ? checker.getAliasedSymbol(sym) : sym;
  const decl = real.valueDeclaration ?? real.declarations?.[0];
  const type = checker.getTypeOfSymbolAtLocation(real, decl);
  const sigs = type.getCallSignatures();
  const props = [];
  let kind = "component";
  if (sigs.length && sigs[0].parameters.length) {
    const pType = checker.getTypeOfSymbolAtLocation(sigs[0].parameters[0], decl);
    for (const p of checker.getPropertiesOfType(pType)) {
      const d = p.valueDeclaration ?? p.declarations?.[0];
      if (!d || !isOurs(d)) continue; // herdadas de HTML/React ficam de fora
      const pt = checker.getTypeOfSymbolAtLocation(p, d);
      const info = describeType(pt, d);
      const doc = ts.displayPartsToString(p.getDocumentationComment(checker)).trim();
      const meta = metas.get(name)?.props?.find((x) => x.name === p.getName());
      props.push({
        name: p.getName(),
        optional: !!(p.flags & ts.SymbolFlags.Optional),
        ts: info.text,
        alias: info.aliasName,
        enum: info.enumLike ? info.literals : undefined,
        fn: info.isFunction || undefined,
        doc: doc || undefined,
        description: meta?.description,
        default: meta?.default,
        semanticRole: meta?.semanticRole,
      });
    }
    props.sort((a, b) => a.name.localeCompare(b.name));
    const codeDefaults = decl ? defaultsFromCode(decl.getSourceFile(), new Set(props.map((x) => x.name))) : {};
    for (const pr of props) {
      if (pr.default === undefined && codeDefaults[pr.name] !== undefined) { pr.default = codeDefaults[pr.name]; pr.defaultFonte = "codigo"; }
    }
  } else {
    kind = "nao-componente";
  }
  const m = metas.get(name);
  components[name] = { kind, file: path.relative(src, decl ? decl.getSourceFile().fileName : "").replace(/\\/g, "/"), category: m?.category, description: m?.description, props };
  if (!props.length) report.semProps.push(name);
  const g = gen[name];
  if (!g) report.semGenerated.push(name);
  else {
    const a = new Set(props.map((p) => p.name));
    const b = new Set(g.map((p) => p.name));
    const soTs = [...a].filter((x) => !b.has(x));
    const soGen = [...b].filter((x) => !a.has(x));
    if (soTs.length || soGen.length) report.diffNomes.push({ componente: name, soNoCompilador: soTs, soNoGeneratedProps: soGen });
  }
}

const pj = JSON.parse(fs.readFileSync(path.join(pkg, "package.json"), "utf8"));
const doc = { fonte: "@seedgrid/fe-components src (compilador TypeScript + *.meta.ts)", versaoReact: pj.version, gerador: "tools/gen_props/extract.mjs", components };
fs.mkdirSync(path.dirname(outFile), { recursive: true });
fs.writeFileSync(outFile, JSON.stringify(doc, null, 1) + "\n");
fs.writeFileSync(outFile.replace(/\.json$/, ".relatorio.json"), JSON.stringify(report, null, 1) + "\n");
const nProps = Object.values(components).reduce((a, c) => a + c.props.length, 0);
const nDef = Object.values(components).reduce((a, c) => a + c.props.filter((p) => p.default !== undefined).length, 0);
const nDefCode = Object.values(components).reduce((a, c) => a + c.props.filter((p) => p.defaultFonte === "codigo").length, 0);
console.log(`props com default: ${nDef} (${nDefCode} lidos do codigo)`);
console.log(`componentes: ${Object.keys(components).length}, props: ${nProps}, sem props: ${report.semProps.length}, diffs de nome vs generated-props.json: ${report.diffNomes.length}`);
