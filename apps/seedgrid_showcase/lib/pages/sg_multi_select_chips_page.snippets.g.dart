// dart format off
// GERADO por tools/showcase_snippets/extract.mjs. NAO EDITE A MAO.
// Cada constante e o trecho entre `// #region` e `// #endregion` de sg_multi_select_chips_page.dart: o mesmo codigo que a pagina renderiza.

abstract final class SgMultiSelectChipsPageSnippets {
  /// Region `sg-multi-select-chips-basico`.
  static const String sgMultiSelectChipsBasico = r'''
Wrap(
  spacing: 16,
  runSpacing: 16,
  children: [
    SizedBox(
      width: 384,
      child: ListenableBuilder(
        listenable: _vazio,
        builder: (context, _) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SgMultiSelectChips(
              id: 'msc-empty',
              labelText: context.tx('Empresas'),
              placeholder: context.tx('Selecione as empresas'),
              options: [
                SgMultiSelectOption(
                  label: 'Empresa 1',
                  value: 'e1',
                ),
                SgMultiSelectOption(
                  label: 'Empresa 2',
                  value: 'e2',
                ),
                SgMultiSelectOption(
                  label: 'Empresa 3',
                  value: 'e3',
                ),
                SgMultiSelectOption(
                  label: 'Empresa 4',
                  value: 'e4',
                ),
                SgMultiSelectOption(
                  label: 'Empresa 5',
                  value: 'e5',
                ),
                SgMultiSelectOption(
                  label: 'Empresa 6',
                  value: 'e6',
                ),
              ],
              value: _vazio.value,
              onChange: (v) => _vazio.value = v,
            ),
            const SizedBox(height: 8),
            Text(
              '${context.tx('Selecionadas')}: ${_vazio.value.isEmpty ? context.tx('(nenhuma)') : _vazio.value.join(', ')}',
            ),
          ],
        ),
      ),
    ),
    SizedBox(
      width: 384,
      child: ListenableBuilder(
        listenable: _preselecionadas,
        builder: (context, _) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SgMultiSelectChips(
              id: 'msc-preselected',
              labelText: context.tx('Empresas (com seleção)'),
              placeholder: context.tx('Selecione as empresas'),
              options: [
                SgMultiSelectOption(
                  label: 'Empresa 1',
                  value: 'e1',
                ),
                SgMultiSelectOption(
                  label: 'Empresa 2',
                  value: 'e2',
                ),
                SgMultiSelectOption(
                  label: 'Empresa 3',
                  value: 'e3',
                ),
                SgMultiSelectOption(
                  label: 'Empresa 4',
                  value: 'e4',
                ),
                SgMultiSelectOption(
                  label: 'Empresa 5',
                  value: 'e5',
                ),
                SgMultiSelectOption(
                  label: 'Empresa 6',
                  value: 'e6',
                ),
              ],
              value: _preselecionadas.value,
              onChange: (v) => _preselecionadas.value = v,
            ),
            const SizedBox(height: 8),
            Text(
              '${context.tx('Selecionadas')}: ${_preselecionadas.value.isEmpty ? context.tx('(nenhuma)') : _preselecionadas.value.join(', ')}',
            ),
          ],
        ),
      ),
    ),
  ],
)
''';

  /// Region `sg-multi-select-chips-busca`.
  static const String sgMultiSelectChipsBusca = r'''
SizedBox(
  width: 384,
  child: ListenableBuilder(
    listenable: _pesquisavel,
    builder: (context, _) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SgMultiSelectChips(
          id: 'msc-searchable',
          labelText: context.tx('Empresas'),
          placeholder: context.tx('Selecione as empresas'),
          searchable: true,
          options: [
            SgMultiSelectOption(label: 'Empresa 1', value: 'e1'),
            SgMultiSelectOption(label: 'Empresa 2', value: 'e2'),
            SgMultiSelectOption(label: 'Empresa 3', value: 'e3'),
            SgMultiSelectOption(label: 'Empresa 4', value: 'e4'),
            SgMultiSelectOption(label: 'Empresa 5', value: 'e5'),
            SgMultiSelectOption(label: 'Empresa 6', value: 'e6'),
          ],
          value: _pesquisavel.value,
          onChange: (v) => _pesquisavel.value = v,
        ),
        const SizedBox(height: 8),
        Text(
          '${context.tx('Selecionadas')}: ${_pesquisavel.value.isEmpty ? context.tx('(nenhuma)') : _pesquisavel.value.join(', ')}',
        ),
      ],
    ),
  ),
)
''';

  /// Region `sg-multi-select-chips-chip-label`.
  static const String sgMultiSelectChipsChipLabel = r'''
SizedBox(
  width: 384,
  child: ListenableBuilder(
    listenable: _filiais,
    builder: (context, _) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SgMultiSelectChips(
          id: 'msc-chip-label',
          labelText: context.tx('Filiais'),
          placeholder: context.tx('Selecione as empresas'),
          searchable: true,
          options: [
            SgMultiSelectOption(
              label: '1 - Matriz São Paulo',
              value: 1,
              chipLabel: '1',
            ),
            SgMultiSelectOption(
              label: '2 - Filial Campinas',
              value: 2,
              chipLabel: '2',
            ),
            SgMultiSelectOption(
              label: '3 - Filial Centro',
              value: 3,
              chipLabel: '3',
            ),
            SgMultiSelectOption(
              label: '4 - Filial Ribeirão Preto',
              value: 4,
              chipLabel: '4',
            ),
            SgMultiSelectOption(
              label: '5 - Depósito Jundiaí',
              value: 5,
              chipLabel: '5',
            ),
          ],
          value: _filiais.value,
          onChange: (v) => _filiais.value = v,
        ),
        const SizedBox(height: 8),
        Text(
          '${context.tx('Selecionadas')}: ${_filiais.value.isEmpty ? context.tx('(nenhuma)') : _filiais.value.join(', ')}',
        ),
      ],
    ),
  ),
)
''';

  /// Region `sg-multi-select-chips-controlado`.
  static const String sgMultiSelectChipsControlado = r'''
SizedBox(
  width: 384,
  child: ListenableBuilder(
    listenable: _controlado,
    builder: (context, _) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SgMultiSelectChips(
          id: 'msc-controlled',
          labelText: context.tx('Frameworks'),
          options: [
            SgMultiSelectOption(label: 'Flutter', value: 'flutter'),
            SgMultiSelectOption(label: 'React', value: 'react'),
            SgMultiSelectOption(label: 'Quarkus', value: 'quarkus'),
          ],
          value: _controlado.value,
          onChange: (v) => _controlado.value = v,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            SgButton(
              size: SgSize.sm,
              appearance: SgAppearance.outline,
              label: Text(context.tx('Selecionar todas')),
              onClick: () => _controlado.value = [
                'flutter',
                'react',
                'quarkus',
              ],
            ),
            SgButton(
              size: SgSize.sm,
              appearance: SgAppearance.outline,
              label: Text(context.tx('Limpar')),
              onClick: () => _controlado.value = const [],
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '${context.tx('Selecionadas')}: ${_controlado.value.isEmpty ? context.tx('(nenhuma)') : _controlado.value.join(', ')}',
        ),
      ],
    ),
  ),
)
''';

  /// Region `sg-multi-select-chips-desabilitado`.
  static const String sgMultiSelectChipsDesabilitado = r'''
SgMultiSelectChips(
  id: 'msc-disabled',
  labelText: context.tx('Empresas'),
  placeholder: context.tx('Selecione as empresas'),
  options: [
    SgMultiSelectOption(label: 'Empresa 1', value: 'e1'),
    SgMultiSelectOption(label: 'Empresa 2', value: 'e2'),
    SgMultiSelectOption(label: 'Empresa 3', value: 'e3'),
    SgMultiSelectOption(label: 'Empresa 4', value: 'e4'),
    SgMultiSelectOption(label: 'Empresa 5', value: 'e5'),
    SgMultiSelectOption(label: 'Empresa 6', value: 'e6'),
  ],
  value: const ['e1', 'e3'],
  enabled: false,
)
''';

  /// Region `sg-multi-select-chips-formulario`.
  static const String sgMultiSelectChipsFormulario = r'''
SizedBox(
  width: 384,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SgMultiSelectChips(
        id: 'msc-form',
        name: 'areas',
        control: _form,
        labelText: context.tx('Áreas'),
        required: true,
        options: [
          SgMultiSelectOption(label: 'Vendas', value: 'vendas'),
          SgMultiSelectOption(label: 'Compras', value: 'compras'),
          SgMultiSelectOption(label: 'Estoque', value: 'estoque'),
        ],
      ),
      const SizedBox(height: 12),
      SgButton(
        label: Text(context.tx('Enviar')),
        onClick: () => _form.handleSubmit(
          (values) => _enviado.value =
              ((values['areas'] as List?) ?? const []).join(', '),
        ),
      ),
      const SizedBox(height: 8),
      ValueListenableBuilder<String>(
        valueListenable: _enviado,
        builder: (context, enviado, _) => enviado.isEmpty
            ? const SizedBox.shrink()
            : Text('${context.tx('Enviado')}: $enviado'),
      ),
    ],
  ),
)
''';

  /// Region `sg-multi-select-chips-limite`.
  static const String sgMultiSelectChipsLimite = r'''
SizedBox(
  width: 384,
  child: ListenableBuilder(
    listenable: _limitadas,
    builder: (context, _) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SgMultiSelectChips(
          id: 'msc-capped',
          labelText: context.tx('Empresas (máx. 3)'),
          placeholder: context.tx('Selecione até 3 empresas'),
          clearable: true,
          maxSelected: 3,
          options: [
            SgMultiSelectOption(label: 'Empresa 1', value: 'e1'),
            SgMultiSelectOption(label: 'Empresa 2', value: 'e2'),
            SgMultiSelectOption(label: 'Empresa 3', value: 'e3'),
            SgMultiSelectOption(label: 'Empresa 4', value: 'e4'),
            SgMultiSelectOption(label: 'Empresa 5', value: 'e5'),
            SgMultiSelectOption(label: 'Empresa 6', value: 'e6'),
          ],
          value: _limitadas.value,
          onChange: (v) => _limitadas.value = v,
        ),
        const SizedBox(height: 8),
        SgButton(
          size: SgSize.sm,
          appearance: SgAppearance.outline,
          label: Text(context.tx('Limpar')),
          onClick: () => _limitadas.value = const [],
        ),
        const SizedBox(height: 8),
        Text(
          '${context.tx('Selecionadas')}: ${_limitadas.value.isEmpty ? context.tx('(nenhuma)') : _limitadas.value.join(', ')}',
        ),
      ],
    ),
  ),
)
''';
}
