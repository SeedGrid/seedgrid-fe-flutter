# seedgrid-fe-flutter

Componentes SeedGrid em Flutter. **Porte familiar** dos componentes React de
`../seedgrid-fe-components`: mesmos nomes de widget, de props e de valores, para quem já usa os
componentes React usar estes com facilidade. Não é pixel a pixel nem reuso de código.

- Plano, tarefas e decisões: `seedgrid-platform-work/planos/seedgrid-fe-components/`.
- ADRs: 48 (local, versão, branches), 49 (formulário próprio), 50 (convenção de tradução).
- **Nada aqui está publicado.** Publicação no pub.dev só com autorização do dono.

## Pacotes (monorepo Dart, pub workspaces)

| Pacote | O que é | Estado |
|---|---|---|
| `packages/seedgrid_theme` | tokens, escala de cor por hex, claro/escuro, `SgTheme` (porte de `@seedgrid/fe-theme`) | Onda 0 pronta |
| `packages/seedgrid_commons` | máscaras, validadores, CEP, CNPJ, cliente HTTP (porte de `masks.ts`, `validators.ts`, `@seedgrid/fe-commons`) | Onda 0 pronta |
| `packages/seedgrid_components` | contratos de props gerados, i18n, widgets (as ondas 1 a 6 ainda não começaram) | Onda 0 pronta |
| `apps/seedgrid_showcase` | showcase (cabeçalho fixo, âncoras, exemplos, playground, referência de props) | esqueleto pronto |

Versão dos pacotes = versão do `@seedgrid/fe-components` (hoje 2026.7.1).

## Como trabalhar

```bash
flutter pub get
bash tools/ci.sh            # formato, análise, testes e arquivos gerados em dia
```

Ferramentas (Node 22; leem o repositório React, que **não é alterado**):

| Comando | O que gera |
|---|---|
| `node tools/parity_vectors/generate.mjs <pacote react>` | vetores de máscara/validação do TypeScript, conferidos pelos testes Dart |
| `node tools/parity_vectors/generate_theme.mjs <pacote react>` | vetores do tema + getters tipados dos tokens |
| `node tools/export_i18n/export.mjs <pacote react>` | os 5 idiomas em Dart + vetores |
| `node --experimental-strip-types tools/gen_props/extract.mjs <pacote react>` | especificação de props (compilador TypeScript) |
| `node tools/gen_props/emit.mjs` | interfaces `<Comp>Props`, enums e `sgPropSpecs` em `lib/src/generated/` |
| `node tools/showcase_snippets/extract.mjs` | código dos exemplos do showcase, igual ao renderizado |
| `node tools/parity_table/generate.mjs` | `docs/PARIDADE.md` |

`<pacote react>` = `../seedgrid-fe-components/packages/seedgrid-fe-components`.

## Regras

- Widget escrito à mão declara `implements <Comp>Props` (gerado): o analisador acusa prop faltando.
- Não editar arquivos `*.g.dart`, `props-spec.json`, `excecoes.json`, `snippets.g.dart`, `docs/PARIDADE.md`.
- Exemplo do showcase: o código exibido é o trecho entre `// #region` e `// #endregion` da própria página.
- Sem `className`/`style`; `enabled` vira `disabled`; eventos mantêm o nome do React (ADR 50).
- Sem referência a PrimeFaces/PrimeReact em exemplos.
- Arquivos em UTF-8.
