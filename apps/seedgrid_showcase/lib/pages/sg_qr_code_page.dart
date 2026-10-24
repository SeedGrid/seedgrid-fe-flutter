// Showcase do SgQRCode. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import 'sg_qr_code_page.snippets.g.dart';

class SgQRCodePage extends StatelessWidget {
  const SgQRCodePage({super.key});

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'QR Code básico',
        description:
            'Gera a matriz do texto (nível de correção H por padrão) e a desenha sem suavização.',
        preview:
            // #region sg-qr-code-basico
            const SgQRCode(value: 'https://seedgrid.com.br'),
        // #endregion
        code: SgQrCodePageSnippets.sgQrCodeBasico,
      ),
      ShowcaseExample(
        title: 'Cores, tamanho e margem',
        description:
            'fgColor e bgColor aceitam hex, rgb e tokens do tema; size é o lado em px e margin conta módulos.',
        preview:
            // #region sg-qr-code-cores
            const SgQRCode(
              value: 'seedgrid',
              size: 160,
              margin: 1,
              fgColor: '#1d4ed8',
              bgColor: '#e0f2fe',
              errorCorrectionLevel: SgQRCodeErrorCorrectionLevel.m,
            ),
        // #endregion
        code: SgQrCodePageSnippets.sgQrCodeCores,
      ),
      ShowcaseExample(
        title: 'Logo no centro',
        description:
            'logoSrc (URL) ou logoImage (qualquer ImageProvider) com tamanho, respiro e cantos configuráveis.',
        preview:
            // #region sg-qr-code-logo
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
            ),
        // #endregion
        code: SgQrCodePageSnippets.sgQrCodeLogo,
      ),
      ShowcaseExample(
        title: 'Vazio e erro',
        description:
            'Texto vazio mostra emptyFallback; texto grande demais chama onGenerateError.',
        preview:
            // #region sg-qr-code-vazio
            const SgQRCode(
              value: '',
              size: 120,
              emptyFallback: Text('Informe um texto'),
            ),
        // #endregion
        code: SgQrCodePageSnippets.sgQrCodeVazio,
      ),
    ];

    return SgShowcasePage(
      name: 'SgQRCode',
      description:
          'Gera QR Code a partir de um texto, com cores, margem, nível de correção de erro e logo central.',
      examples: examples,
      propSpecs: [
        ...sgPropSpecs['SgQRCode']!,
        const SgPropSpec(
          name: 'logoImage',
          reactName: 'logoSrc (imagem local)',
          type: 'ImageProvider?',
          tsType: 'string',
          required: false,
          description:
              'Imagem central local ou em memória. Tem precedência sobre logoSrc, que só carrega URLs.',
        ),
      ],
      playground: SgPlayground(
        specs: sgPropSpecs['SgQRCode']!
            .where(
              (s) => const {
                'errorCorrectionLevel',
                'value',
                'fgColor',
                'bgColor',
              }.contains(s.name),
            )
            .toList(),
        builder: (context, v) => SgQRCode(
          value: (v['value'] as String?) ?? 'https://seedgrid.com.br',
          size: 180,
          fgColor: (v['fgColor'] as String?) ?? '#000000',
          bgColor: (v['bgColor'] as String?) ?? '#FFFFFF',
          errorCorrectionLevel:
              SgQRCodeErrorCorrectionLevel.fromValue(
                v['errorCorrectionLevel'] as String?,
              ) ??
              SgQRCodeErrorCorrectionLevel.h,
        ),
        codeBuilder: (v) {
          final args = <String>[
            "value: '${(v['value'] as String?) ?? 'https://seedgrid.com.br'}'",
            'size: 180',
          ];
          for (final e in v.entries) {
            if (e.value == null || e.value == false || e.key == 'value') {
              continue;
            }
            args.add(switch (e.key) {
              'errorCorrectionLevel' =>
                'errorCorrectionLevel: SgQRCodeErrorCorrectionLevel.${SgQRCodeErrorCorrectionLevel.fromValue(e.value as String)!.name}',
              _ => "${e.key}: '${e.value}'",
            });
          }
          return 'SgQRCode(\n  ${args.join(',\n  ')},\n)';
        },
      ),
    );
  }
}
