#!/usr/bin/env bash
# CI local do seedgrid-fe-flutter: formato, analise, testes e conferencia dos arquivos gerados.
# Uso: bash tools/ci.sh        (rode na raiz do repositorio)
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

echo "== flutter pub get"
flutter pub get >/dev/null

PKGS=(packages/seedgrid_theme packages/seedgrid_commons packages/seedgrid_components apps/seedgrid_showcase)
for p in "${PKGS[@]}"; do
  echo "== $p"
  (cd "$p" && dart format --set-exit-if-changed lib test >/dev/null && dart analyze && flutter test)
done

echo "== arquivos gerados em dia"
node tools/showcase_snippets/extract.mjs --check
node tools/parity_table/generate.mjs --check
node tools/readme/generate.mjs --check
