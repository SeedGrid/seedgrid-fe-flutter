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
    SgDiscardDigit(
      value: '$_n',
      fontSize: 48,
      color: '#7c2d12',
      backgroundColor: '#ffedd5',
      fontWeight: 'bold',
      transitionMs: 900,
      stackDepth: 10,
    ),
    SgButton(
      label: Text(context.tx('Próximo')),
      onClick: () => setState(() => _n = _n % 9 + 1),
    ),
  ],
)
''';

  /// Region `sg-discard-digit-auto-descarte`.
  static const String sgDiscardDigitAutoDescarte = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgDiscardDigit(
      value: _contador.toString().padLeft(2, '0'),
      color: '#0f172a',
      font: sans,
      backgroundColor: '#f8fafc',
      fontSize: 62,
      transitionMs: 700,
      stackDepth: 15,
    ),
    const SizedBox(height: 12),
    SgButton(
      label: Text(context.tx(_rodando ? 'Parar' : 'Iniciar')),
      size: SgSize.sm,
      onClick: _alternarAutomatico,
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
    SgDiscardDigit(
      value: '7',
      color: '#0f172a',
      font: sans,
      backgroundColor: '#f8fafc',
      stackDepth: _pilha,
    ),
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SgButton(
          label: Text(context.tx('Próximo (+1 folha)')),
          onClick: () => setState(
            () => _pilha = _pilha < 30 ? _pilha + 1 : 30,
          ),
        ),
        const SizedBox(height: 8),
        SgButton(
          label: Text(context.tx('Anterior (-1 folha)')),
          appearance: SgAppearance.outline,
          onClick: () =>
              setState(() => _pilha = _pilha > 2 ? _pilha - 1 : 2),
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
    SgDiscardDigit(value: '$_n'),
    SgButton(
      label: Text(context.tx('Próximo')),
      onClick: () => setState(() => _n = _n % 9 + 1),
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
    SgDiscardDigit(
      value: '$_n',
      changeAnimationMode:
          SgDiscardDigitChangeAnimationMode.incoming,
    ),
    SgButton(
      label: Text(context.tx('Próximo')),
      onClick: () => setState(() => _n = _n % 9 + 1),
    ),
  ],
)
''';

  /// Region `sg-discard-digit-folhas-sequenciais`.
  static const String sgDiscardDigitFolhasSequenciais = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgDiscardDigit(
      value: folhas[_folha],
      color: '#111827',
      font: sans,
      backgroundColor: '#fffef7',
      fontSize: 58,
    ),
    const SizedBox(height: 12),
    SgButton(
      label: Text(context.tx('Descartar folha')),
      size: SgSize.sm,
      onClick: () =>
          setState(() => _folha = (_folha + 1) % folhas.length),
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
    SgDiscardDigit(
      value: '$_paginaAtual',
      controller: _ref,
      totalNumberPages: totalPaginas,
      fontSize: 64,
    ),
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${context.tx('Página')} $_paginaAtual ${context.tx('de')} $totalPaginas',
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            SgButton(
              label: Text(context.tx('Anterior')),
              size: SgSize.sm,
              enabled: _paginaAtual > 1,
              onClick: () => setState(() {
                _ref.decreasePage();
                _paginaAtual = _ref.page();
              }),
            ),
            SgButton(
              label: Text(context.tx('Próxima')),
              size: SgSize.sm,
              enabled: _paginaAtual < totalPaginas,
              onClick: () => setState(() {
                _ref.increasePage();
                _paginaAtual = _ref.page();
              }),
            ),
          ],
        ),
      ],
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
    SgDiscardDigit(
      value: '$_page',
      controller: _pages,
      totalNumberPages: 8,
      stackDepth: 8,
    ),
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Página $_page de 8'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 16,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SgButton(
              label: Text(context.tx('Anterior')),
              appearance: SgAppearance.outline,
              onClick: () => setState(() {
                _pages.decreasePage();
                _page = _pages.page();
              }),
            ),
            SgButton(
              label: Text(context.tx('Próxima')),
              onClick: () => setState(() {
                _pages.increasePage();
                _page = _pages.page();
              }),
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
    SgDiscardDigit(value: '$_n', animateOnChange: false),
    SgButton(
      label: Text(context.tx('Próximo')),
      onClick: () => setState(() => _n = _n % 9 + 1),
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
