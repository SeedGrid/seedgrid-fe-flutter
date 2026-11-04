// Vetores de paridade do SgCameraCapture (P134): a verdade e o CODIGO DO REACT (cameraLogic.ts), transpilado com
// esbuild e executado de verdade. Cobre accept, validacao (tipo, tamanho, dimensao, proporcao), formatBytes e formatAspect.
// Uso (na raiz do repo seedgrid-fe-flutter):
//   node packages/seedgrid_components/test/widgets/camera_vectors/generate.mjs <pasta do pacote react>
import fs from "node:fs";
import os from "node:os";
import path from "node:path";
import { pathToFileURL } from "node:url";

const root = process.cwd();
const pkg = path.resolve(process.argv[2] ?? "../seedgrid-fe-components/packages/seedgrid-fe-components");
const out = path.join(root, "packages/seedgrid_components/test/widgets/camera_vectors/vectors.json");
const src = path.join(pkg, "src", "inputs", "cameraLogic.ts");
if (!fs.existsSync(src)) {
  console.error("cameraLogic.ts nao encontrado em " + src);
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
const tmp = fs.mkdtempSync(path.join(os.tmpdir(), "sg-camera-"));
const r = await esbuild.transform(fs.readFileSync(src, "utf8"), { loader: "ts", format: "esm", target: "es2022" });
fs.writeFileSync(path.join(tmp, "logic.mjs"), r.code);
const L = await import(pathToFileURL(path.join(tmp, "logic.mjs")).href);

const resolution = ["low", "medium", "high", "outra"].map((r) => ({ resolution: r, out: L.resolutionSize(r) }));

const guide = [];
for (const g of ["none", "oval", "rect"])
  for (const [w, h] of [[400, 600], [600, 400], [360, 640], [1280, 720], [100, 100], [0, 300], [300, 0]])
    guide.push({ guide: g, width: w, height: h, out: L.guideBox(g, w, h) });

const errors = [
  "NotAllowedError", "PermissionDeniedError", "SecurityError", "CameraAccessDenied", "CameraAccessDeniedWithoutPrompt",
  "CameraAccessRestricted", "NotFoundError", "DevicesNotFoundError", "noCamera", "NotReadableError", "AbortError", "", "  notallowederror  "
].map((n) => ({ name: n, out: L.classifyCameraError(n) }));

const facing = ["user", "environment"].map((f) => ({ facing: f, out: L.nextFacing(f) }));

fs.writeFileSync(out, JSON.stringify({ resolution, guide, errors, facing }, null, 2) + "\n");
fs.rmSync(tmp, { recursive: true, force: true });
console.log("ok " + out);
