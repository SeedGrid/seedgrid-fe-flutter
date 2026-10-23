// Showcase do SgInputPostalCode. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import 'sg_input_postal_code_page.snippets.g.dart';
import '../src/sg_showcase_page.dart';

class SgInputPostalCodePage extends StatefulWidget {
  const SgInputPostalCodePage({super.key});

  @override
  State<SgInputPostalCodePage> createState() => _SgInputPostalCodePageState();
}

class _SgInputPostalCodePageState extends State<SgInputPostalCodePage> {
  final SgFormController _form = SgFormController();
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
        title: 'CEP (padrão)',
        preview:
            // #region sg-input-postal-code-basico
            const SgInputPostalCode(id: 'cep', labelText: 'CEP'),
        // #endregion
        code: SgInputPostalCodePageSnippets.sgInputPostalCodeBasico,
      ),
      ShowcaseExample(
        title: 'Outros países',
        description: 'Cada país tem a sua máscara e o seu tamanho.',
        preview:
            // #region sg-input-postal-code-paises
            const Column(
              children: [
                SgInputPostalCode(
                  id: 'cp-pt',
                  labelText: 'Portugal',
                  country: SgInputPostalCodeCountry.pt,
                ),
                SizedBox(height: 12),
                SgInputPostalCode(
                  id: 'cp-us',
                  labelText: 'Estados Unidos',
                  country: SgInputPostalCodeCountry.us,
                ),
                SizedBox(height: 12),
                SgInputPostalCode(
                  id: 'cp-ar',
                  labelText: 'Argentina',
                  country: SgInputPostalCodeCountry.ar,
                ),
              ],
            ),
        // #endregion
        code: SgInputPostalCodePageSnippets.sgInputPostalCodePaises,
      ),
      ShowcaseExample(
        title: 'Consulta ao ViaCEP',
        description:
            'Aqui a consulta é simulada (viaCepFetch); só vale para o Brasil.',
        preview:
            // #region sg-input-postal-code-viacep
            SgInputPostalCode(
              id: 'cep-consulta',
              labelText: 'CEP com consulta',
              validateWithViaCep: true,
              viaCepErrorMessage: 'CEP inexistente',
              viaCepFetch: (cep) async => cep.startsWith('99')
                  ? const SgViaCepResult(erro: true)
                  : SgViaCepResult(cep: cep, uf: 'SP'),
            ),
        // #endregion
        code: SgInputPostalCodePageSnippets.sgInputPostalCodeViacep,
      ),
      ShowcaseExample(
        title: 'Dentro de um formulário',
        preview:
            // #region sg-input-postal-code-formulario
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgInputPostalCode(
                  id: 'campo',
                  name: 'campo',
                  control: _form,
                  labelText: 'Campo',
                  rules: const SgRules(required: 'Preencha o campo'),
                ),
                const SizedBox(height: 12),
                SgButton(
                  label: const Text('Enviar'),
                  onClick: () => _form.handleSubmit(
                    (values) => setState(() => _enviado = '${values['campo']}'),
                  ),
                ),
                if (_enviado.isNotEmpty) Text('Enviado: $_enviado'),
              ],
            ),
        // #endregion
        code: SgInputPostalCodePageSnippets.sgInputPostalCodeFormulario,
      ),
    ];

    return SgShowcasePage(
      name: 'SgInputPostalCode',
      description:
          'Código postal por país (BR, PT, US, ES, UY, AR, PY) com máscara e consulta opcional ao ViaCEP.',
      examples: examples,
      propSpecs: [
        ...sgPropSpecs['SgInputPostalCode']!,
        const SgPropSpec(
          name: 'initialValue',
          reactName: 'inputProps.defaultValue',
          type: 'String?',
          tsType: 'string',
          required: false,
          description:
              'Valor inicial quando não há control (lista fechada que substitui inputProps).',
        ),
        const SgPropSpec(
          name: 'autofocus',
          reactName: 'inputProps.autoFocus',
          type: 'bool',
          tsType: 'boolean',
          required: false,
          defaultValue: 'false',
          description: 'Foca o campo ao abrir.',
        ),
        const SgPropSpec(
          name: 'autofillHints',
          reactName: 'inputProps.autoComplete',
          type: 'Iterable<String>?',
          tsType: 'string',
          required: false,
          description: 'Dicas de preenchimento automático.',
          exact: false,
        ),
        const SgPropSpec(
          name: 'textInputAction',
          reactName: 'inputProps.enterKeyHint',
          type: 'TextInputAction?',
          tsType: 'string',
          required: false,
          description: 'Ação do botão de confirmar do teclado.',
          exact: false,
        ),
        const SgPropSpec(
          name: 'onSubmitted',
          reactName: 'inputProps.onKeyDown(Enter)',
          type: 'ValueChanged<String>?',
          tsType: '(value: string) => void',
          required: false,
          description: 'Chamado com o valor ao confirmar no teclado.',
          exact: false,
        ),
        const SgPropSpec(
          name: 'focusNode',
          reactName: 'inputProps.ref',
          type: 'FocusNode?',
          tsType: 'Ref<HTMLInputElement>',
          required: false,
          description: 'Controle externo do foco.',
          exact: false,
        ),
      ],
      playground: SgPlayground(
        specs: sgPropSpecs['SgInputPostalCode']!
            .where(
              (s) => const {
                'labelPosition',
                'filled',
                'disabled',
                'readOnly',
                'clearButton',
                'required',
                'hintText',
                'placeholder',
                'validateOnBlur',
                'showCharCounter',
                'country',
              }.contains(s.name),
            )
            .toList(),
        builder: (context, v) => SgInputPostalCode(
          id: 'pg',
          labelText: 'Rótulo',
          labelPosition: SgInputPostalCodeLabelPosition.fromValue(
            v['labelPosition'] as String?,
          ),
          country: SgInputPostalCodeCountry.fromValue(v['country'] as String?),
          filled: v['filled'] as bool?,
          disabled: v['disabled'] as bool?,
          readOnly: v['readOnly'] as bool?,
          clearButton: v['clearButton'] as bool?,
          required: v['required'] as bool?,
          validateOnBlur: v['validateOnBlur'] as bool?,
          showCharCounter: v['showCharCounter'] as bool?,
          hintText: v['hintText'] as String?,
          placeholder: v['placeholder'] as String?,
        ),
        codeBuilder: (v) {
          final args = <String>["id: 'pg'", "labelText: 'Rótulo'"];
          for (final e in v.entries) {
            if (e.value == null || e.value == false) continue;
            args.add(switch (e.key) {
              'labelPosition' =>
                'labelPosition: SgInputPostalCodeLabelPosition.${SgInputPostalCodeLabelPosition.fromValue(e.value as String)!.name}',
              'country' =>
                'country: SgInputPostalCodeCountry.${SgInputPostalCodeCountry.fromValue(e.value as String)!.name}',
              final k when e.value is String => "$k: '${e.value}'",
              _ => '${e.key}: ${e.value}',
            });
          }
          return 'SgInputPostalCode(\n  ${args.join(',\n  ')},\n)';
        },
      ),
    );
  }
}
