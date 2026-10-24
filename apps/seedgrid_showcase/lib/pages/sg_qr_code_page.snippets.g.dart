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

  /// Region `sg-qr-code-logo`.
  static const String sgQrCodeLogo = r'''
SgQRCode(
  value: 'https://seedgrid.com.br/logo',
  size: 200,
  logoImage: MemoryImage(
    base64Decode(
      'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg==',
    ),
  ),
  logoSize: 48,
  logoPadding: 4,
  logoBorderRadius: 8,
)
''';

  /// Region `sg-qr-code-vazio`.
  static const String sgQrCodeVazio = r'''
const SgQRCode(
  value: '',
  size: 120,
  emptyFallback: Text('Informe um texto'),
)
''';
}
