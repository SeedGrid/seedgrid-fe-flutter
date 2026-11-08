// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_roller3d_digit_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgRoller3dDigitPageSnippets {
  /// Region `sg-roller3d-digit-digitos`.
  static const String sgRoller3dDigitDigitos = r'''
Wrap(
  spacing: 16,
  runSpacing: 12,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    ValueListenableBuilder<int>(
      valueListenable: _digit,
      builder: (context, digit, _) =>
          SgRoller3DDigit(value: '$digit', fontSize: 32),
    ),
    SgButton(
      label: Text(context.tx('Próximo')),
      onClick: () => _digit.value = (_digit.value + 1) % 10,
    ),
    SgButton(
      label: Text(context.tx('Aleatório')),
      appearance: SgAppearance.outline,
      onClick: () => _digit.value = (_digit.value * 7 + 3) % 10,
    ),
  ],
)
''';

  /// Region `sg-roller3d-digit-duracao`.
  static const String sgRoller3dDigitDuracao = r'''
ValueListenableBuilder<bool>(
  valueListenable: _slow,
  builder: (context, slow, _) => Wrap(
    spacing: 16,
    runSpacing: 12,
    crossAxisAlignment: WrapCrossAlignment.center,
    children: [
      SgRoller3DDigit(
        value: slow ? '9' : '0',
        transitionMs: 150,
        fontSize: 28,
      ),
      SgRoller3DDigit(
        value: slow ? '9' : '0',
        transitionMs: 1500,
        fontSize: 28,
      ),
      SgButton(
        label: Text(context.tx('Alternar 0 e 9')),
        onClick: () => _slow.value = !slow,
      ),
    ],
  ),
)
''';

  /// Region `sg-roller3d-digit-letras`.
  static const String sgRoller3dDigitLetras = r'''
Wrap(
  spacing: 16,
  runSpacing: 12,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    ValueListenableBuilder<int>(
      valueListenable: _letter,
      builder: (context, letter, _) => SgRoller3DDigit(
        value: String.fromCharCode(65 + letter),
        items: List.generate(
          26,
          (i) => String.fromCharCode(65 + i),
        ),
        fontSize: 32,
      ),
    ),
    SgButton(
      label: Text(context.tx('Próxima letra')),
      onClick: () => _letter.value = (_letter.value + 5) % 26,
    ),
  ],
)
''';

  /// Region `sg-roller3d-digit-minutos`.
  static const String sgRoller3dDigitMinutos = r'''
Wrap(
  spacing: 16,
  runSpacing: 12,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    ValueListenableBuilder<int>(
      valueListenable: _minute,
      builder: (context, minute, _) => SgRoller3DDigit(
        value: minute.toString().padLeft(2, '0'),
        items: List.generate(
          60,
          (i) => i.toString().padLeft(2, '0'),
        ),
        fontSize: 22,
      ),
    ),
    SgButton(
      label: Text(context.tx('+7 minutos')),
      onClick: () => _minute.value = (_minute.value + 7) % 60,
    ),
  ],
)
''';

  /// Region `sg-roller3d-digit-nomes`.
  static const String sgRoller3dDigitNomes = r'''
ListenableBuilder(
  listenable: Listenable.merge([_nome, _passo]),
  builder: (context, _) => Wrap(
    spacing: 8,
    runSpacing: 12,
    crossAxisAlignment: WrapCrossAlignment.center,
    children: [
      for (final letra in _letrasDoNome())
        SgRoller3DDigit(
          value: letra,
          items: _alfabeto,
          fontSize: 28,
          transitionMs: 110,
        ),
      SgButton(
        label: Text(context.tx('Animar nome')),
        size: SgSize.sm,
        onClick: _animarNome,
      ),
    ],
  ),
)
''';

  /// Region `sg-roller3d-digit-tamanhos`.
  static const String sgRoller3dDigitTamanhos = r'''
Wrap(
  spacing: 16,
  runSpacing: 12,
  crossAxisAlignment: WrapCrossAlignment.end,
  children: [
    for (final tamanho in const [16, 32, 56])
      Column(
        children: [
          Text('${tamanho}px'),
          SgRoller3DDigit(value: '5', fontSize: tamanho.toDouble()),
        ],
      ),
  ],
)
''';
}
