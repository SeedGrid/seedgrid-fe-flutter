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
    SgRoller3DDigit(value: '$_digit', fontSize: 32),
    SgButton(
      label: Text(context.tx('Próximo')),
      onClick: () => setState(() => _digit = (_digit + 1) % 10),
    ),
    SgButton(
      label: Text(context.tx('Aleatório')),
      appearance: SgAppearance.outline,
      onClick: () => setState(() => _digit = (_digit * 7 + 3) % 10),
    ),
  ],
)
''';

  /// Region `sg-roller3d-digit-duracao`.
  static const String sgRoller3dDigitDuracao = r'''
Wrap(
  spacing: 16,
  runSpacing: 12,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    SgRoller3DDigit(
      value: _slow ? '9' : '0',
      transitionMs: 150,
      fontSize: 28,
    ),
    SgRoller3DDigit(
      value: _slow ? '9' : '0',
      transitionMs: 1500,
      fontSize: 28,
    ),
    SgButton(
      label: Text(context.tx('Alternar 0 e 9')),
      onClick: () => setState(() => _slow = !_slow),
    ),
  ],
)
''';

  /// Region `sg-roller3d-digit-letras`.
  static const String sgRoller3dDigitLetras = r'''
Wrap(
  spacing: 16,
  runSpacing: 12,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    SgRoller3DDigit(
      value: String.fromCharCode(65 + _letter),
      items: List.generate(26, (i) => String.fromCharCode(65 + i)),
      fontSize: 32,
    ),
    SgButton(
      label: Text(context.tx('Próxima letra')),
      onClick: () => setState(() => _letter = (_letter + 5) % 26),
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
    SgRoller3DDigit(
      value: _minute.toString().padLeft(2, '0'),
      items: List.generate(60, (i) => i.toString().padLeft(2, '0')),
      fontSize: 22,
    ),
    SgButton(
      label: Text(context.tx('+7 minutos')),
      onClick: () => setState(() => _minute = (_minute + 7) % 60),
    ),
  ],
)
''';
}
