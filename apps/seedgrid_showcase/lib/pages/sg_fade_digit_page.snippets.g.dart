// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_fade_digit_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgFadeDigitPageSnippets {
  /// Region `sg-fade-digit-auto`.
  static const String sgFadeDigitAuto = r'''
Wrap(
  spacing: 16,
  runSpacing: 12,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    ValueListenableBuilder<int>(
      valueListenable: _contador,
      builder: (context, contador, _) =>
          SgFadeDigit(value: '$contador'),
    ),
    ValueListenableBuilder<bool>(
      valueListenable: _rodando,
      builder: (context, rodando, _) => SgButton(
        label: Text(context.tx(rodando ? 'Parar' : 'Iniciar')),
        onClick: _alternarContador,
      ),
    ),
  ],
)
''';

  /// Region `sg-fade-digit-basico`.
  static const String sgFadeDigitBasico = r'''
Wrap(
  spacing: 16,
  runSpacing: 12,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    ValueListenableBuilder<int>(
      valueListenable: _digito,
      builder: (context, digito, _) =>
          SgFadeDigit(value: '$digito'),
    ),
    Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        SgButton(
          label: Text(context.tx('Próximo (+1)')),
          onClick: () => _digito.value = (_digito.value + 1) % 10,
        ),
        SgButton(
          label: Text(context.tx('Anterior (-1)')),
          onClick: () => _digito.value = (_digito.value + 9) % 10,
        ),
        SgButton(
          label: Text(context.tx('Aleatório')),
          onClick: () => _digito.value =
              (_digito.value + 1 + Random().nextInt(9)) % 10,
        ),
      ],
    ),
  ],
)
''';

  /// Region `sg-fade-digit-cartao`.
  static const String sgFadeDigitCartao = r'''
const Row(
  mainAxisSize: MainAxisSize.min,
  children: [
    SgFadeDigit(value: '1'),
    SizedBox(width: 8),
    SgFadeDigit(value: '4'),
    SizedBox(width: 8),
    SgFadeDigit(value: '0'),
    SizedBox(width: 8),
    SgFadeDigit(value: '7'),
  ],
)
''';

  /// Region `sg-fade-digit-cores`.
  static const String sgFadeDigitCores = r'''
const Wrap(
  spacing: 12,
  runSpacing: 12,
  crossAxisAlignment: WrapCrossAlignment.end,
  children: [
    SgFadeDigit(
      value: '2',
      color: '#111827',
      backgroundColor: '#fde68a',
    ),
    SgFadeDigit(
      value: '9',
      fontSize: 40,
      color: '#22c55e',
      backgroundColor: '#052e16',
    ),
    SgFadeDigit(value: '0', fontSize: 100),
    SgFadeDigit(value: '1', fontSize: 24, font: 'monospace'),
  ],
)
''';

  /// Region `sg-fade-digit-letras`.
  static const String sgFadeDigitLetras = r'''
Wrap(
  spacing: 16,
  runSpacing: 12,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    ValueListenableBuilder<int>(
      valueListenable: _letra,
      builder: (context, letra, _) =>
          SgFadeDigit(value: String.fromCharCode(65 + letra)),
    ),
    SgButton(
      label: Text(context.tx('Próxima letra')),
      onClick: () => _letra.value = (_letra.value + 1) % 26,
    ),
  ],
)
''';

  /// Region `sg-fade-digit-personalizadas`.
  static const String sgFadeDigitPersonalizadas = r'''
Wrap(
  spacing: 16,
  runSpacing: 12,
  crossAxisAlignment: WrapCrossAlignment.end,
  children: [
    Column(
      children: [
        Text(context.tx('Padrão')),
        const SgFadeDigit(
          value: '7',
          color: '#edebeb',
          backgroundColor: '#333232',
        ),
      ],
    ),
    Column(
      children: [
        Text(context.tx('Verde')),
        const SgFadeDigit(
          value: '7',
          color: '#4ade80',
          backgroundColor: '#052e16',
        ),
      ],
    ),
    Column(
      children: [
        Text(context.tx('Azul')),
        const SgFadeDigit(
          value: '7',
          color: '#60a5fa',
          backgroundColor: '#0f172a',
        ),
      ],
    ),
    Column(
      children: [
        Text(context.tx('Rosa')),
        const SgFadeDigit(
          value: '7',
          color: '#f472b6',
          backgroundColor: '#2d0a1e',
        ),
      ],
    ),
    Column(
      children: [
        Text(context.tx('Âmbar')),
        const SgFadeDigit(
          value: '7',
          color: '#fbbf24',
          backgroundColor: '#1c1007',
        ),
      ],
    ),
  ],
)
''';

  /// Region `sg-fade-digit-relogio`.
  static const String sgFadeDigitRelogio = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    ValueListenableBuilder<int>(
      valueListenable: _segundos,
      builder: (context, total, _) {
        String dois(int n) => n.toString().padLeft(2, '0');
        final horas = dois(total ~/ 3600);
        final minutos = dois(total % 3600 ~/ 60);
        final segundos = dois(total % 60);
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            SgFadeDigit(value: horas[0]),
            SgFadeDigit(value: horas[1]),
            const Text(
              ':',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            SgFadeDigit(value: minutos[0]),
            SgFadeDigit(value: minutos[1]),
            const Text(
              ':',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            SgFadeDigit(value: segundos[0]),
            SgFadeDigit(value: segundos[1]),
          ],
        );
      },
    ),
    const SizedBox(height: 12),
    ValueListenableBuilder<bool>(
      valueListenable: _relogioRodando,
      builder: (context, rodando, _) => SgButton(
        label: Text(context.tx(rodando ? 'Parar' : 'Iniciar')),
        size: SgSize.sm,
        onClick: _alternarRelogio,
      ),
    ),
  ],
)
''';

  /// Region `sg-fade-digit-tamanhos`.
  static const String sgFadeDigitTamanhos = r'''
Wrap(
  spacing: 24,
  runSpacing: 12,
  crossAxisAlignment: WrapCrossAlignment.end,
  children: [
    Column(
      children: [
        Text(context.tx('Pequeno (40px)')),
        const SgFadeDigit(value: '5', fontSize: 40),
      ],
    ),
    Column(
      children: [
        Text(context.tx('Médio (70px)')),
        const SgFadeDigit(value: '5', fontSize: 70),
      ],
    ),
    Column(
      children: [
        Text(context.tx('Grande (110px)')),
        const SgFadeDigit(value: '5', fontSize: 110),
      ],
    ),
  ],
)
''';

  /// Region `sg-fade-digit-troca`.
  static const String sgFadeDigitTroca = r'''
Builder(
  builder: (context) {
    var value = 0;
    return StatefulBuilder(
      builder: (context, set) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SgFadeDigit(value: '$value'),
          const SizedBox(width: 24),
          SgButton(
            label: Text(context.tx('Próximo')),
            onClick: () => set(() => value = (value + 1) % 10),
          ),
        ],
      ),
    );
  },
)
''';
}
