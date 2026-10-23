// Exporta o i18n do @seedgrid/fe-components (5 idiomas) para Dart e gera vetores de paridade.
// Uso: node tools/export_i18n/export.mjs <pasta do pacote react> [pasta do pacote seedgrid_components]
// Saidas (deterministicas):
//   <components>/lib/src/i18n/messages_<locale>.dart   mapas const, um por idioma
//   <components>/test/i18n/vectors.json                 mensagens reais do TS (validators + t + locale) para o teste Dart
import fs from "node:fs";
import os from "node:os";
import path from "node:path";
import { pathToFileURL } from "node:url";

const pkg = path.resolve(process.argv[2] ?? "");
const comp = path.resolve(process.argv[3] ?? "packages/seedgrid_components");
const src = path.join(pkg, "src");
if (!fs.existsSync(path.join(src, "i18n", "index.ts"))) {
  console.error("src/i18n/index.ts nao encontrado em " + pkg);
  process.exit(2);
}

// Mesmo esquema de tools/parity_vectors/generate.mjs: esbuild do proprio repo React, React vira stub.
function findEsbuild(start) {
  let dir = start;
  for (let i = 0; i < 8; i++) {
    const pnpm = path.join(dir, "node_modules", ".pnpm");
    if (fs.existsSync(pnpm)) {
      const hit = fs.readdirSync(pnpm).filter((n) => /^esbuild@/.test(n)).sort().pop();
      if (hit) return path.join(pnpm, hit, "node_modules", "esbuild", "lib", "main.js");
    }
    dir = path.dirname(dir);
  }
  throw new Error("esbuild nao encontrado a partir de " + start);
}
const esbuild = await import(pathToFileURL(findEsbuild(pkg)).href);
const tmp = fs.mkdtempSync(path.join(os.tmpdir(), "sg-i18n-"));
const reactStub = path.join(tmp, "react-stub.mjs");
fs.writeFileSync(reactStub, "const f = () => ({ Provider: null }); export default { createContext: f, useContext: () => null, useMemo: (g) => g(), createElement: () => null };");
const bundle = async (entry, name) => {
  const outfile = path.join(tmp, name);
  await esbuild.build({ entryPoints: [path.join(src, entry)], bundle: true, format: "esm", platform: "node", outfile, alias: { react: reactStub }, logLevel: "error" });
  return import(pathToFileURL(outfile).href);
};
const i18n = await bundle("i18n/index.ts", "i18n.mjs");
const val = await bundle("validators.ts", "validators.mjs");
fs.rmSync(tmp, { recursive: true, force: true });
const version = JSON.parse(fs.readFileSync(path.join(pkg, "package.json"), "utf8")).version;

const LOCALES = [
  ["pt-BR", "pt_br", "PtBr"],
  ["pt-PT", "pt_pt", "PtPt"],
  ["en-US", "en_us", "EnUs"],
  ["es", "es", "Es"],
  ["fr", "fr", "Fr"],
];
const dartStr = (s) => "'" + s.replace(/\\/g, "\\\\").replace(/'/g, "\\'").replace(/\$/g, "\\$").replace(/\n/g, "\\n").replace(/\r/g, "\\r") + "'";

const outDir = path.join(comp, "lib", "src", "i18n");
fs.mkdirSync(outDir, { recursive: true });
const counts = {};
for (const [loc, file, name] of LOCALES) {
  const msgs = i18n.getBuiltInComponentsMessages(loc);
  const keys = Object.keys(msgs); // ordem do fonte (deterministica)
  counts[loc] = keys.length;
  const body = keys.map((k) => `  ${dartStr(k)}: ${dartStr(msgs[k])},`).join("\n");
  fs.writeFileSync(
    path.join(outDir, `messages_${file}.dart`),
    `// GERADO por tools/export_i18n/export.mjs a partir de @seedgrid/fe-components ${version} (src/i18n/${loc}.ts).\n// Nao edite a mao: mude no React e gere de novo; a igualdade e conferida por test/i18n.\n\nconst Map<String, String> componentsMessages${name} = <String, String>{\n${body}\n};\n`
  );
}

// ---- vetores (mensagens reais do TS) ----
const passwords = ["", "   ", "a", "Abcdef1!", "abcdefgh", "ABCDEFGH", "Abcdefg1", "Abc12345!", "Aaa1!bcd", "qwerty123", "A1!a", "Aa1!Aa1!Aa1!", "Senha@2026"];
const policies = [{}, { minSize: 4 }, { minSize: 12 }, { upper: false, lower: false, number: false, special: false, noRepeat: false, minSize: 1 }];
const birth = [
  // sem dependencia de "hoje": data distante em 2999 / 1000 reprova qualquer idade
  { value: "2999-01-01", policy: {} },
  { value: "2999-01-01", policy: { minAge: 30, maxAge: 20 } },
  { value: "", policy: { minAge: 18 } },
  { value: "lixo", policy: { minAge: 18 } },
  { value: "2999-01-01", policy: { minAge: 18 } },
  { value: "1000-01-01", policy: { maxAge: 120 } },
  { value: "2999-01-01", policy: { minAge: 18, maxAge: 60 } },
  { value: "1000-01-01", policy: { minAge: 18, maxAge: 60 } },
];
const params = [
  ["components.password.minSize", { min: 3 }],
  ["components.password.minSize", { min: "7" }],
  ["components.password.minSize", {}],
  ["components.password.minSize", undefined],
  ["components.validators.birthdate.ageBetween", { min: 1, max: 2 }],
  ["chave.que.nao.existe", undefined],
  ["chave.que.nao.existe", { x: 1 }],
];
const vec = { versaoReact: version, contagem: counts, locales: {} };
const probe = ["pt-BR", "pt-PT", "en-US", "en", "es", "fr", "xx", "pt", undefined];
vec.normalize = probe.map((l) => ({ in: l ?? null, out: i18n.normalizeComponentsLocale(l) }));
vec.builtinFallback = ["xx", "pt", "en"].map((l) => ({ in: l, igualA: Object.entries({ "pt-BR": 0, "pt-PT": 0, "en-US": 0, es: 0, fr: 0 }).map(([k]) => k).find((k) => JSON.stringify(i18n.getBuiltInComponentsMessages(l)) === JSON.stringify(i18n.getBuiltInComponentsMessages(k))) ?? null }));
for (const [loc] of LOCALES) {
  const ctx = { locale: loc };
  vec.locales[loc] = {
    messages: i18n.getBuiltInComponentsMessages(loc),
    password: passwords.flatMap((p) => policies.map((pol) => ({ in: p, policy: pol, out: val.validatePassword(p, pol, ctx) }))),
    birthdate: birth.map((b) => ({ ...b, out: val.validateBirthDate(b.value, b.policy, ctx) })),
    t: params.map(([key, ps]) => ({ key, params: ps ?? null, out: i18n.t(i18n.resolveComponentsI18n(ctx), key, ps) })),
  };
}
const vdir = path.join(comp, "test", "i18n");
fs.mkdirSync(vdir, { recursive: true });
fs.writeFileSync(path.join(vdir, "vectors.json"), JSON.stringify(vec, null, 1) + "\n");
console.log(`i18n exportado (React ${version}): ${Object.entries(counts).map(([k, v]) => k + "=" + v).join(" ")} -> ${outDir}`);
