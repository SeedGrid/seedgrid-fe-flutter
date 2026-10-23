// Showcase do SgCombobox. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
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

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final examples = <ShowcaseExample>[
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
        title: 'Itens com id, grupo e item desabilitado',
        description:
            'O valor é o id do item; onValueChange recebe o id e onSelect recebe o item original.',
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
                  source: const [
                    SgAutocompleteItem(id: 1, label: 'Analista', group: 'TI'),
                    SgAutocompleteItem(id: 2, label: 'Gerente', group: 'TI'),
                    SgAutocompleteItem(
                      id: 3,
                      label: 'Diretor',
                      group: 'Gestão',
                      disabled: true,
                    ),
                    SgAutocompleteItem(
                      id: 4,
                      label: 'Coordenador',
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
        title: 'Fonte assíncrona',
        description:
            'A fonte é chamada ao abrir; enquanto espera aparece o texto de carregamento.',
        preview:
            // #region sg-combobox-assincrono
            SgCombobox<String>(
              id: 'estado',
              labelText: 'Estado',
              loadingText: 'Carregando estados...',
              source: (q) async {
                await Future<void>.delayed(const Duration(milliseconds: 600));
                return const ['Paraná', 'Santa Catarina', 'Rio Grande do Sul'];
              },
            ),
        // #endregion
        code: SgComboboxPageSnippets.sgComboboxAssincrono,
      ),
      ShowcaseExample(
        title: 'Item, valor e rodapé próprios',
        preview:
            // #region sg-combobox-visual
            SgCombobox<SgAutocompleteItem>(
              id: 'status',
              labelText: 'Status',
              showCharCounter: false,
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
              renderFooter: (q, has) => const Text('Escolha o status atual'),
              source: const [
                SgAutocompleteItem(id: 1, label: 'Concluído'),
                SgAutocompleteItem(id: 2, label: 'Pendente'),
              ],
            ),
        // #endregion
        code: SgComboboxPageSnippets.sgComboboxVisual,
      ),
      ShowcaseExample(
        title: 'Dentro de um formulário',
        description: 'name + control + rules, como no react-hook-form.',
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
                  rules: const SgRules(required: 'Escolha uma forma'),
                  source: const ['Boleto', 'Cartão', 'Pix'],
                ),
                const SizedBox(height: 12),
                SgButton(
                  label: const Text('Enviar'),
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
                'disabled',
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
          disabled: v['disabled'] as bool?,
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
