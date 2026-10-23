// Showcase do SgInputCurrency. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import 'sg_input_currency_page.snippets.g.dart';

class SgInputCurrencyPage extends StatefulWidget {
  const SgInputCurrencyPage({super.key});

  @override
  State<SgInputCurrencyPage> createState() => _SgInputCurrencyPageState();
}

class _SgInputCurrencyPageState extends State<SgInputCurrencyPage> {
  final SgFormController _form = SgFormController(defaultValues: {'preco': ''});
  String _valor = '';
  String _enviado = '';

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Básico',
        description:
            'Moeda padrão BRL no idioma do SgComponentsI18nProvider. onChange recebe o valor canônico com ponto.',
        preview:
            // #region sg-input-currency-basico
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgInputCurrency(
                  id: 'preco',
                  labelText: 'Preço',
                  onChange: (v) => setState(() => _valor = v),
                ),
                const SizedBox(height: 8),
                Text(
                  'onChange: ${_valor.isEmpty ? '(nada digitado)' : _valor}',
                ),
              ],
            ),
        // #endregion
        code: SgInputCurrencyPageSnippets.sgInputCurrencyBasico,
      ),
      ShowcaseExample(
        title: 'Moedas e locales',
        description:
            'currency e locale escolhem símbolo, posição e separadores (Intl). JPY não tem casas decimais.',
        preview:
            // #region sg-input-currency-moedas
            const Column(
              children: [
                SgInputCurrency(
                  id: 'usd',
                  labelText: 'Dólar (en-US)',
                  currency: 'USD',
                  locale: 'en-US',
                  initialValue: '1234.5',
                ),
                SizedBox(height: 12),
                SgInputCurrency(
                  id: 'eur',
                  labelText: 'Euro (fr)',
                  currency: 'EUR',
                  locale: 'fr',
                  initialValue: '1234.5',
                ),
                SizedBox(height: 12),
                SgInputCurrency(
                  id: 'jpy',
                  labelText: 'Iene (sem casas)',
                  currency: 'JPY',
                  initialValue: '1234',
                ),
              ],
            ),
        // #endregion
        code: SgInputCurrencyPageSnippets.sgInputCurrencyMoedas,
      ),
      ShowcaseExample(
        title: 'Símbolo e agrupamento',
        description:
            'currencyDisplay, currencySymbolPlacement, currencySymbolOverride, showCurrencySymbol e useGrouping.',
        preview:
            // #region sg-input-currency-simbolo
            const Column(
              children: [
                SgInputCurrency(
                  id: 'codigo',
                  labelText: 'Código no fim',
                  currencyDisplay: SgInputCurrencyCurrencyDisplay.code,
                  currencySymbolPlacement:
                      SgInputCurrencyCurrencySymbolPlacement.suffix,
                  initialValue: '1234.5',
                ),
                SizedBox(height: 12),
                SgInputCurrency(
                  id: 'pontos',
                  labelText: 'Símbolo próprio',
                  currencySymbolOverride: 'pts',
                  initialValue: '10',
                ),
                SizedBox(height: 12),
                SgInputCurrency(
                  id: 'semsimbolo',
                  labelText: 'Sem símbolo nem milhar',
                  showCurrencySymbol: false,
                  useGrouping: false,
                  initialValue: '1234567.8',
                ),
              ],
            ),
        // #endregion
        code: SgInputCurrencyPageSnippets.sgInputCurrencySimbolo,
      ),
      ShowcaseExample(
        title: 'Validação',
        description:
            'required (zero conta como vazio), minValue e maxValue; mensagens do idioma ou próprias.',
        preview:
            // #region sg-input-currency-validacao
            const Column(
              children: [
                SgInputCurrency(
                  id: 'obrigatorio',
                  labelText: 'Obrigatório',
                  required: true,
                ),
                SizedBox(height: 12),
                SgInputCurrency(
                  id: 'faixa',
                  labelText: 'Entre 10 e 500',
                  minValue: 10,
                  maxValue: 500,
                  maxValueMessage: 'Acima do limite',
                ),
              ],
            ),
        // #endregion
        code: SgInputCurrencyPageSnippets.sgInputCurrencyValidacao,
      ),
      ShowcaseExample(
        title: 'Dentro de um formulário',
        description:
            'name + control + rules. O formulário guarda o valor canônico com ponto.',
        preview:
            // #region sg-input-currency-formulario
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgInputCurrency(
                  id: 'preco-form',
                  name: 'preco',
                  control: _form,
                  labelText: 'Preço',
                  emptyValue: SgInputCurrencyEmptyValue.nullValue,
                  required: true,
                  requiredMessage: 'Informe o preço',
                  rules: SgRules(
                    validate: (v) =>
                        (num.tryParse('$v') ?? 0) > 0 ? true : 'Maior que zero',
                  ),
                ),
                const SizedBox(height: 12),
                SgButton(
                  label: const Text('Enviar'),
                  onClick: () => _form.handleSubmit(
                    (values) => setState(() => _enviado = '${values['preco']}'),
                  ),
                ),
                if (_enviado.isNotEmpty) Text('Enviado: $_enviado'),
              ],
            ),
        // #endregion
        code: SgInputCurrencyPageSnippets.sgInputCurrencyFormulario,
      ),
    ];

    // currencyDisplay e currencySymbolPlacement ficam de fora: o dropdown do SgPlayground (arquivo
    // compartilhado, sem isExpanded) estoura 1,8 px com esses rotulos longos; os dois estao nos exemplos.
    const playgroundProps = {
      'emptyValue',
      'allowNegative',
      'disabled',
      'readOnly',
      'required',
      'filled',
      'withBorder',
      'clearButton',
      'showCurrencySymbol',
      'useGrouping',
      'currency',
      'locale',
    };
    return SgShowcasePage(
      name: 'SgInputCurrency',
      description:
          'Campo de moeda com símbolo, posição e separadores do idioma (Intl), casas da moeda, limites e ligação a formulário.',
      examples: examples,
      propSpecs: [
        ...sgPropSpecs['SgInputCurrency']!,
        const SgPropSpec(
          name: 'initialValue',
          reactName: 'inputProps.defaultValue',
          type: 'Object?',
          tsType: 'string | number',
          required: false,
          description: 'Valor inicial sem formulário ("1234.56").',
          exact: false,
        ),
        const SgPropSpec(
          name: 'value',
          reactName: 'inputProps.value',
          type: 'Object?',
          tsType: 'string | number',
          required: false,
          description: 'Valor controlado de fora; mudar atualiza o campo.',
          exact: false,
        ),
      ],
      playground: SgPlayground(
        specs: sgPropSpecs['SgInputCurrency']!
            .where((s) => playgroundProps.contains(s.name))
            .toList(),
        builder: (context, v) => SgInputCurrency(
          key: ValueKey(
            'pg-${v['emptyValue']}-${v['currency']}-${v['locale']}',
          ),
          id: 'pg',
          labelText: 'Valor',
          currency: v['currency'] as String?,
          locale: v['locale'] as String?,
          currencyDisplay: SgInputCurrencyCurrencyDisplay.fromValue(
            v['currencyDisplay'] as String?,
          ),
          currencySymbolPlacement:
              SgInputCurrencyCurrencySymbolPlacement.fromValue(
                v['currencySymbolPlacement'] as String?,
              ),
          emptyValue: SgInputCurrencyEmptyValue.fromValue(
            v['emptyValue'] as String?,
          ),
          allowNegative: v['allowNegative'] as bool?,
          disabled: v['disabled'] as bool?,
          readOnly: v['readOnly'] as bool?,
          required: v['required'] as bool?,
          filled: v['filled'] as bool?,
          withBorder: v['withBorder'] as bool?,
          clearButton: v['clearButton'] as bool?,
          showCurrencySymbol: v['showCurrencySymbol'] as bool?,
          useGrouping: v['useGrouping'] as bool?,
        ),
        codeBuilder: (v) {
          final args = <String>["id: 'pg'", "labelText: 'Valor'"];
          for (final e in v.entries) {
            if (e.value == null || e.value == false) continue;
            args.add(switch (e.key) {
              'currencyDisplay' =>
                'currencyDisplay: SgInputCurrencyCurrencyDisplay.${SgInputCurrencyCurrencyDisplay.fromValue(e.value as String)!.name}',
              'currencySymbolPlacement' =>
                'currencySymbolPlacement: SgInputCurrencyCurrencySymbolPlacement.${SgInputCurrencyCurrencySymbolPlacement.fromValue(e.value as String)!.name}',
              'emptyValue' =>
                'emptyValue: SgInputCurrencyEmptyValue.${SgInputCurrencyEmptyValue.fromValue(e.value as String)!.name}',
              final k when e.value is String => "$k: '${e.value}'",
              _ => '${e.key}: ${e.value}',
            });
          }
          return 'SgInputCurrency(\n  ${args.join(',\n  ')},\n)';
        },
      ),
    );
  }
}
