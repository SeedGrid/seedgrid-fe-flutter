// Vetores de paridade do SgFileUpload (P141): a verdade e o CODIGO DO REACT (fileUploadLogic.ts), transpilado com
// esbuild e executado de verdade. Cobre tipo pelo conteudo, mediaType, tamanho com unidade, quantidade/tamanho (planAdd) e formatFileSize.
// Uso (na raiz do repo seedgrid-fe-flutter):
//   node packages/seedgrid_components/test/widgets/file_upload_vectors/generate.mjs <pasta do pacote react>
import fs from "node:fs";
import os from "node:os";
import path from "node:path";
import { pathToFileURL } from "node:url";

const root = process.cwd();
const pkg = path.resolve(process.argv[2] ?? "../seedgrid-fe-components/packages/seedgrid-fe-components");
const out = path.join(root, "packages/seedgrid_components/test/widgets/file_upload_vectors/vectors.json");
const src = path.join(pkg, "src", "inputs", "fileUploadLogic.ts");
if (!fs.existsSync(src)) {
  console.error("fileUploadLogic.ts nao encontrado em " + src);
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
const tmp = fs.mkdtempSync(path.join(os.tmpdir(), "sg-fileup-"));
const r = await esbuild.transform(fs.readFileSync(src, "utf8"), { loader: "ts", format: "esm", target: "es2022" });
fs.writeFileSync(path.join(tmp, "logic.mjs"), r.code);
const L = await import(pathToFileURL(path.join(tmp, "logic.mjs")).href);


const hex = (s) => Uint8Array.from((s.match(/../g) ?? []).map((h) => parseInt(h, 16)));
const txt = (s) => Array.from(new TextEncoder().encode(s)).map((b) => b.toString(16).padStart(2, "0")).join("");
const HEADS = {
  none: "",
  png: "89504e470d0a1a0a",
  jpeg: "ffd8ffe000104a46",
  gif: "474946383961",
  webp: "524946460000000057454250",
  wav: "524946460000000057415645",
  bmp: "424d36000000",
  tiff: "49492a00",
  ico: "00000100",
  pdf: "255044462d312e34",
  zip: "504b030414000600",
  ole: "d0cf11e0a1b11ae1",
  webm: "1a45dfa3",
  ogg: "4f676753",
  flac: "664c6143",
  mp3id3: "494433",
  mp4: "000000186674797069736f6d",
  heic: "000000186674797068656963",
  avif: "000000186674797061766966",
  m4a: "0000001866747970 4d344120".replace(" ", ""),
  mov: "0000001466747970717420 20".replace(" ", ""),
  svg: txt('<svg xmlns="http://www.w3.org/2000/svg"></svg>'),
  text: txt("ola mundo")
};
const NAMES = ["foto.png", "FOTO.JPG", "foto.jfif", "sem-extensao", "doc.pdf", "plan.xlsx", "plan.xls", "texto.docx", "texto.doc", "apres.pptx", "dados.csv", "nota.txt", "pacote.zip", "musica.mp3", "clip.mp4", "icone.svg", "estranho.xyz"];
const DECLARED = ["", "image/png", "application/pdf"];
const resolve = [];
for (const name of NAMES)
  for (const [headName, h] of Object.entries(HEADS))
    for (const declared of DECLARED) resolve.push({ name, declared, head: h, out: L.resolveMime(name, declared, hex(h)) });
const sniff = Object.entries(HEADS).map(([k, h]) => ({ head: h, out: L.sniffMime(hex(h)) }));

const MEDIA = [undefined, [], ["image"], ["pdf"], ["xlsx", "xls"], ["image", "pdf"], ["video", "audio"], ["docx", "doc"], ["all"], ["csv", "txt"], ["zip"]];
const ACCEPTS = [undefined, "", ".png", ".png, .JPG", "image/*", "application/pdf"];
const matches = [];
for (const name of NAMES)
  for (const mime of ["image/png", "image/jpeg", "application/pdf", "text/plain", "audio/mpeg", "video/mp4", "application/zip", ""])
    for (const m of MEDIA)
      for (const a of ACCEPTS) matches.push({ name, mime, mediaType: m ?? null, accept: a ?? null, out: L.matchesMedia(name, mime, m, a) });

const SIZES = [undefined, null, 0, 1024, 1536.9, -1, Number.NaN, "", "abc", "1", "1KB", "1kb", "1 KB", " 2 mb ", "1.5KB", "1.5MB", "1GB", "1tb", "10B", "1XB", "KB", "-1KB", "1.KB", "1,5KB"];
const size = SIZES.map((v) => ({ value: Number.isNaN(v) ? "NaN" : v === undefined ? "undefined" : v, out: L.parseSize(v) ?? null }));

const f = (name, type, size, h = "none") => ({ name, type, size, head: HEADS[h] });
const PICKS = {
  um: [f("a.png", "image/png", 100, "png")],
  dois: [f("a.png", "image/png", 100, "png"), f("b.jpg", "image/jpeg", 200, "jpeg")],
  tres: [f("a.png", "image/png", 100, "png"), f("b.jpg", "image/jpeg", 200, "jpeg"), f("c.gif", "image/gif", 300, "gif")],
  misto: [f("a.png", "image/png", 100, "png"), f("manual.pdf", "application/pdf", 5000, "pdf"), f("c.png", "image/png", 300, "png")],
  disfarcado: [f("foto.png", "image/png", 100, "pdf"), f("estranho.xyz", "", 100, "png")],
  grande: [f("a.png", "image/png", 5000, "png"), f("b.png", "image/png", 50, "png")]
};
const SCENARIOS = [
  { current: [], rules: {} },
  { current: [], rules: { maxFiles: 1 } },
  { current: [900], rules: { maxFiles: 1 } },
  { current: [], rules: { maxFiles: 2 } },
  { current: [10], rules: { maxFiles: 2 } },
  { current: [10, 20], rules: { maxFiles: 2 } },
  { current: [], rules: { maxFiles: 5 } },
  { current: [], rules: { maxFiles: 5, mediaType: ["image"] } },
  { current: [], rules: { maxFiles: 5, mediaType: ["pdf"] } },
  { current: [], rules: { maxFiles: 5, maxSizePerFile: 250 } },
  { current: [], rules: { maxFiles: 5, maxSizePerFile: "1KB" } },
  { current: [], rules: { maxFiles: 5, maxSizeTotal: 350 } },
  { current: [100], rules: { maxFiles: 5, maxSizeTotal: "0.4KB" } },
  { current: [], rules: { maxFiles: 5, mediaType: ["image"], accept: ".pdf", maxSizeTotal: 5200 } },
  { current: [], rules: { maxFiles: 0 } },
  { current: [], rules: { maxFiles: 3.7, mediaType: ["all"] } }
];
const add = [];
for (const s of SCENARIOS)
  for (const [k, picked] of Object.entries(PICKS)) {
    const r = L.planAdd(s.current, picked.map((p) => ({ ...p, head: hex(p.head) })), s.rules);
    add.push({ current: s.current, picked, rules: s.rules, out: r });
  }

const fsize = [];
for (const n of [0, 1, 1023, 1024, 1536, 1048576, 2621440, 1073741824, 5368709120, 1099511627776, 3298534883328, -5])
  for (const loc of ["en-US", "pt-BR", "es"]) fsize.push({ bytes: n, locale: loc, out: L.formatFileSize(n, loc) });

fs.writeFileSync(out, JSON.stringify({ sniff, resolve, matches, size, add, fsize }, null, 2) + "\n");
fs.rmSync(tmp, { recursive: true, force: true });
console.log("ok " + out);
