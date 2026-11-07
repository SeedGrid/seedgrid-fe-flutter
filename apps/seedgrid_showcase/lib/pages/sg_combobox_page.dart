// Showcase do SgCombobox. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';
import 'sg_combobox_page.snippets.g.dart';

class SgComboboxPage extends StatefulWidget {
  const SgComboboxPage({super.key});

  @override
  State<SgComboboxPage> createState() => _SgComboboxPageState();
}

class _SgComboboxPageState extends State<SgComboboxPage> {
  final SgFormController _form = SgFormController();
  String _enviado = '';
  Object? _escolhido;
  Object? _valorControlado;
  String? _ultimoSelect;

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
      ShowcaseExample(
        title: 'Básico com lista de objetos',
        description:
            'Sem input livre: com foco no campo, digite letras e ele "pula" para o item correspondente.',
        preview:
            // #region sg-combobox-itens
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgCombobox<SgAutocompleteItem>(
                  id: 'cargo',
                  labelText: 'Cargo',
                  grouped: true,
                  onValueChange: (id) => setState(() => _escolhido = id),
                  source: [
                    SgAutocompleteItem(
                      id: 1,
                      label: context.tx('Analista'),
                      group: 'TI',
                    ),
                    SgAutocompleteItem(
                      id: 2,
                      label: context.tx('Gerente'),
                      group: 'TI',
                    ),
                    SgAutocompleteItem(
                      id: 3,
                      label: context.tx('Diretor'),
                      group: 'Gestão',
                      enabled: false,
                    ),
                    SgAutocompleteItem(
                      id: 4,
                      label: context.tx('Coordenador'),
                      group: 'Gestão',
                    ),
                  ],
                ),
                Text('id escolhido: ${_escolhido ?? '-'}'),
              ],
            ),
        // #endregion
        code: SgComboboxPageSnippets.sgComboboxItens,
      ),
      ShowcaseExample(
        title: 'Controlado por value',
        description:
            'Use value/onValueChange para definir programaticamente um valor válido.',
        preview:
            // #region sg-combobox-controlado
            Builder(
              builder: (context) {
                const paises = [
                  SgAutocompleteItem(id: 1, label: 'Brazil', group: 'Americas'),
                  SgAutocompleteItem(
                    id: 2,
                    label: 'Argentina',
                    group: 'Americas',
                  ),
                  SgAutocompleteItem(id: 5, label: 'Germany', group: 'Europe'),
                  SgAutocompleteItem(id: 9, label: 'Japan', group: 'Asia'),
                ];
                final resolvido = paises
                    .where((p) => p.id == _valorControlado)
                    .map((p) => p.label)
                    .firstOrNull;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SgCombobox<SgAutocompleteItem>(
                      id: 'pais-controlado',
                      labelText: 'Country (controlled)',
                      value: _valorControlado,
                      openOnFocus: true,
                      source: paises,
                      onValueChange: (id) =>
                          setState(() => _valorControlado = id),
                      onSelect: (item) =>
                          setState(() => _ultimoSelect = item.label),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        SgButton(
                          size: SgSize.sm,
                          appearance: SgAppearance.outline,
                          label: Text(context.tx('Definir Alemanha (id 5)')),
                          onClick: () => setState(() => _valorControlado = 5),
                        ),
                        SgButton(
                          size: SgSize.sm,
                          appearance: SgAppearance.outline,
                          label: Text(context.tx('Definir Japão (id 9)')),
                          onClick: () => setState(() => _valorControlado = 9),
                        ),
                        SgButton(
                          size: SgSize.sm,
                          appearance: SgAppearance.outline,
                          label: Text(context.tx('Limpar valor')),
                          onClick: () =>
                              setState(() => _valorControlado = null),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${context.tx('valor')}: ${_valorControlado ?? context.tx('(vazio)')}',
                    ),
                    Text(
                      '${context.tx('resolvido por value')}: ${resolvido ?? context.tx('(nenhum)')}',
                    ),
                    Text(
                      '${context.tx('último onSelect')}: ${_ultimoSelect ?? context.tx('(nenhum)')}',
                    ),
                  ],
                );
              },
            ),
        // #endregion
        code: SgComboboxPageSnippets.sgComboboxControlado,
      ),
      ShowcaseExample(
        title: 'Fonte assíncrona + render personalizado',
        description:
            'Suporte a loadingText, renderItem, renderGroupHeader, renderFooter e itemTooltip.',
        preview:
            // #region sg-combobox-assincrono
            Builder(
              builder: (context) {
                final concluido = context.tx('Concluído');
                final pendente = context.tx('Pendente');
                return SgCombobox<SgAutocompleteItem>(
                  id: 'status',
                  labelText: 'Status',
                  loadingText: context.tx('Carregando status...'),
                  openOnFocus: true,
                  showCharCounter: false,
                  source: (q) async {
                    await Future<void>.delayed(
                      const Duration(milliseconds: 600),
                    );
                    return [
                      SgAutocompleteItem(id: 1, label: concluido),
                      SgAutocompleteItem(id: 2, label: pendente),
                    ];
                  },
                  renderItem: (item, active) => Row(
                    children: [
                      Icon(
                        item.id == 1 ? Icons.check_circle : Icons.pending,
                        size: 16,
                        color: item.id == 1 ? Colors.green : Colors.orange,
                      ),
                      const SizedBox(width: 8),
                      Text(item.label),
                    ],
                  ),
                  renderValue: (item) => Text('● ${item?.label}'),
                  renderFooter: (q, has) =>
                      Text(context.tx('Escolha o status atual')),
                );
              },
            ),
        // #endregion
        code: SgComboboxPageSnippets.sgComboboxAssincrono,
      ),
      ShowcaseExample(
        title: 'Raio da borda',
        description: 'Aplica o raio no input e no dropdown.',
        preview:
            // #region sg-combobox-raio
            SgCombobox<SgAutocompleteItem>(
              id: 'pais-raio',
              labelText: 'Country with custom radius',
              openOnFocus: true,
              grouped: true,
              borderRadius: 14,
              source: const [
                SgAutocompleteItem(id: 1, label: 'Brazil', group: 'Americas'),
                SgAutocompleteItem(
                  id: 2,
                  label: 'Argentina',
                  group: 'Americas',
                ),
                SgAutocompleteItem(id: 5, label: 'Germany', group: 'Europe'),
                SgAutocompleteItem(id: 9, label: 'Japan', group: 'Asia'),
              ],
            ),
        // #endregion
        code: SgComboboxPageSnippets.sgComboboxRaio,
      ),
      ShowcaseExample(
        title: 'Lista simples',
        description:
            'Toque no campo para abrir. Com o campo focado, digitar uma letra salta para o item que começa com ela (type-ahead).',
        preview:
            // #region sg-combobox-simples
            const SgCombobox<String>(
              id: 'fruta',
              labelText: 'Fruta',
              source: ['Abacate', 'Abacaxi', 'Banana', 'Laranja', 'Uva'],
            ),
        // #endregion
        code: SgComboboxPageSnippets.sgComboboxSimples,
      ),
      ShowcaseExample(
        title: 'Dentro de um formulário',
        description:
            'name + control + required: a mensagem aparece no envio e some ao escolher.',
        preview:
            // #region sg-combobox-formulario
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgCombobox<String>(
                  id: 'pagamento',
                  name: 'pagamento',
                  control: _form,
                  labelText: 'Forma de pagamento',
                  required: true,
                  requiredMessage: 'Escolha uma forma',
                  source: const ['Boleto', 'Cartão', 'Pix'],
                ),
                const SizedBox(height: 12),
                SgButton(
                  label: Text(context.tx('Enviar')),
                  onClick: () => _form.handleSubmit(
                    (values) =>
                        setState(() => _enviado = '${values['pagamento']}'),
                  ),
                ),
                if (_enviado.isNotEmpty) Text('Enviado: $_enviado'),
              ],
            ),
        // #endregion
        code: SgComboboxPageSnippets.sgComboboxFormulario,
      ),
    ];

    return SgShowcasePage(
      name: 'SgCombobox',
      description:
          'Seleção de um item de uma lista (local ou assíncrona), com escolha por id e busca por tecla digitada.',
      examples: examples,
      propSpecs: sgPropSpecs['SgCombobox']!,
      playground: SgPlayground(
        specs: sgPropSpecs['SgCombobox']!
            .where(
              (s) => const {
                'openOnFocus',
                'grouped',
                'enabled',
                'filled',
                'required',
                'placeholder',
                'hintText',
                'labelPosition',
              }.contains(s.name),
            )
            .toList(),
        builder: (context, v) => SgCombobox<SgAutocompleteItem>(
          id: 'pg',
          labelText: 'Item',
          openOnFocus: (v['openOnFocus'] as bool?) ?? false,
          grouped: v['grouped'] as bool?,
          enabled: v['enabled'] as bool?,
          filled: v['filled'] as bool?,
          required: v['required'] as bool?,
          placeholder: v['placeholder'] as String?,
          hintText: v['hintText'] as String?,
          labelPosition: SgComboboxLabelPosition.fromValue(
            v['labelPosition'] as String?,
          ),
          source: const [
            SgAutocompleteItem(id: 1, label: 'Um', group: 'A'),
            SgAutocompleteItem(id: 2, label: 'Dois', group: 'A'),
            SgAutocompleteItem(id: 3, label: 'Três', group: 'B'),
          ],
        ),
        codeBuilder: (v) {
          final args = <String>["id: 'pg'", "labelText: 'Item'"];
          for (final e in v.entries) {
            if (e.value == null || e.value == false) continue;
            args.add(switch (e.key) {
              'labelPosition' =>
                'labelPosition: SgComboboxLabelPosition.${SgComboboxLabelPosition.fromValue(e.value as String)!.name}',
              final k when e.value is String => "$k: '${e.value}'",
              _ => '${e.key}: ${e.value}',
            });
          }
          args.add('source: itens');
          return 'SgCombobox<SgAutocompleteItem>(\n  ${args.join(',\n  ')},\n)';
        },
      ),
    );
  }
}
