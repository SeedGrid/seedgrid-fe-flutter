// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de lib/pages/*.dart: o mesmo codigo que a pagina renderiza.

abstract final class Snippets {
  /// modelo_page.dart, region `modelo-alto`.
  static const String modeloAlto = r'''
const SizedBox(
  height: 420,
  child: Center(child: Text('Conteúdo alto')),
)
''';

  /// modelo_page.dart, region `modelo-alto-2`.
  static const String modeloAlto2 = r'''
const SizedBox(
  height: 520,
  child: Center(child: Text('Mais conteúdo')),
)
''';

  /// modelo_page.dart, region `modelo-botoes`.
  static const String modeloBotoes = r'''
Row(
  children: [
    FilledButton(onPressed: () {}, child: const Text('Salvar')),
    const SizedBox(width: 8),
    OutlinedButton(onPressed: () {}, child: const Text('Cancelar')),
  ],
)
''';

  /// modelo_page.dart, region `modelo-coluna`.
  static const String modeloColuna = r'''
const Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [Text('Linha 1'), Text('Linha 2'), Text('Linha 3')],
)
''';

  /// modelo_page.dart, region `modelo-texto`.
  static const String modeloTexto = r'''
const Text('Olá, SeedGrid')
''';

  /// modelo_page.dart, region `modelo-ultimo`.
  static const String modeloUltimo = r'''
const Chip(label: Text('Fim'))
''';

  /// sg_button_page.dart, region `sg-button-aparencias`.
  static const String sgButtonAparencias = r'''
Wrap(
  spacing: 8,
  runSpacing: 8,
  children: [
    SgButton(label: const Text('Solid'), onClick: () {}),
    SgButton(
      label: const Text('Outline'),
      appearance: SgAppearance.outline,
      onClick: () {},
    ),
    SgButton(
      label: const Text('Ghost'),
      appearance: SgAppearance.ghost,
      onClick: () {},
    ),
  ],
)
''';

  /// sg_button_page.dart, region `sg-button-cores`.
  static const String sgButtonCores = r'''
SgButton(
  label: const Text('Roxo'),
  customColors: const SgButtonCustomColors(
    bg: Color(0xFF7C3AED),
    fg: Colors.white,
    border: Color(0xFF6D28D9),
    hoverBg: Color(0xFF6D28D9),
  ),
  onClick: () {},
)
''';

  /// sg_button_page.dart, region `sg-button-icones`.
  static const String sgButtonIcones = r'''
Wrap(
  spacing: 8,
  runSpacing: 8,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    SgButton(
      label: const Text('Adicionar'),
      leftIcon: const Icon(Icons.add),
      onClick: () {},
    ),
    SgButton(
      label: const Text('Próximo'),
      rightIcon: const Icon(Icons.arrow_forward),
      onClick: () {},
    ),
    SgButton(leftIcon: const Icon(Icons.search), onClick: () {}),
    const SgButton(label: Text('Salvando'), loading: true),
    const SgButton(label: Text('Desabilitado'), disabled: true),
  ],
)
''';

  /// sg_button_page.dart, region `sg-button-severidades`.
  static const String sgButtonSeveridades = r'''
Wrap(
  spacing: 8,
  runSpacing: 8,
  children: [
    SgButton(label: const Text('Primary'), onClick: () {}),
    SgButton(
      label: const Text('Secondary'),
      severity: SgSeverity.secondary,
      onClick: () {},
    ),
    SgButton(
      label: const Text('Success'),
      severity: SgSeverity.success,
      onClick: () {},
    ),
    SgButton(
      label: const Text('Info'),
      severity: SgSeverity.info,
      onClick: () {},
    ),
    SgButton(
      label: const Text('Warning'),
      severity: SgSeverity.warning,
      onClick: () {},
    ),
    SgButton(
      label: const Text('Help'),
      severity: SgSeverity.help,
      onClick: () {},
    ),
    SgButton(
      label: const Text('Danger'),
      severity: SgSeverity.danger,
      onClick: () {},
    ),
  ],
)
''';

  /// sg_button_page.dart, region `sg-button-tamanhos`.
  static const String sgButtonTamanhos = r'''
Wrap(
  spacing: 8,
  runSpacing: 8,
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    SgButton(
      label: const Text('Small'),
      size: SgSize.sm,
      onClick: () {},
    ),
    SgButton(label: const Text('Medium'), onClick: () {}),
    SgButton(
      label: const Text('Large'),
      size: SgSize.lg,
      onClick: () {},
    ),
    SgButton(
      label: const Text('Rounded'),
      shape: SgButtonShape.rounded,
      onClick: () {},
    ),
    SgButton(
      label: const Text('Square'),
      shape: SgButtonShape.square,
      onClick: () {},
    ),
    SgButton(
      label: const Text('Sombra'),
      elevation: SgElevation.md,
      onClick: () {},
    ),
  ],
)
''';

  /// sg_input_text_page.dart, region `sg-input-text-afixos`.
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

  /// sg_input_text_page.dart, region `sg-input-text-basico`.
  static const String sgInputTextBasico = r'''
const SgInputText(
  id: 'nome',
  labelText: 'Nome',
  placeholder: 'Digite seu nome',
)
''';

  /// sg_input_text_page.dart, region `sg-input-text-formulario`.
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

  /// sg_input_text_page.dart, region `sg-input-text-rotulo`.
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

  /// sg_input_text_page.dart, region `sg-input-text-validacao`.
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
