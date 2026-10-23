// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_input_text_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgInputTextPageSnippets {
  /// Region `sg-input-text-afixos`.
  static const String sgInputTextAfixos = r'''
const SgInputText(
  id: 'valor',
  labelText: 'Valor',
  prefixText: r'R$ ',
  suffixText: ' /mês',
  maxLength: 12,
  showCharCounter: true,
)
''';

  /// Region `sg-input-text-basico`.
  static const String sgInputTextBasico = r'''
const SgInputText(
  id: 'nome',
  labelText: 'Nome',
  placeholder: 'Digite seu nome',
)
''';

  /// Region `sg-input-text-formulario`.
  static const String sgInputTextFormulario = r'''
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
)
''';

  /// Region `sg-input-text-rotulo`.
  static const String sgInputTextRotulo = r'''
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
)
''';

  /// Region `sg-input-text-validacao`.
  static const String sgInputTextValidacao = r'''
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
)
''';
}
