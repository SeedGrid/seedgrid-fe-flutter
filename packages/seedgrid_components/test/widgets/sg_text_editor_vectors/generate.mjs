// Fixtures de ida e volta do SgTextEditor: roda o TipTap REAL (as mesmas extensoes do SgTextEditor.tsx,
// empacotadas com esbuild) num jsdom e grava, para cada entrada, o HTML canonico que o React emite
// (`editor.getHTML()`). O Dart confere: le o HTML do React, escreve HTML e compara com o canonico.
// Tambem grava cenarios de comando (o que a barra de ferramentas do React produz) e o que o React faz
// com HTML de documento completo (onLoad/onSave).
// Verificacao: com --verify=<dump.json> (gerado pelo teste Dart com SG_TE_DUMP=<arquivo>) o TipTap real relê o HTML
// que o Dart emitiu e compara com o canonico de vectors.json.
// Uso: node packages/seedgrid_components/test/widgets/sg_text_editor_vectors/generate.mjs <pacote react> [saida.json]
// Deterministico. Nao altera o repositorio React.
import fs from "node:fs";
import os from "node:os";
import path from "node:path";
import { pathToFileURL } from "node:url";

const verifyArg = process.argv.find((a) => a.startsWith("--verify="));
const argv = process.argv.filter((a) => !a.startsWith("--verify="));
const pkg = path.resolve(argv[2] ?? "");
const here = path.dirname(new URL(import.meta.url).pathname.replace(/^\//, ""));
const out = path.resolve(argv[3] ?? path.join(here, "vectors.json"));
const casesFile = path.join(here, "cases.mjs");

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
  throw new Error("esbuild nao encontrado");
}
const esbuild = await import(pathToFileURL(findEsbuild(pkg)).href);

// ---------------------------------------------------------------- driver (roda dentro do bundle)
// A lista de extensoes e a configuracao replicam SgTextEditor.tsx (linhas 155-171) sem alteracao.
const driver = `
import { JSDOM } from "jsdom";

const dom = new JSDOM("<!doctype html><html><body></body></html>", { url: "http://localhost/", pretendToBeVisual: true });
const w = dom.window;
const pick = (k) => (k === "window" ? w : k === "getComputedStyle" ? w.getComputedStyle.bind(w) : w[k]);
for (const k of ["window","document","navigator","HTMLElement","Node","Element","Event","MouseEvent","KeyboardEvent","MutationObserver","DOMParser","getComputedStyle","Range","Selection","DocumentFragment","Text","NodeFilter","DOMException"]) {
  Object.defineProperty(globalThis, k, { configurable: true, writable: true, value: pick(k) });
}
globalThis.requestAnimationFrame = (cb) => setTimeout(() => cb(Date.now()), 0);
globalThis.cancelAnimationFrame = (id) => clearTimeout(id);
// jsdom nao implementa layout: o ProseMirror precisa destes metodos so para rolar a selecao.
w.Range.prototype.getClientRects = () => [];
w.Range.prototype.getBoundingClientRect = () => ({ x: 0, y: 0, width: 0, height: 0, top: 0, left: 0, right: 0, bottom: 0 });
w.document.elementFromPoint = () => null;

import { Editor } from "@tiptap/core";
import StarterKit from "@tiptap/starter-kit";
import Underline from "@tiptap/extension-underline";
import Link from "@tiptap/extension-link";
import Image from "@tiptap/extension-image";
import TextAlign from "@tiptap/extension-text-align";
import TextStyle from "@tiptap/extension-text-style";
import Color from "@tiptap/extension-color";
import Highlight from "@tiptap/extension-highlight";
import Subscript from "@tiptap/extension-subscript";
import Superscript from "@tiptap/extension-superscript";
import FontFamily from "@tiptap/extension-font-family";

const TextStyleWithSize = TextStyle.extend({
  addAttributes() {
    return {
      fontSize: {
        default: null,
        parseHTML: (element) => element.style.fontSize?.replace(/["']/g, "") ?? null,
        renderHTML: (attrs) => {
          if (!attrs.fontSize) return {};
          return { style: "font-size:" + attrs.fontSize };
        }
      }
    };
  }
});

function make(content) {
  const el = w.document.createElement("div");
  w.document.body.appendChild(el);
  return new Editor({
    element: el,
    editable: true,
    extensions: [
      StarterKit.configure({ codeBlock: {} }),
      Underline,
      Link.configure({ openOnClick: false, autolink: true, linkOnPaste: true }),
      Image.configure({ inline: false }),
      TextStyleWithSize,
      FontFamily,
      Color,
      Highlight.configure({ multicolor: true }),
      Subscript,
      Superscript,
      TextAlign.configure({ types: ["heading", "paragraph"] })
    ],
    content
  });
}

// Equivalente a parseHtmlDocument/loadFromHtmlString do SgTextEditor.tsx.
function parseHtmlDocument(html) {
  const doc = new w.DOMParser().parseFromString(html, "text/html");
  const cssText = Array.from(doc.querySelectorAll("head style")).map((s) => s.textContent ?? "").join("\\n").trim();
  const bodyHtml = (doc.body?.innerHTML ?? "").trim();
  return { cssText, bodyHtml };
}

function apply(ed, chain, cmd) {
  const [name, arg] = cmd;
  switch (name) {
    case "selectAll": ed.commands.selectAll(); break;
    case "focusEnd": ed.commands.focus("end"); break;
    case "setSel": ed.commands.setTextSelection({ from: arg[0], to: arg[1] }); break;
    case "insertText": ed.commands.insertContent(arg); break;
    case "heading": { if (arg === "p") ed.commands.setParagraph(); else ed.commands.toggleHeading({ level: arg }); break; }
    case "fontFamily": ed.chain().focus().setFontFamily(arg).run(); break;
    case "fontSize": ed.chain().focus().setMark("textStyle", { fontSize: arg }).run(); break;
    case "bold": ed.chain().focus().toggleBold().run(); break;
    case "italic": ed.chain().focus().toggleItalic().run(); break;
    case "underline": ed.chain().focus().toggleUnderline().run(); break;
    case "strike": ed.chain().focus().toggleStrike().run(); break;
    case "color": ed.chain().focus().setColor(arg).run(); break;
    case "highlight": ed.chain().focus().toggleHighlight({ color: arg }).run(); break;
    case "subscript": ed.chain().focus().toggleSubscript().run(); break;
    case "superscript": ed.chain().focus().toggleSuperscript().run(); break;
    case "bullets": ed.chain().focus().toggleBulletList().run(); break;
    case "numbered": ed.chain().focus().toggleOrderedList().run(); break;
    case "outdent": ed.chain().focus().liftListItem("listItem").run(); break;
    case "indent": ed.chain().focus().sinkListItem("listItem").run(); break;
    case "align": ed.chain().focus().setTextAlign(arg).run(); break;
    case "link": ed.chain().focus().setLink({ href: arg }).run(); break;
    case "unlink": ed.chain().focus().unsetLink().run(); break;
    case "image": ed.chain().focus().setImage({ src: arg }).run(); break;
    case "clear": ed.chain().focus().unsetAllMarks().clearNodes().run(); break;
    default: throw new Error("comando desconhecido " + name);
  }
}

export function main(cases) {
  const results = [];
  for (const c of cases) {
    const r = { ...c };
    try {
      if (c.kind === "html") {
        const ed = make(c.html);
        r.canonical = ed.getHTML();
        const ed2 = make(r.canonical);
        r.idempotent = ed2.getHTML() === r.canonical;
        ed.destroy(); ed2.destroy();
      } else if (c.kind === "commands") {
        const ed = make(c.html ?? "");
        for (const cmd of c.commands) apply(ed, null, cmd);
        r.canonical = ed.getHTML();
        ed.destroy();
      } else if (c.kind === "document") {
        const p = parseHtmlDocument(c.html);
        r.cssText = p.cssText;
        r.bodyHtml = p.bodyHtml;
        const ed = make(p.bodyHtml || "");
        r.canonical = ed.getHTML();
        ed.destroy();
      }
    } catch (e) {
      r.error = String(e && e.stack || e);
    }
    results.push(r);
  }
  return results;
}
`;

const tmp = fs.mkdtempSync(path.join(os.tmpdir(), "sg-te-"));
const bundleFile = path.join(tmp, "driver.cjs");
await esbuild.build({
  stdin: { contents: driver, resolveDir: pkg, loader: "js", sourcefile: "driver.js" },
  bundle: true, platform: "node", format: "cjs", outfile: bundleFile, external: ["jsdom"], logLevel: "error",
  nodePaths: [path.join(pkg, "node_modules")],
});

let { cases } = await import(pathToFileURL(casesFile).href);
const verifyFile = verifyArg ? verifyArg.slice("--verify=".length) : null;
let dartOut = null;
if (verifyFile) {
  dartOut = JSON.parse(fs.readFileSync(verifyFile, "utf8"));
  cases = Object.entries(dartOut).map(([id, html]) => ({ kind: "html", id, html }));
}

const require = (await import("node:module")).createRequire(import.meta.url);
process.env.NODE_PATH = path.join(pkg, "node_modules");
require("node:module").Module._initPaths();
const { main } = require(bundleFile);
const results = main(cases);

if (verifyFile) {
  const ref = Object.fromEntries(JSON.parse(fs.readFileSync(out, "utf8")).cases.map((c) => [c.id, c.canonical]));
  let ok = 0; const bad = [];
  for (const r of results) { if (r.canonical === ref[r.id]) ok++; else bad.push(r.id); }
  console.log(`verificacao: ${ok}/${results.length} saidas do Dart relidas pelo TipTap igual ao canonico`);
  if (bad.length) console.log("diferentes:", bad.join(", "));
  process.exit(0);
}

const pj = JSON.parse(fs.readFileSync(path.join(pkg, "package.json"), "utf8"));
const tiptap = JSON.parse(fs.readFileSync(path.join(pkg, "node_modules", "@tiptap", "core", "package.json"), "utf8")).version;
fs.mkdirSync(path.dirname(out), { recursive: true });
fs.writeFileSync(out, JSON.stringify({ fonte: "TipTap real com as extensoes do SgTextEditor.tsx (jsdom)", versaoReact: pj.version, tiptap, node: process.version, cases: results }, null, 1) + "\n");
const bad = results.filter((r) => r.error);
console.log(`fixtures: ${results.length} casos (${bad.length} com erro) -> ${out}`);
for (const b of bad) console.log("ERRO", b.id, b.error.split("\n")[0]);
process.exit(0);
