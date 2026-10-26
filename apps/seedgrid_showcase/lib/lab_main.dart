// Laboratorio de campos para teste no aparelho (nao faz parte do showcase publicado):
//   flutter run -t lib/lab_main.dart
// Cada campo tem as tres provas: DIGITAR (teclado real), ATRIBUIR por codigo (setValue do SgFormController)
// e LER o valor (getValue do controller, mostrado abaixo do campo). Tambem mostra o texto exibido no campo.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';
import 'package:seedgrid_theme/seedgrid_theme.dart';

void main() => runApp(const LabApp());

class LabApp extends StatelessWidget {
  const LabApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Laboratorio de campos',
    theme: ThemeData(useMaterial3: true),
    builder: (context, child) => SeedThemeProvider(child: child!),
    home: const LabPage(),
  );
}

typedef _Build = Widget Function(String id, String name, SgFormController c);

class _Case {
  const _Case(this.title, this.sample, this.build);

  final String title;

  /// Valor atribuido por codigo (o tipo que o campo espera no formulario).
  final Object sample;
  final _Build build;
}

final List<_Case> _cases = [
  _Case(
    'SgInputText',
    'Texto de teste',
    (id, n, c) =>
        SgInputText(id: id, name: n, control: c, labelText: 'SgInputText'),
  ),
  _Case(
    'SgInputEmail',
    'ana@exemplo.com',
    (id, n, c) =>
        SgInputEmail(id: id, name: n, control: c, labelText: 'SgInputEmail'),
  ),
  _Case(
    'SgInputPassword',
    'Abc@12345',
    (id, n, c) => SgInputPassword(
      id: id,
      name: n,
      control: c,
      labelText: 'SgInputPassword',
    ),
  ),
  _Case(
    'SgInputTextArea',
    'linha 1\nlinha 2',
    (id, n, c) => SgInputTextArea(
      id: id,
      name: n,
      control: c,
      labelText: 'SgInputTextArea',
    ),
  ),
  _Case(
    'SgInputTextSearch',
    'busca',
    (id, n, c) => SgInputTextSearch(
      id: id,
      name: n,
      control: c,
      labelText: 'SgInputTextSearch',
      onSearchChange: (_) {},
    ),
  ),
  _Case(
    'SgInputCPF',
    '12345678909',
    (id, n, c) =>
        SgInputCPF(id: id, name: n, control: c, labelText: 'SgInputCPF'),
  ),
  _Case(
    'SgInputCNPJ',
    '05952365000130',
    (id, n, c) =>
        SgInputCNPJ(id: id, name: n, control: c, labelText: 'SgInputCNPJ'),
  ),
  _Case(
    'SgInputCPFCNPJ',
    '05952365000130',
    (id, n, c) => SgInputCPFCNPJ(
      id: id,
      name: n,
      control: c,
      labelText: 'SgInputCPFCNPJ',
    ),
  ),
  _Case(
    'SgInputPhone',
    '11987654321',
    (id, n, c) =>
        SgInputPhone(id: id, name: n, control: c, labelText: 'SgInputPhone'),
  ),
  _Case(
    'SgInputPostalCode',
    '01310100',
    (id, n, c) => SgInputPostalCode(
      id: id,
      name: n,
      control: c,
      labelText: 'SgInputPostalCode',
    ),
  ),
  _Case(
    'SgInputDate',
    '2026-10-26',
    (id, n, c) =>
        SgInputDate(id: id, name: n, control: c, labelText: 'SgInputDate'),
  ),
  _Case(
    'SgInputBirthDate',
    '1990-05-20',
    (id, n, c) => SgInputBirthDate(
      id: id,
      name: n,
      control: c,
      labelText: 'SgInputBirthDate',
    ),
  ),
  _Case(
    'SgInputNumber',
    1234.5,
    (id, n, c) =>
        SgInputNumber(id: id, name: n, control: c, labelText: 'SgInputNumber'),
  ),
  _Case(
    'SgInputCurrency',
    1234.56,
    (id, n, c) => SgInputCurrency(
      id: id,
      name: n,
      control: c,
      labelText: 'SgInputCurrency',
    ),
  ),
  _Case(
    'SgStepperInput',
    5,
    (id, n, c) =>
        SgStepperInput(id: id, name: n, control: c, minValue: 0, maxValue: 100),
  ),
  _Case(
    'SgCombobox',
    2,
    (id, n, c) => SgCombobox<SgAutocompleteItem>(
      id: id,
      name: n,
      control: c,
      labelText: 'SgCombobox',
      source: _frutas,
    ),
  ),
  _Case(
    'SgAutocomplete',
    3,
    (id, n, c) => SgAutocomplete<SgAutocompleteItem>(
      id: id,
      name: n,
      control: c,
      labelText: 'SgAutocomplete',
      source: (q) => _frutas
          .where((f) => f.label.toLowerCase().contains(q.toLowerCase()))
          .toList(),
    ),
  ),
  _Case(
    'SgMultiSelect',
    ['a', 'c'],
    (id, n, c) =>
        SgMultiSelect(id: id, name: n, control: c, options: _opcoesMulti),
  ),
  _Case(
    'SgMultiSelectChips',
    ['a', 'c'],
    (id, n, c) =>
        SgMultiSelectChips(id: id, name: n, control: c, options: _opcoesMulti),
  ),
  _Case(
    'SgRadioGroup',
    'b',
    (id, n, c) => SgRadioGroup(
      id: id,
      name: n,
      control: c,
      source: const [
        SgRadioGroupOption(label: 'Opção A', value: 'a'),
        SgRadioGroupOption(label: 'Opção B', value: 'b'),
        SgRadioGroupOption(label: 'Opção C', value: 'c'),
      ],
    ),
  ),
  _Case(
    'SgCheckboxGroup',
    ['a', 'c'],
    (id, n, c) => SgCheckboxGroup(
      id: id,
      name: n,
      control: c,
      source: const [
        SgCheckboxGroupOption(label: 'Opção A', value: 'a'),
        SgCheckboxGroupOption(label: 'Opção B', value: 'b'),
        SgCheckboxGroupOption(label: 'Opção C', value: 'c'),
      ],
    ),
  ),
  _Case(
    'SgToggleSwitch',
    true,
    (id, n, c) => SgToggleSwitch(id: id, name: n, control: c, label: 'Ativo'),
  ),
  _Case(
    'SgSlider',
    40,
    (id, n, c) => SgSlider(
      id: id,
      name: n,
      control: c,
      minValue: 0,
      maxValue: 100,
      step: 5,
    ),
  ),
  _Case('SgRating', 4, (id, n, c) => SgRating(id: id, name: n, control: c)),
  _Case(
    'SgInputOTP',
    '123456',
    (id, n, c) => SgInputOTP(id: id, name: n, control: c),
  ),
  _Case(
    'SgPeriodSelector',
    'THIS_YEAR',
    (id, n, c) => SgPeriodSelector(id: id, name: n, control: c),
  ),
  _Case(
    'SgTextEditor',
    '<p>olá <strong>mundo</strong></p>',
    (id, n, c) => SgTextEditor(id: id, name: n, control: c),
  ),
];

const List<SgAutocompleteItem> _frutas = [
  SgAutocompleteItem(id: 1, label: 'Maçã'),
  SgAutocompleteItem(id: 2, label: 'Banana'),
  SgAutocompleteItem(id: 3, label: 'Uva'),
];

const List<SgMultiSelectOption> _opcoesMulti = [
  SgMultiSelectOption(label: 'Opção A', value: 'a'),
  SgMultiSelectOption(label: 'Opção B', value: 'b'),
  SgMultiSelectOption(label: 'Opção C', value: 'c'),
];

class LabPage extends StatefulWidget {
  const LabPage({super.key});

  @override
  State<LabPage> createState() => _LabPageState();
}

/// Um campo por vez (setas no topo): botoes e leitura ficam sempre no mesmo lugar da tela, o que deixa o
/// teste por adb repetivel.
class _LabPageState extends State<LabPage> {
  final SgFormController _form = SgFormController();
  final Map<String, String> _lido = {};
  int _i = 0;

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  String _show(Object? v) => v == null ? '(null)' : '${v.runtimeType}: $v';

  @override
  Widget build(BuildContext context) {
    final c = _cases[_i];
    return Scaffold(
      appBar: AppBar(
        title: Text('${_i + 1}/${_cases.length} ${c.title}'),
        actions: [
          IconButton(
            key: const ValueKey('anterior'),
            icon: const Icon(Icons.chevron_left),
            onPressed: _i == 0 ? null : () => setState(() => _i--),
          ),
          IconButton(
            key: const ValueKey('proximo'),
            icon: const Icon(Icons.chevron_right),
            onPressed: _i == _cases.length - 1
                ? null
                : () => setState(() => _i++),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              SgButton(
                label: const Text('Atribuir'),
                onClick: () async {
                  await _form.setValue(c.title, c.sample);
                  setState(() {});
                },
              ),
              SgButton(
                label: const Text('Ler'),
                onClick: () => setState(
                  () => _lido[c.title] = _show(_form.getValue(c.title)),
                ),
              ),
              SgButton(
                label: const Text('Limpar'),
                onClick: () async {
                  await _form.setValue(c.title, null);
                  setState(() {});
                },
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('atribuir: ${_show(c.sample)}'),
          Text('lido: ${_lido[c.title] ?? '-'}'),
          const SizedBox(height: 16),
          c.build('lab-${c.title}', c.title, _form),
        ],
      ),
    );
  }
}
