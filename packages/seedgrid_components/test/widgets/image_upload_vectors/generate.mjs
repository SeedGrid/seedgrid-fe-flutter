// Vetores de paridade do SgImageUpload (P133): a verdade e o CODIGO DO REACT (imageUploadLogic.ts), transpilado com
// esbuild e executado de verdade. Cobre accept, validacao (tipo, tamanho, dimensao, proporcao), formatBytes e formatAspect.
// Uso (na raiz do repo seedgrid-fe-flutter):
//   node packages/seedgrid_components/test/widgets/image_upload_vectors/generate.mjs <pasta do pacote react>
import fs from "node:fs";
import os from "node:os";
import path from "node:path";
import { pathToFileURL } from "node:url";

const root = process.cwd();
const pkg = path.resolve(process.argv[2] ?? "../seedgrid-fe-components/packages/seedgrid-fe-components");
const out = path.join(root, "packages/seedgrid_components/test/widgets/image_upload_vectors/vectors.json");
const src = path.join(pkg, "src", "inputs", "imageUploadLogic.ts");
if (!fs.existsSync(src)) {
  console.error("imageUploadLogic.ts nao encontrado em " + src);
  process.exit(2);
}
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
const tmp = fs.mkdtempSync(path.join(os.tmpdir(), "sg-imgup-"));
const r = await esbuild.transform(fs.readFileSync(src, "utf8"), { loader: "ts", format: "esm", target: "es2022" });
fs.writeFileSync(path.join(tmp, "logic.mjs"), r.code);
const L = await import(pathToFileURL(path.join(tmp, "logic.mjs")).href);

const FILES = [
  { name: "foto.png", type: "image/png" },
  { name: "FOTO.JPG", type: "image/jpeg" },
  { name: "icone.svg", type: "image/svg+xml" },
  { name: "doc.pdf", type: "application/pdf" },
  { name: "sem-tipo.png", type: "" },
  { name: "sem-ext", type: "image/webp" }
];
const ACCEPTS = [undefined, "", "image/*", "image/png", "image/png,image/jpeg", ".png", ".png, .JPG", "application/pdf", "image/*,.pdf"];
const accept = [];
for (const f of FILES) for (const a of ACCEPTS) accept.push({ name: f.name, type: f.type, accept: a ?? null, out: L.matchesAccept(f.name, f.type, a) });

const RULES = [
  {},
  { accept: "image/png" },
  { maxSizeBytes: 1000 },
  { minWidth: 200, minHeight: 100 },
  { aspect: 1 },
  { aspect: 16 / 9, aspectTolerance: 0.1 },
  { accept: "image/png", maxSizeBytes: 5000, minWidth: 100, minHeight: 100, aspect: 1 }
];
const FACTS = [
  { name: "a.png", type: "image/png", size: 500, width: 300, height: 300 },
  { name: "a.png", type: "image/png", size: 5000, width: 300, height: 300 },
  { name: "a.png", type: "image/png", size: 500, width: 150, height: 150 },
  { name: "a.png", type: "image/png", size: 500, width: 400, height: 300 },
  { name: "a.png", type: "image/png", size: 500, width: 1920, height: 1080 },
  { name: "a.png", type: "image/png", size: 500, width: 1000, height: 990 },
  { name: "a.jpg", type: "image/jpeg", size: 500, width: 300, height: 300 },
  { name: "a.png", type: "image/png", size: 500 },
  { name: "a.pdf", type: "application/pdf", size: 9999, width: 10, height: 10 }
];
const validate = [];
for (const rules of RULES) for (const file of FACTS) validate.push({ file, rules, out: L.validateImage(file, rules) });

const bytes = [];
for (const n of [0, 1, 1023, 1024, 1536, 1048576, 2621440, 1073741824, 5368709120, -5])
  for (const loc of ["en-US", "pt-BR", "es"]) bytes.push({ bytes: n, locale: loc, out: L.formatBytes(n, loc) });

const aspect = [1, 4 / 3, 3 / 2, 16 / 9, 3 / 4, 2 / 3, 9 / 16, 1.5, 1.7777, 2.5].map((a) => ({ aspect: a, out: L.formatAspect(a) }));

fs.writeFileSync(out, JSON.stringify({ accept, validate, bytes, aspect }, null, 2) + "\n");
fs.rmSync(tmp, { recursive: true, force: true });
console.log("ok " + out);
