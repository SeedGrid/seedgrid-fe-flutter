// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_group_box_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgGroupBoxPageSnippets {
  /// Region `sg-group-box-basico`.
  static const String sgGroupBoxBasico = r'''
SgGroupBox(
  title: context.tx('Dados pessoais'),
  child: SgGrid(
    minItemWidth: 200,
    gap: 12,
    children: [
      SgInputText(id: 'gb-campo-1', labelText: context.tx('Campo 1')),
      SgInputText(id: 'gb-campo-2', labelText: context.tx('Campo 2')),
    ],
  ),
)
''';

  /// Region `sg-group-box-classe`.
  static const String sgGroupBoxClasse = r'''
Container(
  padding: const EdgeInsets.all(8),
  decoration: BoxDecoration(
    color: Theme.of(
      context,
    ).colorScheme.onSurface.withValues(alpha: 0.05),
    borderRadius: BorderRadius.circular(12),
  ),
  child: SgGroupBox(
    title: context.tx('Classe customizada'),
    child: Text(context.tx('Conteúdo')),
  ),
)
''';

  /// Region `sg-group-box-formulario`.
  static const String sgGroupBoxFormulario = r'''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SgGroupBox(
      title: context.tx('Cadastro'),
      child: SgGrid(
        minItemWidth: 240,
        gap: 16,
        children: [
          SgInputText(
            id: 'name',
            name: 'name',
            control: _form,
            labelText: context.tx('Nome completo'),
            required: true,
          ),
          SgInputEmail(
            id: 'email',
            name: 'email',
            control: _form,
            labelText: context.tx('Email'),
            required: true,
          ),
          SgInputPhone(
            id: 'phone',
            name: 'phone',
            control: _form,
            labelText: context.tx('Telefone'),
            required: true,
          ),
          SgInputPostalCode(
            id: 'cep',
            name: 'cep',
            control: _form,
            labelText: context.tx('CEP'),
            required: true,
          ),
          SgInputPassword(
            id: 'password',
            name: 'password',
            control: _form,
            labelText: context.tx('Senha'),
            required: true,
          ),
        ],
      ),
    ),
    const SizedBox(height: 12),
    ListenableBuilder(
      listenable: _form,
      builder: (context, _) =>
          Text('${context.tx('Valores')}: ${_form.getValues()}'),
    ),
  ],
)
''';

  /// Region `sg-group-box-lado`.
  static const String sgGroupBoxLado = r'''
SgGrid(
  minItemWidth: 200,
  gap: 12,
  children: [
    SgGroupBox(
      title: context.tx('Entrega'),
      child: Text(context.tx('Rua das Flores, 100')),
    ),
    SgGroupBox(
      title: context.tx('Cobrança'),
      child: Text(context.tx('Mesmo endereço')),
    ),
  ],
)
''';

  /// Region `sg-group-box-tamanho`.
  static const String sgGroupBoxTamanho = r'''
SgStack(
  gap: 12,
  children: [
    SgGroupBox(
      title: context.tx('Largura 320px'),
      width: 320,
      child: Text(context.tx('Conteúdo')),
    ),
    SgGroupBox(
      title: context.tx('Altura 180px'),
      height: 180,
      child: Text(context.tx('Conteúdo')),
    ),
  ],
)
''';
}
