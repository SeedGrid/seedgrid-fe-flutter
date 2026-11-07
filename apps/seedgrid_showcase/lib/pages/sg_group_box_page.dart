// Showcase do SgGroupBox. O codigo exibido em cada exemplo e o trecho entre `// #region` e
// `// #endregion` deste arquivo: exatamente o que esta renderizado.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import '../src/sg_showcase_page.dart';
import '../src/showcase_i18n.dart';
import 'sg_group_box_page.snippets.g.dart';

class SgGroupBoxPage extends StatefulWidget {
  const SgGroupBoxPage({super.key});

  @override
  State<SgGroupBoxPage> createState() => _SgGroupBoxPageState();
}

class _SgGroupBoxPageState extends State<SgGroupBoxPage> {
  final SgFormController _form = SgFormController();

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
        description: 'Uso simples do GroupBox.',
        preview:
            // #region sg-group-box-basico
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
            ),
        // #endregion
        code: SgGroupBoxPageSnippets.sgGroupBoxBasico,
      ),
      ShowcaseExample(
        title: 'Formulário',
        description: 'Exemplo com inputs reais dentro do GroupBox.',
        preview:
            // #region sg-group-box-formulario
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
            ),
        // #endregion
        code: SgGroupBoxPageSnippets.sgGroupBoxFormulario,
      ),
      ShowcaseExample(
        title: 'Tamanho',
        description: 'Largura e altura customizáveis.',
        preview:
            // #region sg-group-box-tamanho
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
            ),
        // #endregion
        code: SgGroupBoxPageSnippets.sgGroupBoxTamanho,
      ),
      ShowcaseExample(
        title: 'Várias caixas lado a lado',
        description: 'Use o SgGrid para dispor várias caixas lado a lado.',
        preview:
            // #region sg-group-box-lado
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
            ),
        // #endregion
        code: SgGroupBoxPageSnippets.sgGroupBoxLado,
      ),
    ];

    final specs = sgPropSpecs['SgGroupBox']!;
    return SgShowcasePage(
      name: 'SgGroupBox',
      description:
          'Caixa com legenda sobre a borda para agrupar campos relacionados.',
      examples: examples,
      propSpecs: specs,
      playground: SgPlayground(
        specs: specs.where((s) => s.name == 'title').toList(),
        builder: (context, v) => SgGroupBox(
          title: (v['title'] as String?) ?? 'Título',
          child: const Text('Conteúdo da caixa'),
        ),
        codeBuilder: (v) =>
            "SgGroupBox(\n  title: '${(v['title'] as String?) ?? 'Título'}',\n  child: Text('Conteúdo da caixa'),\n)",
      ),
    );
  }
}
