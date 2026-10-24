// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_time_provider_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgTimeProviderPageSnippets {
  /// Region `sg-time-provider-basico`.
  static const String sgTimeProviderBasico = r'''
const SgTimeProvider(
  initialServerTime: '2026-06-15T09:41:07Z',
  child: Wrap(
    spacing: 12,
    runSpacing: 12,
    children: [
      SgClock(timezone: 'UTC'),
      SgClock(timezone: 'Asia/Tokyo'),
    ],
  ),
)
''';

  /// Region `sg-time-provider-leitura`.
  static const String sgTimeProviderLeitura = r'''
SgTimeProvider(
  initialServerTime: '2026-06-15T09:41:07Z',
  child: Builder(
    builder: (context) {
      final tempo = useSgTime(context);
      final agora = DateTime.fromMillisecondsSinceEpoch(
        tempo.nowMs().floor(),
        isUtc: true,
      );
      return Text(
        'tick ${tempo.tick}, agora (UTC) ${agora.toIso8601String()}',
      );
    },
  ),
)
''';

  /// Region `sg-time-provider-sem`.
  static const String sgTimeProviderSem = r'''
Builder(
  builder: (context) {
    final tempo = useSgTime(context);
    return Text('Sem provider: tick ${tempo.tick}');
  },
)
''';

  /// Region `sg-time-provider-servidor`.
  static const String sgTimeProviderServidor = r'''
const SgTimeProvider(
  initialServerTime: '2030-01-01T23:59:55Z',
  child: SgClock(
    timezone: 'UTC',
    cardTitle: Text('Hora do servidor'),
  ),
)
''';
}
