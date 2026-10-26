// Showcase do SgInputText (e do contrato de formulario SgForm). O codigo exibido em cada exemplo e
// o trecho entre `// #region` e `// #endregion` deste arquivo.
import 'package:flutter/material.dart';
import 'package:seedgrid_components/seedgrid_components.dart';

import 'sg_input_text_page.snippets.g.dart';
import '../src/sg_showcase_page.dart';

class SgInputTextPage extends StatefulWidget {
  const SgInputTextPage({super.key});

  @override
  State<SgInputTextPage> createState() => _SgInputTextPageState();
}

class _SgInputTextPageState extends State<SgInputTextPage> {
  final SgFormController _form = SgFormController(defaultValues: {'email': ''});
  String _enviado = '';
  String _evento = 'nenhum';

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
        code: SgInputTextPageSnippets.sgInputTextBasico,
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
        code: SgInputTextPageSnippets.sgInputTextRotulo,
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
        code: SgInputTextPageSnippets.sgInputTextAfixos,
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
        code: SgInputTextPageSnippets.sgInputTextValidacao,
      ),
      ShowcaseExample(
        title: 'Mínimo de palavras',
        description:
            'Valida a quantidade mínima de palavras ao sair do campo (minNumberOfWords).',
        preview:
            // #region sg-input-text-palavras
            const SgInputText(
              id: 'palavras',
              labelText: 'Nome completo',
              minNumberOfWords: 2,
              minNumberOfWordsMessage: 'Informe nome e sobrenome',
            ),
        // #endregion
        code: SgInputTextPageSnippets.sgInputTextPalavras,
      ),
      ShowcaseExample(
        title: 'Ícone de prefixo',
        description:
            'prefixIcon recebe qualquer widget e fica à esquerda do texto.',
        preview:
            // #region sg-input-text-icone
            const SgInputText(
              id: 'icone',
              labelText: 'Buscar',
              prefixIcon: Icon(Icons.search, size: 18),
            ),
        // #endregion
        code: SgInputTextPageSnippets.sgInputTextIcone,
      ),
      ShowcaseExample(
        title: 'Botões de ícone',
        description:
            'iconButtons recebe uma lista de widgets; cada botão tem o onClick que você definir.',
        preview:
            // #region sg-input-text-botoes
            SgInputText(
              id: 'botoes',
              labelText: 'Endereço',
              iconButtons: [
                SgButton(
                  iconOnly: true,
                  size: SgSize.sm,
                  appearance: SgAppearance.outline,
                  leftIcon: const Icon(Icons.place_outlined),
                  onClick: () => setState(() => _evento = 'localizar'),
                ),
                SgButton(
                  iconOnly: true,
                  size: SgSize.sm,
                  appearance: SgAppearance.outline,
                  leftIcon: const Icon(Icons.copy),
                  onClick: () => setState(() => _evento = 'copiar'),
                ),
              ],
            ),
        // #endregion
        code: SgInputTextPageSnippets.sgInputTextBotoes,
      ),
      ShowcaseExample(
        title: 'Variações visuais',
        description:
            'filled alterna o fundo preenchido; withBorder remove a borda.',
        preview:
            // #region sg-input-text-variacoes
            const Column(
              children: [
                SgInputText(
                  id: 'preenchido',
                  labelText: 'Preenchido',
                  filled: true,
                ),
                SizedBox(height: 12),
                SgInputText(
                  id: 'vazado',
                  labelText: 'Sem preenchimento',
                  filled: false,
                ),
                SizedBox(height: 12),
                SgInputText(
                  id: 'semborda',
                  labelText: 'Sem borda',
                  withBorder: false,
                ),
              ],
            ),
        // #endregion
        code: SgInputTextPageSnippets.sgInputTextVariacoes,
      ),
      ShowcaseExample(
        title: 'Sem botão de limpar',
        description:
            'clearButton: false esconde o botão de limpar (por padrão ele aparece com texto).',
        preview:
            // #region sg-input-text-sem-limpar
            const SgInputText(
              id: 'semlimpar',
              labelText: 'Sem limpar',
              initialValue: 'texto fixo',
              clearButton: false,
            ),
        // #endregion
        code: SgInputTextPageSnippets.sgInputTextSemLimpar,
      ),
      ShowcaseExample(
        title: 'Largura e borda',
        description:
            'width aceita número (px) ou porcentagem; borderRadius arredonda os cantos.',
        preview:
            // #region sg-input-text-largura
            const SgInputText(
              id: 'largura',
              labelText: 'Arredondado',
              width: 240,
              borderRadius: 20,
            ),
        // #endregion
        code: SgInputTextPageSnippets.sgInputTextLargura,
      ),
      ShowcaseExample(
        title: 'Desabilitado e somente leitura',
        description:
            'disabled bloqueia o campo; readOnly deixa copiar, mas não editar.',
        preview:
            // #region sg-input-text-estados
            const Column(
              children: [
                SgInputText(
                  id: 'desabilitado',
                  labelText: 'Desabilitado',
                  initialValue: 'não edita',
                  disabled: true,
                ),
                SizedBox(height: 12),
                SgInputText(
                  id: 'leitura',
                  labelText: 'Somente leitura',
                  initialValue: 'só leitura',
                  readOnly: true,
                ),
              ],
            ),
        // #endregion
        code: SgInputTextPageSnippets.sgInputTextEstados,
      ),
      ShowcaseExample(
        title: 'Erro externo',
        description:
            'error mostra uma mensagem vinda de fora (por exemplo, da resposta do servidor).',
        preview:
            // #region sg-input-text-erro-externo
            const SgInputText(
              id: 'erro',
              labelText: 'Usuário',
              initialValue: 'admin',
              error: 'Usuário já existe',
            ),
        // #endregion
        code: SgInputTextPageSnippets.sgInputTextErroExterno,
      ),
      ShowcaseExample(
        title: 'Eventos',
        description:
            'onChange, onEnter (foco), onExit (saída) e onClear informam o que o usuário fez.',
        preview:
            // #region sg-input-text-eventos
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SgInputText(
                  id: 'eventos',
                  labelText: 'Digite aqui',
                  onChange: (v) => setState(() => _evento = 'onChange: $v'),
                  onEnter: () => setState(() => _evento = 'onEnter'),
                  onExit: () => setState(() => _evento = 'onExit'),
                  onClear: () => setState(() => _evento = 'onClear'),
                ),
                const SizedBox(height: 8),
                Text('Último evento: $_evento'),
              ],
            ),
        // #endregion
        code: SgInputTextPageSnippets.sgInputTextEventos,
      ),
      ShowcaseExample(
        title: 'Elevação',
        description: 'elevation aplica sombra ao campo: none, sm, md ou lg.',
        preview:
            // #region sg-input-text-elevacao
            const Column(
              children: [
                SgInputText(
                  id: 'sm',
                  labelText: 'Sombra pequena',
                  elevation: SgInputTextElevation.sm,
                ),
                SizedBox(height: 12),
                SgInputText(
                  id: 'lg',
                  labelText: 'Sombra grande',
                  elevation: SgInputTextElevation.lg,
                ),
              ],
            ),
        // #endregion
        code: SgInputTextPageSnippets.sgInputTextElevacao,
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
        code: SgInputTextPageSnippets.sgInputTextFormulario,
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
