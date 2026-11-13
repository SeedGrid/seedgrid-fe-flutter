// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_discard_digit_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgDiscardDigitPageSnippets {
  /// Region `sg-discard-digit-aparencia`.
  static const String sgDiscardDigitAparencia = r'''
Wrap(
  spacing: 16,
  runSpacing: 12,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    ValueListenableBuilder<int>(
      valueListenable: _n,
      builder: (context, n, _) => SgDiscardDigit(
        value: '$n',
        fontSize: 48,
        color: '#7c2d12',
        backgroundColor: '#ffedd5',
        fontWeight: 'bold',
        transitionMs: 900,
        stackDepth: 10,
      ),
    ),
    SgButton(
      label: Text(context.tx('Próximo')),
      onClick: () => _n.value = _n.value % 9 + 1,
    ),
  ],
)
''';

  /// Region `sg-discard-digit-auto-descarte`.
  static const String sgDiscardDigitAutoDescarte = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    ValueListenableBuilder<int>(
      valueListenable: _contador,
      builder: (context, contador, _) => SgDiscardDigit(
        value: contador.toString().padLeft(2, '0'),
        color: '#0f172a',
        font: sans,
        backgroundColor: '#f8fafc',
        fontSize: 62,
        transitionMs: 700,
        stackDepth: 15,
      ),
    ),
    const SizedBox(height: 12),
    ValueListenableBuilder<bool>(
      valueListenable: _rodando,
      builder: (context, rodando, _) => SgButton(
        label: Text(rodando ? context.tx('Parar') : context.tx('Iniciar')),
        size: SgSize.sm,
        onClick: _alternarAutomatico,
      ),
    ),
  ],
)
''';

  /// Region `sg-discard-digit-basico`.
  static const String sgDiscardDigitBasico = r'''
Wrap(
  spacing: 16,
  runSpacing: 12,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    ValueListenableBuilder<int>(
      valueListenable: _pilha,
      builder: (context, pilha, _) => SgDiscardDigit(
        value: '7',
        color: '#0f172a',
        font: sans,
        backgroundColor: '#f8fafc',
        stackDepth: pilha,
      ),
    ),
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SgButton(
          label: Text(context.tx('Adicionar folha')),
          onClick: () => _pilha.value = _pilha.value < 30
              ? _pilha.value + 1
              : 30,
        ),
        const SizedBox(height: 8),
        SgButton(
          label: Text(context.tx('Remover folha')),
          appearance: SgAppearance.outline,
          onClick: () => _pilha.value = _pilha.value > 2
              ? _pilha.value - 1
              : 2,
        ),
      ],
    ),
  ],
)
''';

  /// Region `sg-discard-digit-descarte`.
  static const String sgDiscardDigitDescarte = r'''
Wrap(
  spacing: 16,
  runSpacing: 12,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    ValueListenableBuilder<int>(
      valueListenable: _n,
      builder: (context, n, _) => SgDiscardDigit(value: '$n'),
    ),
    SgButton(
      label: Text(context.tx('Próximo')),
      onClick: () => _n.value = _n.value % 9 + 1,
    ),
  ],
)
''';

  /// Region `sg-discard-digit-entrando`.
  static const String sgDiscardDigitEntrando = r'''
Wrap(
  spacing: 16,
  runSpacing: 12,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    ValueListenableBuilder<int>(
      valueListenable: _n,
      builder: (context, n, _) => SgDiscardDigit(
        value: '$n',
        changeAnimationMode:
            SgDiscardDigitChangeAnimationMode.incoming,
      ),
    ),
    SgButton(
      label: Text(context.tx('Próximo')),
      onClick: () => _n.value = _n.value % 9 + 1,
    ),
  ],
)
''';

  /// Region `sg-discard-digit-folhas-sequenciais`.
  static const String sgDiscardDigitFolhasSequenciais = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    ValueListenableBuilder<int>(
      valueListenable: _folha,
      builder: (context, folha, _) => SgDiscardDigit(
        value: folhas[folha],
        color: '#111827',
        font: sans,
        backgroundColor: '#fffef7',
        fontSize: 58,
      ),
    ),
    const SizedBox(height: 12),
    SgButton(
      label: Text(context.tx('Descartar folha')),
      size: SgSize.sm,
      onClick: () =>
          _folha.value = (_folha.value + 1) % folhas.length,
    ),
  ],
)
''';

  /// Region `sg-discard-digit-fontes`.
  static const String sgDiscardDigitFontes = r'''
Wrap(
  spacing: 24,
  runSpacing: 12,
  children: [
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.tx('Sans')),
        const SgDiscardDigit(
          value: '42',
          color: '#0f172a',
          font: sans,
          backgroundColor: '#f8fafc',
          fontSize: 60,
        ),
      ],
    ),
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.tx('Serif')),
        const SgDiscardDigit(
          value: '42',
          color: '#1f2937',
          font: serif,
          backgroundColor: '#fffef7',
          fontSize: 60,
        ),
      ],
    ),
  ],
)
''';

  /// Region `sg-discard-digit-paginacao-ref`.
  static const String sgDiscardDigitPaginacaoRef = r'''
Wrap(
  spacing: 32,
  runSpacing: 12,
  crossAxisAlignment: WrapCrossAlignment.end,
  children: [
    ValueListenableBuilder<int>(
      valueListenable: _paginaAtual,
      builder: (context, paginaAtual, _) => SgDiscardDigit(
        value: '$paginaAtual',
        controller: _ref,
        totalNumberPages: totalPaginas,
        fontSize: 64,
      ),
    ),
    ValueListenableBuilder<int>(
      valueListenable: _paginaAtual,
      builder: (context, paginaAtual, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${context.tx('Página')} $paginaAtual ${context.tx('de')} $totalPaginas',
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              SgButton(
                label: Text(context.tx('Anterior')),
                size: SgSize.sm,
                enabled: paginaAtual > 1,
                onClick: () {
                  _ref.decreasePage();
                  _paginaAtual.value = _ref.page();
                },
              ),
              SgButton(
                label: Text(context.tx('Próxima')),
                size: SgSize.sm,
                enabled: paginaAtual < totalPaginas,
                onClick: () {
                  _ref.increasePage();
                  _paginaAtual.value = _ref.page();
                },
              ),
            ],
          ),
        ],
      ),
    ),
  ],
)
''';

  /// Region `sg-discard-digit-paginas`.
  static const String sgDiscardDigitPaginas = r'''
Wrap(
  spacing: 16,
  runSpacing: 12,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    ValueListenableBuilder<int>(
      valueListenable: _page,
      builder: (context, page, _) => SgDiscardDigit(
        value: '$page',
        controller: _pages,
        totalNumberPages: 8,
        stackDepth: 8,
      ),
    ),
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ValueListenableBuilder<int>(
          valueListenable: _page,
          builder: (context, page, _) => Text('Página $page de 8'),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 16,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SgButton(
              label: Text(context.tx('Anterior')),
              appearance: SgAppearance.outline,
              onClick: () {
                _pages.decreasePage();
                _page.value = _pages.page();
              },
            ),
            SgButton(
              label: Text(context.tx('Próxima')),
              onClick: () {
                _pages.increasePage();
                _page.value = _pages.page();
              },
            ),
          ],
        ),
      ],
    ),
  ],
)
''';

  /// Region `sg-discard-digit-sem-animacao`.
  static const String sgDiscardDigitSemAnimacao = r'''
Wrap(
  spacing: 16,
  runSpacing: 12,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    ValueListenableBuilder<int>(
      valueListenable: _n,
      builder: (context, n, _) =>
          SgDiscardDigit(value: '$n', animateOnChange: false),
    ),
    SgButton(
      label: Text(context.tx('Próximo')),
      onClick: () => _n.value = _n.value % 9 + 1,
    ),
  ],
)
''';

  /// Region `sg-discard-digit-variacoes-de-papel`.
  static const String sgDiscardDigitVariacoesDePapel = r'''
Wrap(
  spacing: 24,
  runSpacing: 12,
  children: [
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.tx('Papel branco')),
        const SgDiscardDigit(
          value: '7',
          color: '#0f172a',
          font: sans,
          backgroundColor: '#f8fafc',
        ),
      ],
    ),
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.tx('Papel âmbar')),
        const SgDiscardDigit(
          value: '7',
          color: '#4a2d13',
          font: sans,
          backgroundColor: '#fff4d6',
        ),
      ],
    ),
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.tx('Papel azul frio')),
        const SgDiscardDigit(
          value: '7',
          color: '#0b2f50',
          font: sans,
          backgroundColor: '#e7f5ff',
        ),
      ],
    ),
  ],
)
''';
}
