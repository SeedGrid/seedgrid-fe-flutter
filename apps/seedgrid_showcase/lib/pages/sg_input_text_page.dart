// Showcase do SgInputText (e do contrato de formulario SgForm). O codigo exibido em cada exemplo e
// o trecho entre `// #region` e `// #endregion` deste arquivo.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../snippets.g.dart';
import '../src/sg_showcase_page.dart';

const int kSgInputTextExampleCount = 5;

class SgInputTextPage extends StatefulWidget {
  const SgInputTextPage({super.key});

  @override
  State<SgInputTextPage> createState() => _SgInputTextPageState();
}

class _SgInputTextPageState extends State<SgInputTextPage> {
  final SgFormController _form = SgFormController(defaultValues: {'email': ''});
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
        description: 'Rótulo flutuante, placeholder e botão de limpar.',
        preview:
            // #region sg-input-text-basico
            const SgInputText(
              id: 'nome',
              labelText: 'Nome',
              placeholder: 'Digite seu nome',
            ),
        // #endregion
        code: Snippets.sgInputTextBasico,
      ),
      ShowcaseExample(
        title: 'Posição do rótulo',
        preview:
            // #region sg-input-text-rotulo
            const Column(
              children: [
                SgInputText(
                  id: 'topo',
                  labelText: 'Rótulo no topo',
                  labelPosition: SgInputTextLabelPosition.top,
                ),
                SizedBox(height: 12),
                SgInputText(
                  id: 'esquerda',
                  labelText: 'À esquerda',
                  labelPosition: SgInputTextLabelPosition.left,
                  labelWidth: 110,
                ),
              ],
            ),
        // #endregion
        code: Snippets.sgInputTextRotulo,
      ),
      ShowcaseExample(
        title: 'Prefixo, sufixo e contador',
        description:
            'O valor entregue a onChange inclui prefixo e sufixo, como no React.',
        preview:
            // #region sg-input-text-afixos
            const SgInputText(
              id: 'valor',
              labelText: 'Valor',
              prefixText: r'R$ ',
              suffixText: ' /mês',
              maxLength: 12,
              showCharCounter: true,
            ),
        // #endregion
        code: Snippets.sgInputTextAfixos,
      ),
      ShowcaseExample(
        title: 'Validação',
        description:
            'Obrigatório, tamanho mínimo e validação própria; a mensagem aparece ao sair do campo.',
        preview:
            // #region sg-input-text-validacao
            Column(
              children: [
                const SgInputText(
                  id: 'obrigatorio',
                  labelText: 'Obrigatório',
                  required: true,
                ),
                const SizedBox(height: 12),
                const SgInputText(
                  id: 'minimo',
                  labelText: 'Mínimo de 5 letras',
                  minLength: 5,
                ),
                const SizedBox(height: 12),
                SgInputText(
                  id: 'proprio',
                  labelText: 'Só aceita "ok"',
                  validation: (v) => v == 'ok' ? null : 'Digite ok',
                ),
              ],
            ),
        // #endregion
        code: Snippets.sgInputTextValidacao,
      ),
      ShowcaseExample(
        title: 'Dentro de um formulário',
        description:
            'Equivale ao useForm do react-hook-form: name + control + rules.',
        preview:
            // #region sg-input-text-formulario
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgInputText(
                  id: 'email',
                  name: 'email',
                  control: _form,
                  labelText: 'E-mail',
                  rules: SgRules(
                    required: 'Informe o e-mail',
                    pattern: SgRuleValue(
                      RegExp(r'.+@.+\..+'),
                      'E-mail inválido',
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SgButton(
                  label: const Text('Enviar'),
                  onClick: () => _form.handleSubmit(
                    (values) => setState(() => _enviado = '${values['email']}'),
                  ),
                ),
                if (_enviado.isNotEmpty) Text('Enviado: $_enviado'),
              ],
            ),
        // #endregion
        code: Snippets.sgInputTextFormulario,
      ),
    ];

    return SgShowcasePage(
      name: 'SgInputText',
      description:
          'Campo de texto com rótulo, afixos, validação e ligação a formulário (SgForm).',
      examples: examples,
      propSpecs: sgPropSpecs['SgInputText']!,
      playground: SgPlayground(
        specs: sgPropSpecs['SgInputText']!
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
                'prefixText',
                'suffixText',
              }.contains(s.name),
            )
            .toList(),
        builder: (context, v) => SgInputText(
          id: 'pg',
          labelText: 'Rótulo',
          labelPosition: SgInputTextLabelPosition.fromValue(
            v['labelPosition'] as String?,
          ),
          filled: v['filled'] as bool?,
          disabled: v['disabled'] as bool?,
          readOnly: v['readOnly'] as bool?,
          clearButton: v['clearButton'] as bool?,
          required: v['required'] as bool?,
          hintText: v['hintText'] as String?,
          placeholder: v['placeholder'] as String?,
          prefixText: v['prefixText'] as String?,
          suffixText: v['suffixText'] as String?,
        ),
        codeBuilder: (v) {
          final args = <String>["id: 'pg'", "labelText: 'Rótulo'"];
          for (final e in v.entries) {
            if (e.value == null || e.value == false) continue;
            args.add(switch (e.key) {
              'labelPosition' =>
                'labelPosition: SgInputTextLabelPosition.${SgInputTextLabelPosition.fromValue(e.value as String)!.name}',
              final k when e.value is String => "$k: '${e.value}'",
              _ => '${e.key}: ${e.value}',
            });
          }
          return 'SgInputText(\n  ${args.join(',\n  ')},\n)';
        },
      ),
    );
  }
}
