// Showcase do SgQRCode. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.

import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';
import 'sg_qr_code_page.snippets.g.dart';

class SgQRCodePage extends StatelessWidget {
  const SgQRCodePage({super.key});

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Exemplo interativo',
        description: 'Altere o valor do QR Code, o logo central e o tamanho.',
        preview:
            // #region sg-qr-code-interativo
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
            ),
        // #endregion
        code: SgQrCodePageSnippets.sgQrCodeInterativo,
      ),
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
            'O logo central tem tamanho, respiro e cantos configuráveis (logoSize, logoPadding e logoBorderRadius).',
        preview:
            // #region sg-qr-code-logo
            SgQRCode(
              value: 'https://seedgrid.com.br/logo',
              size: 200,
              logoImage: const AssetImage('assets/logo-seedgrid.png'),
              logoSize: 56,
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
            SgQRCode(
              value: '',
              size: 120,
              emptyFallback: Text(context.tx('Informe um texto')),
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
