<div align="center">

# 🌱 SeedGrid para Flutter

**Os componentes SeedGrid, agora em Flutter.**<br>
Mesmos nomes de widget, mesmas props, mesmos valores: quem já usa o SeedGrid em React começa a usar este sem reaprender nada.

[![Flutter](https://img.shields.io/badge/Flutter-%E2%89%A5%203.38-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-%5E3.10-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![Componentes](https://img.shields.io/badge/componentes-89%20de%2089-2ea44f)](#-componentes)
[![Idiomas](https://img.shields.io/badge/idiomas-pt--BR%20%C2%B7%20pt--PT%20%C2%B7%20en--US%20%C2%B7%20es%20%C2%B7%20fr-8957e5)](#-idiomas)
[![Licença](https://img.shields.io/badge/licen%C3%A7a-MIT-blue)](LICENSE)

### [▶ Ver o showcase ao vivo](https://components-flutter.seedgrid.com.br/)

[Instalação](#-instalação) · [Primeiros passos](#-primeiros-passos) · [Componentes](#-componentes) · [Showcase](#-showcase) · [Contribuindo](#-contribuindo)

</div>

---

## ✨ Por que usar

- **Familiar.** É um porte dos componentes React (`@seedgrid/fe-components`): `SgButton`, `SgDatatable`, `SgInputCurrency`, `SgForm`... com as mesmas props e os mesmos valores. Eventos mantêm o nome do React (`onClick`, `onChange`), e `enabled` vira `disabled`.
- **Completo.** **89 de 89** componentes portados: botões, campos com máscara (CPF, CNPJ, telefone, CEP, moeda), tabela com filtro, ordenação e paginação, formulários, menus, docks, diálogos, avisos, gadgets e mais.
- **Tema de verdade.** Escala de cores a partir de uma cor semente, claro/escuro e raio de borda, tudo em tempo de execução (`SeedThemeProvider`).
- **Cinco idiomas.** pt-BR, pt-PT, en-US, es e fr nos textos dos componentes, com validações traduzidas.
- **Formulário próprio.** `SgForm` + `SgFormController` + `SgRules`: sem dependência externa, campo ligado por `name` e `control`.
- **Estado que persiste.** `SgEnvironmentProvider` guarda, por exemplo, a ordem e a visibilidade das colunas do `SgDatatable`.
- **Documentado por exemplo.** Cada componente tem uma página no showcase com exemplos numerados (o código mostrado é o que está renderizado), playground de props e tabela de referência.

## 📦 Instalação

O pacote ainda não está no pub.dev: a instalação é **direto do Git**. Requer Flutter 3.38 ou mais novo (Dart 3.10).

No `pubspec.yaml` do seu app:

```yaml
dependencies:
  flutter:
    sdk: flutter
  seedgrid_components:
    git:
      url: https://github.com/SeedGrid/seedgrid-fe-flutter.git
      path: packages/seedgrid_components
```

Depois:

```bash
flutter pub get
```

`seedgrid_components` já traz o tema (`seedgrid_theme`) e as máscaras e validadores (`seedgrid_commons`): **uma dependência só**. O repositório é um monorepo, por isso o `path:`.

> 💡 **Versão fixa.** Sem `ref`, o Git usa a ponta da branch padrão. Para builds reproduzíveis, fixe um commit ou uma tag:
>
> ```yaml
>   seedgrid_components:
>     git:
>       url: https://github.com/SeedGrid/seedgrid-fe-flutter.git
>       path: packages/seedgrid_components
>       ref: 0123abc   # commit, tag ou branch
> ```
>
> Para trazer novidades: `flutter pub upgrade seedgrid_components`.

## 🚀 Primeiros passos

Coloque o `SeedThemeProvider` abaixo do `MaterialApp` (assim o tema entra no `ThemeData` e o claro/escuro troca em tempo de execução) e use os componentes:

```dart
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

void main() => runApp(const MeuApp());

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    builder: (context, child) => SeedThemeProvider(child: child!),
    home: const Scaffold(body: Center(child: Cadastro())),
  );
}

class Cadastro extends StatelessWidget {
  const Cadastro({super.key});

  @override
  Widget build(BuildContext context) {
    final form = SgFormController(defaultValues: {'nome': ''});
    return SgForm(
      controller: form,
      onValid: (dados) => debugPrint('Salvar: $dados'),
      child: SgStack(
        gap: 12,
        children: [
          SgInputText(
            id: 'nome',
            name: 'nome',
            control: form,
            label: 'Nome',
            required: true,
          ),
          SgButton(label: const Text('Salvar'), type: SgButtonType.submit),
        ],
      ),
    );
  }
}
```

Para um exemplo maior, abra o **CRUD de clientes** no showcase: lista com busca (`SgInputTextSearch`) e tabela (`SgDatatable`), tela de novo/editar com `SgForm`, exclusão com `SgConfirmationDialog` e dados lidos de um JSON. O código-fonte de cada tela está na própria página.

### Diferenças em relação ao React

| React | Flutter |
|---|---|
| `severity="danger"` | `severity: SgSeverity.danger` (enums no lugar de textos) |
| `children` | `child` ou `children`, conforme o widget |
| `className`, `style` | não existem; use `width`, `height`, `padding`, `customColors`... |
| `useForm` + `register` | `SgFormController` + `name`/`control` |
| linhas da tabela `T[]` | `List<Map<String, Object?>>` (`SgDatatableRow`) |

A tabela completa de tradução está em [`docs/TABELA_DE_TRADUCAO.md`](docs/TABELA_DE_TRADUCAO.md), e as diferenças de propósito em [`docs/DIVERGENCIAS_DO_REACT.md`](docs/DIVERGENCIAS_DO_REACT.md).

## 🧩 Componentes

Cada nome abaixo leva à página do componente no showcase ao vivo. O estado de cada porte, prop a prop, está em [`docs/PARIDADE.md`](docs/PARIDADE.md).

<!-- componentes:inicio -->

<details>
<summary><b>🎬 Ação</b> · 4 componentes · <i>Botões e atalhos de ação</i></summary>

| Componente | O que faz |
|---|---|
| [`SgButton`](https://components-flutter.seedgrid.com.br/sg-button) | Botão de ação com severidade, aparência, forma, loading e ícones, para ações principais e secundárias. |
| [`SgFloatActionButton`](https://components-flutter.seedgrid.com.br/sg-float-action-button) | Botão de ação flutuante para a tarefa de maior destaque, com hint, posição, arrastar e speed-dial de ações secundárias. |
| [`SgSplitButton`](https://components-flutter.seedgrid.com.br/sg-split-button) | Botão de ação com um caminho principal e um menu acoplado de variações da mesma tarefa. |
| [`SgToolbarIconButton`](https://components-flutter.seedgrid.com.br/sg-toolbar-icon-button) | Botão de ícone para barras de ferramentas, com rótulo, dica, severidade, estado de carregamento e orientação herdada do SgToolBar. |

</details>

<details>
<summary><b>⌨️ Entrada de dados</b> · 30 componentes · <i>Campos de texto, máscaras, números, datas, escolha e seleção</i></summary>

| Componente | O que faz |
|---|---|
| [`SgAutocomplete`](https://components-flutter.seedgrid.com.br/sg-autocomplete) | Campo de texto com sugestões vindas de uma fonte (lista ou assíncrona), com busca com atraso, cache, grupos e valor livre. |
| [`SgCheckboxGroup`](https://components-flutter.seedgrid.com.br/sg-checkbox-group) | Grupo de caixas de seleção múltipla com título, orientação, estilo highlight, "selecionar todos" e ligação a formulário. |
| [`SgCombobox`](https://components-flutter.seedgrid.com.br/sg-combobox) | Seleção de um item de uma lista (local ou assíncrona), com escolha por id e busca por tecla digitada. |
| [`SgInputBirthDate`](https://components-flutter.seedgrid.com.br/sg-input-birth-date) | Data de nascimento: SgInputDate com limites derivados de minAge/maxAge e validação de idade ao sair do campo. |
| [`SgInputCNPJ`](https://components-flutter.seedgrid.com.br/sg-input-cnpj) | Campo de CNPJ (numérico e alfanumérico) com máscara 00.000.000/0000-00, validação dos dígitos e consulta opcional na base pública. |
| [`SgInputCPF`](https://components-flutter.seedgrid.com.br/sg-input-cpf) | Campo de CPF com máscara 000.000.000-00 e validação dos dígitos verificadores. |
| [`SgInputCPFCNPJ`](https://components-flutter.seedgrid.com.br/sg-input-cpfcnpj) | Campo único que aceita CPF ou CNPJ e decide pela quantidade de caracteres. |
| [`SgInputCurrency`](https://components-flutter.seedgrid.com.br/sg-input-currency) | Campo de moeda com símbolo, posição e separadores do idioma (Intl), casas da moeda, limites e ligação a formulário. |
| [`SgInputDate`](https://components-flutter.seedgrid.com.br/sg-input-date) | Campo de data com máscara do idioma e calendário próprio. |
| [`SgInputEmail`](https://components-flutter.seedgrid.com.br/sg-input-email) | Campo de e-mail com validação de formato, bloqueio de e-mails descartáveis e ligação a formulário. |
| [`SgInputNumber`](https://components-flutter.seedgrid.com.br/sg-input-number) | Campo numérico com formatação por idioma, casas decimais, sinal, limites e ligação a formulário (SgForm). |
| [`SgInputOTP`](https://components-flutter.seedgrid.com.br/sg-input-otp) | Campo de código de uso único com vários campos: máscara, colar o código inteiro,  |
| [`SgInputPassword`](https://components-flutter.seedgrid.com.br/sg-input-password) | Campo de senha com política configurável, barra de força, lista de senhas comuns, mostrar/ocultar e gerador de senha forte. |
| [`SgInputPhone`](https://components-flutter.seedgrid.com.br/sg-input-phone) | Telefone brasileiro (10 ou 11 dígitos) com máscara (00) 00000-0000. |
| [`SgInputPostalCode`](https://components-flutter.seedgrid.com.br/sg-input-postal-code) | Código postal por país (BR, PT, US, ES, UY, AR, PY) com máscara e consulta opcional ao ViaCEP. |
| [`SgInputText`](https://components-flutter.seedgrid.com.br/sg-input-text) | Campo de texto com rótulo, afixos, validação e ligação a formulário (SgForm). |
| [`SgInputTextArea`](https://components-flutter.seedgrid.com.br/sg-input-text-area) | Área de texto com rótulo, limites de caracteres, palavras e linhas, contador e ligação a formulário. |
| [`SgInputTextSearch`](https://components-flutter.seedgrid.com.br/sg-input-text-search) | Campo de busca com debounce, mínimo de caracteres e busca distinta, baseado no SgInputText. |
| [`SgMultiSelect`](https://components-flutter.seedgrid.com.br/sg-multi-select) | Campo de seleção múltipla: o resumo dos itens marcados aparece no campo e a lista (com busca opcional) abre ancorada ou, em tela estreita, como… |
| [`SgMultiSelectChips`](https://components-flutter.seedgrid.com.br/sg-multi-select-chips) | Seleção múltipla com os valores marcados como chips removíveis dentro do campo; a lista abre ancorada ou, em tela estreita, como bottom sheet. |
| [`SgOrderList`](https://components-flutter.seedgrid.com.br/sg-order-list) | Lista ordenável para reordenar itens manualmente, com seleção, botões de mover, teclado e arrastar. |
| [`SgPeriodSelector`](https://components-flutter.seedgrid.com.br/sg-period-selector) | Seletor de períodos prontos (hoje, esta semana, mês passado...) ou de um intervalo personalizado; entrega as datas já resolvidas. |
| [`SgPickList`](https://components-flutter.seedgrid.com.br/sg-pick-list) | Lista dupla para mover itens entre origem e destino, com filtros, seleção, botões de mover e ordenar, e arrastar. |
| [`SgRadioGroup`](https://components-flutter.seedgrid.com.br/sg-radio-group) | Grupo de escolha única com título, orientação, estilo highlight, navegação por setas e ligação a formulário. |
| [`SgRating`](https://components-flutter.seedgrid.com.br/sg-rating) | Avaliação por estrelas com meia estrela, cancelar, tooltip, cores, ícones próprios e ligação a formulário. |
| [`SgSlider`](https://components-flutter.seedgrid.com.br/sg-slider) | Controle deslizante numérico com faixa, passo, largura e ligação a formulário. |
| [`SgStepperInput`](https://components-flutter.seedgrid.com.br/sg-stepper-input) | Campo numérico com botões de aumentar e diminuir, passo configurável e limites. |
| [`SgTextEditor`](https://components-flutter.seedgrid.com.br/sg-text-editor) | Editor de texto rico (negrito, listas, cores, alinhamento, link e imagem) que entrega e recebe HTML. |
| [`SgToggleSwitch`](https://components-flutter.seedgrid.com.br/sg-toggle-switch) | Chave liga/desliga com rótulo, descrição, ícones, validação e ligação a formulário. |
| [`SgYearPartSelector`](https://components-flutter.seedgrid.com.br/sg-year-part-selector) | Seletor de recorte de ano: o usuário escolhe ano, recorte (semestre, trimestre ou bimestre) e fatia, e recebe o intervalo de datas resolvido. |

</details>

<details>
<summary><b>📊 Dados</b> · 1 componentes · <i>Tabela, listas e editor</i></summary>

| Componente | O que faz |
|---|---|
| [`SgDatatable`](https://components-flutter.seedgrid.com.br/sg-datatable) | Tabela de dados com colunas configuráveis, paginação, ordenação, filtros, seleção, carga sob demanda e layout de colunas persistente. |

</details>

<details>
<summary><b>🧱 Layout</b> · 12 componentes · <i>Grade, painéis, cartões, abas e docks</i></summary>

| Componente | O que faz |
|---|---|
| [`SgAccordion`](https://components-flutter.seedgrid.com.br/sg-accordion) | Lista de painéis que abrem e fecham, na vertical ou na horizontal, em modo controlado ou não. |
| [`SgCard`](https://components-flutter.seedgrid.com.br/sg-card) | Cartão com cabeçalho, corpo e rodapé; pode ser clicável, recolhível ou arrastável. |
| [`SgCarousel`](https://components-flutter.seedgrid.com.br/sg-carousel) | Carrossel de itens com setas, indicadores, reprodução automática, vários itens visíveis e orientação vertical. |
| [`SgDockLayout`](https://components-flutter.seedgrid.com.br/sg-dock-layout) | Contexto das toolbars encaixáveis: guarda a zona, a ordem e o recolhimento de cada toolbar e coordena a prévia de soltura entre zonas. |
| [`SgDockScreen`](https://components-flutter.seedgrid.com.br/sg-dock-screen) | Tela completa com um SgDockLayout interno e a grade padrão de zonas (topo, base, esquerda, direita e centro livre). |
| [`SgDockZone`](https://components-flutter.seedgrid.com.br/sg-dock-zone) | Área onde as toolbars se encaixam (top, bottom, left, right ou free). |
| [`SgExpandablePanel`](https://components-flutter.seedgrid.com.br/sg-expandable-panel) | Painel que expande para um lado, empurrando o conteúdo (inline) ou sobre a tela (overlay). |
| [`SgGrid`](https://components-flutter.seedgrid.com.br/sg-grid) | Grade de colunas 1fr com colunas por breakpoint, largura mínima automática, span e rowSpan. |
| [`SgGroupBox`](https://components-flutter.seedgrid.com.br/sg-group-box) | Caixa com legenda sobre a borda para agrupar campos relacionados. |
| [`SgPanel`](https://components-flutter.seedgrid.com.br/sg-panel) | Painel com borda, docking por align, organização do conteúdo e rolagem. |
| [`SgScreen`](https://components-flutter.seedgrid.com.br/sg-screen) | Área raiz de uma tela: ocupa a janela por padrão e organiza o conteúdo por docking. |
| [`SgStack`](https://components-flutter.seedgrid.com.br/sg-stack) | Pilha flex em linha ou coluna, com gap, justify, align, wrap e grow. |

</details>

<details>
<summary><b>🧭 Navegação</b> · 9 componentes · <i>Menus, barras de ferramentas, trilhas e passos</i></summary>

| Componente | O que faz |
|---|---|
| [`SgBreadcrumb`](https://components-flutter.seedgrid.com.br/sg-breadcrumb) | Trilha de navegação com separador, ícone de início, colapso dos itens do meio e variantes. |
| [`SgDockMenu`](https://components-flutter.seedgrid.com.br/sg-dock-menu) | Menu de ações no estilo dock: zoom por proximidade do mouse, badges, rótulos, oito posições ancoradas e arraste com posição persistida. |
| [`SgMenu`](https://components-flutter.seedgrid.com.br/sg-menu) | Menu de navegação em árvore com variantes painel, tiered e mega, recolher, busca, usuário, gaveta e teclado. |
| [`SgPageControl`](https://components-flutter.seedgrid.com.br/sg-page-control) | Abas com painéis: estilo sublinhado ou pílulas, controlado ou não, com navegação por teclado e modo seleção no celular. |
| `SgPageControlPage` |  |
| [`SgToolBar`](https://components-flutter.seedgrid.com.br/sg-tool-bar) | Barra de ferramentas com título, recolher, orientação, botões por linha, arraste livre ou no dock e overflow em menu. |
| [`SgTreeView`](https://components-flutter.seedgrid.com.br/sg-tree-view) | Árvore com expansão, seleção (checkbox, modo confirmar), busca, colunas extras (trilhas) e lista virtualizada para muitos nós. |
| [`SgWizard`](https://components-flutter.seedgrid.com.br/sg-wizard) | Assistente em etapas com stepper numerado ou de ícones, navegação por etapas, guardas assíncronas e validação por etapa no formulário. |
| [`SgWizardPage`](https://components-flutter.seedgrid.com.br/sg-wizard-page) | Uma etapa do SgWizard: título e ícone do stepper e o conteúdo da etapa. |

</details>

<details>
<summary><b>💬 Feedback e exibição</b> · 12 componentes · <i>Avisos, diálogos, avatares, selos e indicadores</i></summary>

| Componente | O que faz |
|---|---|
| [`SgAvatar`](https://components-flutter.seedgrid.com.br/sg-avatar) | Avatar com imagem, iniciais, ícone ou conteúdo próprio; severidades, tamanhos, formas e estado de erro da imagem. |
| [`SgAvatarGroup`](https://components-flutter.seedgrid.com.br/sg-avatar-group) | Agrupa avatares sobrepostos, com limite de exibição e contador do excesso. |
| [`SgBadge`](https://components-flutter.seedgrid.com.br/sg-badge) | Selo compacto para status, contagens e rótulos curtos, com estilos, tamanhos, ícones e remoção. |
| [`SgBadgeOverlay`](https://components-flutter.seedgrid.com.br/sg-badge-overlay) | Posiciona um selo (SgBadge) sobre um canto ou borda de outro widget. |
| [`SgConfirmationDialog`](https://components-flutter.seedgrid.com.br/sg-confirmation-dialog) | Diálogo de confirmação com mensagem, ícone de severidade e botões cancelar e confirmar. |
| [`SgDialog`](https://components-flutter.seedgrid.com.br/sg-dialog) | Diálogo modal com título, corpo e rodapé, foco preso, fechamento por Esc e fundo, severidade, animação e fechamento automático. |
| [`SgPopup`](https://components-flutter.seedgrid.com.br/sg-popup) | Painel flutuante ancorado em um widget, com título, conteúdo e ações; posiciona sozinho dentro da tela. |
| [`SgSkeleton`](https://components-flutter.seedgrid.com.br/sg-skeleton) | Marcador de carregamento com formas, dimensões flexíveis e animações wave, pulse ou nenhuma. |
| [`SgToaster`](https://components-flutter.seedgrid.com.br/sg-toaster) | Renderiza os toasts da API imperativa (toast) em um canto da tela, com cores por tipo, ação, botão de fechar e tempo de vida. |
| [`SgToastHost`](https://components-flutter.seedgrid.com.br/sg-toast-host) | Marca onde os toasts aparecem. |
| [`SgWhistleHost`](https://components-flutter.seedgrid.com.br/sg-whistle-host) | Marca onde os whistles aparecem. |
| [`SgWhistler`](https://components-flutter.seedgrid.com.br/sg-whistler) | Pilha de avisos persistentes ou semi-persistentes, com cores por severidade, ação opcional e máximo visível. |

</details>

<details>
<summary><b>🎛️ Gadgets</b> · 16 componentes · <i>Dígitos animados, relógios, medidores e QR</i></summary>

| Componente | O que faz |
|---|---|
| [`SgCalendar`](https://components-flutter.seedgrid.com.br/sg-calendar) | Calendário mensal em formato de gadget, com locale, vários meses, limites, dias bloqueados e cartão configurável. |
| [`SgClock`](https://components-flutter.seedgrid.com.br/sg-clock) | Relógio analógico ou digital, com fuso, 12/24 horas, temas embutidos e cartão recolhível. |
| [`SgClockThemePicker`](https://components-flutter.seedgrid.com.br/sg-clock-theme-picker) | Seletor de tema de relógio: botão com a miniatura atual e um painel com busca e a lista de temas. |
| [`SgClockThemePreview`](https://components-flutter.seedgrid.com.br/sg-clock-theme-preview) | Miniatura de um tema de relógio, usada no seletor de temas e para escolher entre os temas embutidos. |
| [`SgDiscardDigit`](https://components-flutter.seedgrid.com.br/sg-discard-digit) | Pilha de folhas de papel: a de cima é descartada (ou uma nova sobe por baixo) quando o valor muda. |
| [`SgFadeDigit`](https://components-flutter.seedgrid.com.br/sg-fade-digit) | Cartão que apaga o dígito atual e acende o novo, como uma lâmpada ou display trocando de valor. |
| [`SgFlipDigit`](https://components-flutter.seedgrid.com.br/sg-flip-digit) | Cartão que vira como num relógio de aeroporto: um caractere, animado por uma carta com perspectiva 3D. |
| [`SgLinearGauge`](https://components-flutter.seedgrid.com.br/sg-linear-gauge) | Medidor linear horizontal ou vertical com barra, faixas, ponteiros extras e arraste. |
| [`SgMatrixDigit`](https://components-flutter.seedgrid.com.br/sg-matrix-digit) | Texto desenhado em matriz de pontos 5 x 7 com brilho, cores e medidas configuráveis. |
| [`SgNeonDigit`](https://components-flutter.seedgrid.com.br/sg-neon-digit) | Texto com brilho neon que apaga e acende ao trocar o valor, com cores, intensidade e fonte configuráveis. |
| [`SgQRCode`](https://components-flutter.seedgrid.com.br/sg-qr-code) | Gera QR Code a partir de um texto, com cores, margem, nível de correção de erro e logo central. |
| [`SgRadialGauge`](https://components-flutter.seedgrid.com.br/sg-radial-gauge) | Medidor circular com agulha, marcadores, faixas, anotações e arraste, para velocímetros, mostradores e progresso. |
| [`SgRoller3DDigit`](https://components-flutter.seedgrid.com.br/sg-roller3-d-digit) | Tambor vertical que desliza entre valores (dígitos, números com zero à esquerda, letras ou textos quaisquer). |
| [`SgSegmentDigit`](https://components-flutter.seedgrid.com.br/sg-segment-digit) | Dígito desenhado com retângulos (estilo calculadora), com tamanho e cor configuráveis. |
| [`SgSevenSegmentDigit`](https://components-flutter.seedgrid.com.br/sg-seven-segment-digit) | Display de sete segmentos estilo LED, com paletas, inclinação, brilho e transição entre valores. |
| [`SgStringAnimator`](https://components-flutter.seedgrid.com.br/sg-string-animator) | Anima caractere a caractere de uma string para outra, com seis estilos de dígito (roller3d, flip, neon, fade, discard e matrix). |

</details>

<details>
<summary><b>🔌 Providers</b> · 5 componentes · <i>Idioma, ambiente e persistência</i></summary>

| Componente | O que faz |
|---|---|
| [`SgClockThemeProvider`](https://components-flutter.seedgrid.com.br/sg-clock-theme-provider) | Fornece um resolvedor de temas de relógio (modo, tema de recuo e temas locais) a toda a árvore. |
| `SgComponentsI18nProvider` |  |
| [`SgEnvironmentProvider`](https://components-flutter.seedgrid.com.br/sg-environment-provider) | Ambiente com namespace, escopo e estratégia de persistência (local, API ou as duas) para os componentes SeedGrid e para o estado persistido. |
| [`SgRealtimeProvider`](https://components-flutter.seedgrid.com.br/sg-realtime-provider) | Avisos em tempo real para o usuário logado pelo SeedGrid Pulse: pede o token ao backend, conecta, reconecta sozinho e informa o estado para a tela… |
| [`SgTimeProvider`](https://components-flutter.seedgrid.com.br/sg-time-provider) | Fornece a hora do servidor a toda a árvore e avisa a cada segundo; useSgTime lê esse contexto. |

</details>

<details>
<summary><b>📚 Exemplos completos</b> · 1 exemplo · <i>Telas inteiras montadas só com componentes SeedGrid</i></summary>

| Componente | O que faz |
|---|---|
| [`CrudClientes`](https://components-flutter.seedgrid.com.br/crud-clientes) | Exemplo de CRUD completo só com componentes SeedGrid: lista com busca e tabela, tela de novo/editar com formulário, exclusão com confirmação e… |

</details>

<!-- componentes:fim -->

## 🖥️ Showcase

O showcase é o próprio app em [`apps/seedgrid_showcase`](apps/seedgrid_showcase), publicado no GitHub Pages a cada push na `main`:

**👉 https://components-flutter.seedgrid.com.br/**

Cada página de componente tem:

1. cabeçalho fixo com a descrição e links para cada exemplo;
2. exemplos numerados, com o código ao lado (o mesmo que está renderizado);
3. um **playground** para mexer nas props e ver o código resultante;
4. a **Referência de Props** (prop, tipo, padrão, descrição).

Também há troca de idioma, painel de tema (cor semente e raio) e botão claro/escuro. Os links aceitam âncora, por exemplo `…/sg-button#exemplo-3`.

Para rodar localmente:

```bash
git clone https://github.com/SeedGrid/seedgrid-fe-flutter.git
cd seedgrid-fe-flutter
flutter pub get
cd apps/seedgrid_showcase
flutter run -d chrome        # ou: -d windows, ou um aparelho Android
```

## 🌍 Idiomas

Os textos dos componentes (mensagens de validação, botões da tabela, diálogos) e todo o showcase estão em **pt-BR, pt-PT, en-US, es e fr**. O idioma vem do `SgComponentsI18nProvider`.

## 🏗️ Estrutura

Monorepo Dart com [pub workspaces](https://dart.dev/tools/pub/workspaces):

| Pacote | O que é |
|---|---|
| [`packages/seedgrid_components`](packages/seedgrid_components) | os widgets, contratos de props gerados e i18n (**o que você instala**) |
| [`packages/seedgrid_theme`](packages/seedgrid_theme) | tokens, escala de cor por hex, claro/escuro, `SgTheme` |
| [`packages/seedgrid_commons`](packages/seedgrid_commons) | máscaras, validadores, CEP, CNPJ, cliente HTTP |
| [`apps/seedgrid_showcase`](apps/seedgrid_showcase) | o showcase |
| [`docs/`](docs) | paridade com o React, tabela de tradução e divergências |
| [`tools/`](tools) | geradores (props, snippets, i18n, paridade, este README) |

A versão dos pacotes acompanha a do `@seedgrid/fe-components` (hoje 2026.7.1).

## 🤝 Contribuindo

```bash
flutter pub get
bash tools/ci.sh            # formato, análise, testes e arquivos gerados em dia
```

As ferramentas usam Node 22 e leem o repositório React, que **não é alterado**:

| Comando | O que gera |
|---|---|
| `node tools/parity_vectors/generate.mjs <pacote react>` | vetores de máscara/validação do TypeScript, conferidos pelos testes Dart |
| `node tools/parity_vectors/generate_theme.mjs <pacote react>` | vetores do tema + getters tipados dos tokens |
| `node tools/export_i18n/export.mjs <pacote react>` | os 5 idiomas em Dart + vetores |
| `node --experimental-strip-types tools/gen_props/extract.mjs <pacote react>` | especificação de props (compilador TypeScript) |
| `node tools/gen_props/emit.mjs` | interfaces `<Comp>Props`, enums e `sgPropSpecs` em `lib/src/generated/` |
| `node tools/showcase_snippets/extract.mjs` | código dos exemplos do showcase, igual ao renderizado |
| `node tools/showcase_i18n/extract.mjs` | dicionário de textos das páginas do showcase a partir de `tools/showcase_i18n/traducoes/*.json`; `--check` falha se faltar tradução, `--faltam` lista o que falta. Texto novo numa página = acrescentar a tradução (en-US, pt-PT, es, fr) num JSON novo |
| `node tools/parity_table/generate.mjs` | `docs/PARIDADE.md` e o catálogo do showcase |
| `node tools/readme/generate.mjs` | a seção **Componentes** deste README |

`<pacote react>` = `../seedgrid-fe-components/packages/seedgrid-fe-components`.

**Regras**

- Widget escrito à mão declara `implements <Comp>Props` (gerado): o analisador acusa prop faltando.
- Não editar arquivos `*.g.dart`, `props-spec.json`, `excecoes.json`, `snippets.g.dart`, `docs/PARIDADE.md`.
- Exemplo do showcase: o código exibido é o trecho entre `// #region` e `// #endregion` da própria página.
- Sem `className`/`style`; `enabled` vira `disabled`; eventos mantêm o nome do React (ADR 50).
- Sem referência a PrimeFaces/PrimeReact em exemplos.
- Arquivos em UTF-8.

**Como portar um componente**

1. Ler o componente React (`../seedgrid-fe-components/packages/seedgrid-fe-components/src/<grupo>/<Comp>.tsx`) e o contrato gerado em `packages/seedgrid_components/lib/src/generated/<comp>.g.dart`.
2. Escrever o widget em `packages/seedgrid_components/lib/src/<grupo>/` com `implements <Comp>Props`; exportar no **barril do grupo** (`lib/src/commons/commons.dart`, `lib/src/inputs/{text,masked,number,choice}_inputs.dart`), nunca no arquivo raiz.
3. Props que o React herda do HTML (`onClick`, `disabled`, `children`...) entram como lista fechada (ADR 50).
4. Testes em `packages/seedgrid_components/test/widgets/<comp>_test.dart` (cada prop pública, estados, formulário, golden quando indicado).
5. Página de showcase: `apps/seedgrid_showcase/lib/pages/<snake>_page.dart` com `class <Comp>Page extends StatelessWidget` (construtor `const` sem argumentos) usando `SgShowcasePage`, exemplos com `// #region <id>` ... `// #endregion` e `SgPlayground`. Depois: `node tools/showcase_snippets/extract.mjs`. Os testes de âncoras, props e código 1:1 rodam sozinhos para toda página.
6. `dart format lib test` **antes** de `extract.mjs`; `bash tools/ci.sh` verde.

**Publicação do showcase.** O workflow [`.github/workflows/showcase-pages.yml`](.github/workflows/showcase-pages.yml) compila `flutter build web` com `--base-href /` e publica no GitHub Pages, no domínio `components-flutter.seedgrid.com.br` (DNS: `CNAME` para `seedgrid.github.io`; o workflow grava o arquivo `CNAME` no build). Em *Settings → Pages*, a fonte precisa estar em **GitHub Actions** e o domínio em *Custom domain*, com *Enforce HTTPS*. O `404.html` é uma cópia do `index.html`, para que `/sg-button` aberto direto funcione (fallback de SPA).

## 📄 Licença

[MIT](LICENSE) © 2026 SeedGrid
