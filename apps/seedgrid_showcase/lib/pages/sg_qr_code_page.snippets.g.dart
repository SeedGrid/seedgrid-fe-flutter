// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_qr_code_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgQrCodePageSnippets {
  /// Region `sg-qr-code-basico`.
  static const String sgQrCodeBasico = r'''
const SgQRCode(value: 'https://seedgrid.com.br')
''';

  /// Region `sg-qr-code-cores`.
  static const String sgQrCodeCores = r'''
const SgQRCode(
  value: 'seedgrid',
  size: 160,
  margin: 1,
  fgColor: '#1d4ed8',
  bgColor: '#e0f2fe',
  errorCorrectionLevel: SgQRCodeErrorCorrectionLevel.m,
)
''';

  /// Region `sg-qr-code-interativo`.
  static const String sgQrCodeInterativo = r'''
Builder(
  builder: (context) {
    var value = 'https://seedgrid.com.br';
    var comLogo = true;
    var size = 220.0;
    return StatefulBuilder(
      builder: (context, set) => Wrap(
        spacing: 24,
        runSpacing: 16,
        crossAxisAlignment: WrapCrossAlignment.start,
        children: [
          SizedBox(
            width: 320,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgInputText(
                  id: 'qr-valor',
                  labelText: context.tx('Valor do QR Code'),
                  placeholder: context.tx(
                    'Digite texto, URL ou payload PIX',
                  ),
                  value: value,
                  onChange: (v) => set(() => value = v),
                ),
                const SizedBox(height: 16),
                Text('${context.tx('Tamanho')}: ${size.round()}px'),
                SgSlider(
                  id: 'qr-tamanho',
                  minValue: 140,
                  maxValue: 360,
                  step: 4,
                  value: size,
                  ariaLabel: context.tx('Tamanho'),
                  onChange: (v) => set(() => size = v.toDouble()),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    SgButton(
                      label: Text('URL'),
                      onClick: () => set(
                        () => value = 'https://seedgrid.com.br',
                      ),
                    ),
                    SgButton(
                      severity: SgSeverity.secondary,
                      label: Text(context.tx('Exemplo PIX')),
                      onClick: () => set(
                        () => value =
                            '00020126580014BR.GOV.BCB.PIX0136contato@seedgrid.com.br5204000053039865802BR5922SEEDGRID TECNOLOGIA6009SAO PAULO62140510SEEDGRID1236304ABCD',
                      ),
                    ),
                    SgButton(
                      severity: SgSeverity.warning,
                      label: Text(context.tx('Sem logo')),
                      onClick: () => set(() => comLogo = false),
                    ),
                    SgButton(
                      severity: SgSeverity.success,
                      label: Text(context.tx('Com logo')),
                      onClick: () => set(() => comLogo = true),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SgQRCode(
            value: value,
            size: size,
            logoImage: comLogo
                ? const AssetImage('assets/logo-seedgrid.png')
                : null,
            emptyFallback: Text(context.tx('Informe um valor')),
          ),
        ],
      ),
    );
  },
)
''';

  /// Region `sg-qr-code-logo`.
  static const String sgQrCodeLogo = r'''
SgQRCode(
  value: 'https://seedgrid.com.br/logo',
  size: 200,
  logoImage: const AssetImage('assets/logo-seedgrid.png'),
  logoSize: 56,
  logoPadding: 4,
  logoBorderRadius: 8,
)
''';

  /// Region `sg-qr-code-vazio`.
  static const String sgQrCodeVazio = r'''
SgQRCode(
  value: '',
  size: 120,
  emptyFallback: Text(context.tx('Informe um texto')),
)
''';
}
