// Gera vetores de paridade a partir do TypeScript compilado do @seedgrid/fe-components.
// Uso: node tools/parity_vectors/generate.mjs <pasta do pacote react> [saida.json]
// Empacota (esbuild) src/masks.ts e src/validators.ts do pacote React e executa as funcoes. Deterministico: mesma entrada, mesmo JSON.
import fs from "node:fs";
import os from "node:os";
import path from "node:path";
import { pathToFileURL } from "node:url";

const pkg = path.resolve(process.argv[2] ?? "");
const out = path.resolve(process.argv[3] ?? "packages/seedgrid_commons/test/parity/vectors.json");
const src = path.join(pkg, "src");
if (!fs.existsSync(path.join(src, "masks.ts"))) {
  console.error("src/masks.ts nao encontrado em " + pkg);
  process.exit(2);
}

// Acha o esbuild do proprio repositorio React (instalado como dependencia do tsup).
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

// Empacota masks.ts e validators.ts do FONTE (o dist do tsc nao roda em Node puro). React vira stub: so o i18n o importa.
const tmp = fs.mkdtempSync(path.join(os.tmpdir(), "sg-parity-"));
const reactStub = path.join(tmp, "react-stub.mjs");
fs.writeFileSync(reactStub, "const f = () => ({ Provider: null }); export default { createContext: f, useContext: () => null, useMemo: (g) => g(), createElement: () => null };");
const bundle = async (entry, name) => {
  const outfile = path.join(tmp, name);
  await esbuild.build({ entryPoints: [path.join(src, entry)], bundle: true, format: "esm", platform: "node", outfile, alias: { react: reactStub }, logLevel: "error" });
  return import(pathToFileURL(outfile).href);
};
const masks = await bundle("masks.ts", "masks.mjs");
const val = await bundle("validators.ts", "validators.mjs");
fs.rmSync(tmp, { recursive: true, force: true });
const pj = JSON.parse(fs.readFileSync(path.join(pkg, "package.json"), "utf8"));

// PRNG deterministico (mulberry32)
let seed = 20261023;
const rnd = () => {
  seed |= 0;
  seed = (seed + 0x6d2b79f5) | 0;
  let t = Math.imul(seed ^ (seed >>> 15), 1 | seed);
  t = (t + Math.imul(t ^ (t >>> 7), 61 | t)) ^ t;
  return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
};
const digitsOf = (n) => Array.from({ length: n }, () => Math.floor(rnd() * 10)).join("");
const ALNUM = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
const alnumOf = (n) => Array.from({ length: n }, () => ALNUM[Math.floor(rnd() * 36)]).join("");

// Calculo dos digitos so para fabricar entradas validas; a verdade e sempre a funcao do React.
const cpfDv = (d9) => {
  const c = (s, f) => {
    let t = 0;
    for (let i = 0; i < f - 1; i++) t += +s[i] * (f - i);
    const m = t % 11;
    return m < 2 ? 0 : 11 - m;
  };
  const a = c(d9, 10);
  const b = c(d9 + a, 11);
  return d9 + a + b;
};
const cnpjDv = (b12) => {
  const c = (base, w) => {
    let t = 0;
    for (let i = 0; i < w.length; i++) t += (base.charCodeAt(i) - 48) * w[i];
    const m = t % 11;
    return m < 2 ? 0 : 11 - m;
  };
  const d1 = c(b12, [5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2]);
  const d2 = c(b12 + d1, [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2]);
  return b12 + d1 + d2;
};

const digitsText = ["", "0", "123", "12345678901", "123.456.789-09", "abc", "12a34b56", "  98 765  ", "00000000000", "11111111111", "12345678901234567890", "(11) 98765-4321", "01310-100", "01.310-100"];

const cpfs = [];
for (let i = 0; i < 20; i++) {
  const v = cpfDv(digitsOf(9));
  cpfs.push(v);
  cpfs.push(v.replace(/(\d{3})(\d{3})(\d{3})(\d{2})/, "$1.$2.$3-$4"));
  cpfs.push(v.slice(0, 10) + String((+v[10] + 1) % 10));
}
cpfs.push("", "123", "00000000000", "11111111111", "99999999999", "123456789", "123456789012", "abc.def.ghi-jk", "52998224725", "529.982.247-25");

const cnpjs = [];
for (let i = 0; i < 15; i++) {
  const v = cnpjDv(digitsOf(12));
  cnpjs.push(v);
  cnpjs.push(v.replace(/(\d{2})(\d{3})(\d{3})(\d{4})(\d{2})/, "$1.$2.$3/$4-$5"));
  cnpjs.push(v.slice(0, 13) + String((+v[13] + 1) % 10));
}
for (let i = 0; i < 15; i++) {
  const v = cnpjDv(alnumOf(12));
  cnpjs.push(v);
  cnpjs.push(v.toLowerCase());
  cnpjs.push(v.slice(0, 13) + String((+v[13] + 1) % 10));
}
cnpjs.push("", "123", "00000000000000", "11111111111111", "12ABC34501DE35", "12.ABC.345/01DE-35", "ABCDEFGHIJKLMN", "12345678000195", "11222333000181", "AAAAAAAAAAAAAA", "00.000.000/0000-00", "12ABC34501DEXX");

const emails = ["a@b.co", "a@b", "@b.co", "a@.co", "  a@b.co  ", "x@y.z.w", "semarroba", "", "a b@c.de", "user@yopmail.com", "USER@YOPMAIL.COM", "user@sub.yopmail.com", "u@guerrillamail.com", "u@gmail.com", "a@b@c.de", "user@10minutemail.com", "@", "a@b.", "a@@b.c"];
const passwords = ["", "   ", "a", "Abcdef1!", "abcdefgh", "ABCDEFGH", "Abcdefg1", "Abcdefg!", "Abcdef!1", "Abc12345!", "Xyz!1234Aa", "Senha@2026", "Aaa1!bcd", "Zz9!Zz9!Zz9!", "qwerty123", "P@ssw0rd", "1234567890Aa!", "aB3$aB3$", "Aa1!Aa1!Aa1!", "Ab!1cdEf", "MinhaSenha#Forte9", "abc123!A", "Abcd1!zyx", "A1!a", "a1!A-b-c-d", "Aa!1-a-a-a"];
const passPolicies = [{}, { minSize: 4 }, { minSize: 12 }, { upper: false }, { lower: false }, { number: false }, { special: false }, { noRepeat: false }, { upper: false, lower: false, number: false, special: false, noRepeat: false, minSize: 1 }];
const dates = [["2020-01-01", "2019-12-31"], ["2020-01-01", "2020-01-01"], ["2020-01-01", "2020-01-02"], ["", "2020-01-01"], ["2020-01-01", undefined], ["2020-12-31T23:59:59", "2020-12-31"], ["2021-03-04", "2021-03-05"]];

// Mensagens que ecoam a chave: o vetor guarda QUAIS problemas ocorreram, nao o texto traduzido.
const KEYS = ["empty", "minSize", "upper", "lower", "number", "special", "sequence", "repeated", "invalid"];
const echo = {};
for (const k of KEYS) echo["components.validators.password." + k] = k === "invalid" ? "INVALID:{reasons}" : k + ":{min}";
const i18n = { locale: "en-US", messages: echo };
const parsePassword = (r) => {
  if (r === null) return { ok: true, problems: [], minSize: null };
  if (r.startsWith("INVALID:")) {
    const parts = r.slice(8).split("; ");
    const m = r.match(/minSize:(\d+)/);
    return { ok: false, problems: parts.map((p) => p.split(":")[0]), minSize: m ? Number(m[1]) : null };
  }
  return { ok: false, problems: [r.split(":")[0]], minSize: null };
};

const maskFns = ["maskCpf", "maskCnpj", "maskCpfCnpj", "maskCep", "maskPostalCodeBR", "maskPostalCodePT", "maskPostalCodeUS", "maskPostalCodeES", "maskPostalCodeUY", "maskPostalCodeAR", "maskPostalCodePY", "maskPhone", "onlyDigits"];
const maskInputs = [...digitsText, ...cpfs.slice(0, 12), ...cnpjs.slice(0, 12), "a1b2c3d4e5f6g7h8", "AB12cd34EF56gh", "1", "12", "123456", "1234567", "12345678", "123456789", "1234567890", "12345678901", "(", "(1", "(11", "(11)", "ü9é8", "12.ABC.345/01DE-35"];
const maskCases = {};
for (const f of maskFns) maskCases[f] = maskInputs.map((i) => ({ in: i, out: masks[f](i) }));
for (let i = 0; i < 25; i++) {
  const s = digitsOf(1 + Math.floor(rnd() * 16));
  for (const f of ["maskPhone", "maskCpfCnpj", "maskPostalCodeUS"]) maskCases[f].push({ in: s, out: masks[f](s) });
}

const extra = ["gmail.com", " Example.ORG "];
const doc = {
  fonte: "@seedgrid/fe-components src (esbuild)",
  versaoReact: pj.version,
  gerador: "tools/parity_vectors/generate.mjs",
  masks: maskCases,
  isValidCpf: cpfs.map((i) => ({ in: i, out: val.isValidCpf(i) })),
  isValidCnpj: cnpjs.map((i) => ({ in: i, out: val.isValidCnpj(i) })),
  isValidEmail: emails.map((i) => ({ in: i, out: val.isValidEmail(i) })),
  isBlockedEmailDomain: emails.map((i) => ({ in: i, out: val.isBlockedEmailDomain(i) })),
  isBlockedEmailDomainExtra: emails.map((i) => ({ in: i, extra, out: val.isBlockedEmailDomain(i, extra) })),
  blockedDomains: val.getBlockedEmailDomains(),
  validatePassword: passwords.flatMap((p) => passPolicies.map((pol) => ({ in: p, policy: pol, out: parsePassword(val.validatePassword(p, pol, i18n)) }))),
  isDateAfter: dates.map(([v, m]) => ({ value: v, min: m ?? null, out: val.isDateAfter(v, m) })),
  isDateBefore: dates.map(([v, m]) => ({ value: v, max: m ?? null, out: val.isDateBefore(v, m) })),
};
fs.mkdirSync(path.dirname(out), { recursive: true });
fs.writeFileSync(out, JSON.stringify(doc, null, 1) + "\n");
const simples = ["isValidCpf", "isValidCnpj", "isValidEmail", "isBlockedEmailDomain", "isBlockedEmailDomainExtra", "validatePassword", "isDateAfter", "isDateBefore"];
const n = Object.values(doc.masks).reduce((a, x) => a + x.length, 0) + simples.reduce((a, k) => a + doc[k].length, 0);
console.log(`vetores: ${n} casos -> ${out}`);
