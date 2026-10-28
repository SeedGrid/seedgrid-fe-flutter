// Showcase do SgTimeProvider (e do useSgTime). O codigo exibido em cada exemplo e o trecho entre
// `// #region` e `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';
import 'sg_time_provider_page.snippets.g.dart';

class SgTimeProviderPage extends StatelessWidget {
  const SgTimeProviderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Uma hora para toda a árvore',
        description:
            'Os relógios abaixo não têm initialServerTime: leem a hora do SgTimeProvider e andam juntos, alinhados à virada do segundo.',
        preview:
            // #region sg-time-provider-basico
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
            ),
        // #endregion
        code: SgTimeProviderPageSnippets.sgTimeProviderBasico,
      ),
      ShowcaseExample(
        title: 'Lendo o contexto de tempo',
        description:
            'useSgTime(context) devolve serverStartMs, tick e nowMs. O tick sobe a cada segundo e reconstrói quem o lê.',
        preview:
            // #region sg-time-provider-leitura
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
            ),
        // #endregion
        code: SgTimeProviderPageSnippets.sgTimeProviderLeitura,
      ),
      ShowcaseExample(
        title: 'Hora do servidor diferente da do aparelho',
        description:
            'É o uso típico: o servidor manda a hora certa e a tela segue por ela, sem depender do relógio do aparelho.',
        preview:
            // #region sg-time-provider-servidor
            SgTimeProvider(
              initialServerTime: '2030-01-01T23:59:55Z',
              child: SgClock(
                timezone: 'UTC',
                cardTitle: Text(context.tx('Hora do servidor')),
              ),
            ),
        // #endregion
        code: SgTimeProviderPageSnippets.sgTimeProviderServidor,
      ),
      ShowcaseExample(
        title: 'Sem provider',
        description:
            'Fora de um SgTimeProvider, useSgTime devolve um relógio local (tick 0) e o SgClock cuida do próprio segundo.',
        preview:
            // #region sg-time-provider-sem
            Builder(
              builder: (context) {
                final tempo = useSgTime(context);
                return Text('Sem provider: tick ${tempo.tick}');
              },
            ),
        // #endregion
        code: SgTimeProviderPageSnippets.sgTimeProviderSem,
      ),
    ];

    return SgShowcasePage(
      name: 'SgTimeProvider',
      description:
          'Fornece a hora do servidor a toda a árvore e avisa a cada segundo; useSgTime lê esse contexto.',
      examples: examples,
      propSpecs: sgPropSpecs['SgTimeProvider']!,
      playground: SgPlayground(
        specs: sgPropSpecs['SgTimeProvider']!
            .where((s) => s.name == 'initialServerTime')
            .toList(),
        builder: (context, v) {
          final inicio =
              (v['initialServerTime'] as String?) ?? '2026-06-15T09:41:07Z';
          return SgTimeProvider(
            key: ValueKey(inicio),
            initialServerTime: inicio,
            child: const SgClock(timezone: 'UTC'),
          );
        },
        codeBuilder: (v) =>
            "SgTimeProvider(\n  initialServerTime: '${(v['initialServerTime'] as String?) ?? '2026-06-15T09:41:07Z'}',\n  child: const SgClock(timezone: 'UTC'),\n)",
      ),
    );
  }
}
